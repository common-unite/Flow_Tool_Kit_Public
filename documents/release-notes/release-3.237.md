# Flow Tool Kit v3.237 Release Notes

A small patch release: fixes two Form Builder issues around JSON page-section components and cross-org config reuse, plus a minor form-spacing tweak.

> **Upgrades cleanly from 3.236**: no managed-package members were removed.

## Fixes
- **Form Builder, JSON page-section save** (#218): saving a JSON-configured Form Template **page-section component** no longer performs a *clone*. Previously every save stamped a fresh copy, stacking `(Clone)` on the component label, and when a boolean field was set to the **Attestation** display type the (cloned) save failed and left the builder frozen so it couldn't be re-saved. Stamping a config onto a page section now updates in place, and any failed save surfaces the error and keeps the editor usable instead of hanging.
- **Cross-org config paste** (#219): pasting or loading a Form Component config **exported from another org** no longer errors when the target org is missing one or more referenced fields. The fields that don't exist in the target org are skipped (and noted in the browser console) so the rest of the form renders normally.

## Improvements
- **Form field spacing**: the `Flow_Form_Style_Override_Template` style resource now adds a small amount of top spacing to each field (via the `flowForm-field` style hook added in 3.236) for clearer vertical separation between fields.
