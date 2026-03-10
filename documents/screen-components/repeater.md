# Repeater

> Display and manage a repeating collection of form components on a Flow Screen — add, edit, delete, clone, reorder, and select records.

## Overview

Form (Repeater) renders a collection of records, each displayed using the same form component layout. Users can add new records, edit existing ones, delete, clone, reorder, and select records — all within a single Flow Screen. It's the form-based equivalent of Data Table but displays each record as a full form component instead of a table row.

Repeater is ideal for scenarios where each record needs a rich editing experience: line items with complex fields, repeating sections in applications, or any parent-child relationship where inline table editing isn't enough.

Like Data Table, Repeater tracks all changes in separate output collections (insert, update, delete) so your Flow can perform the right DML operation for each record.

## Where to Use It

- **Flow Screen**

## Video Walkthroughs

{% embed url="https://vimeo.com/917623212" %}

![Repeater displaying contact cards with edit and delete actions](../screenshots/screen-components/repeater/repeater-overview-cards.png)

### Advanced Edit Modal

The repeater supports opening a full edit modal for each record, giving users a richer editing experience than inline fields.

![Advanced edit modal with form fields](../screenshots/screen-components/repeater/repeater-edit-modal-open.png)

### Drag-and-Drop Reordering

Users can arrange records by dragging them into the desired order.

![Drag and drop reordering in action](../screenshots/gifs/repeater-drag-arrange.gif)

## Properties

### Core Configuration

| Property | Type | Required | Default | Description |
|---|---|---|---|---|
| `formRepeaterConfiguration` | FormRepeaterConfiguration (Apex-Defined) | No | — | Configuration object from the "Configure Form (Repeater)" invocable action |
| `formQualifiedApiName` | String | No | — | QualifiedApiName of the form component to render for each record |
| `object` | String | No | — | SObject API name |
| `recordTemplate` | SObject (Generic T) | No | — | Template record with default values for new records |
| `formJSON` | String | No | — | Form definition as JSON (alternative to metadata) |
| `formJsonEnabled` | Boolean | No | false | Use `formJSON` instead of `formQualifiedApiName` |
| `dynamicFormSelectorEnabled` | Boolean | No | false | Allow dynamic form component selection |
| `languageOverride` | String | No | — | ISO language code override |
| `max` | Integer | No | 5 | Maximum number of records allowed |
| `min` | Integer | No | 1 | Minimum number of records required |

### Action Permissions

| Property | Type | Default | Description |
|---|---|---|---|
| `allowNew` | Boolean | — | Show the "New" button |
| `allowEdit` | Boolean | — | Show the "Edit" button |
| `allowDelete` | Boolean | — | Show the "Delete" button |
| `allowClone` | Boolean | — | Show the "Clone" button |
| `allowReposition` | Boolean | — | Show reorder (up/down) buttons |
| `allowImport` | Boolean | — | Show the "Import" button |
| `allowSelect` | Boolean | — | Allow record selection |
| `allowViewDetails` | Boolean | — | Show "View Details" action |

### Action Labels

| Property | Type | Description |
|---|---|---|
| `newButtonLabel` | String | Custom label for the New button |
| `editButtonLabel` | String | Custom label for the Edit button |
| `deleteButtonLabel` | String | Custom label for the Delete button |
| `cloneButtonLabel` | String | Custom label for the Clone button |
| `importButtonLabel` | String | Custom label for the Import button |

### Edit Modal

| Property | Type | Description |
|---|---|---|
| `editFormQualifiedApiName` | String | Alternative form component for the edit modal |
| `editModalHeading` | String | Edit modal title |
| `editModalSubheading` | String | Edit modal subtitle |
| `editModalReturnOnSelect` | Boolean | Close modal and navigate on selection |
| `editReturnButtonLabel` | String | Label for the edit modal return button |

### Collections (Inputs/Outputs)

| Property | Type | Role | Description |
|---|---|---|---|
| `prefillRecords` | SObject[] (Generic T) | Both | Records to display; returns current full collection |
| `insertCollection` | SObject[] (Generic T) | Output | New records created by the user |
| `updateCollection` | SObject[] (Generic T) | Output | Existing records modified by the user |
| `deleteCollection` | SObject[] (Generic T) | Output | Records marked for deletion |
| `prefillRecordsSize` | Integer | Output | Count of prefill records |
| `totalRecordsSize` | Integer | Output | Total record count |
| `insertCollectionSize` | Integer | Output | Count of new records |
| `updateCollectionSize` | Integer | Output | Count of modified records |
| `deleteCollectionSize` | Integer | Output | Count of deleted records |

### Selection Outputs

| Property | Type | Description |
|---|---|---|
| `firstSelectedRow` | SObject (Generic T) | First selected record |
| `selectedRecords` | SObject[] (Generic T) | All selected records |
| `selectedCollectionSize` | Integer | Count of selected records |
| `selectedRecordsIds` | String[] | Array of selected record Ids |
| `selectedRecordsIdsString` | String | Comma-separated selected record Ids |
| `selectedRecordsValues` | String[] | Field values for selected rows |
| `selectedRecordsValuesString` | String | Comma-separated field values |

### Calculation Outputs

| Property | Type | Description |
|---|---|---|
| `calculatedResult` | SObject (Generic T) | Calculation results across all records |
| `calculatedResultSelectedOnly` | SObject (Generic T) | Calculation results for selected records only |

### Display & Layout

| Property | Type | Default | Description |
|---|---|---|---|
| `title` | String | — | Header title |
| `subtitle` | String | — | Header subtitle |
| `helpText` | String | — | Help text |
| `iconName` | String | — | SLDS icon name |
| `richText` | String | — | Rich text HTML content |
| `showHeader` | Boolean | true | Show the header |
| `themeOverrideName` | String | — | Theme for form sections |
| `themeHeaderName` | String | — | Theme for the header |
| `enableAccordion` | Boolean | false | Display each record as an accordion |
| `wrapInAccordion` | Boolean | false | Wrap entire repeater in an accordion |
| `dynamicHeaders` | Boolean | false | Use dynamic header content per record |
| `accordionTitle` | String | — | Accordion header text |
| `subtitleTemplate` | String | — | Template string for record subtitles |
| `iconNameTemplate` | String | — | Template string for record icons |
| `preventAccordionClose` | Boolean | false | Keep at least one accordion open |
| `closedOnLoad` | Boolean | false | Start with accordions collapsed |
| `hideDivider` | Boolean | — | Hide divider between records |
| `displayRepeaterButtonsAbove` | Boolean | — | Show action buttons above records |
| `smallSize` | Integer | — | Column size on small screens |
| `mediumSize` | Integer | — | Column size on medium screens |
| `largeSize` | Integer | — | Column size on large screens |
| `topMargin` | String | — | Top margin SLDS class |
| `bottomMargin` | String | slds-m-bottom_none | Bottom margin SLDS class |

### Validation & Behavior

| Property | Type | Default | Description |
|---|---|---|---|
| `review` | Boolean | false | Read-only review mode |
| `requireAll` | Boolean | false | Make all fields required |
| `disableAll` | Boolean | false | Disable all fields |
| `disableAllHeaders` | Boolean | false | Disable section headers |
| `displayPrompts` | Boolean | false | Show field help prompts |
| `preventValidationBypass` | Boolean | false | Prevent validation bypass |
| `stampFormQualifiedApiName` | Boolean | — | Stamp the form name on each record |

## Common Patterns

### 1. Line Item Entry
Prefill with existing line items. Enable New, Edit, Delete. After the screen, process insert/update/delete collections with the appropriate DML elements.

### 2. Multi-Record Application Sections
Use as a repeating section in a longer form — e.g., "Employment History" where users add multiple jobs. Set `min=1` and `max=5`.

### 3. Record Selection List
Enable `allowSelect` and display records as selectable cards. Use `selectedRecords` output to pass the user's choices downstream.

## Tips & Considerations

- **Configuration Action**: Use the "Configure Form (Repeater)" invocable action to set all repeater properties in a single step, then pass the result to `formRepeaterConfiguration`.
- **Accordion Display**: For complex records, enable `enableAccordion` so each record collapses into a compact header — reduces visual clutter with many records.
- **Responsive Layout**: Use `smallSize`, `mediumSize`, and `largeSize` to control how many records display per row on different screen sizes.
- **Reordering**: When `allowReposition` is enabled, specify `repositionFieldApiName` to indicate which numeric field stores the position value.
