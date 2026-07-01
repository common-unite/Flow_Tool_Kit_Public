# Flow Tool Kit v3.236 Release Notes

A small patch release: fixes a Form Template import error, plus minor prefill-flow and form-styling adjustments.

> **Upgrades cleanly from 3.235** — no managed-package members were removed.

## Fixes
- **Form Template import** — importing a template export whose JSON omits `recordTypeMap` (templates with no prefill record type) no longer throws *"Attempt to de-reference a null object."* `JSON.deserialize` bypasses the wrapper's constructor, so absent collections were left null; the importer now rehydrates them (and guards a null page-sections subquery). (#217)

## Improvements
- **Prefill flow** — `Form_Submission_Prefill` now runs in **Default Mode** (respects the running user's sharing/FLS) instead of system-mode-without-sharing.
- **Form style override** — scoped the segmented-control (radio button group) typography rule so it no longer restyles all buttons, and cleared the brand-button overrides.
- **Style hooks** — added stable class hooks for CSS/style injection: a `flowForm-field` class on each field's outer wrapper, and the Form Template record Id as a class on the form container, so styles can target a specific field or template.
