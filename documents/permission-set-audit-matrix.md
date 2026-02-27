# Permission Set Audit Matrix — Flow Tool Kit (FlowToolKit)

**Generated:** 2026-02-14 (current state of `master` branch)

## Permission Sets

| Permission Set | Alias | Role |
|---|---|---|
| `Form_Builder_Admin` | Admin | Full access: all classes, fields, objects, tabs, apps |
| `Form_Builder_Manager` | Manager | Build/manage forms: most classes, fields, objects, tabs |
| `Form_Flow_User` | User | End-user runtime: minimum needed to fill out forms |

---

## 1. Apex Classes (69 non-test on disk)

**Coverage:** Admin: 57 | Manager: 47 | User: 36

| Apex Class | Admin | Manager | User | Notes |
|---|:---:|:---:|:---:|---|
| AllFormsIterable | Y | Y | - | |
| Button | Y | Y | Y | |
| CacheFlowController | Y | - | - | Admin-only cache management |
| CacheFlow_Batch | - | - | - | **MISSING** — Batch (system ctx) |
| CacheFlowsIterable | - | - | - | **MISSING** — Iterator (system ctx) |
| Collection_Subset_Invocable | Y | Y | Y | |
| CsvReader | Y | Y | - | |
| DataSanitizer_Invocable | Y | Y | Y | |
| DatetimeEpochConvert_Invocable | Y | Y | Y | |
| Dynamic_PDF_Controller | Y | Y | Y | |
| EmailTemplate_Controller | Y | Y | Y | |
| EpochDatetimeConvert_Invocable | Y | Y | Y | |
| FieldSetController | Y | Y | Y | |
| File | Y | Y | Y | |
| FileUpload | Y | Y | Y | |
| FlowCustomException_Invocable | Y | Y | Y | |
| FlowInvoker_Queueable | - | - | - | **MISSING** — Queueable (system ctx) |
| FlowsIterator | - | - | - | **MISSING** — Iterator (system ctx) |
| Flow_ContentDocumentToZip_Invocable | Y | Y | Y | |
| Flow_ConvertLead_Invocable | Y | Y | Y | |
| Flow_DuplicateCheck_Invocable | Y | Y | Y | |
| Flow_DuplicateCheck_Utility | Y | Y | - | |
| Flow_FileUpload_Deserialize_Invocable | Y | Y | Y | |
| Flow_FileUpload_Serialize_Invocable | Y | Y | Y | |
| Flow_GetSObjectType_Invocable | Y | Y | Y | New — PR #61 |
| Flow_MergeRecords_Invocable | Y | Y | Y | |
| Flow_RecordTypes_Invocable | Y | Y | Y | |
| Flow_Remove_Nulls_Invocable | Y | Y | Y | |
| Flow_StripNullValues_Invocable | Y | Y | Y | |
| Flow_UpsertBypassDuplicates_Invocable | Y | Y | Y | |
| FormCacheResetIterable_Batch | Y | Y | - | |
| FormCacheReset_Batch | - | - | - | **MISSING** — Batch (system ctx) |
| FormComponentSelector | Y | Y | - | |
| FormComponentTemplates | - | - | - | **MISSING** — Internal CMT installer |
| FormComponentVersion_Utility | Y | Y | - | |
| FormConfiguration | Y | Y | Y | |
| FormObjectSelector | - | - | - | **MISSING** — DynamicPickList (platform-invoked) |
| FormRepeaterConfiguration | Y | Y | Y | |
| FormSubmission_Data_Invocable | Y | Y | Y | |
| FormSubmission_LogEvent_Invocable | Y | Y | - | |
| FormSubmission_LogEvent_Utilities | - | - | - | **MISSING** — Internal utility |
| FormSubmissions_Utility | Y | - | - | Admin-only |
| FormTemplateClone_Controller | Y | Y | - | |
| FormTemplatePageSections_Utility | Y | - | - | Admin-only |
| FormTemplatePage_Utility | Y | - | - | Admin-only |
| FormTemplate_Controller | Y | Y | Y | |
| FormTemplate_PDF_Controller | Y | Y | Y | |
| FormTemplate_Utility | Y | - | - | Admin-only |
| Form_Controller | Y | Y | Y | |
| Form_Flow_Utility | Y | Y | - | |
| Form_Utility | - | - | - | **MISSING** — global wrapper types |
| FormsIterator | Y | Y | - | |
| FutureDML_Invocable | Y | Y | Y | |
| Generate_PDF_Invocable | Y | Y | Y | |
| InstallScript | Y | - | - | Admin-only post-install handler |
| JSON_Deserialize_Invocable | Y | Y | Y | |
| JSON_Serialize_Invocable | Y | Y | Y | |
| LoggedEmailMessage_Utility | Y | - | Y | Admin + User (not Manager) |
| MetaDataUtils | Y | Y | - | |
| ObjectJSONFieldSelector | - | - | - | **MISSING** — DynamicPickList (platform-invoked) |
| ObjectTextFieldSelector | - | - | - | **MISSING** — DynamicPickList (platform-invoked) |
| Recalculate_Positions_Invocable | Y | Y | Y | |
| SiteUrlRewriter | Y | - | - | Admin-only URL rewriter |
| Template_Invocable | Y | Y | Y | |
| Utilities | Y | Y | - | |
| Utilities_Form | Y | - | - | Admin-only (core engine) |
| flowForm_Controller | - | - | - | **MISSING** — global AuraEnabled |
| reCAPTCHA | Y | Y | Y | |
| reCAPTCHA_Mock | - | - | - | **MISSING** — Test mock (expected) |

### Classes Missing from ALL PSes (12)

**Likely intentional** (system context / platform-invoked / test):

| Class | Reason |
|---|---|
| `CacheFlow_Batch` | Batch class, runs in system context |
| `CacheFlowsIterable` | Iterator helper for batch |
| `FlowInvoker_Queueable` | Queueable, runs in system context |
| `FlowsIterator` | Iterator helper |
| `FormCacheReset_Batch` | Batch class, runs in system context |
| `FormComponentTemplates` | Internal CMT installer, called by InstallScript |
| `FormObjectSelector` | `VisualEditor.DynamicPickList`, platform-invoked at design time |
| `ObjectJSONFieldSelector` | `VisualEditor.DynamicPickList`, platform-invoked at design time |
| `ObjectTextFieldSelector` | `VisualEditor.DynamicPickList`, platform-invoked at design time |
| `FormSubmission_LogEvent_Utilities` | Internal utility, called by other package code |
| `reCAPTCHA_Mock` | Test mock class |

**Needs review:**

| Class | Reason |
|---|---|
| `flowForm_Controller` | `global` AuraEnabled controller with `getForm()`, `getTable()`. All methods return null (stub class). If subscribers call this, they need PS access. |
| `Form_Utility` | `global` class with inner types (`FormComponentManagerOption`, `formWrapper`, etc.) used by other AuraEnabled controllers. Inner types may need PS access for serialization. |

---

## 2. Custom Object Fields

### Fields Missing from ALL PSes (35 on `__c` objects)

#### Form_Component_Condition__c (7 missing)

| Field | Type | Assessment |
|---|---|---|
| `Form_Component_Conditional_Logic__c` | Master-Detail | Auto-readable via object perms |
| `Form_Component__c` | Lookup | Auto-readable via object perms |
| `QualifiedApiName__c` | Text | Internal tracking |
| `VersionId__c` | Text | Internal tracking |
| `fieldName__c` | Text | **NEEDS REVIEW** — runtime reads this |
| `operation__c` | Picklist | **NEEDS REVIEW** — runtime reads this |
| `position__c` | Number | **NEEDS REVIEW** — runtime reads this |

#### Form_Component_Conditional_Logic__c (5 missing)

| Field | Type | Assessment |
|---|---|---|
| `Form_Component__c` | Master-Detail | Auto-readable via object perms |
| `QualifiedApiName__c` | Text | Internal tracking |
| `VersionId__c` | Text | Internal tracking |
| `conditionType__c` | Picklist | **NEEDS REVIEW** — runtime reads this |
| `displayType__c` | Picklist | **NEEDS REVIEW** — runtime reads this |

#### Form_Component_Field__c (5 missing)

| Field | Type | Assessment |
|---|---|---|
| `Form_Component_Section__c` | Master-Detail | Auto-readable via object perms |
| `Form_Component__c` | Lookup | Auto-readable via object perms |
| `QualifiedApiName__c` | Text | Internal tracking |
| `VersionId__c` | Text | Internal tracking |
| `fieldName__c` | Text | **NEEDS REVIEW** — runtime reads this |

#### Form_Component_Section__c (4 missing)

| Field | Type | Assessment |
|---|---|---|
| `Form_Component__c` | Master-Detail | Auto-readable via object perms |
| `QualifiedApiName__c` | Text | Internal tracking |
| `VersionId__c` | Text | Internal tracking |
| `position__c` | Number | **NEEDS REVIEW** — runtime reads this |
| `sectionType__c` | Picklist | **NEEDS REVIEW** — runtime reads this |

#### Form_Component__c (5 missing)

| Field | Type | Assessment |
|---|---|---|
| `QualifiedApiName__c` | Text | Internal tracking |
| `SystemModstamp__c` | DateTime | Standard system field |
| `VersionId__c` | Text | Internal tracking |
| `Version__c` | Number | Internal tracking |
| `type__c` | Picklist | **NEEDS REVIEW** — runtime reads this |

#### Form_Submission_Conversion_Log__c (1 missing)

| Field | Type | Assessment |
|---|---|---|
| `Form_Submission__c` | Master-Detail | Auto-readable via object perms |

#### Form_Template_Page_Section__c (2 missing)

| Field | Type | Assessment |
|---|---|---|
| `Component_Type__c` | Picklist | **NEEDS REVIEW** |
| `Form_Template_Page__c` | Master-Detail | Auto-readable via object perms |

#### Form_Template_Page__c (4 missing)

| Field | Type | Assessment |
|---|---|---|
| `Form_Template__c` | Master-Detail | Auto-readable via object perms |
| `Page_Label__c` | Text | **NEEDS REVIEW** — runtime reads this |
| `Position__c` | Number | **NEEDS REVIEW** — runtime reads this |
| `Visibility__c` | Picklist | **NEEDS REVIEW** — runtime reads this |

#### Form_Template__c (1 missing)

| Field | Type | Assessment |
|---|---|---|
| `Conversion_Type__c` | Picklist | **NEEDS REVIEW** |

### Standard Object Fields Missing

| Field | Admin | Manager | User | Notes |
|---|:---:|:---:|:---:|---|
| `ContentVersion.GuestUploadToken__c` | - | - | - | **MISSING** — used for guest file uploads |

### "Needs Review" Fields Summary (17)

> These are functional fields the runtime likely queries. If Apex uses `WITH SECURITY_ENFORCED` or `AccessLevel.USER_MODE`, missing field permissions will cause query failures for users with only the `Form_Flow_User` PS.

| Object | Fields |
|---|---|
| `Form_Component_Condition__c` | `fieldName__c`, `operation__c`, `position__c` |
| `Form_Component_Conditional_Logic__c` | `conditionType__c`, `displayType__c` |
| `Form_Component_Field__c` | `fieldName__c` |
| `Form_Component_Section__c` | `position__c`, `sectionType__c` |
| `Form_Component__c` | `type__c` |
| `Form_Template_Page_Section__c` | `Component_Type__c` |
| `Form_Template_Page__c` | `Page_Label__c`, `Position__c`, `Visibility__c` |
| `Form_Template__c` | `Conversion_Type__c` |
| `ContentVersion` | `GuestUploadToken__c` |

---

## 3. Visualforce Pages (10 on disk)

| Page | Admin | Manager | User | Notes |
|---|:---:|:---:|:---:|---|
| CacheFlow | Y | Y | - | |
| FormSubmissionPrint | Y | Y | Y | |
| FormSubmissionSimplePrint | Y | Y | Y | |
| FormTemplateClone | Y | Y | Y | |
| FormTemplateExport | Y | Y | - | |
| FormTemplateImport | Y | Y | - | |
| FormTemplatePageClone | Y | Y | Y | |
| FormTemplatePrint | Y | Y | Y | |
| FormTemplateSimplePrint | Y | Y | Y | |
| Support | - | - | - | **MISSING** |

---

## 4. Objects, Tabs, Flows, CMTs, Custom Permissions, Record Types

| Category | Status |
|---|---|
| **Objects** | All 11 custom objects covered (`Form_Component_Utility__c` in all 3) |
| **Tabs** | All 5 tabs covered (Admin/Manager only — User has none, by design) |
| **CMTs** | 13 in PSes, all covered |
| **Custom Permissions** | 3 total (Admin: 2, Manager: 1, User: 0) |
| **Record Types** | 4 total, all covered |
| **Flows** | 35 on disk, 2 in PSes (`Form_Template`, `Utility_Flow_Log_EmailMessage`). 33 missing are auto-launched/record-triggered (system context) — intentional. |

---

## 5. Action Items Summary

### Critical (blocks user functionality)

None identified — `hideHeaders__c` was fixed in this session.

### Needs Review (may affect subscribers)

| Type | Item | Count |
|---|---|---|
| Fields | Functional fields missing from all PSes | 17 |
| Apex | `flowForm_Controller`, `Form_Utility` | 2 |
| VF Page | `Support` | 1 |
| Std Field | `ContentVersion.GuestUploadToken__c` | 1 |

### Likely Intentional (no action needed)

| Type | Item | Count |
|---|---|---|
| Apex | Batch/Queueable/Iterator/DynamicPickList/mock classes | 10 |
| Fields | Master-Detail/Lookup fields (auto-readable via object permissions) | ~14 |
| Fields | `QualifiedApiName__c`/`VersionId__c` (internal tracking) | ~8 |
| Fields | `SystemModstamp__c` (standard system field) | 1 |
| Flows | Auto-launched/record-triggered flows | 33 |
