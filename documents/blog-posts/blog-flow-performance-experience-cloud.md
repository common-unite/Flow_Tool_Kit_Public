# The 30-Second Spinning Wheel: Why Salesforce Flows Load So Slowly in Experience Cloud (and What You Can Do About It)

If you've ever embedded a Screen Flow in an Experience Cloud page, you've experienced it: the first load of the day takes forever. Your users stare at a spinning wheel for 15, 20, even 30 seconds before the flow renders. They refresh the page. They try a different browser. They submit a support ticket.

Then, mysteriously, the second visit is fast. A few seconds and the flow appears. What changed? Nothing on your end — Salesforce's server-side caches warmed up.

We spent time profiling this behavior with Chrome DevTools performance traces and discovered exactly where the time goes, why it happens, and — most importantly — a creative workaround that eliminates the problem entirely.

## The Experiment

We profiled a Screen Flow embedded in an Experience Cloud page under three conditions:

1. **Cold Load** — First visit of the day (fresh session, server caches cold)
2. **Warmed Flow** — Same page, revisited shortly after (session active, server caches warm)
3. **Debug Mode Off** — Warmed flow with Debug Mode disabled on the user profile

The flow under test was a standard account form — two sections, roughly 10 fields, nothing exotic. The org had Lightning Web Security enabled.

## The Numbers

| Metric | Cold Load | Warmed Flow | Debug Mode Off |
|--------|-----------|-------------|----------------|
| **First Contentful Paint** | 8,986 ms | 5,726 ms | 3,185 ms |
| **DOM Content Loaded** | 8,813 ms | 5,532 ms | 3,026 ms |
| **Long Tasks (>50ms)** | 33 / 10.7s blocking | 37 / 11.8s blocking | 32 / 8.3s blocking |
| **Script Evaluation** | 6,218 ms (59 scripts) | 6,508 ms (59 scripts) | 5,029 ms (55 scripts) |
| **Network Requests** | 83 | 86 | 83 |
| **Total Transfer** | 5,682 KB | 5,624 KB | 5,495 KB |

But these top-line numbers hide the real story. When we broke the traces into phases, one server call stood out as the dominant bottleneck.

## Where Does the Time Actually Go?

### Cold Load Waterfall (~27 seconds to interactive)

| Phase | Time | Duration | What's Happening |
|-------|------|----------|-----------------|
| Platform Bootstrap | 0 – 8.6s | **8.6s** | Experience Cloud shell, Aura framework, LWC engine, SLDS |
| First Contentful Paint | 8.9s | — | User sees the page skeleton |
| **`FlowRuntimeConnect.startFlow`** | **10.7s** | **13.1s** | Server-side Flow compilation — the bottleneck |
| Flow Component Definitions | 23.8s | — | Screen component bundles arrive |
| Data Calls (Apex + LDS) | 24.9 – 27s | **2.1s** | Controller calls, record fetches, picklist values |
| **Flow Fully Rendered** | **~27s** | — | User can finally interact |

### Warmed Flow Waterfall (~12.5 seconds)

| Phase | Time | Duration |
|-------|------|----------|
| Platform Bootstrap | 0 – 5.3s | **5.3s** |
| **`FlowRuntimeConnect.startFlow`** | **7.2s** | **1.2s** |
| Data Calls | 9.8 – 12.5s | **2.7s** |
| **Flow Fully Rendered** | **~12.5s** | — |

### The Smoking Gun

`FlowRuntimeConnect.startFlow` — the server-side call that compiles and initializes a Flow — takes **13.1 seconds cold vs. 1.2 seconds warm**. That's a 10x difference for the exact same flow, on the exact same org, minutes apart.

The actual screen components — the fields, sections, buttons, everything the user sees — render in just **1.4 to 2.7 seconds** once the platform delivers the compiled Flow to the browser. The components aren't slow. The platform's cold start is.

## Why Is the Cold Start So Brutal?

The 13-second `startFlow` penalty isn't a bug — it's a consequence of how the Salesforce multi-tenant platform works. Several factors compound to create that spinning wheel:

### 1. Apex Class Caching and Compilation

Salesforce uses a two-tier cache for compiled Apex code:

- **Level 1 Cache** — on each individual application server
- **Level 2 Cache** — shared across application servers

When a request arrives and the needed classes aren't in cache, the platform must reload and potentially recompile them. Research by [Kevin Jones (@nawforce)](https://nawforce.wordpress.com/2019/02/25/apex-cold-starts-and-class-caching-misses/) — a former Salesforce engineer — found that:

- **Cache miss cost scales primarily with the total number of Apex classes in the org** — not just the classes your Flow uses, but every class that needs to be in the cache
- [Recompilation costs approximately 20ms per invalid class](https://nawforce.wordpress.com/2019/02/09/invalid-apex-class-recompile-times/) plus a variable component based on code size
- Cold starts occur sporadically — triggered by server maintenance, cache eviction under memory pressure, or instance rebalancing
- There's no predictable pattern to when they happen

**This is the critical insight**: if your org has 500 Apex classes (between your custom code, managed packages, and ISV apps), a cold start could add 10+ seconds just from class cache misses — even if your Flow only references a handful of them. **Medium-to-large orgs get hit hardest.**

### 2. Flow Runtime Server-Side Compilation

The `startFlow` action doesn't just invoke your flow — it compiles it. On the server, it must:

- Resolve the Flow definition from metadata
- Compile the interview state (variables, screens, decision paths, assignments)
- Resolve all referenced Apex Invocable Actions and their entire dependency chains
- Fetch and prepare component definitions for every screen component
- Initialize the Aura component tree for the Flow runtime container

The 10x speed difference between cold (13.1s) and warm (1.2s) proves the server caches these compilation artifacts aggressively. But after periods of inactivity — overnight, over a weekend, or after a metadata deployment — that cache is gone and everything recompiles from scratch.

### 3. Experience Cloud Shell Overhead

Before your Flow even begins to load, the browser must bootstrap the entire Experience Cloud application:

- **Aura framework** (the container that hosts LWC components)
- **LWC engine** (the reactive component framework)
- **Lightning Design System** (~300KB+ of CSS)
- **Site navigation, header, footer, theme components**
- **Authentication, session management, security context**
- **Platform telemetry and instrumentation**

Our traces show **83 network requests totaling 5.7 MB** just for the shell. That's before a single Flow component loads.

### 4. Debug Mode: The Silent Performance Killer

With Debug Mode enabled on a user's profile, Salesforce injects additional JavaScript that wraps framework internals with logging hooks. Our measurements show it adds significant overhead:

- **4 extra scripts** loaded
- **29% more script evaluation time** (6,508 ms vs 5,029 ms)
- **42% more main thread blocking** (11.8s vs 8.3s)

Debug Mode is meant for developers actively troubleshooting — but we've seen production orgs where it was left enabled on standard user profiles, silently adding seconds to every page load.

### 5. Lightning Locker Service Proxy Overhead

If your org still uses Lightning Locker Service instead of Lightning Web Security (LWS), every JavaScript object access passes through heavyweight [Proxy wrappers](https://developer.salesforce.com/docs/platform/lightning-components-security/guide/lws-performance.html). Salesforce's own documentation states:

> *"The proxy performance cost is negligible when there are a few thousand proxies, but as the number grows into tens of thousands, the performance impact becomes observable... potentially exponential decrease in performance."*

For data-heavy components like tables or forms with many fields, Locker's proxy overhead can freeze the browser entirely. All of our tests ran with LWS enabled — without it, the numbers would be significantly worse.

### 6. Multi-Tenant Infrastructure

Salesforce is a shared platform. Your org's application server resources compete with thousands of other tenants:

- **Peak hours** (morning in your timezone) mean more competition for CPU and memory
- **Cache pressure from other tenants** can evict your org's cached classes to make room
- **Instance maintenance and rebalancing** can reset server-side caches without warning

## What You Can Do About It

### Quick Wins (No Code Required)

**Turn off Debug Mode in production.** Setup > Users > Edit each user > uncheck "Development Mode" and "Debug Mode." This alone can save 2–3 seconds per page load.

**Enable Lightning Web Security.** Setup > Session Settings > "Use Lightning Web Security for Lightning web components." This eliminates Locker's proxy overhead — a free performance win.

**Enable the Salesforce CDN.** Setup > Session Settings > "Enable Content Delivery Network (CDN) for Lightning Component framework." Salesforce reports a [15% improvement in cold boot times](https://developer.salesforce.com/blogs/2023/03/enable-cdn-to-load-lightning-experience-faster) at the 75th percentile. Surprisingly, [only 52% of orgs have this enabled](https://developer.salesforce.com/blogs/2023/03/enable-cdn-to-load-lightning-experience-faster).

**Audit your Apex footprint.** Remove unused classes, decommission abandoned managed packages, and consolidate redundant test helpers. Every class you remove reduces the cold start tax for every user.

**Keep Flow screens focused.** Our simple 10-field form triggered 59 script evaluations. More components = more JavaScript = longer load times. Split complex flows across multiple screens.

### The Creative Solution: Pre-Warming the Flow Cache

The quick wins help, but they don't solve the fundamental problem: the first user of the day still hits that 13-second `startFlow` cold start.

We solved this by building a **Flow Cache Warmer** — a Schedulable Batch Apex class that pre-compiles every screen flow in the org before users arrive.

#### How It Works

The architecture is simple but effective:

1. **A Batchable class** queries all active screen flow definitions in the org via `FlowDefinitionView`
2. **For each flow**, it constructs a `PageReference` to a Visualforce page containing a `<flow:interview>` tag for that flow
3. **It calls `pageReference.getContent()`** — which triggers the full server-side Flow compilation pipeline, the same `startFlow` work that takes 13 seconds cold
4. **But it does this in the background** via batch Apex — no user is waiting

The Visualforce page is the key trick. It contains conditional `<flow:interview>` tags — one per flow — rendered based on a `flowName` URL parameter:

```xml
<apex:page controller="CacheFlowController">
    <flow:interview name="My_Application_Form"
                    rendered="{!flowName == 'My_Application_Form'}"/>
    <flow:interview name="My_Registration_Flow"
                    rendered="{!flowName == 'My_Registration_Flow'}"/>
    <!-- One tag per screen flow in your org -->
</apex:page>
```

The controller simply reads the `flowName` parameter from the URL:

```apex
public class CacheFlowController {
    public String flowName { get; private set; }

    public CacheFlowController() {
        this.flowName = ApexPages.currentPage()
            .getParameters().get('flowName');
    }
}
```

And the batch iterates through every screen flow, one at a time:

```apex
public class CacheFlow_Batch implements Database.Batchable<FlowDefinitionView>,
                                        Schedulable,
                                        Database.AllowsCallouts {

    public void execute(SchedulableContext sc) {
        Database.executeBatch(new CacheFlow_Batch(), 1);
    }

    public Iterable<FlowDefinitionView> start(Database.BatchableContext info) {
        // Returns all active screen flows in the org
        return new CacheFlowsIterable();
    }

    public void execute(Database.BatchableContext BC,
                        List<FlowDefinitionView> scope) {
        for (FlowDefinitionView flow : scope) {
            try {
                PageReference pageRef = new PageReference('/apex/CacheFlowLocal');
                pageRef.getParameters().put('flowName', flow.ApiName);
                Blob content = pageRef.getContent(); // Triggers server-side compilation
            } catch (Exception ex) {
                System.debug(ex.getMessage());
            }
        }
    }
}
```

#### Setting It Up

1. Create the `CacheFlowLocal` Visualforce page with a `<flow:interview>` tag for each screen flow in your org
2. Create the controller and batch classes
3. Schedule the batch to run before your users' workday:

```apex
System.schedule('CacheFlow Daily Warm', '0 0 6 * * ?', new CacheFlow_Batch());
```

When the first real user hits the Experience Cloud page at 8 AM, the server-side Flow cache is already warm. They get the **1.2-second response** instead of the 13-second cold start.

#### Why `PageReference.getContent()` Is the Secret Weapon

The reason this works is that `getContent()` executes the Visualforce page server-side, which triggers the full `<flow:interview>` rendering pipeline — including `FlowRuntimeConnect.startFlow`. This is the same compilation work that would normally happen when a user first visits the page. By doing it in a background batch job, you shift that 13-second penalty from your users' morning to a scheduled job that runs while nobody's watching.

The `try/catch` is important — some flows may fail to compile in this context (e.g., flows that require specific input variables). That's fine. Even partial cache warming dramatically improves the user experience. The flows that compile successfully are cached; the ones that fail will just cold-start normally when a user hits them.

## The Bottom Line

The spinning wheel your users see isn't caused by slow components, a bad internet connection, or too many fields on the screen. It's caused by **Salesforce's server-side Flow compilation cache going cold** — compounded by Apex class cache misses that scale with the total amount of code in your org.

The platform offers no built-in way to keep this cache warm. But with a Schedulable Batch, a Visualforce page, and `PageReference.getContent()`, you can pre-compile every screen flow in your org before your users wake up.

Here's what that buys you:

| Scenario | Time to Interactive |
|----------|-------------------|
| Cold start (no warming) | ~27 seconds |
| **With CacheFlow warming** | **~7–12 seconds** |
| + Debug Mode off + LWS + CDN | **~5–7 seconds** |

The difference between a 27-second load and a 5-second load is the difference between users abandoning your portal and users completing their forms.

---

## Sources

- [Apex Cold Starts and Class Caching Misses — @nawforce](https://nawforce.wordpress.com/2019/02/25/apex-cold-starts-and-class-caching-misses/)
- [Invalid Apex Class Recompile Times — @nawforce](https://nawforce.wordpress.com/2019/02/09/invalid-apex-class-recompile-times/)
- [Understand How LWS Architecture Affects Component Performance — Salesforce Developers](https://developer.salesforce.com/docs/platform/lightning-components-security/guide/lws-performance.html)
- [Enable CDN to Load Lightning Experience Faster — Salesforce Developers Blog](https://developer.salesforce.com/blogs/2023/03/enable-cdn-to-load-lightning-experience-faster)
- [Improve Experience Cloud Site Performance — Salesforce Help](https://help.salesforce.com/s/articleView?id=experience.community_designer_performance_overview.htm&language=en_US&type=5)
- [Lightning Locker vs. Lightning Web Security — Salesforce Ben](https://www.salesforceben.com/lightning-locker-vs-lightning-web-security/)
- [Considerations for the Salesforce CDN — Salesforce Help](https://help.salesforce.com/s/articleView?language=en_US&id=sf.community_builder_cdn_considerations.htm&type=5)

---

*Performance data collected using Chrome DevTools on a Salesforce scratch org, February 2026. Results vary by org size, Apex class count, network conditions, and browser. The CacheFlow pattern has been deployed in production across multiple client organizations.*
