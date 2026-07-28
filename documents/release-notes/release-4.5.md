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


## 🆕 Date, time, and currency formats for merge fields (#324)

Merge fields gain four new format tokens, and the existing date token becomes properly locale-aware. Every one of them renders in the running user's locale rather than always US format:

- `{{$date.Field__c}}` - long date, "July 26, 2026"
- `{{$dateShort.Field__c}}` - short numeric date, "7/26/2026"
- `{{$datetime.Field__c}}` - date and time together
- `{{$time.Field__c}}` - time only
- `{{$currency.Field__c}}` - real currency formatting using your org currency, or the user's currency in multi-currency orgs

These work anywhere merge fields already do: rich text, field labels, help text, and section content.

## 🆕 Design Blocks: build the pages around your forms (#328, #332)

**Form (Design Block)** is a new Experience Cloud component for everything surrounding a form: landing pages, thank-you pages, and campaign microsites. Drop it onto a page, choose a layout, and fill in the content. Ten layouts ship with it:

**Hero**, **Stats**, **Cards**, **Showcase**, **Steps**, **Pricing**, **Table**, **Pills**, **Callout**, and **Call to Action**.

Everything is configured from one property editor: theming, spacing, background gradients and textures, borders, and per-item color overrides. The Heading, Body, and Footnote groups each carry their own alignment, so a centered heading can sit above left-aligned copy, and an Arrangement toggle switches a block between stacked and split.

A block whose layout has not been chosen yet now shows an illustrated prompt pointing at the property editor, instead of a bare line of text.

## 🆕 Merge fields in Design Blocks (#329)

Any text on a Design Block can carry `{{FieldApiName}}` tokens that resolve against a record. On a record page, set the block's **Record Id** property to `{!recordId}` and every token fills in from that record. Relationship traversal works, so `{{ParentAccount__r.Name}}` reaches a parent record.

Tokens are always replaced. If the field is empty, or the record is missing or unreadable, the token renders blank rather than showing a raw `{{...}}` to a visitor. There is nothing else to set up: the block works out which object the record belongs to on its own.

## 🆕 HTML in Design Block content (#330)

Every text field on a Design Block now renders formatting, so you can style copy directly in the property editor:

> `Too hot. Too cold. <b>{{Name}}</b>`

renders the merged name in bold. Headings, titles, bullet text, footnotes, table cells, badges, and button labels all accept markup, including `<span style="color: ...">` for inline color. Unsupported tags are removed, so pasted markup cannot break the page layout.
