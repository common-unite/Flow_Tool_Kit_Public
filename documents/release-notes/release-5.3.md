# Release 5.3

{% hint style="info" %}
**Install or upgrade:** get the latest release from the [Common-Unite install page](https://install.common-unite.com/products).

**Questions?** Ask in our [Slack community](https://common-unite.my.site.com/slack), or book a spot in our [daily office hours](https://calendly.com/common-unite/daily-office-hours).
{% endhint %}

## 🛠 Typing in a Form Template keeps every character

**Who was affected:** only Form Templates that have a conditional rule on a page or on a section, from version 5.0 onward, when section rules arrived. Forms without page or section rules never had this problem.

In those templates, typing in a text field could lose characters or empty the field. Someone typing "BOBBY" at a normal pace often ended up with "BOBB", and moving to the next field and typing there could wipe what had just been typed. It happened when the person paused briefly mid-word, so it showed up for some people and not others.

Now every character typed stays in the field, at any typing speed, including when the person moves straight on to the next field. Values a form sets on purpose, such as a prefill flow's answers, still appear in the fields as before, and a section or page a rule hides still saves its answers blank and gets them back when it shows again.

This applies everywhere a Form Template runs: Lightning record and app pages, the Form Template's Preview Form tab, flow pages and a flow's debug run, embedded forms, and Aura and LWR Experience Cloud sites, including for site visitors who are not logged in.

### Upgrading

Nothing to set up. On an LWR site, **publish the site** after installing the upgrade: an LWR site keeps showing the components from its last publish until it is published again. Every LWR site that shows a form also needs **FlowToolKit LWR Support** in its Theme Footer.

## ⚠️ Upgrading: LWR sites need FlowToolKit LWR Support in the theme footer, then a publish

LWR sites: keep FlowToolKit LWR Support in the Theme Footer of the theme layout, then Publish after upgrading. An LWR site serves the code from its last publish, and since Winter '27 a site published without that component shows forms with no sections.

## ⚠️ Upgrading: what to check after installing 5.3

Most of this release needs nothing. These do:

| Change | After upgrading |
| --- | --- |
| LWR sites | Keep **FlowToolKit LWR Support** in the Theme Footer, then **Publish** (above) |
| The form starts the save flow from Apex | Check how your save flow runs (next section) |
| **Send Save Progress Email** | Until now the checkbox did nothing, so a template that already has it on starts sending. Check yours first |
| A **Form Submission Upsert** override that builds its own record | Add **Send Resume Link** (`Internal_Send_Resume_Link__c`) to what it saves, or no Save Progress email goes out |
| **Attach PDF to Confirmation Email** | Off by default. Before turning it on, set the Form Submission Convert trigger's running user; an override of the send email flow needs the new steps copied in |
| **Export** and **Import Form Component** | Add the Export action to the Form Component page layout and the Import button to the Form Component list view |
| **Reprocess All** and **Reprocess Selected** | Add both buttons by hand |
| **Open Web Form** | On a copied Form Template record page, add Open Web Form and Change Web Form Address |

Each row is explained in its section below.

## ⚠️ Upgrading: the form now starts the save flow from Apex, so check how it runs

The form saves guests, embedded forms and every explicit save by starting **(Form) Upsert | Overridable** (`Form_Submission_Upsert`) from Apex instead of from the browser, so a long application fits (see More fixes). A flow started from Apex on the default **How to Run the Flow** setting runs in system context, so the packaged save flow now saves with system access for every user, guests included.

| Your save flow | What to do |
| --- | --- |
| No override (the packaged flow) | To keep each respondent's own access, **Save As** an override, save it as API version 68.0 or later and set **How to Run the Flow** to **User Context, Enforces User Permissions** |
| An override on the default setting (any made before this release) | It now runs in system context too. Save it as API 68.0 or later and choose **User Context, Enforces User Permissions**, or **System Context** if guests must update their saved submissions |
| An override in System Context | Nothing; it runs as you chose |

Full detail in [How the form starts the save flow](../form-template-framework/prefill-flow.md#how-the-form-starts-the-save-flow).

## 🆕 Respondents get a link back to their draft when they save

{% embed url="https://vimeo.com/1245008625/1886347942" %}

You asked for a way to email respondents a link back to their saved answers on ordinary (non-stages) forms, without building your own flow. Now, on the Form Template, turn on **Send Save Progress Email**, directly below **Allow Save Progress** (it shows only while Allow Save Progress is on). When a respondent saves, they get an email with a **Continue your form** link that reopens their draft on any device. This works for site guests too, including people who only typed an email address and have no Contact record.

**One email an hour.** The first save that has a recipient email sends one email. Saving again, clicking Save Progress repeatedly or autosaving sends nothing more for an hour after the last email. After the hour, the next save sends another email. Each email carries a new link, so only the latest one works. The link works once: the first save after a respondent reopens it sends a fresh link. Submitting sends nothing and ends the link. Links also stop working after 7 days.

**What to set up**
- Set where the form lives with **Open Web Form** or **Change Web Form Address**: a site or custom address for this template, or the org default. The link uses the template's own address first, then the org default.
- Nothing else. The link opens the form with a `resume` parameter that the form template reads itself, and it runs the packaged prefill (default mode) for that load even when the template's Prefill Flow is Bypass. You no longer map `pv9` in URL Parameter Mapping; links sent before this release still work.
- Site guests: in default mode a guest usually can't read their saved draft, so the link opens a new form with a short notice. Letting guests resume is your org's choice (a system-mode copy of the prefill); read **Guest User Considerations** on the Save Progress Email page first.
- If the template has no web form address and the org has no Default Web Form URL, no email is sent and a Conversion Log row says how to fix it. The save is never lost.
- Optional: put an email template's developer name in **Email Template Name (Saved)**. The email always tries it first, rendered against Contact 1; merge the new **Save Progress Resume Link** field for the link. If it can't be sent (no Contact 1, no template by that name, any other error), the built-in email goes out instead.
- The email is sent from the org's Default Workflow User, like the stages resume email. That user's email address must be verified.
- The send flow ships in default mode. A site guest with no Contact 1 gets the built-in email; the Save Progress Email page explains how an org can override the flow, and that it is your security decision.

**Stages mode is unchanged.** A stages-mode template never sends this email, even with the setting on. The **Email me a resume link** button works as before, and both emails are sent by the same packaged flow, **(Form) Send Resume Link | Overridable**. Its built-in email now carries the same working link instead of a placeholder address you had to replace in a clone, and a click with no recipient on the submission still emails the record owner, as before.

**Only the main submission sends.** Child submissions (repeater and related rows) never send or get a link, and a save with no email address on the submission sends nothing.

**When an email doesn't go out, you can see why.** If neither your template nor the built-in email can be sent (no recipient, an unverified Default Workflow User, the daily email limit), the respondent's save is kept and a **Conversion Log** row on the submission says "Save Progress email didn't send" with the error. The stages **Send Resume Email** works the same way; before, a failed send there could fail the respondent's save.

**If your org overrides the Form Submission Upsert flow:** the request to send travels on the submission the form saves, in the **Send Resume Link** field (`Internal_Send_Resume_Link__c`), the same field the stages button uses. If your override builds its own record instead of saving the record it is given, add that field to what it saves, or no email goes out.

**On upgrade:** nothing sends until you turn on **Send Save Progress Email**. Until now that checkbox did nothing, so any template that already has it on starts sending after the upgrade; check yours first. On an LWR site, republish the site so it picks up the new version.

## 🆕 Attach a PDF of the answers to the confirmation email

{% embed url="https://vimeo.com/1245171587" %}

A new Form Template setting, **Attach PDF to Confirmation Email**, sends respondents a copy of their answers. It is a toggle in the **Confirmation Email Settings** card, directly below the **Send Confirmation Email** toggle and above **Recipients (Confirmation Email)**. Attach PDF and Recipients show only while Send Confirmation Email is on. (Send Confirmation Email is now a toggle too, and all three settings use the same label style, so the card reads the same way.) With it on, each confirmation email carries a PDF of the respondent's answers: every question label with its answer, from the Form Submission Simple Print page.

The same PDF is saved in the submission's **Files** as `<Form Template Name> - <Submission Number>.pdf`. It is shared with All Users, so anyone who can see the submission can open it, site users included. The submission remembers the file in the new **Answers PDF Id** field: if a confirmation is ever sent again for that submission, the new PDF is saved as a new version of the same file, and the email carries the newest version. If someone deleted the file, a new one is made and remembered instead.

**Required one-time setup: set the confirmation's running user.** Confirmation emails go out from the conversion, which by default runs as Salesforce's Automated Process user. Salesforce limits what that user can be given (no profile, no permission sets), so it can't open the PDF page. Before you turn this setting on, set the Form Submission Convert trigger's running user to a regular user, such as a system administrator:

1. Deploy a Platform Event Subscriber Config with Metadata API. Salesforce has no Setup screen that creates one.
2. Then **Suspend** and **Resume** the trigger under **Setup → Platform Events → Form Submission Convert → Subscriptions → Manage**.

The exact file and steps are in **Set Up Email Notifications → Set the conversion's running user**.

**If the PDF cannot be made**, for example because the running user is not set, the email still sends without the attachment and the submission still converts. The submission's Conversion Log gets a warning that says the email went without the PDF, names the usual cause (the Automated Process user), says what to change (set the running user, then Suspend and Resume the trigger), points to **Set Up Email Notifications → Set the conversion's running user**, and ends with Salesforce's own reason.

**If your org overrides the send flow** `(Form Submission) Convert | Utility | Send Email | Overridable`, your override gets no PDF until you copy the new steps into it:
- **Switch (Attach PDF)**
- **Get Answers PDF**
- **Generate PDF**, with its fault path **Log Warning (PDF Not Attached)**
- **Assign PDF Attachment**
- **Update Answers PDF Id**
- The **Attachment ID** value on **Send Confirmation Email**

The setting is off by default, so nothing changes until you turn it on.

## 🆕 Picklist option descriptions

Tell respondents what each choice means, right where they choose. Every picklist and multi-select option can now carry a short description beside its custom label and score.

This video writes two descriptions and shows each place respondents can see them:

{% embed url="https://vimeo.com/1244987851" %}

### Where to set it

1. Open the form in **Form Builder** and select a picklist or multi-select field.
2. In **Picklist Override Settings**, click **Override Option Labels** (or **Customize Visual Picker** on a visual picker field).
3. Type a **Description** under any option, click **Save**, then save the form. An option with no description shows none.

Merge fields such as `{{FirstName}}` work in descriptions, as they do in custom labels.

### Where respondents see it

Once a field has a description, **Option Description Display** appears under the editor button. **Auto** picks the place that suits the field's display type:

| Display type | Auto shows the description |
| --- | --- |
| Radio list, checkboxes, survey buttons, visual picker | Under each option, always visible |
| Radio buttons, separated buttons, icon buttons, badges | In a popup when the respondent hovers over or focuses the option itself (a tap shows it on a phone); no icon is added |
| Standard dropdown, multi-select combobox | As a second line under each option inside the dropdown menu |
| Path, dual listbox | The chosen option's description, under the field |

Pick **Below Option**, **Hover Bubble** or **Below Field** to choose for yourself. **Below Field** works on every display type. A Likert matrix shows a column's description when the respondent hovers or focuses its header. Review screens and PDFs show the chosen label only.

### Upgrading

Nothing to do by hand. Custom option labels, scores and visual picker icons you set before this release keep working exactly as they did. The first time someone saves a field's option window after the upgrade, that field's labels, descriptions, scores and icons are kept together in one place, **Picklist Option Settings**.

More: [Picklist Option Labels: Option descriptions](../form-configuration/picklist-option-labels.md#option-descriptions).

## 🆕 Header Tags and a Banner header for every new Form Template

**Header Tags on the Form Template.** A new field, **Header Tags**, sits under the subtitle on a template's Form Setup tab and in the New Form Template dialog. Type short tags separated by semicolons, such as "2027 season; About 10 minutes". Any header or footer component can show them with the merge field `{{FlowToolKit__Header_Tags__c}}`: a Banner section's Tags setting draws one pill per tag, and rich text shows the text as typed. Change the field and the header shows the new tags on the next load, with no header edit.

**A Banner header by default.** New Form Templates now start with the packaged header **Form Header Banner (Template)**: a banner with the template's name as the title, its subtitle, its Header Tags as pills and its Banner/Header Image (Form Images tab) behind them. A template with only a name shows its name on a band of your brand color, and each field you fill adds its part. Clone the header in the Form Builder for another layout or your logo.

{% embed url="https://vimeo.com/1244991111" %}

**Existing templates keep their header.** Templates made before this release, and templates cloned from them, keep the header they already name.

**The old demo header leaves the package.** Earlier versions gave new templates the rich text header **Form Header (Template)** (`Form_Header_Demo`). It is no longer in the package. In an upgraded org it stays, marked deprecated, and every template that uses it keeps working. To move a template to the Banner header, pick **Form Header Banner (Template)** on its Header/Footer tab. Once no template names the old header, an admin can delete it (Setup, Custom Metadata Types, Form, Manage Records). New installs do not get it.

**Upgrade steps.**
- Users who should see or edit Header Tags need Form Builder Admin, Form Builder Manager or Form Builder Internal User; guests and portal users read it through Form Flow User. All four permission sets include it.
- LWR sites that show a form: republish the site after upgrading, with FlowToolKit LWR Support in the theme footer.

## 🆕 Export and import Form Components between orgs

**What you can do now**

- **Move a component from one org to another**, for example from a sandbox to production. A record Form Component has an **Export** action that shows it as a token, and the Form Components list has an **Import Form Component** button that takes the token in the other org. It works like Form Template export and import, one component at a time, and brings the component's sections, fields and conditional logic with it.
- **Importing a component that already exists updates it in place.** When the target org has a component with the same API name, it keeps its record and Id, so the templates that use it keep working.

**Who can use it:** Form Builder (Administrator) and Form Builder (Manager). A Manager updates an existing component only when its **Form Managers** list them.

**After upgrading:** layouts and list view buttons do not upgrade. Add the **Export** action to the Form Component page layout and the **Import Form Component** button to the Form Component list view.

The import can also be automated from developer tooling by calling the `FlowToolKit.FormComponentImport` global class.

Details: [Export and Import Form Components](../form-configuration/export-import-form-components.md)

## 🆕 Turn off the success message on a Form (Dynamic Component)

You asked for a way to turn off the success message on the **Form (Dynamic Component)** on Experience Cloud, because it showed every time. In Experience Builder, open the component's settings, go to **Confirmation Settings** and check **Hide Success Messages**. The message that pops up after a new record is created, and after a record is saved, no longer shows on that form, whether the form sits on the page or opens in a window.

Error and validation messages still show, so the person filling in the form still sees what went wrong.

Nothing to do on upgrade: the setting is unchecked by default, so every existing form behaves as before. On an LWR site, republish the site so it picks up the new version.

This video checks **Hide Success Messages** on a form in Experience Builder, publishes, then saves on the live page: no message on that form, while a form left at the default still shows it:

{% embed url="https://vimeo.com/1244993314" %}

## 🆕 Reprocess many submissions at once, safely

Two new ways to run conversion again, with a summary before anything changes:

- **Reprocess All** on a Form Template reruns every submitted submission of that template.
- **Reprocess Selected** on a Form Submissions list view reruns the ones you tick.

The summary shows how many will run, how many already converted (skipped unless you tick the box to include them) and how many are already queued (left in place).

Conversions now run **one at a time, in the order the submissions arrived**. Before, two new submissions for the same new person, converted at the same moment, could each create that person. A large set takes a while; watch each submission's Conversion Status.

{% embed url="https://vimeo.com/1241799579" %}

**Existing orgs: add both buttons by hand.** A package upgrade does not change page layouts:

| Button | Where to add it |
| --- | --- |
| Reprocess All | Form Template page layout, Mobile and Lightning Actions (or the Form Template record page) |
| Reprocess Selected | Form Submission, Search Layouts, List View, Buttons |

## 🆕 Open Web Form on Form Templates

Form Templates have a packaged **Open Web Form** action that opens the template's live form on your site in a new tab. The first time, it asks where your forms live: pick your site from a list of your org's Experience Cloud sites (Aura and LWR are told apart for you) or type a custom address, then save it as the default for all templates or for this template only. After that it opens the form in one click, and every existing template uses the default straight away. **Change Web Form Address** switches the site later, for every template or just one. The read-only **Web Form URL** field on each template holds the full link for reports, emails and flows. Details in [Creating Templates](../form-template-framework/creating-templates.md#open-the-live-web-form).

{% embed url="https://vimeo.com/1243904372" %}

| After upgrading | Do this |
| --- | --- |
| Your org uses a copy of the Form Template record page | Add **Open Web Form** and **Change Web Form Address** to that page's highlights panel actions |
| You built your own Open Web Form or View Web Form button | Click the packaged **Open Web Form** once and set the address, check it opens the same page, then remove your button from the page and delete it |

## 🆕 Strip Null Values on Prefill From Mapped Record

**Strip Null Values**, a new option on the action, leaves empty fields out of the submission and rows it returns; formula, auto-number and other read-only values stay, because the form shows them. With no Source Record the action only strips. Both starters turn it on for every call, and their resume path now runs the saved submission through a strip-only call (**Prefill (Saved Submission)**), so a resumed form holds only answers and its next save stays small.

## 🎬 Walkthrough: print any record as a PDF, laid out with your form components

{% embed url="https://vimeo.com/1242559675" %}

Any record can be printed with your own Form Components: a Contact, its Account card and every related application in one PDF. The video builds the three components, a Visualforce page on the Contact standard controller that stacks `FlowToolKit:DynamicPDF` blocks (reaching up to the Account and repeating over related records), the Generate PDF action in a screen flow, a record-triggered flow and an autolaunched flow, saving the file to any record, and adding versions to an existing file. Step by step, with the page code, in [Print any record as a PDF, laid out with your form components](../invocable-actions/pdf-and-zip-actions.md#print-any-record-as-a-pdf-laid-out-with-your-form-components).

## 🛠 The page behind an open sheet stays still

When a Form (Dynamic Flow) or a section's Flow Action button opened its sheet, a mouse wheel or trackpad over the dimmed area still scrolled the page behind it. On a long record page or site page, people lost their place, and closing the sheet left them somewhere else on the page.

Now, while any Flow Tool Kit sheet is open, the page behind it does not scroll. The sheet's own content still scrolls as before. When the sheet closes, by its Close button, Cancel, the flow finishing or the **Escape** key, the page scrolls again and is exactly where it was.

A sheet opened from inside another sheet (a Form (Dynamic Flow) that opens a full-size flow, which then opens its own dialog) keeps the page still until the last sheet is closed.

The page is never left stuck. If a sheet goes away some other way, for example the person navigates to another page while it is open, the page scrolls again as soon as they move the mouse, touch the screen or try to scroll.

This applies everywhere a sheet opens: Lightning record and app pages, flow pages, a flow's debug run, embedded forms, and Aura and LWR Experience Cloud sites, including for site visitors who are not logged in.

This video shows the page before and after, on a record page and on an LWR site as a visitor who is not logged in:

{% embed url="https://vimeo.com/1245128343" %}

### Upgrading

Nothing to set up. On an LWR site, **publish the site** after installing the upgrade: an LWR site keeps showing the components from its last publish until it is published again.

## 🛠 Escape closes only the top window when one flow window opens another

A **Form (Dynamic Flow)** window can open a flow that shows its own Form (Dynamic Flow) button, so a second window opens on top of the first. For example, a form with an **Override Limits** button whose window shows another form with the same kind of button. Pressing Escape in the top window closed both windows at once, and the person lost the window behind it. Escape now closes only the top window. The window behind it stays open, with the page behind still held in place, and a second Escape closes it.

This applies wherever a form shows a Form (Dynamic Flow) window: Lightning record pages, flow screens, flow debug runs, embedded forms, and Aura and LWR sites. A single window closes on Escape as before.

Nothing to do on upgrade. On an LWR site, republish the site so it picks up the new version.

## 🛠 A section's Flow Action button opens its flow above a record page's highlights panel

A form section can carry a **Flow Action** button, often placed over a message such as "This budget is over its limits" with an **Override Limits** button. On a Lightning record page, the window that button opened was drawn underneath the record's highlights panel. The panel covered the window's title and stayed undimmed, while the rest of the page was greyed out behind the window. The window now opens above the highlights panel, the global header and the navigation bar, as any other dialog does. It closes cleanly, and the button returns to its place over the message afterwards.

The same fix applies wherever a form shows a section Flow Action button: Lightning pages, flow screens, embedded forms, and Aura and LWR sites. The button's **Custom Style** is unchanged, so a button styled with its own `z-index` keeps that position over the message.

Nothing to do on upgrade. On an LWR site, republish the site so it picks up the new version.

## 🛠 The address Search For Address box follows Text size and Input size

In an address section, the **Search For Address** box now grows and shrinks with the Style Editor's **Text size** and **Input size**. Before this fix it stayed at the default size while Street, City, State, Zip and Country grew. At 150%, the search box and every other input are now the same height, and their text is the same size.

Nothing to do on upgrade. Forms with no size override look the same as before. On an LWR site, republish the site so it picks up the new version.

{% embed url="https://vimeo.com/1244985887" %}

## 🛠 A link can now fill in a Time field

A URL parameter mapped to a **Time** field on a Form Template now fills that field in. Before, the value from the link reached the form exactly as typed, so a link such as `?pv1=9:30` left the time blank or failed to save.

The form now accepts the ways people write a time in a link and stores it the way Salesforce saves a time:

| In the link | Saved as |
|---|---|
| `9:30` or `09:30` | 9:30 AM |
| `14:05` | 2:05 PM |
| `09:30:15` | 9:30:15 AM |
| `09:30:15.5` | 9:30:15.500 AM |
| `09:30Z` | 9:30 AM |

Use the 24-hour clock, hours then minutes, with seconds if you need them. A value that is not a time, such as `25:00`, `9:75`, `noon` or `9:30 PM`, is skipped and the field stays blank, the same as a bad value for a number or date field.

Nothing to do on upgrade: existing mappings to Time fields start working. On an LWR site, republish the site so it picks up the new version.

## 🛠 Conversions run when the convert trigger has a running user

An org can set a running user on the Form Submission Convert trigger with a Platform Event Subscriber Config, so conversions run as a named user instead of the Automated Process user. In those orgs every conversion stopped right after Start: the log showed one Start row, no error, and the submission stayed In Progress. The debug log named the cause as `Field is not writeable: Form_Submission_Convert__e.Start__c`.

Conversions now run to Finish under a running user, the same as under Automated Process. The conversion log is unchanged: the Start row still carries the event's Replay ID.

Nothing to do on upgrade. If you set a running user and have submissions left In Progress by this, select them and use Reprocess.

## 🛠 More fixes

- Long applications save on LWR sites. A guest whose answers added up to about 16,000 characters could not save or submit: the site refused the request (HTTP 414 or 431) and told the guest to check their internet connection. The form now sends the save in the request body, so only each field's own length limits an answer. A resumed application hit the limit soonest, because the prefill record carried every field of the Form Submission, most of them empty; the starters now strip those (see Strip Null Values on Prefill From Mapped Record). Check how your save flow runs: see the upgrading note above.
- In Stages Mode the progress count ("2 of 5") now translates. The word "of" was fixed in English, so a translated form showed it in English beside everything else. It is now the custom label **Stages_Progress_Count** (`{0} of {1}`, the steps done and the total); translate it in Translation Workbench like the other FlowToolKit labels.
- A date field's calendar icon stays inside the field when the Style Editor's **Input size** is above 100%. On pages drawn with SLDS 1 rather than SLDS 2 (Lightning in orgs without SLDS 2, Aura and LWR sites, the Embed Form page and flows on their own page), the icon grew with the field but its box did not, so at 150% it sat low and hung past the right edge. It now stays centred inside the field at every size. LWR sites pick up the fix after the upgrade and a Publish.
- **DynamicPDF** prints components saved in the **Form Components** tab. Name one by its record's **VersionId** (ending in `_v0`). Before, such a component printed an empty block, and only components built in the Form Builder tab printed. Its conditional logic now hides the same sections and fields in the PDF as on the form.
- **Generate PDF** saving a new version of a file that is not yet shared with the **Share With** record now shares it, the same as for a new file, and returns the file and its link. Before, the version was saved but the action returned nothing, so the flow went on with blank outputs. Two Generate PDF actions in one transaction no longer fail on the second, and a PDF that cannot be saved stops the flow with Salesforce's reason (give the action a fault path to handle it) instead of returning nothing.
- **Embed Code Generator** lists each site once, by its name, labelled Aura, LWR or Classic. Before, an LWR site was labelled Aura, and a site with a custom domain could appear once per domain; it now shows its custom domain.
- **Form (Component)** and **Form (Dynamic Component)** on a site or record page draw a Form Component record named by its `_v0` name. Before, such a form drew nothing or kept spinning; forms built in the Form Builder tab were unaffected. A component with a Submission Field Map now maps only when the record it shows is a Form Submission, so an Account record no longer comes up with every field empty.
- A form opened through **EmbedForm** shows a saved submission's mapped section on another object, such as its Account section. Before, that section could stay empty, with nothing in the console, when the form's design arrived before the object's field details.
- A **Flow section** on a Form Template page hands back only the fields its flow changed. Before, a flow that set values on the record it was given returned its whole copy from launch, so answers the respondent changed after the section opened went back to their old values. Setting values on that record in a Flow section is now safe.
- **Lookup Import** opens only the lookup in its own flow. Before, one Import click opened an Import Record window in every lookup on the page for the same object, so a page with two flows showed two windows and a pick could land in the wrong flow.
- **Lookup Import** hides the records already in the repeater. Before, every Import listed every record.
- A **repeater** with its header hidden and no rows shows a start bar with **Import** and **New**, so it can be started. A row's **Import** button now replaces that row with the imported record instead of adding another row; the header's Import still adds.
- **Stages Mode at phone width**: the Mark Complete dropdown lines up with the Return button, and the **Email me a resume link** button stays on screen. Wider layouts are unchanged.
- A Form Template on a record page with a fallback template no longer shows "No form template source configuration found" when the record's object has no source mapping and the fallback form loads. The message still shows when nothing will draw.
- **Apply Submission Field Maps** and **Prefill Submission Field Maps** skip a mapping whose target is a formula, roll-up or auto-number field, instead of logging an Error row in the Conversion Log.
- **Reprocess** on one submission that is already queued or converting shows **Already Queued for Conversion** and changes nothing. Before, it reset the related rows and said Conversion Initiated, though no second run started.
- Submissions left marked Waiting for conversion are picked up again. When a conversion job stopped before cleaning up, its submissions are marked Error (use Reprocess) after 2 minutes, and Waiting submissions with no job running go to a new job. This runs whenever any conversion starts and before every bulk Reprocess; there is nothing to schedule.

## 📘 Note for orgs upgraded from version 3

If your org was upgraded straight from a version 3 release, unused version 3 fields may still be there, and they can make **Reset Form Cache** put section titles and widths back to their defaults. Most orgs never had them. If yours does, message us in our [Slack community](https://common-unite.my.site.com/slack) (or email support@common-unite.com if you'd rather keep it private) and we'll clean up your org for free. See [Orgs upgraded from version 3](../deployment/upgrading-versions.md#orgs-upgraded-from-version-3) for how to tell.
