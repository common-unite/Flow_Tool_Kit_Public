# Installation

> Install Flow Tool Kit from AppExchange, assign permission sets, and verify everything is working.

{% hint style="info" %}
**Prerequisites**: You need System Administrator access to install managed packages in your Salesforce org.
{% endhint %}

## Install from AppExchange

1. Go to the [Flow Tool Kit listing on AppExchange](https://appexchange.salesforce.com/appxListingDetail?listingId=a0N4V00000HC4zCUAT).
2. Click **Get It Now**.
3. Choose the org where you want to install (production or sandbox).
4. Select **Install for Admins Only** (recommended) — you can grant access to other users later via permission sets.
5. Wait for the installation to complete. You'll receive an email confirmation.

{% hint style="warning" %}
**Install in a sandbox first.** Always test new packages in a sandbox before installing in production. This lets you verify compatibility with your existing customizations.
{% endhint %}

## Assign Permission Sets

Flow Tool Kit includes three permission sets. Assign them based on each user's role:

| Permission Set | Who Gets It | What It Grants |
|---------------|-------------|----------------|
| **Form Builder Admin** | System Administrators | Full access — all components, objects, fields, configuration, and admin utilities |
| **Form Builder Manager** | Admins who build and manage forms | Build and manage forms, templates, and submissions — everything except admin-only utilities |
| **Form Flow User** | End users who fill out forms | Minimum access to fill out forms in Flows — read access to form metadata, no builder access |

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
2. **Click the Form Builder tab** — you should see the Form Builder interface with options to create a new form.
3. **Create a test form** — select any object (e.g., Account), add a section, add a few fields, and save.
4. **Test in a Flow** — create a simple screen flow, add the "Flow Form" component, select your test form, and preview it.

If you see the Form Builder tab and can create a form, Flow Tool Kit is installed correctly.

{% hint style="warning" %}
**Can't see the Form Builder tab?** Make sure you've assigned the **Form Builder Admin** or **Form Builder Manager** permission set. The tab is only visible to users with the correct permissions.
{% endhint %}

## Next Steps

- [Quick Start Guide](quick-start.md) — build your first real form in 5 minutes
- [Core Concepts](core-concepts.md) — understand how forms, sections, fields, and templates work together
- [Permission Sets](permission-sets.md) — detailed breakdown of what each permission set grants
