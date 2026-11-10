# Unreleased: sprint 2026-10-26

## ⚠️ Upgrading: LWR sites need FlowToolKit LWR Support in the theme footer, then a publish

If a form on an LWR site shows no sections after this upgrade, or on the next publish of the site, the site needs two things: the **FlowToolKit LWR Support** component in the **Theme Footer** of its theme layout, and a **Publish**.

| Why | What you see without it |
| --- | --- |
| An LWR site serves the component code captured at its last publish, so an upgrade is not on the site until you publish | Blank form sections, `component/latest` requests failing with 401 or 503, `LWR3008` in the console |
| Since Winter '27 the LWR publisher bundles only what it reaches from the components on each page, and the Form Template loads its section forms on demand | A page holding only a Form Template publishes with no section forms, even on a site that worked before |

Steps: Experience Builder, any page, scroll to the Theme Footer, drag **FlowToolKit LWR Support** into an empty footer column, Publish, then open a form page by its own address in a private window. Full detail in [LWR Sites: Setup and Considerations](../experience-cloud/lwr-site-component-support.md) and [Upgrading Versions](../deployment/upgrading-versions.md). Aura sites and Lightning pages are unaffected.

{% embed url="https://vimeo.com/1242836710" %}

## ⚠️ Upgrading: the form now starts the save flow from Apex, so check how it runs

The form saves guests, embedded forms and every explicit save by starting **(Form) Upsert | Overridable** (`Form_Submission_Upsert`) from Apex instead of from the browser, so a long application fits (see Fixes). A flow started from Apex on the default **How to Run the Flow** setting runs in system context, so the packaged save flow now saves with system access for every user, guests included.

| Your save flow | What to do |
| --- | --- |
| No override (the packaged flow) | To keep each respondent's own access, **Save As** an override, save it as API version 68.0 or later and set **How to Run the Flow** to **User Context, Enforces User Permissions** |
| An override on the default setting (any made before this release) | It now runs in system context too. Save it as API 68.0 or later and choose **User Context, Enforces User Permissions**, or **System Context** if guests must update their saved submissions |
| An override in System Context | Nothing; it runs as you chose |

Full detail in [How the form starts the save flow](../form-template-framework/prefill-flow.md#how-the-form-starts-the-save-flow).

## 🎬 Walkthrough: print any record as a PDF, laid out with your form components

{% embed url="https://vimeo.com/1242559675" %}

Any record can be printed with your own Form Components: a Contact, its Account card and every related application in one PDF. The video builds the three components, a Visualforce page on the Contact standard controller that stacks `FlowToolKit:DynamicPDF` blocks (reaching up to the Account and repeating over related records), the Generate PDF action in a screen flow, a record-triggered flow and an autolaunched flow, saving the file to any record, and adding versions to an existing file. Step by step, with the page code, in [Print any record as a PDF, laid out with your form components](../invocable-actions/pdf-and-zip-actions.md#print-any-record-as-a-pdf-laid-out-with-your-form-components).

## 🆕 Prefill from mapped sections

{% embed url="https://vimeo.com/1241917566" %}

**Form Submission | Prefill From Mapped Record** fills a submission from records your prefill flow fetched, through the Submission Field Maps on your form components. The flow no longer needs a field-by-field mapping.

| Mode | Use it to |
| --- | --- |
| **Single** | Copy one record (an Account, a Contact, a Program) through every section mapped to its object. Chain one call per record. Works for guest users. |
| **Related** | Turn a collection (for example the other Contacts on the Account) into rows for the repeater or table section with a chosen Section Tag. |
| **Auto** | For users who may read the source records: read the lookups already set on the submission and copy those records as the running user. |

A value on the record replaces the submission value; a blank value never clears one.

Both starter prefill flows (`Form_Submission_Prefill` and `Form_Prefill_w_Screen_Template`) now show the pattern: the Pre-fill Mappings Transform sets defaults and lookups, then the action copies the Account, the primary Contact and the alternate Contacts. They are examples: keep the Transform for defaults, or remove it and let the mapped sections do the work. The starters now fetch all fields, so a newly mapped field needs no flow edit.

**Strip Null Values**, a new option on the action, leaves empty fields out of the submission and rows it returns; formula, auto-number and other read-only values stay, because the form shows them. With no Source Record the action only strips. Both starters turn it on for every call, and their resume path now runs the saved submission through a strip-only call (**Prefill (Saved Submission)**), so a resumed form holds only answers and its next save stays small.

## 🆕 Page sections on other objects in Custom mode

A page section's Custom form can now be built on any object (Account, Contact, a custom object) from the new **Object** list, and mapped to Form Submission fields on the Form Template Mapping tab.

## 🆕 Mapped sections keep formulas current and stay in sync

Three behaviours for page sections mapped to another object:

- **Formulas recalculate from a mapped section.** A change in an Account or Contact section used to leave the Form Submission's formulas, and anything conditioned on them, at their last saved value. Now the first Form Submission section on the page recalculates once for every edit in a mapped section, the same as an edit in a Form Submission section, with no extra round trips when several sections draw formulas.
- **A mapped section recalculates once on load.** A prefilled or saved submission opens with current formula values instead of blank or stale ones. Repeater and data table rows are saved records and are left alone.
- **Sections on the same object stay in sync by the lookup they map.** Sections applied to the same Form Submission lookup share every field on every page of the template; sections on different lookups (Account and Parent Account, Primary and Alternate Contact) never touch; a form applied to **All** (every conversion) syncs with every section on that object on the page, through the fields it draws. The help text under **Apply these mappings to** states the rules, and the guide's [Several sections on the same object](../form-template-framework/form-template-mapping.md#several-sections-on-the-same-object) explains the two-record case.

## 🆕 One button bar on a page with a Flow section

A template page with a Flow section used to show two bars: the page's and the flow's. Now the flow chooses who drives, through two variables the Flow Section template already carries:

| The flow | Who drives | What happens |
| --- | --- | --- |
| Declares the text input `buttonTriggerName` | The page | The page's Continue, Submit, Back and Save Progress run the flow's docked buttons. Continue and Submit validate the flow; Back and Save Progress do not. On a flow with several screens, Continue moves to the next screen and Back to the previous one, and only the first screen's Back leaves the page. The flow's own bar hides itself. |
| Sets its output `hidePageButtons` to true | The flow | The page hides its own buttons on that page and the flow's docked bar drives, finishing with the clicked label as before. The flow can set it at start or change it on any screen. The review page always keeps its Submit. |
| Neither | As before | Both bars show, as in earlier releases. |

Flows cloned from the Flow Section template before this release keep working; add the two variables to adopt the single bar.

## 🆕 Rich text labels in the field editor

On a field's **Labels** tab, **Custom Label**, **Placeholder** and **Help Text** now work like a section title: they show formatted text, and clicking one opens the rich text editor. **Prepend** and **Append** stay plain.

These three values can now be longer than 255 characters, so a heavily styled label saves. Labels saved before the upgrade keep working with no change.

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

## 🛠 Fixes

- Long applications save on LWR sites. A guest whose answers added up to about 16,000 characters could not save or submit: the site refused the request (HTTP 414 or 431) and told the guest to check their internet connection. The form now sends the save in the request body, so only each field's own length limits an answer. A resumed application hit the limit soonest, because the prefill record carried every field of the Form Submission, most of them empty; the starters now strip those (see Prefill from mapped sections). Check how your save flow runs: see the upgrading note above.
- In Stages Mode the progress count ("2 of 5") now translates. The word "of" was fixed in English, so a translated form showed it in English beside everything else. It is now the custom label **Stages_Progress_Count** (`{0} of {1}`, the steps done and the total); translate it in Translation Workbench like the other FlowToolKit labels.
- A date field's calendar icon stays inside the field when the Style Editor's **Input size** is above 100%. On pages drawn with SLDS 1 rather than SLDS 2 (Lightning in orgs without SLDS 2, Aura and LWR sites, the Embed Form page and flows on their own page), the icon grew with the field but its box did not, so at 150% it sat low and hung past the right edge. It now stays centred inside the field at every size. LWR sites pick up the fix after the upgrade and a Publish.
- The Form Template Page preview shows section titles, icons, frame colours and fonts from the template's Style Editor settings. Before, a theme with white headings drew titles and icons white on white in the preview; the live form was unaffected.

- Conversions run again in an org with a custom Address or Geolocation field on Form Submission. The Setup action left the whole field out of the record it hands to the flow; its parts (street, city, latitude, longitude) are still there. Every conversion in such an org had failed since 5.0 with "A field wasn't found or isn't supported for Apex action".
- Conversions run again in an org with its own Form Submission field named like one of ours without the prefix (a `Submitted_By__c` beside `FlowToolKit__Submitted_By__c`). The package cannot read such a field, so it is left out of the Setup record and a debug log says so; read it in your own flow with a Get Records, or rename it. Every conversion in such an org had failed since 5.0 with "duplicate field selected".
- **DynamicPDF** prints components saved in the **Form Components** tab. Name one by its record's **VersionId** (ending in `_v0`). Before, such a component printed an empty block, and only components built in the Form Builder tab printed. Its conditional logic now hides the same sections and fields in the PDF as on the form.
- **Generate PDF** saving a new version of a file that is not yet shared with the **Share With** record now shares it, the same as for a new file, and returns the file and its link. Before, the version was saved but the action returned nothing, so the flow went on with blank outputs. Two Generate PDF actions in one transaction no longer fail on the second, and a PDF that cannot be saved stops the flow with Salesforce's reason (give the action a fault path to handle it) instead of returning nothing.
- A long subtitle in a framed section with its title on the border no longer runs under the header icon; it wraps beside it.
- **Embed Code Generator** lists each site once, by its name, labelled Aura, LWR or Classic. Before, an LWR site was labelled Aura, and a site with a custom domain could appear once per domain; it now shows its custom domain.
- A repeater or data table inside a Flow section now lines up with the flow's form and the page's other sections; rows no longer sit 14px left and run past the page's edge. The Form Template Page preview shows the Flow section on the same edge as the page's own sections.
