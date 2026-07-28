# Release 4.5

## 🆕 Source Field Mappings: pull a record's own values onto its forms (#320, #322, #323)

One Form Template can now behave differently for every campaign, event, or job that uses it. On the Form Template Source configurator's Pre-fill tab, map any field on the source record onto a Form Submission field: pick a source field, pick the Form Submission field to receive it, and add the row. The picker supports **relationship traversal up to five hops** (a parent campaign's or account's fields) and **basic type matching** so text maps to text, a checkbox to a checkbox, and a lookup to a same-object lookup.

![Source Field Mappings Demo](https://raw.githubusercontent.com/common-unite/Flow_Tool_Kit_Public/main/documents/screenshots/322-source-field-mappings-demo.gif)

Each mapping is **Prefill** or **Live**:

- **Prefill** seeds the value on new submissions only, winning over the Pre-fill Template - a respondent resuming a draft keeps their own answers.
- **Live** re-copies the value onto the submission on *every* load, always overwriting - for values that must stay current with the source (a campaign's live owner, status, or amount) and for on-screen display text: map a source field onto a rich-text `Source_Text_1/2/3__c` field as Live and surface it with the `{{FlowToolKit__Source_Text_1__c}}` merge fields. So a Campaign's own description can open its form, and stay current if it changes.

## 🆕 More source overrides: subtitle, banner image, submit button label (#320)

The Form Template Source record gains three more overrides alongside name and theme: **Subtitle**, **Banner Image URL**, and **Submit Button Label**. Map a source field to each, and every record presents its own subtitle, hero banner URL, and call-to-action on the shared template.

## 🎨 Redesigned source configurator (#321)

The Form Template Source editor has a new look built entirely on Salesforce Lightning Design System, so it inherits your org theme:

- A **status band** shows whether the form is accepting submissions, a progress bar across the availability window, the assigned template as a link, and live submission counts.
- Navigation is grouped into **The Form**, **Publishing**, and **After Submit**.
- A **stateful save footer** tracks unsaved changes through to saved.
- The **brand footer** (also now on the Form Builder and Embed Code pages) carries a refreshed FlowToolKit wordmark and a support link.

![Redesigned Source Configurator Demo](https://raw.githubusercontent.com/common-unite/Flow_Tool_Kit_Public/main/documents/screenshots/321-source-configurator-redesign-demo.gif)

