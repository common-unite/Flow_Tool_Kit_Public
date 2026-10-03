# Guest Forms Quickstart

> A checklist for putting a Form Template on an Experience Cloud site that anyone can fill out without logging in. Work through it top to bottom; each step links to the detailed page if you need more.

{% hint style="info" %}
**Before you start:** Flow Tool Kit is installed, you have a Form Template that is **Active**, and Digital Experiences is turned on (**Setup → Digital Experiences → Settings → Enable Digital Experiences**).
{% endhint %}

## 1. Create the site

- [ ] **Setup → Digital Experiences → All Sites → New.**
- [ ] Pick a template. **Build Your Own (Aura)** needs the fewest extra settings. **Build Your Own (LWR)** works too; do the LWR extras in step 8.
- [ ] Give the site a name and a URL (for example `forms`), then **Create**.
- [ ] In the site's **Workspaces → Administration → Settings**, click **Activate**. A site that is not active shows guests nothing.

## 2. Let guests in

- [ ] Open the site in **Experience Builder** (**Workspaces → Builder**).
- [ ] **Settings → General**: tick **Public can access the site**.
- [ ] Note the **Guest User Profile** link on the same panel. You use the guest user in steps 4 to 7.

## 3. Add record pages for Form Template and Form Submission

Object pages give every Form Template its own link on the site, so one page serves all your forms. Resume links from save and resume land on the Form Template page, and links to a saved submission open it on the Form Submission page. Flow Tool Kit ships a page template for each.

- [ ] In Experience Builder, open the **Pages** menu → **New Page** → **Object Pages** → choose **Form Template** → **Create**. Builder adds a detail page, a list page and a related list page.
- [ ] Repeat for **Form Submission**.
- [ ] Open **Form Template Detail** → page properties (the gear) → **Page Variations** → **New Page Variation** → choose the **Form Template Detail** template → **Next**, name it, **Create**. Then make it the page's default variation and delete the standard one. The template holds **Form (Template)** bound to the page's record, and a page title from the record's name.
- [ ] Do the same on **Form Submission Detail** with the **Form Submission Detail** template. Given a Form Submission, the form opens that submission with its saved answers.
- [ ] **LWR sites:** the templates are for Aura sites. On an LWR site, remove the standard record components from each detail page and drag **Form (Template)** on instead, with **Record Id** set to `{!Route.recordId}`. Also drag **FlowToolKit LWR Support** into the site footer.
- [ ] **Publish** the site.

A form's link is then `https://<your site>/s/form-template/<Form Template Id>` (LWR sites have no `/s`). Share that link, use it in the resume email (see [Stages Mode](../form-template-framework/stages-mode.md)), and build buttons and menu items from it.

{% hint style="info" %}
**One fixed form instead:** on any regular page, drag **Form (Template)** and set **Record Id** to the Form Template's Id.
{% endhint %}

Guests read a Form Template page through the sharing rule in step 5. A Form Submission is private to external users, so the Form Submission page is for logged-in site members opening their own submissions; guests come back to a saved form through a resume link on the Form Template page instead.

## 4. Give the guest user the Form Flow User permission set

- [ ] In Experience Builder, **Settings → General → Guest User Profile** link → **View Users** → open the site's guest user.
- [ ] **Permission Set Assignments → Edit Assignments** → add **Form Flow User** → **Save**.

Form Flow User gives guests Read and Create on the form objects and access to the packaged form flows. Guests can never hold Edit or Delete, which is why the save override in step 6 exists. See [Permission Sets](../getting-started/permission-sets.md).

- [ ] If the form writes to or reads other objects (Contact, Account, a custom object), grant the guest **Read** and **Create** on those objects and access to the fields the form uses, in a permission set of your own assigned the same way.

## 5. Share the records guests need

External users see no records by default. Create guest user sharing rules in **Setup → Sharing Settings**, in each object's **Sharing Rules** list, with **New** and the rule type **Guest user access, based on criteria**. Set each one to **Read Only**.

- [ ] **Form Template**: criteria **IsActive equals True**. Without it the form does not load for guests.
- [ ] **Form Submission**, only if your templates use a [Pre-fill Template](../form-template-framework/prefill-templates.md#who-can-read-the-pre-fill-template): criteria **Is Pre-fill Template equals True**. Key the rule on that checkbox, never on the record type. Without it the form opens without its default answers and shows a notice saying so.
- [ ] Any other records the form shows or searches, for example Accounts in a [Record Picker](use-the-record-picker.md). Share only what the form needs, with criteria. A guest sharing rule makes those records visible to anyone on the internet.

## 6. Set up the save override for guests

Guests save through the flow **(Form) Upsert | Overridable**. The packaged flow runs as the respondent, so a guest save is refused whenever it would update a saved submission (save and resume) or point at a record the guest cannot read (an Account or Contact passed in the URL or by a prefill flow). Since 4.46 the form shows the refusal instead of a false "Submitted successfully".

{% hint style="success" %}
**Installed with the Flow Tool Kit installer, 4.46 or later?** Its optional step **Install the Guest Save Override (inactive)** has done the first two items for you: **Setup → Flows** holds **(Form) Upsert | Guest Override**, already in System Context Without Sharing, and the permission set **Form Flow (Guest User)** already grants it. Review the override, **Activate** it, and assign the permission set to the guest user as in step 4. See [The installer's guest save override](../advanced-topics/overriding-packaged-flows.md#the-installers-guest-save-override).
{% endhint %}

- [ ] **Setup → Flows** → open **(Form) Upsert | Overridable** → **Save As** to create your override.
- [ ] In the new flow, open the flow's properties (**Show Advanced**) and set **How to Run the Flow** to **System Context Without Sharing-Access All Data**. Save and **Activate**. From then on every form uses your override instead of the packaged flow.
- [ ] Create a permission set of your own, add your override under **Flow Access**, and assign it to the guest user as in step 4. Form Flow User only grants the packaged flow; without this the save fails with "You do not have permission to run this form's save process".

{% hint style="warning" %}
**Your override runs without sharing for anyone who can open the form.** Keep it to saving the submission it receives, and review it like any other code that runs for the public. Flow Tool Kit ships nothing in system mode; the override is yours. See [Guest users and the upsert override](../form-template-framework/prefill-flow.md#guest-users-and-the-upsert-override) and, if the override is deployed with metadata rather than built in Setup, [Overriding Packaged Flows](../advanced-topics/overriding-packaged-flows.md): it may arrive inactive, and a flow with a local action needs API 63 or later.
{% endhint %}

If your templates use a **prefill flow** or **resume links**, their overrides need the same treatment; see [Prefill Flow](../form-template-framework/prefill-flow.md) and [Stages Mode](../form-template-framework/stages-mode.md).

## 7. Optional extras

- [ ] **Bot protection:** [Add reCAPTCHA](add-recaptcha.md). Guests also need the external credential access that page lists.
- [ ] **Speed:** confirm **Setup → Session Settings → Use Lightning Web Security for Lightning web components** is on.
- [ ] **On your own website instead of the site page:** use [Iframe Embed](../advanced-topics/iframe-embed.md); steps 4 to 6 apply to that site's guest user too.

## 8. LWR sites only

- [ ] **Workspaces → Administration → Preferences**: turn on **Allow guest users to access public APIs**. Without it the form does not load for guests. It is not deployable, so set it in every org and after every sandbox refresh.
- [ ] Turn on **Let guest users view asset files, library files, and CMS content available to the site** if forms use image assets.
- [ ] **Publish the site again after every Flow Tool Kit upgrade.**

Details: [LWR Sites: Setup and Considerations](../experience-cloud/lwr-site-component-support.md).

## 9. Test as a guest

- [ ] Open `https://<your site>/s/form-template/<Form Template Id>` in a **private browser window**, where you are not logged in to Salesforce.
- [ ] The form loads, any default answers are filled in, and no warning toast about default answers appears.
- [ ] Fill it out and submit. You see the confirmation, and a new **Form Submission** appears in Salesforce with the related records your form creates.
- [ ] If the form uses save and resume, save progress, open the resume link in a new private window, change an answer and submit.
- [ ] Test the URL parameters and prefill your real links will carry, with real records.

## If something is wrong

| What the guest sees | Fix |
| --- | --- |
| "Page not found" or an empty record page | Step 3: the object page exists, its default variation holds Form (Template), and the site is published. |
| Nothing, or "You can't view this form" | Step 5: Form Template sharing rule, and the template is Active. Step 1: the site is active. |
| Blank or spinning form on an LWR site | Step 3: FlowToolKit LWR Support placed, and the site published. Step 8: public APIs on. |
| "You do not have permission to run this form's save process" | Step 4 and step 6: Form Flow User, and a permission set of your own that grants your override under Flow Access. |
| "could not be updated with your current access", "linked to a record you do not have access to" or "do not have access to save" | Step 6: the override runs in System Context Without Sharing, or the URL or prefill passes a record the guest cannot read. |
| The save still fails after you activated the override or assigned the permission set | A guest session that started earlier keeps the access it had. Test in a new private window, or log out of the site at `https://<site domain>/<site path>/secur/logout.jsp` and load the form again. |
| "does not accept the value" | A URL or prefilled value is not one of the field's picklist values. Add the value or change what the link or prefill sends. |
| "...this form's pre-fill template is not shared with you" | Step 5: the Pre-fill Template sharing rule on Is Pre-fill Template. |
| Changes from an upgrade do not show on an LWR site | Step 8: publish the site. |
| The form is slow | Step 7: Lightning Web Security. |

## Related Pages

- [Deploy to Experience Cloud](deploy-to-experience-cloud.md): placing and configuring Flow Tool Kit components on any site
- [Experience Cloud Components](../experience-cloud/experience-cloud-components.md): every component available in Experience Builder
- [Permission Sets](../getting-started/permission-sets.md): what each Flow Tool Kit permission set grants
- [Prefill Templates](../form-template-framework/prefill-templates.md): default answers for new submissions
