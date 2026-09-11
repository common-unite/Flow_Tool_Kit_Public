# Release 4.34

Fifteen fixes and improvements from the September sprint, most of them reported from client orgs. Nothing changes shape: every existing form, template and setting keeps working as before, and the new behaviours are opt-in or fix something that was plainly wrong.

## Forms and templates

- **Flow page sections: Back goes back** (#652): a flow-type page section's own Back button returned to the previous page or, on the last page, submitted the whole form. The form now routes the section's buttons by their labels, so Back goes back, Save Progress saves, and only the section's own Next or Finish moves forward.
- **Required Yes/No questions open unanswered** (#649): a Boolean shown as a picklist, radio group or attestation was pre-answered No whenever the template's prefill values came from a Prefill Template, because a checkbox on that record can never be empty. New submissions seeded from a Prefill Template now drop those unticked boxes; a ticked box still carries through as Yes, and saved answers are never touched.
- **Prefill flows that insert their own record** (#646): a prefill flow returning the record it created or found (the resume pattern the shipped Prefill Template flow uses) now updates that record on save instead of failing with Save Failed for logged-in users.
- **Form component selector inside record forms** (#589): a form-selector field placed on a form component showed only its label. It renders its picker again, and a failed load now reports instead of staying blank.
- **View Details in a new tab under Lightning Web Security** (#627): repeaters, navigation buttons and the receipt link open new tabs through a link click, the mechanism Salesforce prescribes from Winter '27, instead of `window.open`, which the platform can refuse for same-origin pages.
- **Read-only multiselects can show every option** (#635): a new org setting, Multiselect Show All When Read Only, shows all values of a read-only multiselect with the chosen ones highlighted. Off by default, so nothing changes until an admin turns it on in Setup, Custom Settings, Flow Tool Kit Settings.
- **Custom LWC sections receive their section record** (#633): a custom Lightning web component placed as a page section now receives the page section record, so it can read the admin's form component and render it instead of hand-writing every input.

## Configuration

- **Template defaults reach the builder** (#640, #648): record-type and matching-rule defaults on a new Form Template are now value-level picklist defaults instead of formulas, and the Form Template Settings form seeds a new template from the full defaults loader rather than the layout's fields alone. Defaults set post-install, including the Nonprofit Cloud extension's, now preselect on a new template.
- **Upgrading orgs, one thing to know**: the record-type and matching-rule defaults on a new Form Template are now set by the picklist values rather than by formulas. A package upgrade does not apply picklist default flags to an existing org, so in an upgraded org a new template opens with those fields blank until you pick a value. Blank behaves as the standard default at runtime; existing templates are unchanged. Fresh installs and Nonprofit Cloud orgs get the defaults. Tracked in #655.
- **Fewer required settings** (#651): Stage Indicator Type, Confirmation Page Label and Confirmation Page Message are optional; each has a platform default.
- **Conversion status fields never appear in prefill or URL mapping pickers** (#650), including ones an extension package or your own org adds.

## Access and email

- **One missing field grant no longer hides every record-based form component** (#613): the field sweep behind record-based components now skips fields the running user cannot read instead of failing the whole query. Guest users were the ones hitting this.
- **Confirmation emails to Leads with Form Submission merge fields** (#644): a new Render Email Template flow action renders any template for a Contact or Lead recipient with the submission as the related record, and the packaged send flow uses it, so Lead recipients receive the merged message.

## Nonprofit Cloud

- **Head of household from the form** (#625): Form Submission gains Primary Contact checkboxes for Contact 1 and Contact 2. The base package stores them; the Nonprofit Cloud extension uses them to name the household's primary member when it converts the submission.

## Installer

- The installer no longer deploys a branded style sheet into your org (#636). The example sheet remains available on GitHub for anyone building a custom style sheet.

Admins: load your public form pages, including any embedded form URLs, once after upgrading; the first visit pays the component compile so a real visitor does not.
