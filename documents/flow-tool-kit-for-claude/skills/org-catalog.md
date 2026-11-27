# org-catalog

Maps the org's existing Flow Tool Kit components and templates so nothing is rebuilt by accident.

Run it as `/flow-tool-kit:org-catalog`, or just describe what you want and Claude picks it.

## What it's for

Reads every Form Component, every Form Template with its pages and sections, and the layers between them: which components are built from other components, and which sections repeat across templates. A Form Template is one whole form, end to end; what gets reused is the Form Components placed in it. The result is a reuse map of those components. It also holds the edition answer (free or paid) that ftk-start collects.

Every component and section is reported with its shape, one of three ways Flow Tool Kit stores a form's questions:

- **JSON on the section**: questions attached directly to one section, one form component inside a flow, or one dynamic form component on an Experience Cloud page. The default for a new section: the easiest to build and change, and it cannot conflict with a shared component. The trade-off: every edit is made in each place.
- **Record component**: a Form Component record built as data right in the org, with no deploy. Recommended when reuse is known at design time: the design asks the same questions in more than one place (a section and a Repeater on one form, or several forms), or the org already has them built in place on other templates. It is built right away and every place references it.
- **Metadata component**: custom metadata, deployable to every org and version controlled, so one update reaches every Form Template, flow and Lightning record page form that uses it. Not recommended for new work: a shared component becomes metadata through convert-to-metadata once it is final, or when you ask for it.

## When it's used

Always, first, before any design. ftk-start runs it every time. You can also ask it directly.

## What you say

- "What components do we already have?"
- "Can this form reuse our address block?"
- "Catalog the org before we design anything."
- "Which sections repeat across our templates?"
- "Refresh the catalog, we added two templates yesterday."

## Inputs

The connected org.

## Outputs

A catalog file: components with their shape, fields and layers, templates with their sections (each section's shape), repeated sections, existing mapped forms per object, and the edition answer. With no org connected it says so in one line instead of being silently empty. [form-design](form-design.md) refuses to start without a fresh catalog.

## How it connects

- **Calls:** Nothing.
- **Called by:** [ftk-start](ftk-start.md) (always), [form-design](form-design.md) (required input), [build-form-component](build-form-component.md) (reads it).

## Why it's valuable

It is the step that stops duplicate building. Every section in the design is marked reuse (an existing component), extend (a new version of an existing component plus fields) or new, and Claude always asks which, naming the existing component. For anything extended or new it also recommends a shape with the reason, and asks: JSON on the section by default, a record component when reuse is known at design time, and an extended component in the original's shape. It never reuses or picks a shape silently.

## Where it runs

Claude Code (reads metadata and records). In chat with a Salesforce connector it reads Form Template records only; chat without one says so in a line.

## Walkthrough demo

All names and data below are invented. Read the lines aloud as a video script: your words, then what Claude says and does, then the result.

**You:** Before we design the Harbor Food Bank volunteer form, what do we already have in the org?

**Claude:** I am reading the org now. You have 14 Form Components (9 metadata, 5 record) and 6 Form Templates. The most reused components are Contact Details (a metadata component, used in 4 templates) and Mailing Address (metadata, 3 templates). An Emergency Contact section is built in place as JSON on 2 templates. There is also a mapped form on Contact that lands on the packaged Contact 1 fields.

**Claude:** For the volunteer form I would use Contact Details as it is (it stays a metadata component), extend Mailing Address with a Neighborhood field, and build Availability as new. For the new version of Mailing Address I recommend a metadata component: Mailing Address is metadata today and sits on 3 templates, so one deployed update keeps reaching all of them. For Availability I recommend JSON on its section: only this form asks it, so it is the simplest and cannot conflict with a shared component; a record component if you already know another form will ask it. Do you want to reuse Contact Details, extend Mailing Address as metadata, and create Availability new as JSON on its section? I will not change anything until you say.

**You:** Yes to all three.

**Result.** A catalog file saved in the project, with every component's shape, and the three choices and two shapes recorded per section in the design plan.

[Back to all skills](../README.md)
