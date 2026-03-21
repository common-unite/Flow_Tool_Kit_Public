# Release 3.216 — Form Template Sources

**Build one form. Use it everywhere.**

Release 3.216 introduces **Form Template Sources** — a powerful new way to connect your forms to any Salesforce record. Instead of duplicating form templates for each campaign, event, or program, you configure one template and let the source record drive the details.

## What's New

### Form Template Sources

A single registration form can now power hundreds of campaigns, events, programs, or cohorts — each with its own name, dates, branding, pre-filled values, and confirmation messaging. No duplicating templates. No maintaining parallel forms.

**How it works:** Create a Form Template Source metadata record that maps fields on your object (like Campaign) to form template overrides. Then drop the new Form Template Source Editor component on the record page. Admins configure everything from one place — form assignment, availability dates, themes, pre-fill templates, confirmation messages, offline messages, and email templates.

![Form Template Source Editor](https://raw.githubusercontent.com/common-unite/cUnite_FormBuilder/master/documents/screenshots/form-template-source-editor-demo.gif)

**Use cases enabled:**
- **Event Registration** — one form template across every event, each with its own dates and messaging
- **Program Enrollment** — intake forms that pull program-specific details from the program record
- **Grant Applications** — application forms with deadlines driven by the funding opportunity
- **Membership Signups** — tier-specific pre-fill values and confirmation emails
- **Volunteer Signups** — per-opportunity availability windows
- **Cohort Registration** — cohort records drive registration periods and pre-populated details

The pattern works with any standard or custom object — if you can create a record in Salesforce, you can connect a form to it.

### Form Template Source Editor

The new **Form (Template Source Editor)** component provides a polished admin experience:

- **Tabbed navigation** — Details, Availability, Prefill Values, Confirmation Message, Email Template
- **Auto-save on tab switch** — changes save automatically when navigating between tabs
- **Live preview** — preview the form exactly as users will see it, with a loading spinner during load
- **Pre-fill template picker** — search and select pre-fill templates with tag-based matching
- **Dynamic field labels** — labels resolve from object metadata, not hardcoded
- **Save state indicator** — button shows "Saved" or "Save Changes" so you always know where you stand

### Dynamic Email Template Resolution

The confirmation email flow no longer hardcodes Campaign as the source. A new **Get Source Email Template** Flow action dynamically resolves the email template from any configured source object using the Form Template Source metadata. This means email template overrides work automatically when you extend to new objects.

### Additional Improvements

- **Form loading spinner** — the Form Template component now shows a branded spinner while loading, replacing the blank flash
- **Docked footer in modals** — form buttons now display correctly inside Lightning Modals instead of behind them
- **Safe area padding fix** — docked buttons have proper bottom padding on all devices (including iPhone home bar)
- **Source Id tracking** — every submission from a source record is stamped with `Source_Id__c`, enabling conversion Flows to query source-specific data and drive downstream automation

## Getting Started

1. Navigate to **Setup > Custom Metadata Types > Form Template Source > Manage Records**
2. Create a record mapping your object's fields to form template overrides
3. Add the **Form (Template Source Editor)** component to your record page in Lightning App Builder
4. Start configuring forms directly from your source records

Full documentation: [Form Template Sources Guide](https://common-unite.gitbook.io/flow-tool-kit/form-template-sources)
