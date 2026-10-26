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

## Render Email Template

**Action Label**: Render Email Template
**Category**: Flow Tool Kit

Renders a stored email template against a recipient (a Contact or a Lead) and an optional related record such as a Form Submission, and returns the merged subject, HTML body and plain-text body so a Send Email action can send them as a plain rich-body email.

The reason this action exists: the standard Send Email action only honours a related record when the recipient is a Contact. A form that converts to a Lead could therefore never merge Form Submission fields at send time, and any template using them failed with *We don't recognize the field prefix FlowToolKit__Form_Submission__c*. Rendering here applies no such rule, so the packaged `(Form Submission) Convert | Utility | Send Email | Overridable` flow renders first and sends the result with **Use Email Template** off and **Send Rich Body** on. Lead and Contact recipients now behave the same.

### Inputs

| Property | Type | Required | Description |
|---|---|---|---|
| `emailTemplate` | String | Yes | The template to render, as its EmailTemplate record Id or its developer name. An Id is recognised by its key prefix; a name resolves to the newest template with that name, so an admin can iterate by cloning a template under the same name. |
| `recipientId` | String | No | The Contact or Lead the template renders against. Recipient merge fields resolve against this record. Optional for a template with no recipient merge fields. |
| `relatedRecordId` | String | No | The record whose merge fields the template uses, such as the Form Submission. Merges for Lead recipients as well as Contacts. |

### Outputs

| Property | Type | Description |
|---|---|---|
| `emailTemplateId` | String | The template that was rendered, or null when it could not be found |
| `renderedSubject` | String | The subject with every merge field resolved |
| `renderedHtmlBody` | String | The HTML body with every merge field resolved |
| `renderedPlainTextBody` | String | The plain-text body with every merge field resolved |
| `hasError` | Boolean | True when the template was not found or the render failed |
| `errorMessage` | String | Why the render failed, in the platform's own words |

### Usage

1. Call the action with the template (Id or developer name), the recipient, and the Form Submission as `relatedRecordId`
2. Branch on `hasError`: log `errorMessage` and stop, exactly as a missing template is handled
3. Send with the standard Send Email action: **Use Email Template** off, **Send Rich Body** on, `emailSubject` = `renderedSubject`, `emailBody` = `renderedHtmlBody`, `recipientId` as before, and `relatedRecordId` only for a Contact recipient (the platform refuses a related record on a Lead email; it no longer affects the merge, only where the sent email is logged)

The action never throws. Template file attachments and classic letterheads are not carried into the rendered output; a template that relies on them should stay on the Send Email template path with a Contact recipient.

## Create Form Submission Answers

**Form Template | Create Form Submission Answers** writes one Form Submission Answer record per question the respondent was shown on a Form Submission, one per chosen option for a multi-select, replacing any written before. The packaged flow **Form Submission (After Update → Create Submission Answers)** calls it when a submission completes or is bypassed and the template's **Enable Form Analytics** is on.

| Input | Required | Purpose |
| --- | --- | --- |
| Form Submission Id | Yes | The submission whose answers are written. |
| Include Unanswered Questions | No | Also write a **No Response** answer for each question the respondent was shown and left unanswered. The packaged flow sets it on. |
| Skip Fields | No | Form Submission fields that never write an answer, whatever a question is set to in the Form Builder, as API names separated by semicolons or commas. A name that is not a field on Form Submission stops the action with an error. |

### Fields that never become answers

Each question's **Reporting** setting in the Form Builder decides. Left on **Automatic**, these never write an answer record:

- A contact's identity: Contact 1 and Contact 2 first name, last name, title, email, email type, phone and phone type.
- The record lookups: Contact 1, Contact 2, Lead 1, Lead 2, Account, Campaign.
- Status and the other package fields that ask the respondent nothing (any packaged Form Submission field without a question type).
- Free-written text, because it charts nothing; a file upload is not free text and is written.

Set a question to **Always** to include it even so, or **Never** to leave it out. Skip Fields is for a client's own exclusions; identity, lookup and system fields need no entry there. See [Question Reporting](../form-configuration/question-reporting.md) for the settings and worked examples.

## Recalculate Results

**Action Label**: Form Template | Recalculate Results

**Category**: Flow Tool Kit

Starts a background job that calculates each Form Template's stored results from its **Form Submission Answers**. It maintains one Form Template Result per question and the template's headline Responses, Average Score, Favorable, and Net Promoter Score. A record is written only when its numbers change.

> Available in [Release 4.49](../release-notes/release-4.49.md). Configure this action in your own administrator-triggered or Schedule-Triggered Flow; no results schedule is installed automatically.

| Input | Required | Meaning |
| --- | --- | --- |
| Batch Size | No | Answers read per batch, from 1 to 2000; defaults to 2000. |

| Output | Meaning |
| --- | --- |
| Job Id | The recalculation job started or already waiting/running. |
| Already Running | True when an existing job is reused and no second job is started. |

The action requests work and returns before the job finishes. Opening Results or switching a chart does not invoke this action.

You do not need this action to see new responses. A template's results are worked out again about two minutes after its answers are written, and **Refresh results** on the Analytics panel works them out at once. Both read only that template's answers and never stop this action from starting. Keep a scheduled run of this action as a nightly safety net, for example after answers are deleted or a refresh could not be scheduled.

See the recorded [submission-to-results walkthrough](../form-template-framework/survey-results.md#submit-convert-and-recalculate), including the prepared administrator Flow and independently checked updated totals.

## Related Pages

- [Form Submissions](../form-template-framework/form-submissions.md): submission lifecycle
- [Overridable Conversion Flows](../form-template-framework/how-to/overridable-conversion-flows.md): custom conversion logic
- [Use Form Submissions](../form-template-framework/how-to/use-form-submissions.md): end-to-end guide
