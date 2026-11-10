# Installation

> Install Flow Tool Kit from AppExchange, assign permission sets, and verify everything is working.

{% hint style="info" %}
**Prerequisites**: You need System Administrator access to install managed packages in your Salesforce org.
{% endhint %}

## Install from AppExchange

1. Go to the [Flow Tool Kit listing on AppExchange](https://appexchange.salesforce.com/appxListingDetail?listingId=a0N4V00000HC4zCUAT).
2. Click **Get It Now**.
3. Choose the org where you want to install (production or sandbox).
4. Select **Install for Admins Only** (recommended); you can grant access to other users later via permission sets.
5. Wait for the installation to complete. You'll receive an email confirmation.

{% hint style="warning" %}
**Install in a sandbox first.** Always test new packages in a sandbox before installing in production. This lets you verify compatibility with your existing customizations.
{% endhint %}

## Assign Permission Sets

Flow Tool Kit includes three permission sets. Assign them based on each user's role:

| Permission Set | Who Gets It | What It Grants |
|---------------|-------------|----------------|
| **Form Builder Admin** | System Administrators | Full access: all components, objects, fields, configuration, and admin utilities |
| **Form Builder Manager** | Admins who build and manage forms | Build and manage forms, templates, and submissions; everything except admin-only utilities |
| **Form Flow User** | End users who fill out forms | Minimum access to fill out forms in Flows: read access to form metadata, no builder access |

To assign a permission set:

1. Go to **Setup → Users → [Select User]**.
2. In the **Permission Set Assignments** section, click **Edit Assignments**.
3. Add the appropriate permission set and click **Save**.

{% hint style="info" %}
**Delegated Admin Pattern**: Use **Form Builder Manager** for non-admin users who need to create and manage forms. This gives them full form-building capabilities without requiring a System Administrator profile. See [Permission Sets](permission-sets.md) for details.
{% endhint %}

## Verify the Installation

After installation and permission set assignment:

1. **Open the App Launcher** (waffle icon) and search for "Form Builder".
2. **Click the Form Builder tab**: you should see the Form Builder interface with options to create a new form.
3. **Create a test form**: select any object (e.g., Account), add a section, add a few fields, and save.
4. **Test in a Flow**: create a simple screen flow, add the "Flow Form" component, select your test form, and preview it.

If you see the Form Builder tab and can create a form, Flow Tool Kit is installed correctly.

{% hint style="warning" %}
**Can't see the Form Builder tab?** Make sure you've assigned the **Form Builder Admin** or **Form Builder Manager** permission set. The tab is only visible to users with the correct permissions.
{% endhint %}

## Check the Form Cache

Nothing to do here in most orgs; this is a one-minute check.

Flow Tool Kit keeps every built form, theme, label and style sheet in a Platform Cache partition named **FormComponents**. Because Flow Tool Kit is a security-reviewed AppExchange package, Salesforce gives that partition **3 MB of cache free** the moment the package installs. You cannot remove it, and you do not need to set it up.

To see it: Setup → **Platform Cache** → open **FormComponents** (namespace FlowToolKit). The Organization cache should show at least 3 MB, listed as Provider Free.

| Org | What you get |
|---|---|
| Enterprise, Unlimited, Performance | 3 MB free, automatically. Large orgs can add more from the org's own cache on the same page. |
| Developer Edition | 3 MB free, automatically. |
| Professional Edition | No Platform Cache. Forms still work, but every form load builds the form from scratch. |
| Scratch org | Only when the org definition turns cache on. See [Cache Reset](../advanced-topics/cache-reset.md#where-the-cache-lives). |

Without the cache, every form load rebuilds the form from scratch and nothing reports an error. One form measured 2,875 ms to load without the cache against 60 ms with it. See [Troubleshooting](../faq-troubleshooting/troubleshooting.md#every-form-load-is-slow-not-only-the-first).

## Schedule the Daily Warmer

Do this once, before you go live. It is the single highest-impact performance step for Flow Tool Kit.

Salesforce recompiles every screen flow on its first run of the day, which costs a real person 20 seconds or more of waiting. Flow Tool Kit ships a scheduled job that pays that cost overnight instead. As of 4.13 it warms your own screen flows too, not only the packaged ones.

1. Setup → **Apex Classes** → **Schedule Apex**.
2. Job Name: `Cache_FlowToolKit_Components`.
3. Apex Class: `FormCacheResetIterable_Batch`.
4. Frequency: **daily**, before your earliest users start work (for example 5:00 AM).
5. Save.

Schedule it as yourself, an active administrator. Full detail, including how to verify it ran and how to extend per-flow warming to your own flows, is in [Schedule Flow Cache Warming](../how-to-guides/schedule-flow-cache-warming.md).

{% hint style="warning" %}
**Upgrading rather than installing fresh?** Check Setup → **Scheduled Jobs** for an existing `Cache_FlowToolKit_Components` entry. If its **Submitted By** column is blank, it was created automatically by an old installer, has never worked, and needs to be deleted and re-created by you.
{% endhint %}

## Next Steps

- [Quick Start Guide](quick-start.md): build your first real form in 5 minutes
- [Core Concepts](core-concepts.md): understand how forms, sections, fields, and templates work together
- [Permission Sets](permission-sets.md): detailed breakdown of what each permission set grants
