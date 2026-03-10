# Cache Reset

> When and how to reset Flow Tool Kit's form and flow cache.

## Overview

Flow Tool Kit caches form metadata for performance — instead of querying Custom Metadata Types on every form load, it stores parsed form definitions in the platform cache. This makes forms load faster but means changes in Form Builder aren't instantly visible at runtime.

## When to Reset Cache

Reset the cache when:
- You've made changes in Form Builder that aren't appearing at runtime
- You've deployed new CMDT records and forms show old data
- After upgrading the Flow Tool Kit package
- Conditional logic rules aren't reflecting recent changes
- Themes or labels appear outdated

## How to Reset

### Method 1: CacheFlow Visualforce Page

Navigate to:
```
https://your-org.lightning.force.com/apex/FlowToolKit__CacheFlow
```

This page clears all cached form data. After clearing:
- The next form load will query fresh metadata
- All users will see the updated forms

{% hint style="info" %}
**Tip**: Bookmark the CacheFlow page for quick access. Only users with the **Form Builder Admin** permission set can access it.
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

## Troubleshooting

| Symptom | Likely Cache Issue? | Action |
|---------|:------------------:|--------|
| Old fields showing on form | Yes | Reset cache |
| New fields not appearing | Yes | Reset cache |
| Conditional logic outdated | Yes | Reset cache |
| Theme colors wrong | Yes | Reset cache |
| Form not loading at all | No | Check permissions and configuration |
| Error messages | No | Check form setup and object access |

{% hint style="warning" %}
**Cache reset affects all users.** After a reset, the first form load for each user will be slightly slower as the cache is rebuilt. This is temporary — subsequent loads are fast again.
{% endhint %}

## Related Pages

- [Troubleshooting](../faq-troubleshooting/troubleshooting.md) — common issues and solutions
- [Deploying Metadata](../deployment/deploying-metadata.md) — post-deployment cache clearing
- [Upgrading Versions](../deployment/upgrading-versions.md) — post-upgrade steps
