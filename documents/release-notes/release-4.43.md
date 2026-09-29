# Release 4.43

A controlled page header for Form Template Pages, the Stacked header on every page section type, spacing control for repeater records, prefill flow values that show on the first page again, and a Site Design Blocks review pass.

## Form Templates

- **Prefill flow values show on the page** (#735). Since 4.41, a prefill flow that finished while the first page was already on screen left its fields blank: the values were held and saved, but not shown. They now fill in as the prefill window closes. The same fix covers every value pushed onto a page that is already drawn: the upsert and action flow `record` output, a settled payment, and formula results. Stages templates were not affected.
- **Page header** (#733). Each Form Template Page can show its own header above its sections, set once on the page instead of faked with a section header and margins. Choose Classic, Classic Spread or Stacked; Stacked adds the pretitle, body, tags and footer. Every part is rich text and accepts merge fields, including `{{$Template.Name}}` and the page fields. New fields on Form Template Page: `Show_Header__c`, `Header_Style__c`, `Header_Top_Margin__c`, `Header_Icon_Name__c`, `Header_Title__c`, `Header_Subtitle__c`, `Header_Text__c`, `Header_Text_Variant__c`, `Header_Kicker__c`, `Header_Lead__c`, `Header_Tags__c`, `Header_Tags_Position__c`, `Header_Footer__c` and `Header_Bottom_Margin__c`. New pages default to Classic with no top or bottom margin, and a page saved before this release reads the same way.
- **Page Header tab** on the Form Template Page record page, with the new **Form Page (Header)** component. The Page Text tab keeps Title, Body and Footer.
- **Stacked header on Field Set, Repeater and Table sections** (#731). A page section of those types set to Stacked rendered the Classic header. All three now show the pretitle, body, tags, footer and bottom margin.
- **Page record preview** shows Flow, LWC and Display Text sections as well as Field Set, Repeater and Table sections.

## Repeaters

- **Record Spacing** (#732). A new setting in Customize > Repeater, `Repeater_Record_Spacing__c`, sets the space above each repeater record, from none to xx-large. Blank keeps today's spacing.
- **No divider under the last record** (#732). The divider separates records, so the last record (or the first, when the buttons sit above) no longer draws one. Hide Divider still hides them all.
- **The first record sits under the header like a Field Set's fields** (#732). A visible repeater header now has the same gap above the first record as a Field Set header.

## Record page configurators

- **Faster autosave for buttons and picklists** (#734). A picklist, checkbox, lookup or date change on a configurator tab now saves at once; typed text and numbers still wait for a pause. Choosing a header style shows in the preview in about 1.6 seconds instead of 3.2.

## Site Design Blocks

- **Next Design keeps your placement** (#730). Loading or cycling designs replaces a block's copy and look but keeps its placement, spacing and visibility. The design pool is curated to 119 designs, at least six for every type.
- **Every control reaches something** (#730). Settings that were unreachable or did nothing now work, including Count Up, pricing columns and colours, hover on Image and Action Card, and a Hero band layout.
- **Block Height presets are the real height** (#423), **re-picking a default no longer changes the look** (#421), and **carousel and form button text is translatable** through custom labels (#422).

## Installing and upgrading

- Upgrades from 4.42 are safe: public properties that 4.43 no longer uses are kept, so an org on an earlier version upgrades without a removed-property error.

## After upgrading

Load each public form page once so the first visitor does not wait for the post-upgrade compile. If a prefill flow fills fewer fields than expected, check that its Transform targets the same Form Submission fields the form shows.
