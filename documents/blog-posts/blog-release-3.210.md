g# Flow Tool Kit v3.210: Review Mode, Hidden Headers, and More

We're excited to release Flow Tool Kit v3.210! This release adds new form-building capabilities, a handy new Flow action, and squashes a few bugs.

## Highlights

This release introduces a **Review display type** for Form Builder — you can now design read-only review screens directly in the WYSIWYG editor, perfect for "Review your answers" confirmation steps in multi-screen flows. We've also added the ability to **hide headers and dividers** on Component Sections, giving you more control over how embedded components look inside a parent form.

## New Features

### Review Display Type (#57)

You can now select **Review** as a Form Display Type in Form Builder. This lets you design read-only summary layouts using the same drag-and-drop experience you already know — select fields, arrange sections, apply themes — all rendered in a clean review format.

**Use case:** Multi-step flows often need a "Review your answers" screen before final submission. Previously, you had to build these manually outside of Form Builder. Now it's a built-in option.

![Review Display Type Demo](https://raw.githubusercontent.com/common-unite/Flow_Tool_Kit_Public/main/documents/screenshots/57-review-display-type-demo.gif)

### Hide Headers and Dividers on Component Sections (#56)

When embedding a reusable form component inside another form via a **Component Section**, you can now hide the embedded component's headers and dividers. This gives you control over the visual presentation without modifying the source component — so all other usages remain unaffected.

![Hide Headers Demo](https://raw.githubusercontent.com/common-unite/Flow_Tool_Kit_Public/main/documents/screenshots/56-hide-headers-demo.gif)

### Get SObject Type Invocable Action (#59)

A new **Get SObject Type from Record Id** action is available under the Flow Tool Kit category. Pass in any record ID and get back the SObject API name (e.g., `Account`, `Contact`, `Opportunity`) — entirely in-memory with no SOQL query.

**Performance:** This replaces the common pattern of querying `EntityDefinition` by key prefix (~100-300ms) with `Id.getSObjectType()` (~1ms).

![Get SObject Type Demo](https://raw.githubusercontent.com/common-unite/Flow_Tool_Kit_Public/main/documents/screenshots/59-get-sobject-type-demo.gif)

## Enhancements

- **Header Title & Subtitle Accept Static Text** — The Header component's property editor now lets you type static text directly into the title and subtitle fields, instead of requiring a flow variable. Same pattern as button labels. (#51)

## Bug Fixes

- **Fixed:** Calendar Scheduler no longer crashes when a multi-select picklist field is passed for the `times` or `daysOfWeek` parameters. The Flow runtime delivers multi-select values as arrays, and the component now handles both arrays and semicolon-delimited strings. (#50)

---

*Flow Tool Kit v3.210 is available now on the AppExchange.*
