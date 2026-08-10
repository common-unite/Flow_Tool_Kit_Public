# Schedule Flow Cache Warming

Screen flows on Salesforce pay a heavy first-load penalty: the platform compiles each flow on its first run, and that compiled state does not last. Our measurements across subscriber-style orgs show a flow's first load costing **20-27 seconds of server time**, dropping to a few hundred milliseconds once warm - and going cold again **every night** and **after any metadata deploy in your org, including editing a single flow**. Salesforce acknowledges the symptom in a Known Issue ("Screen Flow takes more than 20 seconds for an initial load each day"); no platform fix exists today.

Flow Tool Kit ships a cache warmer that pre-pays this cost before your users arrive. **Scheduling it is the single highest-impact performance change an admin can make**, and as of 4.13 it also warms your own flows, not just ours.

## What the warmer does

`FormCacheResetIterable_Batch` runs as a scheduled job. It refreshes Flow Tool Kit's form caches, then hands off to the flow warmer, which renders every active screen flow in your org one at a time through a Visualforce page.

There are **two separate costs**, and the warmer addresses them differently. Understanding the split is what lets you get the most out of it.

| Tier | What it is | Who pays it | How it gets warmed |
|---|---|---|---|
| **Shared component definitions** | Compiling the Flow Tool Kit components themselves - the form renderer, tables, lookups, repeating sections and so on. Shared by every flow that uses them. | The first flow of the day to touch a given component | **Automatic.** The packaged Warm Up flow (below) - no setup beyond scheduling the job |
| **Per-flow compile** | Compiling one specific flow definition. Charged separately for every flow, every morning. | The first visitor to each individual flow | Only for flows listed on a Visualforce page - ours are; yours need `CacheFlowLocal` |

Outcomes are written to the debug log (`CACHEFLOW_WARM` lines - see "Confirm it is working"). The job never emails anyone: it runs daily across every screen flow in your org, so a notification on failure would reach you every morning.

## The Warm Up flow: your own flows get faster too

**New in 4.13.** Flow Tool Kit now ships a screen flow labelled **Warm Up Components** (API name `Utility_Warm_Up_Components`), whose only screen holds a component that renders nothing and exists solely to reference every Flow Tool Kit component at once.

Warming that one flow compiles the entire component library in a single pass. Because those definitions are shared org-wide, **every other flow that uses Flow Tool Kit components then loads fast - including flows you built yourself, which the warmer has no other way to reach.**

Measured on a fresh set of never-before-run flows, warming this one flow first:

| Component | First-ever load, cold | First-ever load, after the Warm Up flow |
|---|---|---|
| Form Template | 12.25s | **1.48s** |
| Data Table | 4.08s | **0.93s** |
| Lookup | 1.83s | **0.99s** |
| *(empty control flow, for reference)* | 0.70s | 0.97s |

After warming, every component's first-ever load landed at or under roughly 1.7x the cost of an empty flow that does nothing at all. The Warm Up flow itself absorbs about **26 seconds** during the batch run - that is the whole compile, paid once, by a scheduled job at 5 AM instead of by a person.

**You do not need to do anything to enable this** beyond scheduling the daily job. The flow is active on install and the batch already knows to warm it.

{% hint style="info" %}
This is why scheduling matters even if every flow in your org is your own. Before 4.13 a subscriber who never built a `CacheFlowLocal` page got nothing from the warmer. Now they get the entire shared tier.
{% endhint %}

## Schedule the daily job

The job must be scheduled by an **active administrator** - see "Fix a broken legacy schedule" below for why.

1. Setup → **Apex Classes** → **Schedule Apex**.
2. Job Name: `Cache_FlowToolKit_Components`.
3. Apex Class: `FormCacheResetIterable_Batch`.
4. Frequency: **daily**, at a time before your earliest users start work (for example 5:00 AM in your org's primary timezone).
5. Save.

Daily is the minimum, not a suggestion: the platform's per-flow cache does not survive the night. In our measurements, flows warm at bedtime were fully cold 7.5 hours later.

## Fix a broken legacy schedule

Earlier versions of Flow Tool Kit scheduled this job automatically during package installation. Jobs created that way are owned by a temporary system user that cannot hold permissions, and they **fail silently every day**. Check yours:

1. Setup → **Scheduled Jobs**.
2. Find `Cache_FlowToolKit_Components`.
3. If **Submitted By is blank**, the job is owned by the phantom installer user and has never worked. Delete it.
4. Re-create it using the steps above, as yourself.

## Confirm it is working

Warming is invisible by design, so verify it rather than assume it. After a scheduled run, open Setup → **Apex Jobs**, find the batch, and check the debug log for lines beginning `CACHEFLOW_WARM`. Each flow produces one line with an outcome:

| Outcome | Meaning | What to do |
|---|---|---|
| `WARMED_VF` | The flow rendered and was warmed. The line includes the byte count. | Nothing |
| `SKIPPED_NO_COVERAGE` | No Visualforce tag matched this flow, so only an empty shell rendered. **The flow was not warmed.** | Add it to `CacheFlowLocal` (below) if you want it warmed |
| `FAILED_RENDER` | The render threw. | Check the flow is active and the running user can run it |

A final `CACHEFLOW_WARM_SUMMARY` line totals all three. Outcomes are **verified from what actually rendered**, never assumed - a flow is only reported as warmed if the page returned real content.

Failures appear as a `CACHEFLOW_WARM_FAILURES` line naming each flow. Nothing is emailed, so check the log after a run when you want to confirm the outcome.

## Re-run warming after changes

Three events reliably re-cold **every** screen flow in your org:

- **Any metadata deploy** - including saving a new version of a single flow. One flow edit at midday means every flow's next first visitor pays the full cold start.
- **Package installs and upgrades** (Flow Tool Kit's or any other).
- **Flow Tool Kit upgrades specifically** also discard the warmed component definitions, because the components themselves are replaced.

After any of these, run the flow warmer on demand from Developer Console → Execute Anonymous:

```apex
FlowToolKit.CacheFlowController.resetFlowCache();
```

This warms flows. It does **not** reset the form metadata cache - for that, use the **Reset Form Cache** button in Form Builder, which does both.

Upgrading Flow Tool Kit in the middle of the workday without re-warming means your next visitor pays the full cold compile. Either upgrade outside business hours and let the nightly job absorb it, or run the line above immediately afterward.

## Extend full warming to your own flows

The Warm Up flow gets your flows the shared component tier automatically. This section closes the remaining gap: the **per-flow compile**, which is charged separately for every flow definition and can only be pre-paid by rendering that specific flow.

The platform requires each warmed flow to have its own `<flow:interview>` tag on a Visualforce page (tag names cannot be dynamic). Create one page in your org listing your screen flows:

1. Setup → **Visualforce Pages** → New. Name it exactly `CacheFlowLocal`.
2. One gated tag per screen flow:

```xml
<apex:page controller="FlowToolKit.CacheFlowController">
    <flow:interview name="My_Application_Flow" rendered="{!flowName == 'My_Application_Flow'}"/>
    <flow:interview name="My_Intake_Flow" rendered="{!flowName == 'My_Intake_Flow'}"/>
    <!-- one line per screen flow you want warmed -->
</apex:page>
```

3. Save. The nightly job detects the page automatically and warms every flow you listed. Add a line whenever you create a new flow.

Any flow you leave off the page still benefits from the shared component tier - it will simply also pay its own per-flow compile on its first load of the day. Flows you have not listed appear in the log as `SKIPPED_NO_COVERAGE`, which is a report, not an error.

## Launch flows the fast way

Independent of warming: never launch screen flows from Detail Page Buttons or links whose URL starts with `/flow/`. That surface boots a separate application context with its own cold caches, and it is the exact subject of Salesforce's daily-20-second Known Issue. Use **Flow Actions** or flows embedded in Lightning/Experience pages instead - they reuse the session your user already warmed.

## Related pages

- [Cache Reset](../advanced-topics/cache-reset.md): resetting the form metadata cache, which is a different cache from the one this page warms
- [Upgrading Versions](../deployment/upgrading-versions.md): post-upgrade steps, including re-warming
- [LWR Sites: Component Support Block](../experience-cloud/lwr-site-component-support.md): required on LWR sites, because they bundle components at publish time rather than loading them on demand
