# Custom Metadata Types
> The metadata foundation of Flow Tool Kit — Forms, Sections, Fields, Conditional Logic, Themes, Labels, and more are all defined as Custom Metadata Type records.

## Overview

Flow Tool Kit is metadata-driven. Every form, section, field, theme, label, and conditional logic rule is stored as a Custom Metadata Type (CMT) record. This means your form definitions deploy with your metadata — through change sets, packages, and CI/CD pipelines — and are available across environments without data migration.

You rarely need to create CMT records manually. The Form Builder UI handles creation and management. But understanding the metadata structure helps you troubleshoot, build advanced configurations, and work with the system at a deeper level.

## Metadata Hierarchy

```
Form_Object__mdt          (which objects are available for form building)
    └── Form__mdt         (a form definition — tied to one object)
        ├── Form_Section__mdt         (sections within the form)
        │   └── Form_Field__mdt       (fields within each section)
        ├── Form_Conditional_Logic__mdt           (visibility rules)
        │   └── Form_Conditional_Logic_Condition__mdt  (individual conditions)
        └── Form_Theme__mdt           (visual styling)

Form_Label__mdt           (reusable translatable text)
    └── Form_Label_Translation__mdt   (language-specific translations)

Form_Style_Sheet__mdt     (custom CSS overrides via static resources)
FormBuilderCache__mdt     (internal cache for Form Builder performance)
```

## Custom Metadata Types

### Form_Object__mdt — Allowed Objects
Controls which objects are available in the Form Builder object selector.

| Field | Type | Required | Description |
|---|---|---|---|
| `Object__c` | EntityDefinition | Yes | Reference to the SObject (unique per object) |
| `IsActive__c` | Checkbox | No | Default: true. Deactivate to hide from Form Builder without deleting |

**Admin Use**: Add a `Form_Object__mdt` record for each object you want admins to build forms for. Without a record here, the object won't appear in Form Builder's object picklist.

### Form__mdt — Form Definition
The top-level form record. Each form is tied to a single object.

| Field | Type | Required | Description |
|---|---|---|---|
| `Form_Object__c` | Form_Object__mdt | Yes | The object this form is for |
| `type__c` | Picklist | Yes | Form type: `form`, `table`, `default` (Tabset), `scoped` (Tabset), `vertical` (Tabset), `carousel`. Default: `form` |
| `Theme__c` | Form_Theme__mdt | No | Theme for visual styling |
| `Active__c` | Checkbox | No | Default: true. Inactive forms are hidden from selectors |
| `Description__c` | Text (255) | No | Admin description |
| `CategoryTag__c` | Picklist | No | Organizational tag: Component(s), Form(s), Template(s) |
| `Form_Managers__c` | LongTextArea | No | User Ids (semicolon-separated) who can manage this form |
| `config__c` | LongTextArea (131072) | No | Internal JSON configuration |
| `prefill__c` | LongTextArea (131072) | No | Test prefill data for Form Builder preview |
| `Delete__c` | Checkbox | No | Soft delete marker |
| `DemoRecord__c` | Checkbox | No | Marks demo/sample records |

### Form_Section__mdt — Form Section
Defines a section within a form. Sections group fields and control layout.

| Field | Type | Required | Description |
|---|---|---|---|
| `Form__c` | Form__mdt | Yes | Parent form |
| `position__c` | Number | Yes | Display order (default: 1) |
| `Theme__c` | Form_Theme__mdt | No | Section-level theme override |
| `conditionalLogic__c` | Form_Conditional_Logic__mdt | No | Conditional visibility rule |
| `Default_Table_Form__c` | Form__mdt | No | Default table form for this section |
| `Default_Table_Form_bulk__c` | Form__mdt | No | Bulk edit form for tables in this section |
| `formComponent__c` | Form__mdt | No | Component assignment reference |
| `contentAssetName__c` | Text (55) | No | Content asset reference |
| `config__c` | LongTextArea (131072) | No | Internal JSON configuration |
| `Delete__c` | Checkbox | No | Soft delete marker |
| `PreventDelete__c` | Checkbox | No | Prevent deletion in Form Builder |

### Form_Field__mdt — Form Field
Defines an individual field within a section.

| Field | Type | Required | Description |
|---|---|---|---|
| `Form__c` | Form__mdt | Yes | Parent form |
| `Form_Section__c` | Form_Section__mdt | Yes | Parent section |
| `Object__c` | EntityDefinition | Yes | Object this field belongs to |
| `fieldName__c` | EntityParticle | Yes | The field API name reference |
| `position__c` | Number | Yes | Display order within the section (default: 1) |
| `required__c` | Checkbox | No | Override field as required (default: false) |
| `readOnly__c` | Checkbox | No | Override field as read-only (default: false) |
| `conditionalLogic__c` | Form_Conditional_Logic__mdt | No | Field-level conditional visibility |
| `Alternative_Object__c` | EntityDefinition | No | Alternative object for cross-object references |
| `Alternative_Field__c` | FieldDefinition | No | Alternative field from the alternative object |
| `referenceFormComponent__c` | Form__mdt | No | Override form for related lookup display |
| `config__c` | LongTextArea (131072) | No | Internal JSON — stores label overrides, help text, default values, column widths, calculations, and more |
| `minDateFieldName__c` | EntityParticle | No | Dynamic min date from another field |
| `maxDateFieldName__c` | EntityParticle | No | Dynamic max date from another field |
| `columnClassFieldReference__c` | EntityParticle | No | Field reference for dynamic CSS classes on table columns |
| `columnIconNameFieldReference__c` | EntityParticle | No | Field reference for dynamic column icons |
| `columnUrlLabelOverrideFieldReference__c` | EntityParticle | No | Field reference for dynamic URL label overrides |
| `addressFieldType__c` | Picklist | No | Address sub-field type: Address, Street, City, State, PostalCode, Country |
| `Delete__c` | Checkbox | No | Soft delete marker |

### Form_Conditional_Logic__mdt — Conditional Logic Rules
Defines visibility rules for sections and fields. See the [Conditional Logic](../form-configuration/conditional-logic.md) documentation for details.

| Field | Type | Required | Description |
|---|---|---|---|
| `Form__c` | Form__mdt | No | Associated form |
| `config__c` | LongTextArea (131072) | No | JSON configuration for the logic rule |
| `Delete__c` | Checkbox | No | Soft delete marker |

### Form_Conditional_Logic_Condition__mdt — Individual Conditions
Each condition within a conditional logic rule.

| Field | Type | Required | Description |
|---|---|---|---|
| `conditionalLogic__c` | Form_Conditional_Logic__mdt | Yes | Parent logic rule |
| `Object__c` | EntityDefinition | Yes | Object for field reference |
| `fieldName__c` | EntityParticle | Yes | Field to evaluate |
| `value__c` | Text (255) | No | Value to compare against |
| `position__c` | Number | Yes | Evaluation order (default: 1) |
| `UserValidation__c` | Picklist | No | User-based condition type: DeviceSize, LanguageLocaleKey, IsGuest, Profile, Role, IsNew, CustomPermission |
| `Form__c` | Form__mdt | No | Associated form |
| `config__c` | LongTextArea (131072) | No | JSON configuration |
| `Delete__c` | Checkbox | No | Soft delete marker |

### Form_Theme__mdt — Theme Styling
See the [Themes, Labels & Styling](../form-configuration/themes-labels-styling.md) documentation for full details.

### Form_Label__mdt — Reusable Labels
See the [Themes, Labels & Styling](../form-configuration/themes-labels-styling.md) documentation.

### Form_Label_Translation__mdt — Label Translations
See the [Themes, Labels & Styling](../form-configuration/themes-labels-styling.md) documentation.

### Form_Style_Sheet__mdt — Custom CSS Overrides
References a Static Resource CSS file to override default form styles.

| Field | Type | Description |
|---|---|---|
| `StaticResourceName__c` | Text (255) | API name of the Static Resource |
| `Path__c` | Text (255) | Path within a zip file (e.g., "StaticResourceName/folder/file.css") or just the resource name |
| `NamespacePrefix__c` | Text (255) | Namespace of the static resource (if packaged) |

### Form_Object__mdt — Object Registry
Defines which objects are available for building forms.

### FormBuilderCache__mdt — Builder Cache
Internal cache records for Form Builder performance. Contains `Form__c` and `Table__c` text fields that store cached references.

### Form_Sites_Url_Rewriter_Mappings__mdt — URL Rewriting
Configuration for Salesforce Sites URL rewriting. Maps friendly URLs to Salesforce URLs.

| Field | Type | Required | Description |
|---|---|---|---|
| `Friendly_URL__c` | Text (255) | Yes | The user-friendly URL path |
| `Salesforce_URL__c` | Text (255) | Yes | The actual Salesforce URL path |

## Subscriber-Controlled vs Developer-Controlled

Most fields are **Subscriber-Controlled**, meaning admins in subscriber orgs can modify the values. A few fields (like `DemoRecord__c` and `PreventDelete__c`) are **Developer-Controlled** — only the package publisher can set them.

## Tips & Considerations

- **Form Builder is the Primary Interface**: You should rarely need to create CMT records directly. Form Builder handles all CRUD operations on these metadata types.
- **Deployment**: CMT records deploy via metadata (change sets, packages, SFDX). They do NOT count toward data storage limits.
- **Soft Delete Pattern**: Records use a `Delete__c` checkbox for soft deletion. Form Builder marks records for deletion; a cleanup process removes them.
- **Config Fields**: The `config__c` LongTextArea fields store JSON with runtime configuration. These are managed by Form Builder and should not be edited manually unless you understand the schema.
- **131072 Character Limit**: The `config__c` and related LongTextArea fields support up to 131,072 characters — sufficient for complex form configurations.
