# Form Components System
> Save, share, and reuse form configurations as Form Component records — enabling component-based form selection in Flows, Experience Cloud, and record pages.

## Overview

The Form Components system lets you save form configurations as reusable `Form_Component__c` records. Instead of referencing Form metadata by QualifiedApiName every time, you create a Form Component that packages the form definition, object, theme, and layout settings into a single selectable record.

This is especially useful when:
- Admins need to select forms from a dropdown without knowing metadata API names
- You want to store form JSON configurations in a manageable record
- You need to version form configurations or restrict who can manage them
- Experience Cloud pages need a form selection mechanism outside of Flow

## Key Objects

### Form_Component__c

| Field | Type | Description |
|---|---|---|
| `Label__c` | Text | Display name for the component |
| `QualifiedApiName__c` | Text | Unique API name for referencing the component |
| `ObjectApiName__c` | Text | The SObject API name this form is for |
| `FormConfigJSON__c` | LongTextArea | The form definition stored as JSON |
| `Form_Object__c` | Lookup | Reference to the Form Object metadata |
| `Theme__c` | Lookup | Associated Form Theme |
| `Active__c` | Checkbox | Whether this component is available for selection |
| `Description__c` | Text | Admin description |
| `CategoryTag__c` | Picklist | Organizational category tag |
| `Form_Managers__c` | LongTextArea | User Ids (semicolon-separated) who can manage this component |
| `type__c` | Picklist | Component type (form, table, etc.) |
| `Version__c` | Number | Version number for tracking changes |
| `VersionId__c` | Text | Version identifier |
| `SystemModstamp__c` | DateTime | Last modification timestamp |
| `prefill__c` | LongTextArea | Prefill configuration |
| `horizontalAlign__c` | Picklist | Horizontal alignment setting |
| `verticalAlign__c` | Picklist | Vertical alignment setting |
| `widthSmall__c` | Number | Small screen width |
| `widthMedium__c` | Number | Medium screen width |
| `widthLarge__c` | Number | Large screen width |

## Configuration Modes

Flow Tool Kit components that accept form configurations support three input modes:

### 1. Component Mode
Select a Form Component by its QualifiedApiName from a dropdown. The component's stored JSON configuration is used at runtime.

**Best for**: Admins selecting from pre-built form configurations without touching JSON.

### 2. Custom JSON Mode
Build a form configuration using the visual Form Builder editor. The resulting JSON is stored directly on the component's configuration property.

**Best for**: One-off configurations or when you need a specific form that doesn't warrant a reusable component.

### 3. Record Field Reference Mode
Reference a field on a record that contains the form JSON. This enables truly dynamic form selection — the form to render can change based on the record's field value.

**Best for**: Dynamic scenarios where different records need different forms (e.g., different form configurations per record type or account).

## Key Components

### formComponentSelector
A Lightning component for Record Pages that lets users select a Form Component from a dropdown and store the selection on a record field.

- **Targets**: Record Page
- **Uses**: Apex datasources for dynamic picklist values
- **Supports**: Both form and table component types

### formComponentConfigurator
An internal (not exposed) component used by property editors to provide the component selection or custom JSON configuration UI.

- **Modes**: Component selection or JSON editor
- **Used by**: Experience Cloud property editors and Flow CPEs

### formComponentEditor
A standalone wrapper for the custom JSON mode. Opens the Form Builder in a modal for visual form building.

### formComponentPreviewSelector
A shared child component that renders either a combobox (Component mode) or an editor button (Custom JSON mode).

## How It Works

1. **Create a Form Component**: In Form Builder, design your form and save it as a Form Component (or create a `Form_Component__c` record directly)
2. **Component stores JSON**: The form definition is serialized as JSON in the `FormConfigJSON__c` field
3. **Runtime selection**: When a Flow Form, Data Table, or Experience Cloud component references the Form Component, it reads the JSON and renders the form
4. **Version tracking**: Changes to the Form Component update the version number, providing an audit trail

## Works With

| Component | Integration |
|---|---|
| **Flow Form** | Select a Form Component as the form source (via `formQualifiedApiName` or JSON) |
| **Data Table** | Select a Form Component for table column definitions |
| **Experience Cloud Components** | Property editors use formComponentConfigurator for component selection |
| **Form Builder** | Create and edit Form Components visually |
| **Form Templates** | Template sections can reference Form Components |

## Common Patterns

### 1. Admin-Managed Form Library
Create Form Components for common forms (Quick Edit Account, Full Contact Intake, Order Line Items). Admins select from this library when configuring Flow screens — no metadata API names needed.

### 2. Dynamic Form Per Record Type
Store a Form Component QualifiedApiName on each record type (via a custom field). Use Record Field Reference mode to dynamically render the right form based on the record type.

### 3. Versioned Form Configurations
Use the `Version__c` and `VersionId__c` fields to track changes to form configurations over time. Roll back by restoring a previous JSON version.

## Tips & Considerations

- **Form Components are SObject Records**: Unlike Form metadata (CMTs), Form Components are regular custom object records. They count toward data storage and are subject to CRUD/FLS permissions.
- **Edit Override**: The `Form_Component__c` object has an edit action override that opens the Form Builder directly, providing a seamless editing experience.
- **Mode Preservation**: When switching between Component and Custom JSON modes in a property editor, the JSON configuration is preserved — switching modes doesn't lose your work.
- **Active Flag**: Deactivate Form Components to hide them from selection picklists without deleting the record. This is useful for retiring old configurations.
- **Search and Reports**: Because Form Components are regular records, you can build reports, list views, and dashboards to manage your form library.
