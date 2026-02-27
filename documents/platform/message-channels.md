# Lightning Message Channels
> The pub/sub communication backbone that connects Flow Tool Kit components on the same page — enabling form validation, button clicks, lookup searches, and data sync between independent components.

## Overview

Flow Tool Kit components on the same Flow Screen or Lightning page communicate through Lightning Message Channels (LMS). When a button triggers form validation, when a lookup field opens a search table, when form data syncs between components — it all happens through these message channels.

Understanding message channels helps you troubleshoot component interactions and build advanced multi-component screen layouts. You don't configure message channels directly — they're internal plumbing — but knowing what they do explains why components work together the way they do.

## Message Channels

### FlowButton (FLOW_BUTTON__c)
**Purpose**: Communication between Custom Buttons and other components (primarily Flow Form for validation).

| Field | Type | Description |
|---|---|---|
| `buttonClicked` | — | The button object that was clicked |
| `elementApiName` | — | The Flow screen element name of the sender |
| `interviewStartDateTime` | — | Key for matching button clicks to the correct screen |
| `interviewGuid` | — | Unique identifier for the Flow interview |
| `disableButtons` | — | Signal to disable/enable all buttons |
| `togglePrompt` | — | Signal to toggle help prompts |

**How It's Used**:
- Custom Buttons publishes a `buttonClicked` message when a user clicks a button
- Flow Form subscribes to this channel to trigger validation before navigation
- The `interviewGuid` and `interviewStartDateTime` fields ensure messages are scoped to the correct Flow interview (important when multiple Flow screens exist on the same page)
- `disableButtons` lets one component disable all buttons (e.g., during processing)

---

### FlowForm (FLOW_FORM__c)
**Purpose**: Data synchronization between Flow Form instances on the same screen.

| Field | Type | Description |
|---|---|---|
| `key` | — | Record key for matching (confirms if record should be synced) |
| `value` | — | The updated record value |
| `object` | — | Object API name |
| `formName` | — | Name of the sending form |
| `elementApiName` | — | Flow screen element name of the sender |
| `fieldName` | — | Name of the field that changed |
| `dataType` | — | Data type of the changed field |
| `disconnected` | — | Alert when a component disconnects |
| `fullFieldName` | — | Full field name (object.fieldName) |
| `recordId` | — | Alternative to using the key |
| `recalculateFormulas` | — | Signal to recalculate formula fields |
| `isLookup` | — | True if the sender is a lookup component |

**How It's Used**:
- When a field value changes on one Flow Form, a message is published with the field name, value, and data type
- Other Flow Forms on the same screen subscribe and can update their own fields accordingly (cross-form data sync)
- The `recalculateFormulas` field triggers formula recalculation on receiving forms
- `disconnected` alerts other components when a form unmounts (e.g., during Flow navigation)

---

### FlowFormLookupSearch (FLOW_FORM_LOOKUP_SEARCH__c)
**Purpose**: Opening and configuring the lookup search table when a user clicks a lookup field.

| Field | Type | Description |
|---|---|---|
| `key` | — | Record key for matching |
| `value` | — | Current selected value/Id |
| `object` | — | Child object (the object being looked up) |
| `parentObject` | — | Parent object (the object containing the lookup field) |
| `formName` | — | Sending form name |
| `elementApiName` | — | Sending element name |
| `fieldName` | — | Lookup field name |
| `recordId` | — | Alternative key |
| `customTitle` | — | Custom modal title text |
| `customSubtitle` | — | Custom modal subtitle text |
| `recalculateFormulas` | — | Signal to recalculate formulas on commit |
| `importSelection` | — | When true, return the entire record instead of just the Id |
| `filterOutRecordIds` | — | Collection of record Ids to exclude from lookup results |

**How It's Used**:
- When a user clicks a lookup field in Flow Form, a message is published on this channel with the field context (object, field name, current value)
- The Lookup component (flowFormLookup) subscribes to this channel and opens the lookup search table
- `filterOutRecordIds` allows the form to exclude already-selected records from the lookup results
- `customTitle` and `customSubtitle` enable the form to set a context-specific modal header

---

### FlowFormImport (FLOW_FORM_IMPORT__c)
**Purpose**: Returning selected records from the lookup table back to the form.

| Field | Type | Description |
|---|---|---|
| `key` | — | Record key for matching |
| `object` | — | Object API name |
| `formName` | — | Sending form name |
| `elementApiName` | — | Sending element name |
| `recordId` | — | Record Id of selected record |
| `record` | — | The full selected record and values |

**How It's Used**:
- When a user selects a record in the lookup table, a message is published with the selected record
- Flow Form subscribes to this channel and populates the lookup field with the selected record's Id (or the full record if configured)
- The `record` field carries the complete record data, enabling the form to display related field values

---

### FlowFormSectionValidate (FLOW_FORM_SECTION_VALIDATE__c)
**Purpose**: External validation control for individual form sections.

| Field | Type | Description |
|---|---|---|
| `SectionQualifiedApiName` | — | The Qualified API Name of the target section |
| `isvalid` | — | Boolean value to toggle section validity |

**How It's Used**:
- External components or reactive screen components can publish to this channel to mark a specific section as valid or invalid
- Flow Form subscribes and updates the section's validation state accordingly
- This enables scenarios where validation logic lives outside the form (e.g., a custom component validates data and signals the form)

## How Components Connect

```
                     FlowButton
Custom Buttons  ──────────────────→  Flow Form
                                        ↑
                     FlowForm          │
Flow Form #2    ──────────────────→  Flow Form #1
                                        │
                   FlowFormLookupSearch │
Flow Form      ──────────────────→  Lookup Component
                                        │
                   FlowFormImport       │
Lookup          ──────────────────→  Flow Form
                                        ↑
                FlowFormSectionValidate │
Custom LWC     ──────────────────→  Flow Form
```

## Message Scoping

Messages are scoped by `interviewGuid` (or `interviewStartDateTime` as a fallback). This ensures that when multiple Flow interviews exist on the same page, button clicks in one interview don't affect forms in another.

The `elementApiName` field further scopes messages to specific screen elements, preventing cross-component interference within the same interview.

## Tips & Considerations

- **You Don't Configure These**: Message channels are internal to Flow Tool Kit. You interact with them through component properties, not directly.
- **Same Page Only**: LMS only works between components on the same page. Components on different pages or in different browser tabs cannot communicate.
- **Interview Isolation**: The `interviewGuid` scoping means components in different Flow interviews are fully isolated, even if they're on the same page.
- **Debugging**: If components aren't communicating (e.g., buttons not triggering form validation), check that both components are on the same screen element and that `interviewGuid` values match.
- **Custom Integration**: Advanced developers building custom LWC components can subscribe to these channels to integrate with Flow Tool Kit components. The channels are exposed (`isExposed=true`).
- **Performance**: Message channel communication is synchronous within the page. Messages are delivered instantly — there's no polling or delay.
