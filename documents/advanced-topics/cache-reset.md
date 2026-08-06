# Cache Reset

> When and how to reset Flow Tool Kit's form and flow cache.

## Overview

Flow Tool Kit caches form metadata for performance: instead of querying Custom Metadata Types on every form load, it stores parsed form definitions in the platform cache. This makes forms load faster but means changes in Form Builder aren't instantly visible at runtime.

## When to Reset Cache

Reset the cache when:
- You've made changes in Form Builder that aren't appearing at runtime
- You've deployed new CMDT records and forms show old data
- After upgrading the Flow Tool Kit package
- Conditional logic rules aren't reflecting recent changes
- Themes or labels appear outdated

## How to Reset

### Method 1: The Reset Form Cache button

Open **Form Builder** and click **Reset Form Cache** in the toolbar.

This is the only supported way to clear the cache on demand. It empties the cache partition, re-saves every form definition, and then re-warms your screen flows in the same job. After it finishes:
- The next form load queries fresh metadata
- All users see the updated forms

The button is visible only to users with the **Form Component Admin** custom permission.

{% hint style="info" %}
**The job is asynchronous.** The toast reports a Job Id; the cache is not clear until that batch finishes. Track it in Setup → **Apex Jobs**.
{% endhint %}

{% hint style="warning" %}
Do not use `/apex/FlowToolKit__CacheFlow` for this. Earlier versions of this page documented that URL as a cache reset; it is not one. That page is the internal render surface used by the flow warming job and clears nothing when you visit it.
{% endhint %}

### Method 2: Wait for Automatic Refresh

Form cache has a built-in TTL (time-to-live). If you can wait, the cache will automatically refresh within a few minutes.

### Method 3: Hard Refresh the Browser

Sometimes the issue is browser caching, not server caching:
- **Mac**: Cmd + Shift + R
- **Windows**: Ctrl + Shift + R

This forces the browser to reload all JavaScript and CSS, which can resolve display issues.

## What Gets Cached

| Cache | Contains | Impact of Reset |
|-------|----------|----------------|
| **Form definitions** | Parsed Form__mdt, Section, Field records | Next load queries CMDTs fresh |
| **Conditional logic** | Parsed logic rules and conditions | Next evaluation uses fresh rules |
| **Themes** | Parsed style sheet metadata | Next render applies fresh styles |

## Two different caches

Flow Tool Kit performance involves two caches that are easy to confuse. Resetting one does nothing for the other.

| | Form metadata cache | Screen flow compile cache |
|---|---|---|
| **Holds** | Parsed form, logic, theme and label definitions | The platform's compiled screen flows and component definitions |
| **Owned by** | Flow Tool Kit (platform cache partition) | Salesforce |
| **Symptom when cold or stale** | Form shows *old* configuration | Form is *slow* to load - 20 seconds or more |
| **You want to** | **Reset** it, so it re-reads metadata | **Warm** it, so nobody waits |
| **How** | Reset Form Cache button, this page | [Schedule Flow Cache Warming](../how-to-guides/schedule-flow-cache-warming.md) |

If forms are showing outdated *content*, reset. If forms are showing correct content *slowly*, warming is what you need.

## Troubleshooting

| Symptom | Likely Cache Issue? | Action |
|---------|:------------------:|--------|
| Old fields showing on form | Yes | Reset cache |
| New fields not appearing | Yes | Reset cache |
| Conditional logic outdated | Yes | Reset cache |
| Theme colors wrong | Yes | Reset cache |
| Form not loading at all | No | Check permissions and configuration |
| Error messages | No | Check form setup and object access |
| Form correct but takes 20+ seconds on first load each day | No | Schedule flow cache warming |

{% hint style="warning" %}
**Cache reset affects all users.** After a reset, the first form load for each user will be slightly slower as the cache is rebuilt. This is temporary; subsequent loads are fast again.
{% endhint %}

## Related Pages

- [Schedule Flow Cache Warming](../how-to-guides/schedule-flow-cache-warming.md): the daily job that pre-pays screen flow load cost
- [Troubleshooting](../faq-troubleshooting/troubleshooting.md): common issues and solutions
- [Deploying Metadata](../deployment/deploying-metadata.md): post-deployment cache clearing
- [Upgrading Versions](../deployment/upgrading-versions.md): post-upgrade steps
