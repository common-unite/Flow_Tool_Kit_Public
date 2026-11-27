# build-email-templates

Builds the confirmation and resume-link emails a Form Template sends.

Run it as `/flow-tool-kit:build-email-templates`, or just describe what you want and Claude picks it.

## What it's for

Designs and builds the emails a Form Template sends: a confirmation per form and a resume-link email for forms with Save Progress. They are Lightning Email Templates on Form Submission, so the form's own answers merge in.

## When it's used

By build-template, right after the template is built, so every form ships with its confirmation; or directly: add a confirmation email to this form.

## What you say

- "Add a confirmation email to this form."
- "Redo the confirmation for the scholarship form."
- "Add a resume-link email so people can come back to their saved form."
- "Write the thank-you email in the organization's voice."
- "Send a test submission and show me the email."

## Inputs

The form's plan (fields, program, form type), optionally the brand kit for the letterhead (logo, colors, button), and the org's Asset Library images.

## Outputs

- A confirmation template per form, with a subject and body written for that form: a thank-you, what was received (key answers as merge fields), what happens next, and a contact. At least two paragraphs, a next step and a contact.
- One shared resume-link template with the resume button wired.
- Both deployed, set on the Form Template's confirmation and resume fields, and proven with a test submission whose email is read back.

## How it connects

- **Calls:** Nothing.
- **Called by:** [build-template](build-template.md); [form-design](form-design.md) draws the emails first. Reads the saved [brand-kit](brand-kit.md).

## Why it's valuable

Every real form needs a confirmation, and merge syntax and deploy order are easy to get wrong (direct fields only, never a relationship; images referenced by asset name; the unfiled public folder). This is one step proven by a real email.

## Where it runs

Claude Code.

## Walkthrough demo

All names and data below are invented. Read the lines aloud as a video script: your words, then what Claude says and does, then the result.

**You:** Add the confirmation email for the Riverbend Arts Fund grant application.

**Claude:** I used the saved brand kit for the letterhead: the teal button and the logo. Subject: 'We received your Riverbend grant application'. Body: a thank-you with their name, a line with the project title and amount they requested, what happens next (a program officer will reply within 10 business days) and a contact. I also made the shared resume email for people who save and come back.

**Claude:** Deployed both, set them on the template, and submitted a test application. The email arrived with the name, project title and amount merged in, and the logo displayed.

**Result.** A confirmation and a resume email, attached to the form and proven by a test send.

[Back to all skills](../README.md)
