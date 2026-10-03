# Release 4.46

A refused form save is never silent again: the save flow reports every failed step, and the form shows the reason with what an admin can do about it. Guest sites get the pre-fill template sharing rule documented, and Phone Type gains Other.

## 🛠 A refused save shows its reason instead of "Submitted successfully" (#756, #762)

- **Guests and embedded forms no longer see a success message when nothing was saved.** The headless save flow, `Form Submission Upsert`, sent a failed Form Submission create back into its own routing, which ended cleanly, so the form reported success with no record and no auto-number consumed. Every save step in the flow now ends through Assign Error Message, and the message names the step that failed, such as Form Submission save.
- **The toast shows everywhere the form runs.** Save errors now use Salesforce's newer toast, which also appears on LWR sites and on forms embedded in other websites, where the older toast never showed. A save error stays on screen until the respondent closes it; only field validation toasts close on their own.
- **The message is readable and says what to do.** The platform's boilerplate is stripped and the cause is put in one plain sentence, followed by what to do: correct the answer, or contact the administrator, with a plain direction for the administrator to increase access for guest users when access is the cause. For example: `Phone Type does not accept the value "Landline". Please choose another value or contact your administrator.` Access errors, restricted picklist values, validation rules, required fields and a missing permission set grant on an override each get their own wording. The full platform text stays in the browser console for admins. Prefill flow errors get the same cleanup.
- **A clone of the save flow made before this release keeps the old wiring.** Open the clone, select the Upsert element that saves the Form Submission, and point its fault path at Assign Error Message, or clone the packaged flow again. See [Guest users and the upsert override](../form-template-framework/prefill-flow.md#guest-users-and-the-upsert-override).

## 🛠 A guest's refused update shows its reason and the remedy (#775)

- **Save progress, then submit, as a guest.** The second save updates the submission, which a guest in user mode can never do. The refusal used to reach the toast as the raw flow text, with an HTML tag printed as text and no remedy. It now reads "Your saved submission could not be updated with your current access. Please contact your administrator about increasing access for guest users."
- **Why it slipped through:** an Update or Delete Records fault uses a different sentence shape than a Create Records fault, which the form had not learned. It knows all three now, and strips the SOAP guide boilerplate whether or not the platform wraps it in a link.

## 🛠 URL parameter mappings apply on the embed page (#756)

- **Forms embedded through Lightning Out now apply URL Parameter Mappings.** The embed page never supplies the page state the mappings waited for, so `pv` parameters were ignored there while they worked on Experience Cloud and Lightning pages.

## 🆕 Other on Phone Type (#757)

- **Contact 1 Phone Type and Contact 2 Phone Type offer Other,** matching Email Type, on the Default and Pre-fill Template record types.
- **Existing orgs do not receive new picklist values on upgrade.** If you need Other, add it to both fields and to your Form Submission record types in Setup.

## 🛠 A form says so when its pre-fill template cannot be read (#765)

- **Missing defaults are no longer silent.** When the person filling in a form cannot read its Pre-fill Template record, the form used to open without the defaults and give no sign of it, while the admin's own preview showed every default. The form now shows a warning toast saying that some default answers were not loaded because the pre-fill template is not shared with them, and asking them to contact their administrator. The toast stays until it is closed. The browser console names the Pre-fill Template record and the sharing rule that fixes it. This also covers pre-fill templates on repeater and table sections, which could stop the section from loading.
- **Share pre-fill templates on the Is Pre-fill Template checkbox, never on the record type.** A sharing rule written on the Pre-fill Template record type stops matching when the record carries another record type. The new [Who Can Read the Pre-fill Template](../form-template-framework/prefill-templates.md#who-can-read-the-pre-fill-template) section gives the rule, and the Experience Cloud deployment guides list it as a guest setup step.
- **The toast text is the custom label `Notice_Prefill_Unavailable`,** so you can reword or translate it.

## 📘 Guest Forms Quickstart (#767)

- **One checklist for public forms on an Experience Cloud site.** [Guest Forms Quickstart](../how-to-guides/guest-forms-quickstart.md) covers creating and activating the site, letting guests in, placing the form, the guest permission set, guest sharing rules, the save override in System Context Without Sharing, LWR extras and testing as a guest, with a table of what a guest sees when a step is missing.
- **Corrected:** the Experience Cloud deploy guide said guest users cannot receive permission sets. They can, and Form Flow User is meant to be assigned to the site's guest user.

## 📘 Overriding Packaged Flows (#763)

- **One page for the override mechanism.** [Overriding Packaged Flows](../advanced-topics/overriding-packaged-flows.md) explains the flow override (Save as flow override: every caller runs yours, and every counter, picklist and log keeps showing the packaged name) against a plain clone, why a guest-serving save override runs in System Context Without Sharing while the package ships nothing in system context, and what to check when an override is deployed with metadata: it can arrive as Draft, and a flow with a local action needs API 63 or later. Linked from the NPSP and Nonprofit Cloud Customizing pages, the Prefill Flow page and the Guest Forms Quickstart.
- **The installer sets up the guest save override.** An optional step on a first install, **Install the Guest Save Override (inactive)**, checked by default on the Install, Nonprofit Cloud and NPSP plans, deploys a copy of `(Form) Upsert | Overridable` as a flow override in System Context Without Sharing, inactive, plus the **Form Flow (Guest User)** permission set that grants it. The admin reviews it, activates it and assigns the permission set to the site's guest user; the package itself still ships nothing in system context. Re-runs and upgrades skip the step, so the permission set, which extension installers add their guest grants to, is never replaced. See [The installer's guest save override](../advanced-topics/overriding-packaged-flows.md#the-installers-guest-save-override).

## 📘 Record types and duplicate rules in conversions (#755)

- **Documented, by design.** The packaged Contact engines look the template's record type up but never write it, because a packaged flow cannot reference RecordTypeId without failing to install in orgs that have no Contact record types. A duplicate rule with a Record Type condition therefore never matches a form conversion, and the saved Contact takes the user's default record type. [Submission Conversion](../form-template-framework/submission-conversion.md#record-types-and-duplicate-rules) and the NPSP [Conversion Flows](../npsp/conversion-flows.md#record-types-and-duplicate-rules) page give the two remedies; both engine descriptions say so in Setup.

## 🆕 Experience Cloud page templates for Form Template and Form Submission (#768)

Digital Experiences must be enabled in the org before 4.46 installs or upgrades, because these templates are Experience Cloud pages. The installer checks for it first and stops with instructions when it is off.

- **Record pages for your forms in two clicks.** On an Aura site, create a page variation of the Form Template and Form Submission object pages from the new **Form Template Detail** and **Form Submission Detail** templates. Each holds Form (Template) bound to the page's record, so every template gets its own link on the site and resume links have a page to land on. See step 3 of the [Guest Forms Quickstart](../how-to-guides/guest-forms-quickstart.md).

## 🛠 A value set on an input by a tool registers (#760)

- **A value set by a browser tool or a test harness commits.** A change event aimed at the input itself, which carries no value detail, is read off the input instead of committing nothing, which used to leave a number or currency field blank with "Complete this field" even though the value was showing. Typing is unchanged: it still commits once per keystroke, and a number input ignores a value that is not a number yet.

## 🛠 One save at a time (#770)

- **Double clicks no longer start a second save.** While a save you started is running, further button clicks are ignored, on every save path, including Save Progress, which shows no spinner.
- **A click during an autosave is not lost.** It waits for the autosave to finish, then runs, saving the record the autosave just created rather than creating it again.
- **Fixed:** after an autosave failed, later saves on the page could run as silent autosaves and show no message.

## 🛠 A blocked Next or Submit shows its toasts everywhere and moves to the first field (#758, #766)

- **Toasts that show everywhere, three at most.** When required fields are empty or a value fails validation, each field keeps its red message and the field-by-field toasts now use Salesforce's newer toast, so they also show on LWR sites and embedded forms, where they never appeared before. Inside a Form Template, focus also moves to the first field to fix. A screen shows at most three of them however many forms it holds: the first two problems, then a count of the rest. A warning or a save error that is still open does not take one of the three places. The Form Template's own "fix the errors" toast is gone; the field toasts already say what to fix.
- **Everywhere a form validates:** page Next and Submit, Mark Complete in stages mode, the review page and its Edit window, and a Flow Form on its own in a Flow screen. There the Flow runtime redraws the screen after a blocked Next, so the form toasts and marks its fields and leaves focus where it was.
- **One count for the whole screen.** The "additional errors" toast is always the last one and covers every form, repeater row and section on the screen.
- **Custom LWC sections** can return `invalidItems` from `validate()` to name their own fields; the items decide where focus lands. An on-page list of the same items is built and not shown in this release.

## 🛠 A blank required picklist shows as invalid in a Flow screen (#773)

- **Fixed:** in a Flow screen, after Next or Finish was blocked, text inputs showed the error outline while a blank required picklist stayed plain, though the toasts counted it. After the Flow runtime redraws the screen the form re-marks its fields, and the picklist missed that pass. A field that has been asked to show its validity now keeps showing it on its own redraws. Inside a Form Template the picklist was already marked.

## 🛠 A required radio or multi-select field shows its message under the options (#776, #772)

- **Fixed:** left blank, a required radio or multi-select field drew "Complete this field." on top of its last option, where it could not be read. The message now sits under the options, as it does for the button-style group.

## 🛠 Radio buttons and checkbox pills are real inputs to assistive tech and tools (#759)

- **The native input carries the field's name and the picklist value.** Radio options, survey buttons, separated buttons and the multi-select checkboxes each hold a native input whose value is the picklist value; before, it was a made-up option id. A checkbox is named by the field API name. A radio group is named by the field API name plus an instance suffix, because two copies of one field on a page (repeater rows) must not share a radio group, and each radio carries `data-field-name` with the exact API name. `data-value` stays on every input.
- **A click on the control is a click on the input.** The input now lies over the drawn radio, button or pill instead of being clipped to a pixel beside it, so a tap, a password manager or a testing tool that clicks the element lands. Each multi-select badge pill gains a real checkbox, and the pill shows the keyboard focus.

## 🛠 The combo box works from the keyboard and exposes its values (#761)

- **Arrow keys move through the options, Enter picks, Escape closes.** The Flow Tool Kit combo box (multi-select Combobox picklists and the builder's selectors) highlights an option as the arrows move, wraps at the ends and opens the list when it is closed. Escape closes the list without closing a window behind it.
- **Every option carries `data-value`,** so tools and tests can pick an option by its value instead of its text.

## 🛠 Flow Builder can add form components to a screen again (#771)

- **Fixed "Unsupported community context. Invalid usage of @salesforce/community" in Flow Builder.** Since 4.45, form components asked an Experience Cloud module for the site's address so image assets load on LWR sites. Outside a site that request could make Flow Builder fail when a form component was added to a screen. The site's address is now read from the page itself, and no form component touches the Experience Cloud module.
- **Image assets keep working on every site.** An LWR site names its address in the page; an Aura site and the Experience Builder canvas carry it in the page address. Publish an LWR site after upgrading, as always on LWR.

## 🆕 Nothing renders behind the pre-fill flow modal (#778)

While a Form Template's pre-fill flow runs, the template shows a loading placeholder in place of its pages. The pages mount once the flow has finished and its outputs are in the submission, so a respondent never sees a half-ready form behind the modal and the pages render once. A flow with a screen shows that screen in the modal; a flow with no screen shows the modal's spinner until it finishes.

## 🛠 The Record Form embed can render read-only (#602)

`readOnly=true` on the embed page URL now reaches the Record Form, so an embedded form can display a record without allowing edits. Lightning Out drops a property named `readOnly` on the way in, so the embed page hands the switch over under another name. The Embed Code Generator's Read Only toggle is carried into the snippet.

## 🛠 Site design block dropdowns commit only a chosen option (#392)

The site design block property editor's dropdowns are now the package combo box, which commits a value only on a click or Enter and closes on Escape without a change. The standard combobox commits the highlighted option on Tab, and an Escape over a hovered option was seen to commit it in Experience Builder, where every change is written to the page draft at once.

## 🛠 Three packaged flows open in auto layout again (#769)

The save flow and two other packaged flows opened in Flow Builder's free-form layout after a regression. They open in auto layout again, so a clone starts tidy.

## 🛠 Built on the previous Salesforce release during the Winter '27 window (#777)

4.46 is built on Summer '26, so it installs in orgs still on Summer '26 as well as orgs already on Winter '27. Every scratch definition in the repo targets the previous release until the window closes on 2026-10-10.
