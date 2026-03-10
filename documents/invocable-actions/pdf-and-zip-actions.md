# PDF & Zip File Actions

> Invocable actions for generating PDFs from Visualforce pages and combining files into zip archives.

## Generate PDF

**Action Label**: Generate PDF
**Category**: Flow Tool Kit

Generates a PDF document from a Visualforce page and creates it as a Salesforce ContentDocument. Optionally shares the PDF with a specified record via ContentDocumentLink.

### Inputs

| Property | Type | Required | Description |
|---|---|---|---|
| `pageName` | String | Yes | API name of the Visualforce page to render as PDF |
| `PathOnClient` | String | Yes | Filename for the PDF (e.g., "Application_Form.pdf") |
| `Title` | String | Yes | Document title |
| `Description` | String | No | Document description |
| `recordId` | Id | No | Record Id to pass to the Visualforce page as a URL parameter |
| `ContentDocumentId` | Id | No | Existing ContentDocument Id to create a new version of (instead of a new document) |
| `shareWithId` | Id | No | Record Id to share the PDF with via ContentDocumentLink |
| `shareVisibility` | String | No | Sharing visibility for the ContentDocumentLink |
| `shareType` | String | No | Sharing type for the ContentDocumentLink |

### Outputs

| Property | Type | Description |
|---|---|---|
| `contentDocumentId` | Id | Id of the created ContentDocument |
| `contentVersion` | ContentVersion | Full ContentVersion record |
| `contentDocumentLink` | ContentDocumentLink | Sharing link record (if `shareWithId` was provided) |

### Usage

1. Create a Visualforce page that renders your form data (using the submission record or any other data source)
2. In your Flow, add the "Generate PDF" action after form submission
3. Set `pageName` to your VF page's API name and `recordId` to the submission Id
4. Set `shareWithId` to link the PDF to the submission record
5. The PDF is created as a ContentDocument and linked to the record

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

- [Create PDF from Submission](../form-template-framework/how-to/create-pdf-from-submission.md) — step-by-step guide
- [File Upload Actions](file-upload-actions.md) — serialize and deserialize file collections
