# File & Upload Actions
> Invocable Actions for generating PDFs, creating zip archives, and managing file uploads in Flows.

## Overview

Flow Tool Kit includes actions for working with files in Flows — generating PDFs from Visualforce pages, combining multiple files into zip archives, and serializing/deserializing file upload data. These actions extend Salesforce's file handling capabilities for common admin scenarios.

All actions appear under the **Flow Tool Kit** category in Flow Builder.

## Actions

### Generate PDF

**Action Name**: `Generate PDF`

Generate a PDF document from a Visualforce page and save it as a ContentDocument (File). Optionally share the file with a record and attach metadata.

#### Inputs

| Parameter | Type | Required | Description |
|---|---|---|---|
| `pageName` | String | Yes | The API name of the Visualforce page to render as PDF |
| `PathOnClient` | String | Yes | File name with extension (e.g., "Invoice_001.pdf") |
| `Title` | String | Yes | Document title |
| `Description` | String | No | Document description |
| `recordId` | Id | No | Record Id to pass to the Visualforce page (available as `{!$CurrentPage.parameters.id}`) |
| `ContentDocumentId` | Id | No | Existing ContentDocument Id (for version updates) |
| `shareWithId` | Id | No | Record Id to share the file with (creates a ContentDocumentLink) |
| `shareVisibility` | String | No | Sharing visibility setting |
| `shareType` | String | No | Sharing type setting |

#### Outputs

| Parameter | Type | Description |
|---|---|---|
| `contentDocumentId` | Id | The Id of the created/updated ContentDocument |
| `contentVersion` | ContentVersion | The full ContentVersion record |
| `contentDocumentLink` | ContentDocumentLink | The sharing record (if `shareWithId` was provided) |

---

### Zip Files / ContentDocuments

**Action Name**: `Zip Files/ContentDocuments`

Combine multiple ContentDocuments into a single zip file. Creates a new ContentDocument containing the zip archive.

#### Inputs

| Parameter | Type | Required | Description |
|---|---|---|---|
| `contentDocumentIds` | Id[] | Yes | List of ContentDocument Ids to include in the zip |
| `zipFileName` | String | No | Name for the zip file (default: "Combined_Documents.zip") |
| `zipFileDescription` | String | No | Description for the zip file |
| `shareWithId` | Id | No | Record Id to share the zip file with |
| `shareVisibility` | String | No | Sharing visibility (default: "AllUsers") |
| `shareType` | String | No | Sharing type (default: "V" for Viewer) |

#### Outputs

| Parameter | Type | Description |
|---|---|---|
| `isSuccess` | Boolean | Whether the operation succeeded |
| `contentDocumentId` | Id | Id of the created zip ContentDocument |
| `contentVersion` | ContentVersion | Full ContentVersion record of the zip file |
| `contentDocumentLink` | ContentDocumentLink | Sharing record (if shared) |
| `totalFiles` | Integer | Number of files included in the zip |
| `zipFileSize` | Long | Size of the zip file in bytes |
| `errorMessage` | String | Error details if the operation failed |

---

### File Upload | Serialize File Collection

**Action Name**: `File Upload | Serialize File Collection`

Convert a collection of Flow Tool Kit File wrapper objects into a JSON string for storage. See [JSON & Serialization Actions](json-serialization.md) for details.

---

### File Upload | Deserialize Upload String

**Action Name**: `File Upload | Deserialize Upload String`

Convert a JSON string of file upload data back into a FileUpload wrapper object. See [JSON & Serialization Actions](json-serialization.md) for details.

## Common Patterns

### 1. Invoice PDF Generation
Create a Visualforce page that renders an invoice layout. In your Flow, after an Opportunity is won, use **Generate PDF** to create the invoice PDF, share it with the Opportunity, and optionally email it using an Email Alert.

### 2. Document Package
When a case is closed, collect all related ContentDocuments using a Get Records element, then use **Zip Files** to bundle them into a single archive. Share the zip with the Case or email it to the customer.

### 3. Application File Bundle
In a multi-page Form Template intake flow, users upload supporting documents on each page. At submission, collect all uploaded file Ids and use **Zip Files** to create a single application package.

### 4. File Upload Persistence
After a user uploads files through a Flow Form:
1. The file wrapper objects are returned from the form
2. Use **Serialize File Collection** to convert to JSON
3. Store the JSON on the record for later processing
4. Use **Deserialize Upload String** when you need to access the file data again

## Tips & Considerations

- **Visualforce Page Required**: Generate PDF requires a Visualforce page. The page must be accessible to the running user and render properly as a PDF (standard controller or custom controller).
- **PDF Size Limits**: Visualforce PDF rendering has a 15MB limit. Complex pages with many images may hit this limit.
- **Zip Size**: The zip action combines files in memory. Very large file collections may hit heap size limits. Consider chunking large sets of files.
- **File Sharing**: Both actions support optional file sharing via `shareWithId`. The sharing record (ContentDocumentLink) connects the file to a record so it appears in the Files related list.
- **ContentVersion vs ContentDocument**: Salesforce files have two key objects. ContentDocument is the logical file; ContentVersion is a specific version. The actions return both for flexibility.
- **Existing File Updates**: For Generate PDF, pass a `ContentDocumentId` to create a new version of an existing file rather than a new file. This keeps the file history intact.
