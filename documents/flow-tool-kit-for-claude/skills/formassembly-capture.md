# formassembly-capture

Archives and reads a whole FormAssembly account at once, connectors included.

Run it as `/flow-tool-kit:formassembly-capture`, or just describe what you want and Claude picks it.

## What it's for

Archives and reads a whole FormAssembly account: every form with its design, field aliases, calculations, show/hide rules, and its prefill and submit connectors. It is for a full move off FormAssembly. For one form, use form-migrate.

## When it's used

You say 'we are leaving FormAssembly, convert the whole account', or you want an archive before an account closes.

## What you say

- "We are leaving FormAssembly. Convert the whole account."
- "Archive every form in our FormAssembly account."
- "Which of our FormAssembly forms hand off to each other?"
- "List every prefill and submit connector we have."
- "Repeat the FormAssembly archive for our second client."

## Inputs

By default, an export file or your FormAssembly API key (read from your environment, never written to a file). Then Claude asks: 'Do you also want to review the Salesforce connectors (prefill and post)? That needs Chrome access so Claude Code can log in to FormAssembly as you.' Only on a yes does it open a browser, and you sign in yourself; Claude never types your password.

## Outputs

- An inventory of every form (responses, last used, status).
- Per form: the logic in plain words, every prefill and submit mapping, and the form-migrate description, ready to rebuild.
- An account map: which forms hand off to which, the URL parameters each prefill expects, which objects each form reads or writes, and the sections shared across forms.
- A flow plan that turns FormAssembly's one-connector-per-form model into Flow Tool Kit's shared conversion and prefill flows per object.
- Readable summary pages.
Client secret keys are blanked at capture, and its check refuses to finish if any remain.

## How it connects

- **Calls:** Hands each form to [form-migrate](form-migrate.md)'s description, then [form-design](form-design.md) and [build-template](build-template.md); the flow plan to [new-mapping-flow](new-mapping-flow.md); shared-section candidates to [build-form-component](build-form-component.md).
- **Called by:** [ftk-start](ftk-start.md).

## Why it's valuable

A whole account in one pass instead of form by form. The flow plan is the part that is hardest to work out alone: it turns dozens of connectors into a handful of shared conversion rules.

## Where it runs

Claude Code, local or web (add *.formassembly.com and *.tfaforms.com to the web environment's allowed domains). Default needs no browser.

## Walkthrough demo

All names and data below are invented. Read the lines aloud as a video script: your words, then what Claude says and does, then the result.

**You:** Harbor Food Bank is closing its FormAssembly account next month. Convert everything.

**Claude:** I will use your API key from the environment. I found 18 forms. 11 had responses in the last year; 7 are unused. I read the form definitions and logic for all 18. Do you also want to review the Salesforce connectors (prefill and post)? That needs Chrome access so Claude Code can log in to FormAssembly as you.

**You:** Yes, the connectors matter.

**Claude:** Opening a browser window. Please sign in to FormAssembly; I will wait. ... Thank you. I opened each connector and read every object mapping. Secret keys are blanked.

**Claude:** Account map: 18 forms collapse into 4 conversion rules (Contact and Household, Volunteer Shift, Donation Pledge, Event Registration) and 3 prefill flows. Five forms share one Emergency Contact section, so it becomes one reusable component.

**Result.** An archive folder, an account map and a flow plan, with each form queued for design and build.

[Back to all skills](../README.md)
