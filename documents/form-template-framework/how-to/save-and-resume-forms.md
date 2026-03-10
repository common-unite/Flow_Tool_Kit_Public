# How To: Save and Resume Forms

> Let users save their progress on multi-page forms and return later to complete them.

{% hint style="info" %}
**Prerequisites**: A Form Template (multi-page form). See [Build a Multi-Page Form](build-multi-page-form.md).
{% endhint %}

## Video Walkthrough

{% embed url="https://vimeo.com/974652702" %}

## Overview

For long or complex forms, users may not be able to complete everything in one session. Save and Resume lets them:
1. Save their progress at any point
2. Close the browser or navigate away
3. Return later and pick up exactly where they left off

All saved data is stored in a **Form Submission** record with a status of "Draft."

## Step 1: Enable Save & Resume

1. Open your Form Template configuration.
2. Enable the **Save & Resume** option.
3. Configure:

| Setting | Description |
|---------|-------------|
| **Save Button Label** | Text on the save button (e.g., "Save Draft") |
| **Auto-Save** | Optionally save automatically at intervals or page transitions |
| **Resume URL** | Where users go to resume (Experience Cloud page, Flow URL) |

## Step 2: Provide a Way to Resume

Users need a way to find and re-open their saved submission:

### Option A: Direct Link
Send the user a link to resume their form (via email notification or on-screen confirmation).

### Option B: Submission List
Create a screen or page that shows the user's draft submissions with a "Continue" button.

### Option C: Auto-Resume
If the user returns to the same form URL and has an existing draft, automatically load their saved progress.

## Step 3: Test

1. Start filling out the form template.
2. Click **Save Draft** partway through.
3. Close the browser.
4. Return via your resume method.
5. Verify:
   - All previously entered data is restored
   - The user returns to the correct page
   - Completing and submitting the form works normally

## How It Works

1. **User clicks Save** → A `Form_Submission__c` record is created with status = "Draft"
2. **Field data is stored** → All entered values are serialized and saved on the submission record
3. **User returns** → The form loads the draft submission and pre-fills all fields
4. **User submits** → The draft is promoted to a full submission (status changes to "Submitted")

## Tips

{% hint style="warning" %}
**Draft submissions are not converted.** Only fully submitted forms go through the conversion process. Drafts remain as-is until the user completes and submits.
{% endhint %}

- **Reminder emails** — consider sending a reminder email after X days if a draft hasn't been completed
- **Draft expiration** — for time-sensitive forms (applications with deadlines), implement logic to expire old drafts
- **Authenticated users only** — Save & Resume requires user identity. Guest users on Experience Cloud need to be authenticated for their draft to be retrievable.

## Related Pages

- [Build a Multi-Page Form](build-multi-page-form.md) — template creation
- [Use Form Submissions](use-form-submissions.md) — submission lifecycle
- [Form Template Framework](../form-template-framework/form-templates.md) — full reference
