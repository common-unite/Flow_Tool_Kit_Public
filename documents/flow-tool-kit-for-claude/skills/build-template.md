# build-template

Builds the approved design as a working draft Form Template in the org.

Run it as `/flow-tool-kit:build-template`, or just describe what you want and Claude picks it.

## What it's for

Turns plan.json into a working draft Form Template, one whole form end to end: the template, its pages and sections, every field with its control and width, every page, section and field rule, the banner and logo, and the form-type settings (Stages, Save Progress, review screen, PDF) from the form-type rules table. A changed plan rebuilds cleanly.

It builds in one of two modes, chosen in the gap round:

- **Records mode**, for fast prototyping: the template and its new or extended components are built as records and JSON sections, with no metadata deploy, so the whole build runs from claude.ai chat with a Salesforce connector. Great for quick design, review and changes. Components the org-catalog review chose to reuse are only referenced, by API name or record, never copied. When the prototype is final, convert-to-metadata turns what it created into metadata.
- **Metadata mode**: metadata components deployed through Claude Code, as before.

## When it's used

After the design, or directly: build this plan, rebuild the template after these changes.

## What you say

- "Build this plan."
- "Rebuild the template after the client's changes."
- "Seed a draft template from plan.json in my sandbox."
- "Add the missing Form Submission fields and rebuild."
- "Compare our templates and tell me which sections should become shared components."

## Inputs

plan.json, the org, and optionally the saved brand kit's assets and styles.

## Outputs

- A draft Form Template ready to preview.
- Each component in the shape the plan names: JSON on its section, a record component created in the org, or a metadata component that build-form-component deploys and the build then places by name.
- New Form Submission fields where the plan needs them, so the form saves end to end.
- A round-trip check: it reads the built template back and compares it with the plan.
- Every rule walked both ways in Preview.
- A review pass that compares sections across templates and proposes promote, switch or keep, so only sections that really repeat become shared components, reused in each template that has them. It is a file you mark up.

## How it connects

- **Calls:** [build-form-component](build-form-component.md) for component JSON and every metadata component; [build-flow-section](build-flow-section.md) and [build-custom-lwc](build-custom-lwc.md) for those sections; then [build-email-templates](build-email-templates.md) and finally [new-mapping-flow](new-mapping-flow.md).
- **Called by:** [ftk-start](ftk-start.md).

## Why it's valuable

It knows the package behavior that trips people up: the default page and section a new template creates, section IDs that change on every save, headers hidden by default, package fields carrying the FlowToolKit__ prefix in a subscriber org, and rules that must be built exactly or the build stops. Brand styles are added to the org's Form Style defaults only where blank.

## Where it runs

Records mode runs entirely in claude.ai chat with a Salesforce connector, or in Claude Code. Metadata mode needs Claude Code, which deploys the metadata components through build-form-component. Anything that is metadata by nature (new fields, flows, Flow Sections, custom LWCs) is handed to Claude Code as a named next step.

## Walkthrough demo

All names and data below are invented. Read the lines aloud as a video script: your words, then what Claude says and does, then the result.

**You:** The client approved the Maple Clinic plan. Build it in the sandbox.

**Claude:** Building from plan.json. Created the template 'Patient Intake' with 3 pages, 7 sections, 31 fields. Contact Details is placed as your existing metadata component, the consent and the insurance questions stay JSON on their sections as you chose, and the emergency contact block, which the plan places in a section and in a Repeater, is one new record component both reference. Added two Form Submission fields: Insurance Member ID and Consent Date. Applied the teal brand styles to the Form Style defaults where blank. Set Save Progress and the review screen.

**Claude:** Round-trip check: I read the template back and it matches the plan on all 31 fields and 4 rules. I walked each rule both ways in Preview: the Member ID shows only for Insured Yes, and the guardian block appears under 18.

**Result.** A draft Form Template you can open in Preview, with the check results in a file. Next Claude adds the confirmation email and the conversion flow.

[Back to all skills](../README.md)
