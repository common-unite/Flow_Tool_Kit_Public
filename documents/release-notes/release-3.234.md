# Flow Tool Kit v3.234 Release Notes

A large release centered on the **native Page Sections configurator**, a **JSON-baked Form Template record-page rebuild**, and a wave of form-design building blocks — theming, help-text modes, attestation, dividers, message cards, and illustrations.

> **Upgrade directly to 3.234.** Versions 3.232 and 3.233 were promoted early and contain incidental managed-package removals that break upgrades from earlier versions. Both are superseded by 3.234, which consolidates everything since 3.231.

## New Features

### Native Page Sections configurator

The *Configure Page Sections* screen flow is replaced by a native LWC configurator on the Form Template Page record page — faster, themed, and far more capable. (#143)

**What you can do.**

- Add, reorder, and delete page sections in a native UI (no screen-flow round trips), with live preview.
- Use new section types: **Display Text** and **Lightning Web Component**, alongside Form, Repeater, and Table. (#171)
- Add a **section divider** on every component type — rendered in the page-section component for Flow/LWC/Display Text, and via pass-through for Repeater/Table. (#172)
- Build up to **15 page sections** (raised from 6), across the configurator, lookups, trigger, flexipage, and permission sets. (#168)
- Customize a section in place: a **Customize** button and modal with a config-driven Pre-fill panel, rich-text Overview cards, a **Margin** section (top + bottom), and a dynamic Flow-template picklist. (#173, #174, #175, #176)

### Form Template record-page rebuild (JSON-baked LWCs)

The CMT-driven Form Template / Page / Section configurator pages are rebuilt as **JSON-baked record-page LWCs**, replacing the deprecated CMT-driven config forms. This sets up retiring packaged CMT config records, and gives cleaner, faster record pages with live preview. (#187)

The underlying JSON-config wrapper pattern is now generalized so any object can render a section-level `FormConfigJSON` configuration. (#145)

### Theme: Label Color + Default Label Size

Form Themes can now paint and size **every** field label in a form.

![Theme Label Color and Default Label Size in the theme builder](https://raw.githubusercontent.com/common-unite/Flow_Tool_Kit_Public/main/documents/screenshots/204-theme-label-color-size.png)

**What you can do.** (#204)

- Set a **Label Color** on a theme — it applies to all labels under the form: text fields, comboboxes, checkboxes, radios, toggles, and address sub-fields.
- Set a **Default Label Size** that every field inherits, with the cascade **field Label Size → theme Default Label Size → Salesforce default**.
- Override per field with the existing Label Size, including a new **Body Small** option that forces the standard small label over a theme default.

### Per-field Help Text display modes

Choose how help text appears, per field. (#201)

![Help text shown as a hover bubble, below the label, and below the field](https://raw.githubusercontent.com/common-unite/Flow_Tool_Kit_Public/main/documents/screenshots/201-help-text-display.gif)

**What you can do.**

- Pick a **Help Text Display** mode per field: **Hover Bubble** (default), **Below Label**, or **Below Field**.
- Below-label / below-field render the help text as a lighter, smaller subtitle instead of an icon bubble.

### Boolean toggle: Label Position

Boolean toggle fields gain a **Label Position** — Above (default), Left, or Right — with a side text block, a visible on/off state, and a rich-text label. (#192)

### Form (Icon Selector) record-page component

A new record-page selector for choosing an SLDS icon, plus DRY shared LDS plumbing extracted across all the field selectors (icon, theme, image, field). (#146)

### Illustration section

A new section type renders a `displayIllustration` scene with a title and subtitle — useful for empty states, intros, and confirmations. (#159)

![Illustration section](https://raw.githubusercontent.com/common-unite/Flow_Tool_Kit_Public/main/documents/screenshots/159-illustration-section.png)

### Also in this release (introduced in 3.232, included here)

These shipped in the superseded 3.232 build and are part of 3.234 — see [Release 3.232](release-3.232.md) for full detail:

- **Section Divider Styles** — a Divider Style picker with designed, theme-driven divider styles. (#147)
- **Rich Text Message Cards** — render rich text as an info / warning / error / success status card. (#148)
- **Attestation Field Override** — a card-wrapped consent checkbox with rich text and an SLDS success state. (#188)

The Form Template framework gains parity for these: page-section dividers + message cards (#149), a Header Text Variant that renders header rich text as a message card (#156), and `formTemplateSection` full divider/header/margin parity across all component types (#184). Dividers also pick up subtitle styling (#157) and a configurable vertical margin (#158).

## Fixes & Improvements

### Conditional logic
- Multiselect-picklist `CONTAINS` now matches any selected value (was exact-only), and a new `INCLUDES` operator was added. (#194)
- Conditions can now be added to conditional rules on **record-based** components (previously metadata-based only). (#193)

### Theming & layout
- The default (no-theme) form header drops its gradient and uses the org's brand tokens for header, subtitle, icon, and border. (#199)
- The Page Sections and Page Conditional Logic configurators gained a descriptive header (icon + title + help text). (#200)
- When vertical stage indicators are off, the form header and body render as one combined block (per-block popout division removed, hover shadow retained). (#203)
- The Component/Custom toggle preserves both values, persists the mode, and auto-opens the builder on first Custom. (#165)

### Preview & merge fields
- Section preview resolves merge fields with a fallback to the template-level Prefill Template (#197); stages-overview `{{merge}}` tokens in titles/headers/subtitles now render (#198); a missing merge record no longer throws (#196); page header/body/footer rich text aligns between record-page Preview and the live form (#195).

### Flow Section (stages)
- Stages mode: button labels round-trip so Finish works, and the repeater keeps in-progress edits across re-render. (#177, #183)

### Form Builder & data
- Rearranged fields are now sorted by position in generated JSON. (#190)
- Values equal to the field default now commit on record-based components. (#155)
- Cloning an existing metadata Form Component no longer throws "Invalid id value". (#150)
- Saving a record component with many sections/fields no longer hits the 10-chunk limit. (#152)
- `cloneForm` no longer crashes on save when the form's object identifier isn't loaded. (#202)
- Field documentation: descriptions + 2-sentence help text added across Form Template, Page, and Section fields. (#189, #191)

### Configurator polish & safety
- Fixed narrow Flow CPE / Experience Cloud column layout (#166); the Form Selection Mode radio reflects on load (#169); inline mode toggle + selector in the page-section-editor context (#170); removed a SOQL-in-loop in section sort (#167); cleared a category-only icon console warning (#153).

### Packaging
- DynamicPickList field-picker datasources survive package version creation (the field/theme/image/component pickers no longer fail the build). (#206)
- Restored a component target and a public property that had been incidentally removed during refactors, so the managed package upgrades cleanly from prior versions. (#207)

## Known Limitations

- The design-time field/theme/image/component pickers currently relax their stored-value validation to remain package-build-safe; restoring full builder typo-validation and exposing the pickers to subscriber App Builder are tracked follow-ups (#208, #209).
