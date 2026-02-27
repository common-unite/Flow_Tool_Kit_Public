# Form Templates
> Build multi-page, multi-section forms with built-in navigation, progress tracking, and save-and-resume capability — all driven by a template record structure.

## Overview

Form (Template) enables multi-page forms that go beyond what a single Flow Screen can offer. Instead of cramming everything onto one screen or building complex multi-screen flows manually, you define a Form Template record with pages and sections, and the component handles navigation, progress tracking, and form rendering automatically.

Form Templates use a record-based structure: a Form Template contains Pages, and each Page contains Sections. Each section references a Form (built in Form Builder), and the component renders the appropriate form for each section. Users navigate between pages with built-in or custom navigation, and the component tracks their progress.

This is especially useful for long intake forms, applications, surveys, and any scenario where users need to complete information across multiple logical pages — potentially saving progress and returning later.

## Where to Use It

- **Flow Screen** (with full navigation and submission support)
- **App Page**
- **Record Page**
- **Home Page**
- **Experience Cloud** (Community Page and Default)

## Quick Start

1. **Create a Form Template** — Create a `Form_Template__c` record with a name and description.
2. **Add Pages** — Create `Form_Template_Page__c` records linked to the template, each with a page number and label.
3. **Add Sections** — Create `Form_Template_Page_Section__c` records linked to each page. Each section references a Form (built in Form Builder) via the Form name field.
4. **Add to Screen** — In Flow Builder, drag "Form (Template)" onto a screen and pass the Form Template record Id.
5. **Process Output** — After the screen, use the `currentPage`, `priorPage`, and `formSubmission` outputs to track navigation and save data.

## Properties

### Inputs (Flow Screen)

| Property | Type | Required | Default | Description |
|---|---|---|---|---|
| `recordId` | String | Yes | — | The Id of the Form Template record (`Form_Template__c`) |
| `isFlow` | Boolean | Yes | false | Set to true when used inside a Flow |
| `disableAll` | Boolean | No | — | Read-only mode — disables all form editing |
| `currentPageId` | String | No | — | Id of the current page (for resuming at a specific page) |
| `formSubmission` | Form_Submission__c | No | — | Existing Form Submission record (for save-and-resume) |
| `relatedRecords` | Form_Submission__c[] | No | — | Collection of related submission records |

### Inputs (Record/App/Home Page)

| Property | Type | Required | Default | Description |
|---|---|---|---|---|
| `recordId` | String | Yes* | — | Form Template record Id (auto-set on Record Pages) |
| `relatedFieldName` | String | No | — | Field name to filter templates by related record |
| `disableAll` | Boolean | No | — | Read-only mode |

### Inputs (Experience Cloud)

| Property | Type | Required | Default | Description |
|---|---|---|---|---|
| `recordId` | String | Yes | {!recordId} | Form Template record Id |
| `relatedFieldName` | String | No | — | Field name for related record filtering |
| `disableAll` | Boolean | No | — | Read-only mode |

### Outputs (Flow Screen)

| Property | Type | Description |
|---|---|---|
| `currentPage` | Form_Template_Page__c | The page the user is currently viewing |
| `priorPage` | Form_Template_Page__c | The previous page the user was on |
| `buttonClicked` | Button (Apex-Defined) | The custom button clicked (if using custom navigation) |
| `formSubmission` | Form_Submission__c | The form submission record (for save-and-resume) |
| `saveProgress` | Boolean | True when the user clicked "Save Progress" |

## How It Works

**Template Structure**: The hierarchy is Template → Pages → Sections → Forms:
- `Form_Template__c` — The top-level container with name, description, and settings
- `Form_Template_Page__c` — Individual pages within the template, ordered by page number
- `Form_Template_Page_Section__c` — Sections within each page, each referencing a Form built in Form Builder

**Page Navigation**: The component renders one page at a time with navigation controls. Users move forward and backward through pages. Each page displays its sections with the corresponding forms.

**Save and Resume**: When `formSubmission` is provided, the component loads previously saved data. The `saveProgress` output signals when the user wants to save their progress. Your Flow handles the actual DML to save/load the Form Submission record.

**Record Page / App Page**: Outside of Flows, the component renders the template's pages inline with the option to filter by a related record field.

## Works With

| Component | Integration |
|---|---|
| **Flow Form** | Each template section renders a Flow Form instance |
| **Form Builder** | Forms referenced by sections are built in Form Builder |
| **Custom Buttons** | Custom navigation buttons integrate via `buttonClicked` output |
| **Form Submissions** | Save-and-resume capability via Form_Submission__c records |
| **Themes** | Theme applied to all forms within the template |

## Common Patterns

### 1. Multi-Page Application
Create a template with 4 pages: "Personal Info", "Employment", "Education", "Review". Each page has 1-3 sections referencing different forms. Users navigate freely between pages.

### 2. Save and Resume Survey
Build a long survey template. Pass a `formSubmission` record to persist progress. When `saveProgress=true`, update the submission record. When users return, pass the same submission to resume where they left off.

### 3. Read-Only Template Viewer
Set `disableAll=true` to display a completed template in read-only mode. Useful for review screens or displaying submitted data on record pages.

## Tips & Considerations

- **Page Order**: Set page numbers on `Form_Template_Page__c` records to control display order. Gaps are fine (10, 20, 30) — they're sorted numerically.
- **Section Order**: Sections within a page are also ordered. Each section should reference a valid Form QualifiedApiName.
- **Flow Loop Pattern**: For save-and-resume in Flows, use a loop: display the template screen → check if `saveProgress` is true → if yes, save the submission and loop back to the same screen → if no (user clicked Next/Finish), proceed with the flow.
- **Experience Cloud**: Works in Experience Cloud with `{!recordId}` binding for the template Id.
- **Related Field Filtering**: Use `relatedFieldName` when you want to show only template pages/sections relevant to a specific record (e.g., filtering by account type).
