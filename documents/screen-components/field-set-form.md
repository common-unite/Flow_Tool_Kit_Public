# Field Set Form

> Render a form on a Flow Screen driven by a Salesforce Field Set instead of Form Builder metadata.

## Overview

Form (Field Set) renders a form using a standard Salesforce Field Set as its field source instead of Form Builder metadata. This is useful when you want a quick form without building a form component in Form Builder, or when you need the form layout to be managed through standard Salesforce Field Set administration.

The component reads the specified Field Set, renders the fields in order, and outputs the record with user-entered values — similar to Flow Form but with Field Sets as the configuration source.

## Where to Use It

- **Flow Screen**

## Properties

### Inputs

| Property | Type | Required | Default | Description |
|---|---|---|---|---|
| `object` | String | No | — | SObject API name |
| `fieldSetName` | String | No | — | API name of the Field Set to render |
| `record` | SObject (Generic T) | No | — | Record variable for input/output values |
| `topMargin` | String | No | slds-m-top_none | Top margin SLDS class |
| `bottomMargin` | String | No | slds-m-bottom_none | Bottom margin SLDS class |

### Outputs

| Property | Type | Description |
|---|---|---|
| `record` | SObject (Generic T) | Record with all field values (prefilled + user-entered) |
| `fieldSetFieldsOnly` | SObject (Generic T) | Record with only the fields from the Field Set |

## Common Patterns

### 1. Quick Edit Form
Create a Field Set on Contact with the fields you want to edit. Add Field Set Form to a screen, specify the object and Field Set name, and pass an existing record. After the screen, update the record.

### 2. Dynamic Form by Field Set
Use a Flow variable to set `fieldSetName` dynamically. Different branches of your Flow can render different Field Sets for the same object.

## Tips & Considerations

- **Field Set vs Form Builder**: Field Set Form is simpler but lacks Form Builder features like conditional logic, themes, sections, labels, and validation rules. Use it for quick, simple forms; use Flow Form with Form Builder metadata for rich experiences.
- **Two Output Variants**: `record` returns all field values (including any prefilled values not in the Field Set). `fieldSetFieldsOnly` returns only the Field Set fields — useful when you want to update only those specific fields.
