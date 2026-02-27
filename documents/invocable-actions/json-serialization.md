# JSON & Serialization Actions
> Invocable Actions for converting records to/from JSON strings and processing Form Submission data in Flows.

## Overview

These actions handle serialization — converting Salesforce records to JSON strings and back. This is essential for storing record data in text fields (like Form Submissions), passing complex data between systems, and processing multi-step form data.

All actions appear under the **Flow Tool Kit** category in Flow Builder.

## Actions

### JSON | Serialize SObject

**Action Name**: `JSON | Serialize SObject`

Convert any Salesforce record into a JSON string. Use this to store record data in a text field, pass it to an external system, or preserve a snapshot of field values.

#### Inputs

| Parameter | Type | Required | Description |
|---|---|---|---|
| `record` | SObject | Yes | The record to serialize |

#### Outputs

| Parameter | Type | Description |
|---|---|---|
| `jsonString` | String | The record's field values as a JSON string |

#### Example
Serialize a Contact record → `{"FirstName":"Jane","LastName":"Smith","Email":"jane@example.com","Id":"003..."}`

---

### JSON | Deserialize SObject String

**Action Name**: `JSON | Deserialize SObject String`

Convert a JSON string back into a Salesforce record. The inverse of Serialize — takes a previously serialized JSON string and recreates the SObject record.

#### Inputs

| Parameter | Type | Required | Description |
|---|---|---|---|
| `jsonString` | String | Yes | The JSON string to deserialize |

#### Outputs

| Parameter | Type | Description |
|---|---|---|
| `record` | SObject | The deserialized record |

---

### JSON | Deserialize Additional Data

**Action Name**: `JSON | Deserialize Additional Data`

Specialized action for processing Form Submission internal data. Converts the JSON collection stored in `Form_Submission__c.Internal_Additional_Data__c` into separate collections of records to upsert and delete.

#### Inputs

| Parameter | Type | Required | Description |
|---|---|---|---|
| `record` | Form_Submission__c | Yes | The Form Submission record containing additional data |

#### Outputs

| Parameter | Type | Description |
|---|---|---|
| `recordsToUpsert` | Form_Submission__c[] | Records that should be upserted |
| `recordsToDelete` | Form_Submission__c[] | Records that should be deleted |
| `numberOfRecordsToUpsert` | Integer | Count of records to upsert |
| `numberOfRecordsToDelete` | Integer | Count of records to delete |

---

### File Upload | Serialize File Collection

**Action Name**: `File Upload | Serialize File Collection`

Convert a collection of Flow Tool Kit File wrapper objects into a JSON string for storage in a record field.

#### Inputs

| Parameter | Type | Required | Description |
|---|---|---|---|
| `files` | File[] | No | Collection of File wrapper objects |

#### Outputs

| Parameter | Type | Description |
|---|---|---|
| `jsonString` | String | The serialized file collection as JSON |

---

### File Upload | Deserialize Upload String

**Action Name**: `File Upload | Deserialize Upload String`

Convert a JSON string of file upload data back into a FileUpload wrapper object. The inverse of File Upload Serialize.

#### Inputs

| Parameter | Type | Required | Description |
|---|---|---|---|
| `jsonString` | String | No | JSON string containing file upload data |

#### Outputs

| Parameter | Type | Description |
|---|---|---|
| `fileUpload` | FileUpload | The deserialized FileUpload wrapper object |

## Common Patterns

### 1. Store Record Snapshot
Before an update, serialize the current record with **JSON Serialize** and store the JSON string in a Long Text Area field. This provides a before-image for audit or undo purposes.

### 2. Cross-Flow Data Passing
Serialize a record in one Flow, store the JSON in a variable, and deserialize it in another Flow. Useful for subflows or when passing complex data through platform events.

### 3. Form Submission Processing
When processing multi-page Form Template submissions:
1. User completes the template
2. **Deserialize Additional Data** processes the submission's internal JSON
3. Use `recordsToUpsert` and `recordsToDelete` collections for the appropriate DML
4. Update submission status

### 4. File Upload Storage
After a user uploads files through a Flow Form file upload field:
1. **Serialize File Collection** converts the files to JSON
2. Store the JSON in a record field
3. Later, **Deserialize Upload String** recreates the file data for processing

## Tips & Considerations

- **JSON Size**: Serialized JSON strings can be large. Ensure your target text field has sufficient length (Long Text Area fields support up to 131,072 characters).
- **Null Fields**: Serialization includes null fields by default. If you need a compact JSON string, use **Strip Null Values** before serializing.
- **Cross-Object**: Serialization captures field values but loses the SObject type context. Ensure the JSON is deserialized into the correct object type.
- **FormSubmission Specific**: The "Deserialize Additional Data" action is specifically designed for the Form Submission system. It expects the data structure used by Form Templates.
- **File Wrappers**: File serialize/deserialize actions work with Flow Tool Kit's custom File/FileUpload Apex-Defined types, not standard ContentDocument records.
