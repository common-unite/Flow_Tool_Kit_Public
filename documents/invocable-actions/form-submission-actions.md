# Form Submission Actions

> Invocable actions for processing Form Submission data and logging conversion events in the Form Template Framework.

## Deserialize Additional Data

**Action Label**: JSON | Deserialize Additional Data
**Category**: Flow Tool Kit

Converts the JSON string stored in a `Form_Submission__c` record's `Internal_Additional_Data__c` field into SObject collections. This action is used during submission processing to extract related records (repeating sections, child records) that were serialized during form completion.

### Inputs

| Property | Type | Required | Description |
|---|---|---|---|
| `record` | Form_Submission__c | Yes | The Form Submission record containing serialized data |

### Outputs

| Property | Type | Description |
|---|---|---|
| `recordsToUpsert` | Form_Submission__c[] | Submission records to upsert (additional data) |
| `recordsToDelete` | Form_Submission__c[] | Submission records to delete |
| `numberOfRecordsToUpsert` | Integer | Count of records to upsert |
| `numberOfRecordsToDelete` | Integer | Count of records to delete |

### Usage

Use this action in conversion flows when a Form Template includes repeating sections or child record collections. The form serializes these records into the submission's additional data field. This action deserializes them so your Flow can process each record individually.

---

## Log Conversion Event

**Action Label**: Form Template | Log Conversion Event
**Category**: Flow Tool Kit

Logs a conversion event on a Form Submission record. This action handles updating conversion statuses, recording reference Ids for created records, and creating `Form_Submission_Conversion_Log__c` entries. Use it in both standard and overridable conversion flows to maintain an audit trail.

### Inputs

| Property | Type | Required | Description |
|---|---|---|---|
| `record` | Form_Submission__c | Yes | The Form Submission being converted |
| `platformEvent` | Form_Submission_Convert__e | No | Platform event that triggered the conversion |
| `status` | String | No | Event status (default: "Error") |
| `conversionStatus` | String | No | Conversion status value to set |
| `statusFieldApiName` | String | No | API name of the field that holds conversion status |
| `lookupFieldApiName` | String | No | API name of the lookup field to the created record |
| `recordId` | String | No | Id of the record created by conversion |
| `flowLabel` | String | No | Label of the conversion flow (for logging) |
| `message` | String | No | Success/info message |
| `faultMessage` | String | No | Error message (for fault handling) |

### Outputs

| Property | Type | Description |
|---|---|---|
| `record` | Form_Submission__c | Updated Form Submission record with conversion status |

### Usage

Call this action after creating records from a submission:
1. After a successful record insert, call with `status="Success"`, `recordId` set to the new record's Id, and the relevant `lookupFieldApiName`
2. In a fault handler, call with `status="Error"` and `faultMessage` set to the error details
3. The action updates the submission record and creates a conversion log entry

## Related Pages

- [Form Submissions](../form-template-framework/form-submissions.md) — submission lifecycle
- [Overridable Conversion Flows](../form-template-framework/how-to/overridable-conversion-flows.md) — custom conversion logic
- [Use Form Submissions](../form-template-framework/how-to/use-form-submissions.md) — end-to-end guide
