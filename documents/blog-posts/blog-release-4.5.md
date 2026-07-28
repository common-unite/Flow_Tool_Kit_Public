# Flow Tool Kit 4.5: One Template, Every Campaign, and a Page Builder to Wrap Around It

**TL;DR: 4.5 lets a single Form Template behave differently for every campaign, event, or job that uses it by mapping fields off the source record onto the submission. It also introduces Design Blocks, ten ready-made layouts for building the landing and thank-you pages around your forms, which now accept merge fields and HTML in any text. Merge fields gain proper date, time, and currency formats in the user's own locale. Upgrading is one click: Setup, Installed Packages, Upgrade to Recommended Version.**

## One template, a different form for every record

If you run the same application for forty different grants, or the same registration for every event on the calendar, you have probably built forty nearly identical templates. **Source Field Mappings** end that. On the Form Template Source configurator's Pre-fill tab, map any field on the source record onto a field on the Form Submission: pick the source field, pick the destination, add the row. The picker traverses relationships up to five hops, so a campaign's parent account is as reachable as the campaign itself, and it type-checks as you go, so text lands in text and a lookup lands in a same-object lookup.

Each mapping is either **Prefill** or **Live**, and the difference matters. Prefill seeds the value on new submissions only, winning over the Pre-fill Template, which means a respondent who saves a draft and comes back keeps their own answers. Live re-copies on every load and always overwrites, which is what you want for anything that must track the source: a campaign's current owner, its status, its amount.

Live mappings are also how you get a record's own copy onto its form. Map a source field into one of the new rich-text `Source_Text_1/2/3__c` fields, then surface it in the form with `{{FlowToolKit__Source_Text_1__c}}`. A campaign's description can now open its own form and stay current if someone edits it.

Alongside those, the Form Template Source record gained three more overrides to sit next to name and theme: **Subtitle**, **Banner Image URL**, and **Submit Button Label**. Point each at a source field and every record presents its own subtitle, its own hero image, and its own call to action on a shared template.

## The configurator that got a redesign

The Form Template Source editor was rebuilt on Lightning Design System, so it inherits your org theme instead of fighting it. A status band across the top tells you whether the form is accepting submissions, how far through the availability window you are, which template is assigned, and how many submissions have arrived. The settings are grouped into The Form, Publishing, and After Submit rather than one long scroll, and a save footer tracks you from unsaved through to saved.

## Design Blocks: the pages around your forms

A form rarely lives alone. It has a landing page in front of it and a thank-you page behind it, and until now those were somebody else's problem. **Form (Design Block)** is a new Experience Cloud component that builds them. Drop it on a page, choose one of ten layouts, and fill in the content:

Hero, Stats, Cards, Showcase, Steps, Pricing, Table, Pills, Callout, and Call to Action.

Everything is configured from one property editor: theming, spacing, background gradients and textures, borders, and per-item color overrides. Heading, Body, and Footnote each carry their own alignment, so a centered heading can sit above left-aligned copy without a workaround, and an Arrangement toggle flips a block between stacked and split.

## Your pages can read your records

Any text on a Design Block can carry `{{FieldApiName}}` tokens. On a record page, set the block's Record Id property to `{!recordId}` and every token fills in from that record, relationship traversal included, so `{{ParentAccount__r.Name}}` reaches a parent. There is nothing else to configure: the block works out which object the record belongs to on its own.

Tokens are always replaced. If the field is empty, or the record is missing, or the visitor cannot read it, the token renders blank. A visitor never sees a raw `{{...}}` staring back at them.

## And your copy can be styled

Every text field on a Design Block now renders formatting, so you can write markup straight into the property editor. Put this in a heading:

`Too hot. Too cold. <b>{{Name}}</b>`

and the merged name comes out bold. Headings, titles, bullet text, footnotes, table cells, badges, and button labels all accept markup, including `<span style="color: ...">` for inline color. Unsupported tags are stripped rather than rendered, so pasted markup cannot break your layout.

## Dates and money that look right

Merge fields gained four format tokens, and the date token that already existed finally respects the running user's locale instead of always printing US format:

- `{{$date.Field__c}}` for a long date
- `{{$dateShort.Field__c}}` for a short numeric one
- `{{$datetime.Field__c}}` for date and time together
- `{{$time.Field__c}}` for time alone
- `{{$currency.Field__c}}` for real currency formatting, using your org currency or the user's currency in multi-currency orgs

They work anywhere merge fields already do: rich text, field labels, help text, and section content.

## What's next

Design Blocks are new, and the obvious next questions are ours to answer: a proper mobile story for every layout, and blocks that can read a list of records rather than a single one. On the forms side, review mode's lookup display and the Platform Cache allocation warning are still queued.

## Upgrade in one click

4.5.0.1 is the recommended version: open **Setup > Installed Packages** and click **Upgrade to Recommended Version**. Full notes live on the [release page](https://github.com/common-unite/Flow_Tool_Kit_Public/releases/tag/release%2F4.5.0.1).

One habit worth keeping: load your public form pages once right after upgrading, so the one-time component compile happens to you rather than your first real visitor.

Questions or feedback? Reach us at support@common-unite.com.
