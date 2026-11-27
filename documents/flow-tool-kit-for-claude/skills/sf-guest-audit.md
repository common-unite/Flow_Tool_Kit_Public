# sf-guest-audit

Check your client's guest exposure: what an anonymous visitor's browser receives from the forms on a site you built, and what the guest can read, run or call.

Run it as `/flow-tool-kit:sf-guest-audit`, or just describe what you want and Claude picks it.

## What it's for

A guest form can look safe on screen and still send far more to the browser. The common case: a guest screen flow running in System Mode uses a standard Get Records, which stores every field, and passes the whole record into a form component. Every field value (a date of birth, internal notes, the owner) then reaches the visitor's browser and is readable in the developer console, even though the form shows only five of them.

This skill finds that, in three parts after one short interview:

1. **Live guest pass.** Opens each form as a logged-out visitor, fills it in with fake data, follows the prefill links you give it, and lists every field the browser received, marked shown on screen or not, with the likely sensitive ones flagged (birth dates, government ids, financial, health, internal notes, owner and audit fields, and another person's record).
2. **Flow review** (needs the org's metadata). Flags guest flows in System Mode that pass a whole Get Records record to a screen or form component without the Flow Tool Kit **FLS Record(s) Sanitizer** action in between, and flows that look a record up by a value from the link.
3. **Setup audit.** Reads each site's guest profile, permission sets, guest sharing rules and how many records they share, site settings, guest flows and Apex, read only, with an opt-in outside probe from the public URL.

The first fix it recommends for a flow sending whole records: pass the record through the FLS Record(s) Sanitizer before the form. It removes every field the guest has not been granted, so the guest's profile and permission sets decide what the form receives, the normal way. Then narrow the guest's field access, query only the needed fields, avoid System Mode where you can, and keep prefill templates to defaults.

It never writes to the org and never fixes anything itself; granting what a guest needs, and changing guest flows, is [flow-access-fix](flow-access-fix.md).

## When it's used

Before a guest form or prefilled Form Template goes public, after changing a guest flow, a guest permission set or a sharing rule, or when a client asks what the public can see.

## What you say

- "Check my client's guest exposure on this site."
- "Is the prefilled renewal form leaking anything to the browser?"
- "Review the guest flows before the site launches."
- "What does an anonymous visitor actually receive from the sign-up form?"
- "Did opening that sharing rule expose too much?"

## Inputs

From the interview, with defaults offered:
- The site, and your confirmation that you are authorized by your client to test it (a sandbox site is preferred).
- The form addresses, and any real prefill links with their parameters, each for a test record.
- The guest flows to review (by default every flow granted to the guest).
- Whether to fill and step through the forms (default yes, with fake data) and whether to submit (default no).

## Outputs

- `exposure.md`: per form, every record and field the browser received, shown or not, what each looks like, a severity and the fixes in order.
- `flow-review.md`: per flow, the element, the component and the exact fix.
- `findings.md`: the setup audit, each finding with its fix.
- `guest-report.md`: one row per form or flow, what is exposed, how serious, and the first fix.

Reports hold field names and the kind of each value, never the value, so they can go to the client. The raw captures stay in your project folder, out of version control.

## Safety rules

- Only a site you are authorized to test for your client; a sandbox first.
- Fake test data only; never payment, password or file fields.
- It stops on the last page without submitting unless you say yes for that form.
- It never tries to get past a sign-in, a CAPTCHA or bot protection.
- It reads only what the browser receives, uses prefill links exactly as given, and never edits a link to reach someone else's record.

## How it connects

- **Calls:** Nothing.
- **Called by:** [ftk-start](ftk-start.md), [flow-access-fix](flow-access-fix.md) after wiring guest access, and [build-site-pages](build-site-pages.md) and [build-template](build-template.md) once a guest form or site is ready.
- **Hands over to:** [flow-access-fix](flow-access-fix.md) for changes to guest flows, flow grants and guest sharing rules.

## Why it's valuable

It checks what a visitor really gets, not what the page shows, and points at the exact flow element to fix. Teams can build guest flows and prefilled Form Templates for their clients that send only what each form needs.

## Where it runs

- **Claude Code (local or web):** all three parts. The live pass runs headless with Playwright; the flow review and setup audit use the Salesforce CLI.
- **claude.ai chat:** the live pass from a HAR file you save with your browser's developer tools (Claude gives the steps); the flow review on flow files you upload; the setup audit through a Salesforce connector.

## Walkthrough demo

All names and data below are invented. Read the lines aloud as a video script: your words, then what Claude says and does, then the result.

**You:** Check the volunteer renewal form on the Riverside Community Garden sandbox site. I'm authorized to test it. Here's a prefill link for our test volunteer.

**Claude:** Opening it as a logged-out visitor, filling it with fake data and stopping on the last page without submitting. The form shows first name, last name and email, but the browser received seven fields for the test volunteer, including Birthdate and Case Notes, which are never shown.

**Claude:** The flow review explains why: Volunteer Renewal runs in System Mode, Get Contact stores all fields, and the whole record goes into the Form (Component). The fix: add the FLS Record(s) Sanitizer after Get Contact and pass its Record output to the form, then keep the guest's field access to the three fields the form shows.

**Result.** A report with one HIGH form and one HIGH flow, each with its exact fix, and no personal data in it.

[Back to all skills](../README.md)
