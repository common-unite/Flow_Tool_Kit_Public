# Flow Tool Kit v3.235 Release Notes

A focused follow-up to 3.234: form **theming now reaches JSON-rendered page-section components**, the attestation label gets a full rich/plain-text editor, and several theming and help-text fixes land.

> **Upgrades cleanly from 3.234**: no managed-package members were removed; existing forms and configs are unaffected.

## New & Improved

### Theming now applies to JSON-rendered page sections

Page sections render their component from a stored JSON config, a path that previously bypassed all theme resolution. Theming now works there the same as in the live form.

- **Form Template Theme override** now applies to page-section components (field set, table, and repeater). The JSON render path previously received an empty themes list, so the template's `Theme` override never resolved. (#211)
- **Theme Label Color** now paints field labels. The `--labelColor` variable is set on the form wrapper, a real ancestor of the (slotted) labels, so it inherits correctly, and a partial theme baked into an older saved config is upgraded to the full theme once it loads. (#212)
- **Custom style-sheet static resources** (`Form_Style_Sheet__mdt`, e.g. the org's style override) now load for JSON-only page-section components across all three renderers. They were previously loaded only when a form was fetched by API name. (#215)

### Attestation Rich Text Label: full editor

The attestation field's **Rich Text Label** now matches the section rich-text editor: a **code-snippet** toolbar button, a **plain-text (raw HTML)** editor, and a **Rich / Plain Text** toggle that persists your choice. (#214)

## Fixes

- **Help text propagation**: overridden managed-field help text now renders from a `helpText__c` override in the record-page settings configs, so it shows correctly in subscriber orgs where the managed inline help text doesn't propagate. (#210)
- **Radio button group**: a selected segmented-control button's brand background/border no longer overflows the group's rounded corners. (#213)
