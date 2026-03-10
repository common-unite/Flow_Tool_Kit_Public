# Upgrading Package Versions

> How to upgrade Flow Tool Kit to a new version — what to check and post-upgrade steps.

## Overview

Flow Tool Kit is a managed package installed from AppExchange. When a new version is released, you upgrade the package to get new features, bug fixes, and improvements. Your form configurations (CMDT records) are preserved during upgrades — they're your data, not the package's.

## Pre-Upgrade Checklist

1. **Read the release notes** — check [Release Notes](../release-notes/release-3.211.md) for the version you're upgrading to. Look for:
   - Breaking changes or deprecated features
   - New features that require configuration
   - New permission set entries
2. **Upgrade in sandbox first** — install the new version in a sandbox and test your forms before upgrading production.
3. **Back up your CMDT records** — retrieve your form metadata via SFDX as a safety net.

## Upgrade Steps

1. Go to the [Flow Tool Kit AppExchange listing](https://appexchange.salesforce.com/appxListingDetail?listingId=a0N4V00000HC4zCUAT).
2. Click **Get It Now** and select the org to upgrade.
3. Follow the installation prompts.
4. Wait for the upgrade to complete (you'll receive an email).

## Post-Upgrade Steps

### 1. Verify Permission Sets

New versions may add Apex classes, objects, or fields that need to be in permission sets:

1. Go to **Setup → Permission Sets**.
2. Open each Flow Tool Kit permission set (Admin, Manager, Flow User).
3. Verify they have the latest entries — the managed package update should handle this automatically.

### 2. Clear Form Cache

After upgrading, clear the form cache to ensure the new package code uses fresh metadata:

Navigate to: `your-org/apex/FlowToolKit__CacheFlow`

### 3. Test Your Forms

1. Open **Form Builder** — verify it loads without errors.
2. Run a Flow with your forms — verify rendering, validation, and submission.
3. If using Experience Cloud, test public-facing forms.
4. If using Form Templates, test multi-page form navigation and submission.

### 4. Check for New Features

Review the release notes for new features you may want to enable:
- New component properties
- New invocable actions
- New configuration options

## Troubleshooting Upgrades

| Issue | Fix |
|-------|-----|
| "Insufficient access" errors after upgrade | Re-check permission set assignments — new classes may have been added |
| Forms look different after upgrade | Clear browser cache (Cmd+Shift+R / Ctrl+Shift+R) and form cache |
| New features not appearing | Verify the upgrade completed successfully in Setup → Installed Packages |
| Flows with Flow Tool Kit components won't save | A new required property may have been added — check release notes |

{% hint style="info" %}
**Version compatibility**: Flow Tool Kit maintains backward compatibility across versions. Your existing forms should work without changes after upgrading. If something breaks, check the release notes for known issues.
{% endhint %}

## Related Pages

- [Release Notes](../release-notes/release-3.211.md) — version history
- [Installation](../getting-started/installation.md) — first-time installation
- [Deployment Overview](deployment-overview.md) — deploying form metadata
