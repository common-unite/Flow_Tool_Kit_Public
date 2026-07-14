# Flow Tool Kit v3.230 Release Notes

## New Features

### Prefill Flow on Form Template

Form Templates now support an optional **Prefill Flow**: an autolaunched Flow that runs once on initial load of a fresh Form Submission, with full programmatic control over prefill values, related-record seeding, and form-load gating. Drop `formTemplate` directly on an Experience Cloud or Lightning page; no more wrapping the LWC in a Screen Flow just to run a Get Records.

**What you can do.**

- Look up records based on the running user (`$User.ContactId`, related Account, etc.) and prefill the form with their data.
- Seed repeater or table sections with related records, without hard-coding section Ids that break across template copies and org migrations.
- Stop the form from loading when your Flow detects a condition the user shouldn't bypass (duplicate submission, license check, eligibility window).
- Customize by cloning the shipped starter Flow into your namespace.

**Configuring.** Open a Form Template record. In the **Default Form Values** section, set the new **Prefill Flow** picklist. The base package ships `Bypass` (default; no flow runs) and `(Form) Prefill | Template` (the starter). Add your own cloned flows as picklist values via Setup.

![Prefill Flow picklist on the Form Template edit modal](https://raw.githubusercontent.com/common-unite/Flow_Tool_Kit_Public/main/documents/screenshots/123-prefill-flow-demo.gif)

**The Flow contract.** Five variables, only one required:

| Variable | Direction | Required | Purpose |
| --- | --- | --- | --- |
| `record` | Input | Yes | Form Submission after defaults + URL-param prefill |
| `prefillRecord` | Output | Optional | Fields here overwrite the local Form Submission |
| `prefillRelatedRecords` | Output | Optional | Collection of related Form Submissions for repeater/table sections |
| `hasError` | Output | Optional | When `true`, stops form load and shows the error illustration |
| `errorMessage` | Output | Optional | Rich-text subtitle for the error illustration (HTML + Flow merge fields) |

**Section Tag routing for related records.** A new **Section Tag** picklist on `Form_Template_Page_Section__c` (sharing the existing `Data_Conversion_Tag_s` global value set) lets your Flow target a section by stable tag value instead of the brittle runtime section Id. Set `Internal_SectionId__c = "Contacts"` on a `prefillRelatedRecords` entry and the form routes it to the section tagged `Contacts`. Migration-safe. A trigger enforces tag uniqueness per Form Template.

**Starter Flow.** `(Form) Prefill | Template` ships as a Template flow (clonable via Setup) demonstrating the full pattern: Contact + Account lookups, surgical Transform mapping, related-record seeding with the section tag, and an `Already_Submitted` guard that blocks a Contact who already submitted from filling the form out again.

![The shipped starter prefill flow in Flow Builder](https://raw.githubusercontent.com/common-unite/Flow_Tool_Kit_Public/main/documents/screenshots/123-prefill-flow-builder-canvas.png)

**Documentation.** See [Prefill Flow](../form-template-framework/prefill-flow.md) for the full admin guide, troubleshooting catalog, and security guidance.

### Guest-User Save Override (Overridable Flow)

A new overridable autolaunched Flow, `Form_Submission_Upsert`, defines the DML interface for guest-user Form Submission saves. The `formTemplate` LWC routes guest-context saves through this Flow whenever the running user is a guest, the save path triggers DML, and the LWC is not inside a parent Flow Screen. The Flow handles both INSERT and UPDATE in a single Upsert element.

**Important: safe by install, opt-in to elevate.** FlowToolKit is a managed package and cannot ship any Flow or Apex that elevates sharing. This Flow runs in **user mode by default**, where guest users still cannot UPDATE non-owned Form Submissions. If your guest community needs the bypass (e.g., guests updating their own draft submissions across sessions), clone the Flow into your own namespace, set the clone's Run In Mode to `System Mode Without Sharing` (or a tighter scope), and wire your override in. You own the security review of any sharing elevation you introduce.

See the [Guest users and the upsert override](../form-template-framework/prefill-flow.md#guest-users-and-the-upsert-override) section of the Prefill Flow guide.

## Other Changes

### Section Tag field and global value set additions

A new **Section Tag** picklist on `Form_Template_Page_Section__c` provides stable, migration-safe identifiers for repeater and table sections. The field uses the existing `Data_Conversion_Tag_s` global value set, which gains four new values shipped with this release: `Contacts`, `Tasks`, `Cases`, `Opportunities` (alongside the existing `Default`). Add more values via Setup as your data model demands.

A trigger on `Form_Template_Page_Section__c` enforces uniqueness: the same Section Tag value cannot be used twice within a single Form Template. The trigger fires on both insert and update, against both within-batch duplicates and the existing DB state.

### Loading overlay on prefill

When a Prefill Flow is configured on a Form Template, the form renders immediately with defaults + URL-param values, then a small `lightning-spinner` overlay appears on top while the Flow runs. The overlay has a ~150ms delay before first paint so fast Flows don't flash an unnecessary spinner. The form is visually disabled but the underlying DOM is present; perceived performance stays high compared to a blank screen with a spinner.

### Permission sets

Two new Flow Accesses added to `Form_Builder_Admin`, `Form_Builder_Manager`, and `Form_Flow_User`: `Form_Submission_Prefill` (the starter) and `Form_Submission_Upsert` (the override interface). Two new field permissions added to all three sets: `Form_Template__c.Prefill_Flow_Api_Name__c` and `Form_Template_Page_Section__c.Section_Tag__c`.

## Affected Components

- `formTemplate` LWC: adds the prefill flow invocation pipeline, hidden `<lightning-flow>` runtime, loading overlay, error illustration, `Internal_SectionId__c` normalization (Id or tag → Id), guest upsert routing through the override Flow.
- `FormTemplatePageSections_Utility.handleBeforeInsertUpdate`: adds `enforceSectionTagUniqueness` for the new Section Tag uniqueness rule.
- `Form_Submission_Prefill.flow-meta.xml`: new starter prefill Flow.
- `Form_Submission_Upsert.flow-meta.xml`: new overridable upsert interface.
- `Form_Template__c.Prefill_Flow_Api_Name__c`: new picklist field.
- `Form_Template_Page_Section__c.Section_Tag__c`: new picklist field.
- `Data_Conversion_Tag_s.globalValueSet-meta.xml`: adds `Contacts`, `Tasks`, `Cases`, `Opportunities`.
- Permission sets: `Form_Builder_Admin`, `Form_Builder_Manager`, `Form_Flow_User`.
- Page layouts: `Form Template Layout`, `Form Template Page Section Layout`, `Form_Template_Record_Page` flexipage.

## Tracking

- GitHub issue: [#123](https://github.com/common-unite/cUnite_FormBuilder/issues/123)
- Spec: [`_specs/form-template-prefill-flow.md`](https://github.com/common-unite/cUnite_FormBuilder/blob/master/_specs/form-template-prefill-flow.md)
