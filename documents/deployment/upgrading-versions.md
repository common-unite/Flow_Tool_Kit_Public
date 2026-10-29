# Upgrading Package Versions

> How to upgrade Flow Tool Kit to a new version: what to check and post-upgrade steps.

## Overview

Flow Tool Kit is a managed package installed from AppExchange. When a new version is released, you upgrade the package to get new features, bug fixes, and improvements. Your form configurations (CMDT records) are preserved during upgrades; they're your data, not the package's.

## Pre-Upgrade Checklist

1. **Read the release notes**: check [Release Notes](../release-notes/release-3.211.md) for the version you're upgrading to. Look for:
   - Breaking changes or deprecated features
   - New features that require configuration
   - New permission set entries
2. **Upgrade in sandbox first**: install the new version in a sandbox and test your forms before upgrading production.
3. **Back up your CMDT records**: retrieve your form metadata via SFDX as a safety net.

## Upgrade Steps

1. Go to the [Flow Tool Kit AppExchange listing](https://appexchange.salesforce.com/appxListingDetail?listingId=a0N4V00000HC4zCUAT).
2. Click **Get It Now** and select the org to upgrade.
3. Follow the installation prompts.
4. Wait for the upgrade to complete (you'll receive an email).

## Post-Upgrade Steps

### 0. LWR sites: place FlowToolKit LWR Support, then publish every site

If you run an **LWR** Experience site (Build Your Own (LWR) / Microsite) that shows a Flow Tool Kit form, do this before anything else. The upgrade does not reach an LWR site until the site is published, and a site published on Winter '27 or later without the support component drops the form engine from every page that holds only a Form Template.

1. Open the site in Experience Builder, on any page. Scroll to the **Theme Footer** region at the bottom; it belongs to the theme layout and appears on every page.
2. Drag **FlowToolKit LWR Support** from the Components panel into an empty column of that footer. It renders nothing. If the site uses more than one theme layout, do this in each layout whose pages show a form.
3. Click **Publish**.
4. Open a form page by its own address in a private window and confirm the form shows its fields, with no `LWR3008` error in the browser console.

Why both steps: an LWR site keeps serving the component code captured at its last publish, so an upgraded package is not on the site until you publish. Since Winter '27 the publisher bundles only the components it can see on your pages at publish time, and the Form Template loads its section forms on demand, so without the support component a form page gets no section forms (blank sections, or `component/latest` requests failing with 401 or 503 in the Network panel). A site that worked on an earlier publish breaks on its next publish without this step.

Aura sites and Lightning pages need no change. See [LWR Sites: Setup and Considerations](../experience-cloud/lwr-site-component-support.md), which also covers the guest settings LWR sites need.

### 1. Verify Permission Sets

New versions may add Apex classes, objects, or fields that need to be in permission sets:

1. Go to **Setup → Permission Sets**.
2. Open each Flow Tool Kit permission set (Admin, Manager, Flow User).
3. Verify they have the latest entries; the managed package update should handle this automatically.

### 2. Clear Form Cache and Re-Warm

After upgrading, clear the form cache so the new package code reads fresh metadata:

Open **Form Builder** and click **Reset Form Cache**. The button requires the **Form Component Admin** custom permission.

An upgrade also discards every warmed screen flow in the org, because the components themselves are replaced. The Reset Form Cache button re-warms them as part of the same job. If you upgraded during business hours and did not use the button, run this from Developer Console → Execute Anonymous so your next visitor does not pay the full cold start:

```apex
FlowToolKit.CacheFlowController.resetFlowCache();
```

See [Schedule Flow Cache Warming](../how-to-guides/schedule-flow-cache-warming.md) for the daily job that keeps this from being a manual step.

### 3. Test Your Forms

1. Open **Form Builder**; verify it loads without errors.
2. Run a Flow with your forms; verify rendering, validation, and submission.
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
| "Insufficient access" errors after upgrade | Re-check permission set assignments; new classes may have been added |
| Forms look different after upgrade | Clear browser cache (Cmd+Shift+R / Ctrl+Shift+R), then **Reset Form Cache** in Form Builder |
| First form load is very slow after upgrade | Expected - the upgrade re-colds every flow. Re-warm as in step 2 |
| New features not appearing | Verify the upgrade completed successfully in Setup → Installed Packages |
| Flows with Flow Tool Kit components won't save | A new required property may have been added; check release notes |

{% hint style="info" %}
**Version compatibility**: Flow Tool Kit maintains backward compatibility across versions. Your existing forms should work without changes after upgrading. If something breaks, check the release notes for known issues.
{% endhint %}

## Related Pages

- [Release Notes](../release-notes/release-3.211.md): version history
- [Installation](../getting-started/installation.md): first-time installation
- [Deployment Overview](deployment-overview.md): deploying form metadata
