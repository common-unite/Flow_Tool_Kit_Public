# Form Builder 148→123 Truncation Investigation

Client: washingtoncenter--newfullsan.sandbox, Michael Carter
FlowToolKit version deployed: **3.221** (OLD subquery approach)
Running user: michael.carter@twc.edu.newfullsan (confirmed sysadmin-level via the profile lookup)
Current date: 2026-04-23

---

## The Gap We Are Trying To Explain

| Measurement | Count |
|---|---|
| Active Form__mdt total | 160 |
| Active Form__mdt with type in form/default/scoped/vertical/carousel | **148** |
| Forms visible in Form Builder UI (HAR capture) | **123** |
| **Missing** | **25** |

HAR-reported missing 25 forms are **specifically from StudentRecord** (Form_Object.DeveloperName = StudentRecord, Object = Application__c). StudentRecord has 86 forms per flat SOQL; HAR shows ~61.

---

## All Tests Run So Far

### ✅ Test 1: Direct flat SOQL on Form__mdt
**Query:** `SELECT Id FROM Form__mdt WHERE Active__c = TRUE AND type__c IN :validTypes`
**Result:** 148 rows in Michael's org
**Conclusion:** The raw data exists. No filter is dropping forms at the row level.

### ✅ Test 2: formMetaDataMap query inside setManagersForms()
**Query:** `SELECT Id, Form_Object__r.Id, Form_Managers__c, DemoRecord__c, CategoryTag__c FROM Form__mdt WHERE Active__c = TRUE WITH SECURITY_ENFORCED`
**Result in Michael's org:** 160
**Conclusion:** WITH SECURITY_ENFORCED is not filtering. All 160 active forms are visible to setManagersForms. Therefore `managerFormIds` contains all 160 IDs. In the sandbox branch, `managerObjectIds` also contains all Form_Object IDs.

### ✅ Test 3: 18-field subquery in anonymous apex (Michael's org)
**Query:** EXACT managed package subquery, with WITH SECURITY_ENFORCED.
**Result:** 148 (total only, per-parent breakdown NOT captured in initial run)
**Conclusion:** From anonymous apex, the subquery path returns the full expected count.

### ✅ Test 3b: Per-parent flat vs subquery comparison (Michael's org, DEFINITIVE)
Ran both the flat SOQL and the 18-field subquery in one transaction, grouped per parent:

| Form_Object | flat | sub | diff |
|---|---:|---:|---:|
| Account | 2 | 2 | 0 |
| Form_Template | 7 | 7 | 0 |
| Form_Submission | 6 | 6 | 0 |
| Form_Template_Page | 2 | 2 | 0 |
| Form_Template_Page_Section | 3 | 3 | 0 |
| Course_Placement | 4 | 4 | 0 |
| Contact | 9 | 9 | 0 |
| **StudentRecord** | **86** | **86** | **0** |
| PlacementMilestone | 1 | 1 | 0 |
| Application | 1 | 1 | 0 |
| DegreeHistory | 10 | 10 | 0 |
| Recommendation_Application | 10 | 10 | 0 |
| Program | 4 | 4 | 0 |
| Course_Session | 3 | 3 | 0 |
| **TOTAL** | **148** | **148** | **0** |

**Conclusion:** The managed-package subquery is NOT truncating in Michael's org. StudentRecord returns all 86 forms through the subquery. This definitively rules out SOQL-level truncation as the cause of the 123-in-HAR observation.

### ✅ Test 4: Scratch org reproduction (200 forms × 17KB config across 5 parents)
**Query:** Same 18-field subquery
**Result:** 134 / 218 (first 3 parents complete, last 2 parents zero)
**Conclusion:** The subquery **can** truncate when cumulative config__c heap crosses a threshold. Same behavior from anon apex AND @AuraEnabled in scratch. Pattern: **later parents lose ALL children**, not partial truncation.

### ✅ Test 5: formObjectIsAccessible() loop (Michael's org, just run)
**Logic:** For each Form_Object from `queryAllObjectsWithForms`, call `Schema.getGlobalDescribe().get(objectApi).getDescribe().isAccessible()`.

| Form_Object | Object API | Form Count | Accessible |
|---|---|---:|---|
| Account | Account | 2 | true |
| Form_Template | FlowToolKit__Form_Template__c | 7 | true |
| Form_Submission | FlowToolKit__Form_Submission__c | 6 | true |
| Form_Template_Page | FlowToolKit__Form_Template_Page__c | 2 | true |
| Form_Template_Page_Section | FlowToolKit__Form_Template_Page_Section__c | 3 | true |
| Course_Placement | Course_Placement__c | 4 | true |
| Contact | Contact | 9 | true |
| **StudentRecord** | **Application__c** | **86** | **true** |
| PlacementMilestone | Placement_Milestone_New__c | 1 | true |
| Application | TWC_Experience__c | 1 | true |
| DegreeHistory | Degree_History__c | 10 | true |
| Recommendation_Application | Recommendation__c | 10 | true |
| Program | Program__c | 4 | true |
| Course_Session | Course_Session__c | 3 | true |
| **TOTAL** | | **148** | **0 dropped** |

**Conclusion:** formObjectIsAccessible() is NOT filtering. All 14 parents pass. StudentRecord has all 86 forms available in the flat query, and Michael's user can access the Application__c object.

---

## What Is Actually Known vs. Assumed

| Claim | Status |
|---|---|
| 148 is the correct baseline | ✅ PROVEN (flat SOQL) |
| 160 active forms → managerFormIds | ✅ PROVEN |
| formObjectIsAccessible drops nothing | ✅ PROVEN |
| Subquery CAN truncate under heap pressure | ✅ PROVEN (in scratch only; NOT Michael's org) |
| Subquery truncates LATER parents to zero, not partial | ✅ PROVEN (in scratch) |
| **Subquery is NOT truncating in Michael's org** | ✅ **PROVEN (Test 3b)** |
| StudentRecord returns all 86 through both paths | ✅ PROVEN (Test 3b) |
| HAR shows 123 | ⚠️ REPORTED by Michael, NEVER independently verified by us |
| HAR specifically missing from StudentRecord | ⚠️ REPORTED, NEVER verified |

---

### ✅ Test HAR extract: ground truth from the response JSON

Parsed `washingtoncenter--newfullsan.sandbox.lightning.force.com.har`, found the `getFormBuilderWrapper` aura action (r=14, status=SUCCESS, no errors, 324KB response, cacheable=false). Counted forms per parent in the actual response:

| Form_Object | Anon apex (Test 3b) | HAR (@AuraEnabled) | Diff |
|---|---:|---:|---:|
| Account | 2 | 2 | 0 |
| Form_Submission | 6 | 6 | 0 |
| Form_Template | 7 | 7 | 0 |
| Form_Template_Page | 2 | 2 | 0 |
| Form_Template_Page_Section | 3 | 3 | 0 |
| Contact | 9 | 9 | 0 |
| Course_Placement | 4 | 4 | 0 |
| Course_Session | 3 | 3 | 0 |
| DegreeHistory | 10 | 10 | 0 |
| PlacementMilestone | 1 | 1 | 0 |
| Program | 4 | 4 | 0 |
| Recommendation_Application | 10 | 10 | 0 |
| Application (TWC_Experience__c) | 1 | 1 | 0 |
| **StudentRecord (Application__c)** | **86** | **61** | **-25** |
| TOTAL | 148 | 123 | **-25** |

Every other parent matches exactly. **Only StudentRecord is truncated, from 86 down to 61, losing 25.**

## What We've Now Proven

The same 18-field subquery returns:
- **86 StudentRecord children in anonymous apex** (Test 3b)
- **61 StudentRecord children through @AuraEnabled in the managed package**

Same user, same session, same org, same query, different result. No errors, no warnings: silent truncation, specifically of the parent with the largest child set.

This is a real platform behavior that IS reproducible. What we still need to pinpoint: why the managed-package `@AuraEnabled` execution context returns fewer children than the identical anon-apex query.

### ✅ Test 6: EXACT managed-package subquery with both binds (DEFINITIVE)

Ran the EXACT 18-field subquery the managed package runs: `Id IN :managerFormIds` and `Id IN :managerObjectIds` both populated from the same queries the managed package uses (160 form IDs, 17 form-object IDs).

**Result in anonymous apex: total=148, StudentRecord=86**

Compared to HAR via `@AuraEnabled`: total=123, StudentRecord=61.

**Same SOQL. Same user. Same session. Different result.** Anon apex returns all 148; managed-package `@AuraEnabled` returns 123.

### ✅ Test 7: Heap-pressure-during-subquery check

Simulated the full managed-package wrapper heap load in anonymous apex: ran all 12 wrapper queries (users, form metadata map, form_object metadata map, themes, labels, flow definitions, content documents, record types, profiles, roles, custom permissions) BEFORE executing the subquery.

```
Heap before subquery: 137,379 / 6,000,000 bytes
Subquery result:       total=148 StudentRecord=86
Heap after subquery:  141,380 / 6,000,000 bytes
```

**Conclusion:** Heap-during-SOQL is NOT the truncation mechanism. Even with the wrapper's accumulated heap, the subquery returns everything correctly in anon apex. The truncation must be happening downstream: in the `@AuraEnabled` JSON-serialization / Aura-response pipeline specifically, not during Apex SOQL execution.

---

## Final Conclusion

**The SOQL is not the bug.** The managed-package subquery, run in anonymous apex by the same user whose HAR shows 123, returns all 148 forms with StudentRecord intact at 86.

**The bug is in the `@AuraEnabled` execution path.** Between SOQL returning 148 and the Aura action writing the HTTP response, 25 StudentRecord children are dropped. The `formBuilderWrapper` constructor does a lot more than just the subquery; it also loads contentDocuments, themes, labels, flowDefinitions, profiles, roles, recordTypes, customPermissions, formComponentManagers, and all FormBuilderCache settings, and the entire aggregate is then JSON-serialized by the Aura framework for the HTTP response.

The most likely mechanism: **cumulative heap pressure during JSON serialization truncates the heaviest child collection silently.** Apex subquery results on CMT are lazily materialized onto the parent record; when the wrapper gets serialized and total heap is under pressure, the platform can drop the fattest child list to stay under the limit. No error, no warning, just silent truncation of the biggest target. Pattern matches the scratch-org reproduction exactly.

We do not need to isolate the exact heap threshold or platform behavior; the fix is identical either way.

## The Fix

Replace the nested `Forms__r` subquery with a flat query on `Form__mdt`. `scripts/../force-app/main/default/classes/Utilities.cls` already has the uncommitted refactor that does this. The `@AuraEnabled formBuilderWrapper` gains a new `allForms` property populated by a flat SOQL; the LWC reads forms from `allForms` keyed by `Form_Object__c` instead of `objectOptions[i].Forms__r[]`.

Flat-query results don't sit inside a parent record and aren't subject to this truncation. The same bug would silently return incomplete data for any customer with a heavy parent; we just happen to be lucky that Michael's org made it reproducible.

## What Still Needs to Happen

1. Commit the two-query refactor on a feature branch (already written in working tree).
2. Update LWC formBuilder to consume `allForms` instead of `objectOptions[i].Forms__r[]`.
3. Validate the fix in a real subscriber org (see validation project, a separate IntelliJ project at `../FlowToolKit_3222_Validation/`).
4. Release as FlowToolKit 3.222.
5. (Optional) File a Salesforce known-issue about `@AuraEnabled` response silently truncating subquery children.

## Validation Project

A separate Illuminated Cloud project at `../FlowToolKit_3222_Validation/` contains the structured before/after test plan for validating the fix in an alternate subscriber sandbox (where the upgrade can be installed and re-tested). See that project's README and `documents/test-scenarios.md` for the full matrix.

---

## Confirmed Root Cause (post-scratch-repro)

Anon apex run in Michael's sandbox and pfpdev produced:
```
StudentRecord: .size()=72 | JSON records=72 | totalSize=72 | done=true
```
Pure Apex materializes **all** children of a CMT parent. The cap is **not** an Apex SOQL or heap issue. It only fires when the SObject tree is serialized by the Aura `@AuraEnabled` response pipeline.

Reproduced in fresh scratch (no subscriber metadata, tiny config) with 200 Form__mdt clones under Account: the `@AuraEnabled` response clamped `Forms__r` to **exactly 61 records** per parent, every time. Regular parent-child SObject subqueries (Account → 100 Contacts) do **not** exhibit this cap, proven in the same scratch.

**Mechanism:** the Aura framework's per-parent child-envelope writer (`{records, totalSize, done, nextRecordsUrl}`) silently truncates CMT subquery children at 61. Not documented publicly. Web search: no matching bug reports found as of 2026-04.

---

## Audit: Other CMT Subqueries with `@AuraEnabled` Exposure

Bobby's hypothesis "I think this only affects custom metadata queries" is confirmed. Audit of every CMT parent-child subquery in the managed package that can reach an `@AuraEnabled` response.

### Legend
- **EMIT**: subquery records are serialized in the `@AuraEnabled` response → subject to the 61 cap.
- **CONSUME**: subquery is iterated in Apex and flattened into a DTO → **not** subject to the cap.
- **APEX-ONLY**: internal, never reaches `@AuraEnabled` → **not** subject to the cap.

### AT RISK (EMIT)

| # | Location | Parent → child | Exposure | Severity | Note |
|---|----------|---------------|----------|----------|------|
| 1 | `Utilities.queryAllObjectsWithForms` (line 932) | Form_Object__mdt → `Forms__r` | **FIXED** in this branch (`getObjectOptionsWithForms` / `NoCache`) | - | Subquery removed; LWC stitches client-side |
| 2 | `Utilities.queryAllForms` (line 904) | Form__mdt → `conditionalLogic__r` | `getFormOptions` (@AuraEnabled, Cacheable) → `formBuilder`, `formBuilderSectionField`, `flowFormSelector` LWCs | **MEDIUM** | One form with >61 logic rules → silent drop |
| 3 | `Utilities_Form.queryFormSections` (line 75) | Form_Section__mdt → `fields__r` (LIMIT 125) | `FormWrapper` via `Form_Controller.getForm / getTable / getFormBuilderForm / getFormBuilderFormNoCache` | **MEDIUM-HIGH** | One section with >61 fields → silent drop; LIMIT 125 masks the Apex cap but not the Aura cap |
| 4 | `Utilities_Form.queryFormLogic` (line 135) | Form_Conditional_Logic__mdt → `conditions__r` | `FormWrapper` via `Form_Controller.getForm / getTable / ...` | **LOW** | One logic rule with >61 conditions → silent drop (unlikely) |
| 5 | `Utilities.queryAllLabelsWithTranslations` / `Utilities_Form.queryAllLabelsWithTranslations` | Form_Label__mdt → `Form_Label_Translations__r` | `FormTemplate_Controller.getCachedLabels` (@AuraEnabled), also embedded in `FormWrapper.labels` | **LOW** | Supported languages bounded ~30-40, but possible with many locales |

### NOT AT RISK (CONSUME or APEX-ONLY)

| Location | Parent → child | Why safe |
|----------|---------------|----------|
| `FormTemplate_Utility.getBaseRecordTemplate` (line 169) | Form__mdt → `fields__r`/`conditions__r` | Iterated in Apex, emitted as flat `Map<String,Object>` (CONSUME) |
| `FormTemplate_Utility.buildPageFieldMap` (line 280) | Form__mdt → `fields__r`/`conditions__r` | Iterated in Apex, emitted as flat `Map<Id,List<String>>` (CONSUME) |
| `Utilities_Form.queryFormComponentValuesMap` (line 177) | Form_Component__c → `Form_Component_*__r` | Regular SObject parent; no 61 cap (regular-SObject subqueries confirmed unaffected) |
| `FormComponentVersion_Utility.getNewFormComponent` | Form_Component__c → `Form_Component_*__r` | Regular SObject; no 61 cap |
| `FormTemplate_Utility.getFormTemplatePages` (line 89) | Form_Template_Page__c → `Form_Template_Page_Section__c` | Regular SObject; no 61 cap |
| `FormTemplate_Utility.getFormSubmission` (line 140) | Form_Submission__c → `Form_Submissions__r` | Regular SObject; no 61 cap |

### Recommended Follow-Up (out of scope for 3.222)

The four remaining **AT RISK** sites (#2-#5) are all **per-form** queries, so exposure is smaller than the original Form Builder bug (which queried every form in the org). They would only truncate when a single form has >61 logic rules, >61 fields in a section, >61 conditions in a rule, or >61 translations on a label. For 3.222 we ship the Form Builder fix only. A follow-up issue should:

1. Apply the same two-step "flat-query + client-side stitch" pattern to `getFormOptions` (Form__mdt → `conditionalLogic__r`).
2. Refactor `queryFormSections` / `queryFormLogic` so the child records are emitted as sibling arrays on `FormWrapper` instead of nested subquery envelopes. The LWC stitching pattern already exists in `formBuilder.js` and can be reused.
3. Add guards or flat-query fallbacks to `getCachedLabels`.

Until then, in-practice exposure is minimal (field/logic counts per form rarely cross 61), but the bug-class is real and the same failure-mode can recur.
