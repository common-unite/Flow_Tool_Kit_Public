# build-form-component

Designs and writes Form Components in the shape that fits: a metadata component, a record component or JSON.

Run it as `/flow-tool-kit:build-form-component`, or just describe what you want and Claude picks it.

## What it's for

Designs and writes Flow Tool Kit Form Components: blocks of questions or display content, such as contact details, one household member, a survey or Likert scale, a consent, or a table. A table is a form component too; it renders through the Table component. A Repeater is not a component: it is a page section type, and a flow screen component, that repeats a form component, so this skill builds the block and the section or screen repeats it. It decides where a component's boundaries are, so a reusable block is built once and placed in many Form Templates (a Form Template is one whole form; reuse is always of components).

It builds all three shapes, and recommends which one with the reason before asking:

- **JSON on the section** (the default): every new section unless reuse is known at design time. The easiest to build and change, and it cannot conflict with a shared component. If the same questions turn up on other forms later, they are merged into one shared component then.
- **Record component**: when reuse is known at design time, such as a contact block asked once as the main contact and again inside a Repeater for additional contacts. Built right away as data in the org with no deploy, and every section and Repeater that uses it references it.
- **Metadata component**: when a shared component is final and should live in version control, so one deployed update reaches every Form Template, flow and Lightning record page form that uses it. Reached through convert-to-metadata once the work is final, or built as metadata when you ask for it; a change is a deploy.
 On another object, it also writes the form's Form Template Mapping (each field's target and 'Apply these mappings to'), using one lookup per record when a submission makes two of the same object. On a free-edition org it falls back to building on Form Submission.

## When it's used

By build-template for every section, or directly: make this section a reusable component, build a table of line items.

## What you say

- "Make this section a reusable component."
- "Build a table of household members."
- "Make a Likert scale for our satisfaction survey."
- "Add conditional logic: show Other when Referral Source is Other."
- "Put preset donation amounts of 25, 50 and 100 on this form."

## Inputs

The section design from plan.json, plus the existing components from org-catalog.

## Outputs

A metadata component (Form, Form Section and Form Field custom metadata, deployed), a record component (loaded into the org) or JSON for one section, flow or page, correctly namespaced for your org, with conditional logic, option labels, preset amounts, and every rule and section labeled in plain words.

## How it connects

- **Calls:** Reads [org-catalog](org-catalog.md). May call [pull-form](pull-form.md) and [new-record-page-form](new-record-page-form.md).
- **Called by:** [build-template](build-template.md); [ftk-start](ftk-start.md).

## Why it's valuable

It is the Flow Tool Kit component encyclopedia: the keys, the patterns that work and the traps (the Builder saving raw field IDs, namespace prefixes, platform cache needing a reset after a redeploy).

## Where it runs

Claude Code (all three shapes; a metadata component needs it to deploy) and claude.ai chat (record components and JSON; when you ask for metadata in chat, Claude asks whether to build a record component now or wait for Claude Code).

## Walkthrough demo

All names and data below are invented. Read the lines aloud as a video script: your words, then what Claude says and does, then the result.

**You:** Harbor Food Bank's partner application asks "Who is your main support contact?" and then lets them add more contacts, as many as they need.

**Claude:** I checked the catalog and there is no contact block for partner agencies yet. Both places ask the same questions: name, email, phone and role as a picklist (Director, Coordinator, Volunteer Lead, Other). The main contact is one section, and the additional contacts are a Repeater section that repeats the same block, up to five more contacts. I used your org's namespace on the field names. Which shape: I recommend one record component, Partner Contact, built now: the main contact section and the Repeater both reference it, so one change reaches both. JSON on each would mean two copies to keep in step, and metadata can come later through convert-to-metadata once the form is final. Record, JSON or metadata?

**You:** Record.

**Claude:** Created Partner Contact as a record component in the org. The 'Main support contact' section and the 'Additional contacts' Repeater both point at it. The 'Programs you run' questions only this form asks, so they stay JSON on their section, as you chose earlier.

**Result.** One record component, built in the org with no deploy, referenced by a section and a Repeater on the same form, and listed in the catalog so a later form can reuse it.

[Back to all skills](../README.md)
