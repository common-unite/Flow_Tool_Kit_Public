# convert-to-metadata

Turns a finished prototype into metadata: the record components and JSON sections a records-mode build created become metadata components.

Run it as `/flow-tool-kit:convert-to-metadata`, or just describe what you want and Claude picks it.

## What it's for

Records mode lets you design, review and change a Form Template fast, straight from claude.ai chat, with no deploy. When the client approves it, this skill makes it permanent: the new and extended components the build created as records, and the questions kept as JSON on a section, become metadata components that live in your project's source control and deploy to every org. Components the form only references (an existing metadata component, a packaged one, or a record component the catalog review chose to reuse) are left exactly as they are.

## When it's used

When a prototype is approved, or directly: convert this form to metadata.

## What you say

- "The prototype is approved, make it metadata."
- "Convert the volunteer application to metadata."
- "Move this form's record components into the repo."
- "Turn the JSON sections on this template into components."

## Inputs

The Form Template, form-design's plan.json (which records every reuse, extend and new answer) and the connected org.

## Outputs

- A dry run to approve first: every component and section it would convert and why, the metadata names it would create (checked so nothing in the org is overwritten), every component it leaves alone and why, and every section it would point at the new component.
- The metadata files in your project, deployed after a validation, then a check that the template now draws from them.
- A rollback script, written before anything changes.
- The original records are deleted only in a separate step, after you have checked the converted template.

## How it connects

- **Calls:** Uses [build-form-component](build-form-component.md)'s writer, so a converted component is the same as one built as metadata from the start.
- **Called by:** You, when the prototype is final, usually after [build-template](build-template.md) ran in records mode.

## Why it's valuable

Prototyping as records is fast; shipping as metadata is safe. This skill is the bridge, and it converts only what the prototype created, so shared components other forms rely on are never copied or changed.

## Where it runs

The dry run runs in claude.ai chat with a Salesforce connector, or in Claude Code. Writing and deploying the metadata needs Claude Code (local or web).

## Walkthrough demo

All names and data below are invented. Read the lines aloud as a video script: your words, then what Claude says and does, then the result.

**You:** Riverbend approved the grant application prototype. Make it metadata.

**Claude:** Here is the dry run. Two pieces were built for this form and become metadata components: the Project Budget component and the questions on the Eligibility section. Three stay as they are: your Contact Details and Mailing Address components, which other forms use, and the packaged header. Two sections will point at the new components. Nothing in the org has these names yet. Shall I go?

**You:** Go.

**Result.** The two components are in the project as metadata, deployed and checked, and the template draws from them. The original records stay until you say to remove them.

[Back to all skills](../README.md)
