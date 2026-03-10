# How To: Build a Multi-Page Form

> Create a multi-page form using the Form Template Framework — pages, sections, navigation, and save & resume.

{% hint style="info" %}
**Prerequisites**: Familiarity with single-page forms in Form Builder. See [Build a Form](build-a-form.md) if you're new to Flow Tool Kit.
{% endhint %}

## Video Walkthrough

{% embed url="https://vimeo.com/976953865" %}

## Overview

![Form Template record page overview](../../screenshots/form-template-framework/overview/template-record-page-overview.png)

For complex data collection — applications, intake forms, surveys — a single-page form isn't enough. The **Form Template Framework** lets you build multi-page forms with:
- Multiple pages with ordered navigation
- Sections within each page
- Page-level conditional logic (show/hide entire pages)
- Save and resume (users can return later)
- Form submissions with review mode
- Automatic conversion to Salesforce records

The architecture is: **Template → Pages → Sections → Forms**

## Step 1: Build the Individual Forms

Each page of your multi-page form uses a standard Form Builder form. Create one form per page:

1. Open **Form Builder** and create forms for each page:
   - "Applicant Info" (Contact fields)
   - "Organization Details" (Account fields)
   - "Application Questions" (custom object fields)
2. Add sections and fields to each form as usual.
3. Save all forms.

## Step 2: Create a Form Template

1. Navigate to the **Form Templates** tab (or the Form Template section in Form Builder).
2. Click **New Template**.
3. Configure the template settings:

| Setting | Description | Example |
|---------|-------------|---------|
| **Name** | Template display name | "Grant Application 2026" |
| **Description** | What this template is for | "Annual grant application form" |
| **Active** | Whether the template is available | `true` |

## Step 3: Add Pages

1. Within the template, click **Add Page**.
2. For each page, set:

| Setting | Description |
|---------|-------------|
| **Page Label** | Displayed in the navigation bar (e.g., "Step 1: Your Info") |
| **Position** | Page order (1, 2, 3...) |

3. Repeat for each page in your workflow.

## Step 4: Add Sections to Pages

Each page contains one or more sections, and each section references a Form you built in Step 1:

1. Select a page.
2. Click **Add Section**.
3. Select the **Form** to use for this section (e.g., "Applicant Info").
4. Set the section order if the page has multiple sections.

## Step 5: Add the Template to a Flow

1. In Flow Builder, create a Screen Flow.
2. Add a **Form Template** screen component.
3. Configure:
   - Select your template
   - Assign record variables as needed
4. The component handles page navigation, validation, and submission automatically.

## Step 6: Test

1. Debug the Flow.
2. Verify:
   - Pages appear in order with working navigation (Next/Previous)
   - Fields render correctly on each page
   - Navigation validates required fields before proceeding
   - The final page submits successfully

## Optional: Enable Save & Resume

Allow users to save their progress and return later:

1. In the template settings, enable **Save & Resume**.
2. When users click "Save", their progress is stored as a Form Submission record.
3. When they return, previously entered data is restored.

See [Save and Resume Forms](save-and-resume-forms.md) for detailed configuration.

## Optional: Add Page Conditional Logic

Show or hide entire pages based on answers from previous pages:

- Example: Only show "Spouse Information" page when Marital Status = "Married" on the first page

See [Form Template Framework](../form-template-framework/form-templates.md) for page-level conditional logic configuration.

## What's Next

- [Use Form Submissions](use-form-submissions.md) — capture, review, and convert submission data
- [Save and Resume Forms](save-and-resume-forms.md) — let users save progress
- [Set Up Email Notifications](set-up-email-notifications.md) — send emails on submission
- [Create PDF from Submission](create-pdf-from-submission.md) — generate PDFs from form data

## Related Pages

- [Form Template Framework](../form-template-framework/form-templates.md) — full reference documentation
- [Form Submissions](../form-template-framework/form-submissions.md) — submission lifecycle
- [Core Concepts](../getting-started/core-concepts.md) — forms vs. templates comparison
