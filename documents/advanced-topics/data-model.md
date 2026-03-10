# Data Model

> The Salesforce objects and fields that admins interact with when using Flow Tool Kit.

## Overview

Flow Tool Kit stores form configuration in **Custom Metadata Types** (CMDTs) and manages runtime data in **Custom Objects**. Understanding the data model helps you troubleshoot, deploy, and build advanced integrations.

## Custom Metadata Types (Configuration)

These store your form definitions. CMDTs don't count against data storage and deploy between orgs as metadata.

### Form Structure

```
Form__mdt
├── Form_Section__mdt (1 → many)
│   └── Form_Field__mdt (1 → many)
├── Form_Conditional_Logic__mdt (1 → many)
│   └── Form_Conditional_Logic_Condition__mdt (1 → many)
└── Form_Style_Sheet__mdt (1 → 1, optional)
```

| CMDT | Purpose | Key Fields |
|------|---------|-----------|
| **Form__mdt** | Form definition — name, object, settings | Object, FormType, Active |
| **Form_Section__mdt** | Section within a form — layout and grouping | Form (lookup), Position, Columns |
| **Form_Field__mdt** | Field within a section — configuration and display | Section (lookup), FieldName, Position, Required, ReadOnly |
| **Form_Conditional_Logic__mdt** | Visibility rule — when to show/hide a target | Form (lookup), LogicType (AND/OR), Target |
| **Form_Conditional_Logic_Condition__mdt** | Individual condition within a logic rule | Logic (lookup), FieldName, Operator, Value |
| **Form_Style_Sheet__mdt** | Theme — visual styling | Colors, fonts, spacing |
| **Form_Labels__mdt** | Label overrides and translations | Field, Language, LabelText |

### Additional Configuration CMDTs

| CMDT | Purpose |
|------|---------|
| **Form_Component__mdt** | Component type definitions |
| **Form_Validation__mdt** | Validation rules for form fields |
| **Form_Configuration__mdt** | Global configuration settings |

## Custom Objects (Runtime Data)

These store runtime data — templates, submissions, and conversion logs.

### Form Template Framework

```
Form_Template__c
├── Form_Template_Page__c (1 → many)
│   └── Form_Template_Page_Section__c (1 → many)
└── Form_Submission__c (1 → many)
    └── Form_Submission_Conversion_Log__c (1 → many)
```

| Object | Purpose | Key Fields |
|--------|---------|-----------|
| **Form_Template__c** | Multi-page form template definition | Name, Active, SaveAndResume |
| **Form_Template_Page__c** | Page within a template | Template (lookup), Position, Label |
| **Form_Template_Page_Section__c** | Section within a page (links to a Form) | Page (lookup), Form (lookup), Position |
| **Form_Submission__c** | User's submission data | Template (lookup), Status, SubmittedDate, Data (JSON) |
| **Form_Submission_Conversion_Log__c** | Record of conversion results | Submission (lookup), TargetObject, RecordId, Status |

### Supporting Objects

| Object | Purpose |
|--------|---------|
| **Form_Component__c** | Component instance records |
| **Form_Component_Field__c** | Field configurations within components |
| **Form_Component_Section__c** | Section configurations within components |
| **Form_Component_Condition__c** | Conditional logic conditions |
| **Form_Component_Conditional_Logic__c** | Conditional logic rules |
| **Form_Component_Utility__c** | Utility configurations |

## Object Relationships Diagram

```
┌─────────────────────────────────────────────────────┐
│ DESIGN TIME (Custom Metadata Types)                 │
│                                                     │
│ Form__mdt ──→ Section__mdt ──→ Field__mdt          │
│     │                                               │
│     ├──→ Conditional_Logic__mdt ──→ Condition__mdt │
│     └──→ Style_Sheet__mdt                          │
└─────────────────────────────────────────────────────┘
          │ referenced by
          ▼
┌─────────────────────────────────────────────────────┐
│ RUNTIME (Custom Objects)                            │
│                                                     │
│ Template__c ──→ Page__c ──→ Page_Section__c        │
│     │                            │                  │
│     │                            └── refs Form__mdt│
│     ▼                                               │
│ Submission__c ──→ Conversion_Log__c                │
└─────────────────────────────────────────────────────┘
```

## Permission Access

| Object | Admin | Manager | Flow User |
|--------|:-----:|:-------:|:---------:|
| Form__mdt (CMDT) | Read | Read | Read |
| Form_Template__c | CRUD | CRUD | Read |
| Form_Submission__c | CRUD | CRUD | Create/Read |
| Form_Submission_Conversion_Log__c | CRUD | CRUD | — |
| Form_Component__c | CRUD | CRUD | Read |

See [Permission Sets](../getting-started/permission-sets.md) for full details.

## Related Pages

- [Custom Metadata Types Reference](../form-configuration/custom-metadata-types.md) — CMDT details
- [Core Concepts](../getting-started/core-concepts.md) — how building blocks fit together
- [Deployment Overview](../deployment/deployment-overview.md) — deploying metadata between orgs
