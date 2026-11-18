# Release 5.4

{% hint style="info" %}
**Install or upgrade:** get the latest release from the [Common-Unite install page](https://install.common-unite.com/products).

**Questions?** Ask in our [Slack community](https://common-unite.my.site.com/slack), or book a spot in our [daily office hours](https://calendly.com/common-unite/daily-office-hours).
{% endhint %}

## New features

### Email fields check for a complete address before the form moves on

{% embed url="https://vimeo.com/1248021542" %}

**What changed.** Every Email field on a form, packaged or your own, now checks for a complete address before the respondent can move on: a name, an @, and a domain with a dot in it, such as `name@example.com` (Email fields: built-in basic email format check before submit, #1219). An address such as `bobby@wright` shows this message under the field: "This email address is not complete. Enter it like name@example.com."

**Why it matters.** The browser's own email check let `bobby@wright` through, and Salesforce then refused it at the save with a Save Failed message the respondent could not act on. The form now catches it at the field, where the respondent can fix it.

- **Your own pattern wins.** A field with a **Field Format** uses only that pattern and its **Custom Formatting Alert Message**, and skips the built-in check.
- **Existing values are never blocked.** The check runs only on an address the respondent typed or changed on this visit. A prefilled or saved value that is left as it is submits as before.
- **It matches Salesforce.** Subdomains, plus addressing, dots in the name and long endings such as `.nonprofit` all pass. If an incomplete address still reaches the save, the error now names the address and asks the respondent to correct it.
- **Ready-made patterns.** [Field Validation](../form-configuration/field-validation.md#built-in-email-address-check) has tested email patterns (Standard, and Public addresses only) and US phone and ZIP patterns to paste into a Field Format.

Learn more: [Field Validation: Built-in Email Address Check](../form-configuration/field-validation.md#built-in-email-address-check).

### Field Format patterns: tested patterns to paste in

{% embed url="https://vimeo.com/1248039924" %}

A **Field Format** checks what someone types against a pattern, but a pattern written from scratch is hard to get right. The docs now carry tested, ready-made patterns for email addresses (Standard, and Public addresses only), US phone numbers and US ZIP codes. Paste one into a field's **Field Format** and pair it with a friendly **Custom Formatting Alert Message**, so respondents see what to fix. Nothing in the package changed.

Learn more: [Field Validation: Regex Pattern Validation](../form-configuration/field-validation.md#regex-pattern-validation).

### Banner: one shared header with each template's own logo and colors

{% embed url="https://vimeo.com/1247981214" %}

A Banner header can now take its logo, the logo's alt text and its colors from the Form Template it heads. One header component can serve every Form Template, so you no longer need a copy for each client or program. The org also gets one default logo, set once, so most templates never need a logo of their own.

#### What changed

- **Org default logo on the Global Styles tab.** In the Form Builder, the Global Styles tab has a new **Logo** group with **Default Logo** and **Default Logo Alt Text**. Pick the logo with **Select Image**, the same picker the Banner's Logo Image uses: your org's public assets, with folders and search. Save it with **Save org defaults**, like the other org styles.
- **Logo fields on Form Template.**
  - **Logo Override** and **Logo Alt Text Override** set a template's own logo and alt text. Both are optional.
  - **Logo** and **Logo Alt Text** are formula fields. Each gives the template's override when there is one, and otherwise the org default from the Global Styles tab.
  - Reference the formula fields in a Banner, and every template has a logo without setting one on each.
- **Banner Logo Override Field.** The Banner editor's Logo group has a new **Logo Override Field**. Pick a field, such as the Form Template's **Logo** field, or type an asset name or a link. When it has no value, the Banner shows the **Logo Image** as before. The **Logo Alt Text Override Field** can now also be a field, such as **Logo Alt Text**.
- **The packaged Banner header uses them.** The default header, Header (Banner), now reads the template's Logo and Logo Alt Text. A template on that header shows the org default logo as soon as one is set. With no default and no override, it shows no logo, as before.
- **Colors from the record.** A Banner's Background Color, Scrim Color and Tag Color can hold a field, for example `{{Brand_Color__c}}`. A field that is empty, or that does not hold a color, is ignored, and the banner keeps its usual brand color.
- **Preview in the Form Builder.** While you edit a Banner whose logo comes from a field, the Form Builder has no template record. It previews the org default logo instead.

#### Who can see it

- Respondents and site guests read the four new Form Template fields through **Form Flow User**.
- Form Builder admins and managers can also edit the two overrides.
- Only users who can save org styles can change the default logo: **Form Style Defaults Manager**, or **Form Builder Admin**, plus Customize Application.

#### Using it

- The packaged permission sets carry the field access, so there is nothing new to assign.
- To show a logo on every template, set **Default Logo** on the Form Builder's Global Styles tab. Templates on the packaged Banner header pick it up at once. For your own Banner headers, set the Banner's **Logo Override Field** to the Form Template's **Logo** field.

Learn more: [Banner Sections](../form-configuration/banner-sections.md).

### Help links in the Form and Table Builder

Help is now one click away while you build. The Form Builder and Table Builder show three links on the title line, above the toolbar on the right (Builder header links, #1100):

- **What's New**: the release notes for each version.
- **Slack Support**: join the Flow Tool Kit community on Slack and ask a question.
- **Office Hours**: book a spot in our daily office hours.

Each link opens in a new tab. On a narrower screen the links show as icons only; hover an icon to see where it goes.

The same three links replace the support email address at the bottom of the source configurator and the Embed Code Generator, so every help request reaches the team in Slack.

### Question Reporting walkthrough: choose which survey questions report

{% embed url="https://vimeo.com/1247810767" %}

The Question Reporting page now opens with a narrated walkthrough (Use Vimeo embeds instead of GIFs, #1174). It sets a Question Type and a default chart on a question, gives each answer choice a score, turns reporting off for a name field, and reads the result on the template's Analytics tab. Nothing in the package changed.

Learn more: [Question Reporting](../form-configuration/question-reporting.md).

### Rich text images walkthrough: show photos on your site, even for guests

{% embed url="https://vimeo.com/1247811689" %}

The Show Rich Text Field Images guide now opens with a narrated walkthrough (Use Vimeo embeds instead of GIFs, #1174). It shows a photo stored in a rich text field as the image in Form (Image), a Record Card or a Design Block, even for signed-out site guests: the guest sharing rule and field access, pointing a Record Card at the rich text field in Experience Builder, and publishing the site. Nothing in the package changed.

Learn more: [Show Rich Text Field Images](../how-to-guides/show-rich-text-field-images.md).

## Bug fixes

### Review screen: dates show as saved, and file uploads list their files

{% embed url="https://vimeo.com/1247961498" %}

Two fixes on the review screen of a Form Template (Review screen dates, #1178, and Review screen file uploads, #1179).

- **Date fields show the saved date.** On an Experience Cloud LWR site, a Date field on the review screen showed one day early for anyone whose browser is set west of UTC (for example Chicago or Los Angeles): a date saved as November 10 showed as November 9. The saved data was always correct. Date fields now show exactly the saved date, whatever the viewer's time zone. The same fix applies to the Date rows of the Merge Records compare screen.
- **Date/Time follows the user's zone.** Date/Time fields are unchanged: they still show in the viewer's own time zone (on an LWR site the browser's zone, on Lightning pages and Aura sites the Salesforce user's zone).
- **File Upload fields list their files.** A File Upload field showed its raw stored text instead of the file names once the server had processed the upload (for example on a saved or resumed form), and an upload whose files were all removed showed raw text too. The review screen now lists the remaining files by name as a bulleted list (one file included), leaves out files that were removed, and shows "- not provided -" when none remain.

Respondents check their answers on the review screen before they submit. A date one day off, or a block of code where the file names should be, made respondents doubt that their answers were saved correctly.

### Flow Tool Kit installs in orgs without Orders

Flow Tool Kit now installs and upgrades in a Salesforce org that has Orders turned off. Before this fix, the install stopped with "Can't install package because orders aren't enabled. Go to Salesforce order settings, enable orders, and try again."

The cause was a test helper inside the package that named the Order object directly. Salesforce checks every class in a package when it installs, so that one reference made the whole package require Orders. The helper now looks for Order when its tests run and uses it only when the org has it.

Nothing changes for you: there is no setup step, and you do not need to turn Orders on. Orgs that already use Orders see no difference.

Affected versions: every version from 4.42.0.3 through 5.3.0.2.

### A flow's sheet shows only the flow's own buttons

{% embed url="https://vimeo.com/1247961651" %}

**What changed.** When a Form (Dynamic Flow) button, or a form section's flow action button, opens a flow in a sheet, the sheet no longer adds a Close button of its own under the flow's buttons (Flow modals show an extra Cancel button, #1173). The flow's own buttons (Next, Finish and so on) are the only buttons in the sheet. To leave without finishing, use the X at the top of the sheet or press Escape. A flow with three or more stages still shows its stage indicator at the bottom of the sheet.

**Why it matters.** Since release 5.0 every flow sheet showed two rows of buttons: the flow's own, and a Close under them. The flow is meant to control its buttons, and the extra row confused respondents. The Close had been added so a full-size sheet could be closed on a phone, where the X sat above the screen; the X now moves inside the sheet on a phone, so that Close is no longer needed.

Other dialogs in the package (confirmations, editors, lookups) keep their Cancel and Confirm buttons.

Learn more: [Dynamic Flow Display](../experience-cloud/dynamic-flow-display.md).

### Email links with a 15-character record Id

{% embed url="https://vimeo.com/1247234634" %}

A Lightning email template's lookup merge field writes a record Id in its 15-character form. When that Id goes into a form link as a URL parameter, the prefill flow used to receive the 15-character Id. A flow step that expects the 18-character Id could then fail with "not a valid Id" (15-character Id to 18, #1090).

Form Templates now turn a 15-character record Id into its 18-character form before the prefill flow starts. This happens only where the parameter is mapped to a **lookup** or **Id** field, and for the reserved `sourceId` parameter. Text, External Id and every other field type receive the value exactly as the link carried it. A value that is already 18 characters, or is not a record Id at all, is left alone.

You don't need to change any links, email templates or prefill flows. Saved submissions store the same 18-character Id they always did.

Learn more: [URL Parameter Mapping: Type Coercion](../form-template-framework/url-parameter-mapping.md#type-coercion).

### A Campaign's form opens when Form Prefill Flow keeps its default

{% embed url="https://vimeo.com/1247973790" %}

A form opened from a Campaign no longer fails with **Flow "-- None --" is not found or doesn't have an active version**.

The Campaign field **Form Prefill Flow** starts at the picklist default **-- None --**. The form read that value as the name of a flow, so every Campaign that kept the default showed the error instead of the form: on the Campaign record page (Preview Form) and anywhere the Campaign is the form's source.

Now **-- None --** means the same as a blank field: the Campaign does not override the prefill flow, and the Form Template's own Prefill Flow runs (or none, when the template is set to Bypass). A flow you pick on the Campaign still runs instead of the template's.

Existing Campaigns work as they are; there is no need to clear the field.

Learn more: [Campaign Integration](../form-template-framework/campaign-integration.md).

### Add to Account now links the Contact to the converted Account

{% embed url="https://vimeo.com/1247973996" %}

The **Contact1 👉 Add to Account** and **Contact2 👉 Add to Account** Conversion Rules are meant to put the converted Contact on the submission's Account, the household or organization the same form created or matched. They did nothing whenever the template had any other Conversion Rule selected, which is every real template (an Account form always has at least Account and Contact1 too). The Account and the Contact were both created, but the Contact's Account Name stayed blank.

Now the rule works alongside the template's other rules: the converted Contact gets the submission's Account (or, for a repeater or table row, the main submission's Account).

- **Nothing to change in your templates.** A template that already has Add to Account selected starts linking Contacts on its next conversion.
- **Existing Contacts are not fixed retroactively.** Contacts converted before the upgrade keep their blank Account; reprocessing a submission links its Contact.
- The **Add to Account** box on a page section, for repeater and table rows, worked before and is unchanged.

#### Where the fix is

The fix is in the packaged flow **(Form Submission) Convert | Upsert | Contact | Overridable**, in its **Switch (Add to Account)** decision. The **🏣 Add to Account** outcome checks the template's Conversion Rules for `Contact1 👉 Add to Account` and `Contact2 👉 Add to Account`. It used to match only when the Conversion Rules equalled that one value, so it missed every template with more than one rule. It now matches when the Conversion Rules contain the value.

Learn more: [Submission Conversion: Conversion Rules](../form-template-framework/submission-conversion.md#conversion-rules).

### Converted Opportunities take their name from the submission's Subject

Data Conversion used to name every Opportunity it created with the Form Submission's number, such as 002130. Nothing a form or a component mapping set could change it, so a pipeline of converted Opportunities read as a list of numbers.

The Opportunity is now named with the submission's **Subject** when the submission has one. A form that fills Subject (from an answer, a prefill or a hidden field) gives the Opportunity a real name, such as "Quote: Acme Nonprofit".

- **No Subject, no change.** A submission without a Subject still names the Opportunity with its number, so existing forms behave as they did.
- **Long subjects.** Subject holds up to 255 characters and an Opportunity Name 120, so the first 120 characters are used and the conversion never fails on length.
- **Updates too.** When the submission already points at an Opportunity, the conversion updates that Opportunity's name the same way, as it did with the number before.
- **Cases are unchanged.** The Case conversion already uses Subject as the Case Subject.

The Subject field on Form Submission now has a description and help text that say where its value lands.

#### Where the change is

The change is in the packaged flow **(Form Submission) Convert | Process | Opportunity | Overridable**. Its **Opportunity Field Map** transform now sets the Opportunity **Name** from the submission's Subject, falls back to the submission's number (or "New Opportunity" when there is neither), and keeps the first 120 characters.

Learn more: [Submission Conversion](../form-template-framework/submission-conversion.md).

### The answers PDF skips sections with nothing to print

{% embed url="https://vimeo.com/1247973391" %}

A Form Submission's PDF no longer prints a section heading with nothing under it. A page section is now left out of the PDF when it has nothing to show:

- every question in it is hidden by its rules, for example the follow-up questions an anonymous respondent never sees;
- its component's own section is hidden by a rule, for example the contact details of an anonymous response;
- it is a Repeater or Table with no rows.

A section that carries its own text (section text or header text) still prints, even with no questions. A page left with no sections and no title, text or footer of its own is skipped, the same way a page the respondent never saw is skipped.

This applies to both print pages, Form Submission Print and Form Submission Simple Print, so the PDF attached to a confirmation email and the PDF made by the Generate PDF action both change. A Form Template preview still prints every page and section.

You no longer need to turn on **Do Not Print** for an empty Repeater just to keep its heading out of the PDF.

Learn more: [Create PDF from Submission](../form-template-framework/how-to/create-pdf-from-submission.md).

### Escape works again after a sheet inside a sheet closes

{% embed url="https://vimeo.com/1247974207" %}

When a flow in a sheet opened a second sheet on top, closing that second sheet with its Close button left the keyboard on the page behind. The first sheet stayed open, but Escape did nothing, and a keyboard or screen reader user lost their place until they clicked back into the sheet.

Now, when the top sheet closes, the keyboard goes back to the button that opened it, or, when the flow has redrawn that button, onto the Close button of the sheet that is still open. The next Escape closes that sheet.

This applies to every Flow Tool Kit sheet: Form (Dynamic Flow) sheets, flow action buttons on form sections, and the dialogs in the Form and Table Builders. A single sheet works as before.

Learn more: [Dynamic Flow Display](../experience-cloud/dynamic-flow-display.md).

### Form themes stay in sync with the theme cache

Flow Tool Kit keeps the list of Form Themes in the org's platform cache, so a form does not read them on every load. Saving a form in the Form Builder already resets that cache, which is how most themes are changed. Themes delivered straight as metadata (a deploy, a change set, or the themes a new package version adds) could leave the cache out of sync until someone pressed **Reset Form Cache** in the Form Builder. Until then a new theme was not found, and the Template Catalog refused to use a template whose theme the cache did not list.

What changes:

- **A theme missing from the cache is read again.** When a form, a template or the Template Catalog asks for a theme by name or Id that the cached list does not hold, Flow Tool Kit reads the themes from the org once and refreshes the cache. A new theme shows on the next load. A name that really does not exist is still not found, and costs one extra theme read per request.
- **The installer refreshes the theme cache.** Every Flow Tool Kit installer plan has a new step, **Refresh the Form Theme cache**, which runs after the package installs. It clears the cached theme list, so themes the new version adds or changes show on the next form load. Nothing runs inside the package at install time.

If you deploy theme changes as metadata yourself, **Reset Form Cache** in the Form Builder still refreshes the list at once, as before.

Learn more: [Themes, Labels & Styling](../form-configuration/themes-labels-styling.md).

### Form Builder: Custom Label is full width again on a field's Labels tab

{% embed url="https://vimeo.com/1247970483" %}

**What changed.** In the Form Builder field editor, the **Custom Label** input on a field's **Labels** tab was squeezed to a sliver at the right edge of the panel, beside Label Position, Label Size and Align Center, with its label wrapped to "Cu / La" (Custom Label input squeezed, #1197). It now sits on its own row under those settings, as wide as the editor. On fields that have Prepend and Append (Text, Picklist, Number and similar), Custom Label still shares its row with them, as before.

**Who saw it.** Admins editing a field that has no Prepend or Append: Long Text Area, Rich Text, Checkbox and multi-select picklist fields. It happened at every editor width and whatever the label's length. It started in release 5.2.0.1, when Custom Label began editing as rich text, so orgs that upgraded from 5.1 or earlier first met it in 5.3.0.2.

**Why it matters.** Custom Label is where an admin rewords a question for respondents. With the input a few pixels wide, the label could not be read or edited on these field types.

The fix applies as soon as the package is upgraded.

Learn more: [Field Labels Help Text: Custom Label Override](../form-configuration/field-labels-help-text.md#custom-label-override).

### Repeater rows keep what you type

{% embed url="https://vimeo.com/1247961631" %}

A Repeater could save every row blank when its row design was stored on the section, which is how every template from the Template Catalog saves its sections (Repeater rows over a record Form Component, #1163). The rows were created, but nothing typed into them was kept, so the form could not be submitted. Rows now keep what respondents type from the first keystroke.

Nothing changes for you: there is no setup step, and existing Repeaters keep working as before.

Learn more: [Repeater](../screen-components/repeater.md).

{% hint style="info" %}
**Using LWR sites?** Publish your site after upgrading so it picks up the latest package code from the LWR cache. See [LWR Sites: Setup and Considerations](../experience-cloud/lwr-site-component-support.md).
{% endhint %}
