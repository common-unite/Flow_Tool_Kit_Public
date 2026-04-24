# Flow Tool Kit v3.226 Release Notes

## Bug Fixes

### Form Builder and Form Selector Silently Truncate at 61 Forms per Object

The Form Builder UI and the Flow Form Selector component were silently dropping forms from the displayed list when any single object had many active forms. Orgs with large form libraries saw totals like StudentRecord 86 → 61 or 72 → 61 on the UI, with no error, toast, or debug log. Forms were still queryable via SOQL and still worked when referenced by QualifiedApiName; they just never appeared in pickers.

**Root cause.** Aura's `@AuraEnabled` response serializer caps CMT (Custom Metadata Type) subquery children at ~61 records per parent when the response envelope meets some combination of payload, wrapper shape, and heap conditions we were not able to fully isolate. Reproduced in three separate orgs (one subscriber sandbox on 3.221, one internal sandbox on 3.62.3, and a controlled scratch org with 200 seeded forms).

**Fix.** Replaced the `Form_Object__mdt → Forms__r` nested subquery with two flat queries — one for objects, one for forms — and stitch the forms onto each parent object client-side in the LWC. Flat-query results are not routed through the parent-child envelope, so whatever triggers the cap cannot touch them.

**Impact.** Customers with large form libraries will see the full set of forms in Form Builder and in any `flowFormSelector`-based component after upgrading.

**Affected components:**
- `Utilities.cls` — `queryAllObjectsWithForms` (subquery removed), `queryAllFormsForBuilder` (new flat query), `formBuilderWrapper.allForms` (new field), `getObjectOptionsWithForms` / `getObjectOptionsWithFormsNoCache` (new `@AuraEnabled` methods)
- `formBuilder` LWC — groups `allForms` by `Form_Object__c` and attaches as `FlowToolKit__Forms__r` before rendering
- `flowFormSelector` LWC — same stitch, uses the new `NoCache` endpoint

## Known Follow-Ups

The same bug class exists in four other CMT-subquery sites that are exposed through `@AuraEnabled` responses. These are all per-form-scoped queries (the cap only fires if a single form has more than 61 logic rules / fields in a section / conditions in a rule / translations on a label), so real-world exposure is much lower than the Form Builder case. Tracked for a future release:

- `Utilities.queryAllForms` — `Form__mdt → conditionalLogic__r`
- `Utilities_Form.queryFormSections` — `Form_Section__mdt → fields__r`
- `Utilities_Form.queryFormLogic` — `Form_Conditional_Logic__mdt → conditions__r`
- `Utilities.queryAllLabelsWithTranslations` — `Form_Label__mdt → Form_Label_Translations__r`

Full investigation and audit notes live in [`documents/form_builder_truncation_investigation.md`](../form_builder_truncation_investigation.md).
