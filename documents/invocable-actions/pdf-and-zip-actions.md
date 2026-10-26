# PDF & Zip File Actions

> Invocable actions for generating PDFs from Visualforce pages and combining files into zip archives.

## Generate PDF

**Action Label**: Generate PDF
**Category**: Flow Tool Kit

Turns a Visualforce page into a PDF and saves it as a Salesforce file: a new file, or a new version of an existing one. Optionally shares the file with a record or a user.

### Setting it up in Flow Builder

The action has its own editor, in three parts:

* **Page.** Choose the Visualforce page from a list. The four Flow Tool Kit print pages come first, each with a line saying what it prints and which record it needs, then your org's other pages. Every name in the list carries its namespace. A packaged page typed without it (`FormSubmissionPrint` instead of `FlowToolKit__FormSubmissionPrint`) is read as one of your own pages and stops the flow with "Maximum redirects (100) exceeded", so the editor marks it as an error and Flow Builder will not save the flow until it is fixed. **Record Id** is passed to the page as its id.
* **File.** The file name, title and description, and **New Version Of** to save the PDF as a new version of an existing file instead of a new one.
* **Share.** **Share With** links the file to a record or a user. **Share Type** and **Visibility** appear once it is set, each with a line saying what the choice does and where Salesforce accepts it.

Every input and output also carries help text, so the action reads the same in places that show Flow Builder's standard panel.

### The print pages

| Page | Prints | Record Id |
|---|---|---|
| Form Submission Print (`FlowToolKit__FormSubmissionPrint`) | The submission in its form's own layout and theme, page by page. Pages the respondent never saw and pages marked Do Not Print are left out. | The Form Submission |
| Form Submission Simple Print (`FlowToolKit__FormSubmissionSimplePrint`) | The same answers as plain question and answer tables, with the same pages left out. | The Form Submission |
| Form Template Print (`FlowToolKit__FormTemplatePrint`) | The template as its form, every page, with its pre-fill answers when it has a pre-fill template. | The Form Template |
| Form Template Simple Print (`FlowToolKit__FormTemplateSimplePrint`) | The template's questions as plain tables. | The Form Template |

### Sharing the file

What Salesforce accepts depends on what the file is shared with. Measured on file link inserts:

| Shared with | Share Type accepted | Visibility accepted |
|---|---|---|
| A record, such as a Form Submission or an Account | Viewer, Inferred | All Users, Internal Users |
| A user | Viewer, Collaborator | All Users (Shared Users only when sharing for internal users is private) |

Blank means Viewer and All Users, which work for both. Any other pair makes Salesforce refuse the link: the flow stops with the error (for example "Invalid sharing type C") and the new file is not kept.

### Inputs

| Property | Type | Required | Description |
|---|---|---|---|
| `pageName` | String | Yes | The Visualforce page, with its namespace, such as `FlowToolKit__FormSubmissionPrint` |
| `PathOnClient` | String | Yes | The file name, such as `Application.pdf`. `.pdf` is added when the name does not end in it |
| `Title` | String | Yes | The file's title |
| `Description` | String | No | A description saved with the file |
| `recordId` | Id | No | The record the page prints, passed to the page as its id |
| `ContentDocumentId` | Id | No | An existing file to save the PDF as a new version of, instead of a new file |
| `shareWithId` | Id | No | The record or user to share the file with |
| `shareVisibility` | String | No | `AllUsers` (when blank), `InternalUsers` or `SharedUsers`; see Sharing the file |
| `shareType` | String | No | `V` (when blank), `I` or `C`; see Sharing the file |

### Outputs

| Property | Type | Description |
|---|---|---|
| `contentDocumentId` | Id | The file's Id: the new file, or the existing one when the PDF was saved as a new version |
| `contentVersion` | ContentVersion | The saved version, with its Title, PathOnClient, FileType, ContentSize and VersionNumber |
| `contentDocumentLink` | ContentDocumentLink | The file's link to the Share With record, when one was given |

### Usage

1. In your Flow, add the **Generate PDF** action after the form is submitted.
2. Choose **Form Submission Print**, or your own page, and set **Record Id** to the submission's Id.
3. Set **Share With** to the submission, so the PDF appears in its Files list.
4. The PDF is saved as a file and linked to the record.

---

## Zip Files

**Action Label**: Zip Files/ContentDocuments
**Category**: Flow Tool Kit

Combines multiple ContentDocuments into a single zip file and creates it as a new ContentDocument.

### Inputs

| Property | Type | Required | Description |
|---|---|---|---|
| `contentDocumentIds` | Id[] | Yes | Collection of ContentDocument Ids to include in the zip |
| `zipFileName` | String | No | Name for the zip file (default: "Combined_Documents.zip") |
| `zipFileDescription` | String | No | Description for the zip file |
| `shareWithId` | Id | No | Record Id to share the zip file with |
| `shareVisibility` | String | No | Sharing visibility (default: "AllUsers") |
| `shareType` | String | No | Sharing type (default: "V") |

### Outputs

| Property | Type | Description |
|---|---|---|
| `isSuccess` | Boolean | Whether the operation succeeded |
| `contentDocumentId` | Id | Id of the created zip ContentDocument |
| `contentVersion` | ContentVersion | Full ContentVersion record of the zip file |
| `contentDocumentLink` | ContentDocumentLink | Sharing link (if shared) |
| `totalFiles` | Integer | Number of files included in the zip |
| `zipFileSize` | Long | Size of the zip file in bytes |
| `errorMessage` | String | Error message if the operation failed |

### Usage

1. Collect ContentDocument Ids from file upload fields, related files, or previous Generate PDF actions
2. Pass the Ids to the "Zip Files" action
3. Optionally share the zip with a record
4. Use the output `contentDocumentId` to reference the zip in subsequent Flow logic

## Related Pages

- [Create PDF from Submission](../form-template-framework/how-to/create-pdf-from-submission.md): step-by-step guide
- [File Upload Actions](file-upload-actions.md): serialize and deserialize file collections
