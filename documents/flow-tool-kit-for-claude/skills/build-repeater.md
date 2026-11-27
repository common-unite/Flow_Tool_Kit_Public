# build-repeater

Builds a Repeater page section or repeating flow screen component.

Run it as `/flow-tool-kit:build-repeater`, or just describe what you want and Claude picks it.

## What it's for

A Repeater is not a component: it is a Form Template page section type, and a flow screen component (**Form (Repeater)**), that repeats one form component row by row with every question of the row on the page. This skill sets the Repeater's own settings: the minimum and maximum rows, the New, Clone and Delete actions and their labels, row spacing and the divider, the Pre-fill Template, the Section Tag a prefill flow fills, the conversion setting and the header. It checks them against the package's property list in your org and writes them where they belong.

## When it's used

After [repeating-data](repeating-data.md) chose a Repeater, when build-template reports a section marked Repeater, or directly: let people add up to four household members, make this section repeat.

## What you say

- "Let people add up to four household members."
- "Make the additional contacts section repeat."
- "Change the Repeater's button to Add and allow up to ten rows."
- "Put a repeating list of shifts on the volunteer flow screen."
- "Prefill the Repeater with the contacts already on the account."

## Inputs

The decision from repeating-data or from you (rows, questions in one row, where it goes, the row component's shape, prefill), the connected org, and its Data Conversion Tag(s) values.

## Outputs

One spec per Repeater, checked by its script, then written where it goes:
- **A page section in a planned form:** the keys on the section in plan.json, so build-template rebuilds them every time.
- **An existing page section:** an update to the section record, through Claude Code or a Salesforce connector.
- **A screen flow:** the Form (Repeater) component ready to paste into the screen, beside the rows' record collection.

The check fails a missing component, a minimum above the maximum, a button label the section editor cannot keep (New, Add, Create, Insert; Clone, Copy, Duplicate; Delete, Remove, Clear), a planned prefill with no Section Tag or a tag the org lacks, and any property the package does not have. It warns when the rule points to a Table instead.

## How it connects

- **Calls:** [build-form-component](build-form-component.md) for the row component, [new-mapping-flow](new-mapping-flow.md) for the prefill flow and any custom row conversion, [build-flow-section](build-flow-section.md) for a Repeater inside a Flow Section.
- **Called by:** [repeating-data](repeating-data.md), [build-template](build-template.md); standalone.

## Why it's valuable

A Repeater's defaults surprise people: a blank maximum falls back to a default, a minimum of 1 starts optional rows with an empty one, Edit does nothing on a page section, and a section left on the Default conversion ignores a custom flow. A planned section edited by hand in Form Builder is replaced on the next rebuild. The skill sets every value on purpose, reads your org's own property list so an older Flow Tool Kit version is respected, and finishes with a Preview Form walk that includes removing a saved row and seeing it deleted.

## Where it runs

Claude Code (local or web) does everything, including deploying a flow that carries the component. claude.ai chat writes and checks the spec, and with a Salesforce connector updates an existing section record.

## Walkthrough demo

All names and data below are invented. Read the lines aloud as a video script: your words, then what Claude says and does, then the result.

**You:** Build the children Repeater on the Maple Street Youth League registration form, from the spec.

**Claude:** Read the spec: rows from 0 to 6, the row is four questions as JSON on the section, New labelled Add and Delete labelled Remove, prefill by the Section Tag Contacts, each row converted with the Contact rule. Your org has every Repeater field the spec uses and the Contacts tag. The check passed with no warnings. The form is built from a plan, so I put the settings on the section in plan.json and rebuilt with build-template.

**You:** Does it work?

**Claude:** I walked it in Preview Form at desktop and phone width. The section starts empty with an Add button; at six rows Add disappears. Opened from a household with two children, both appear as rows. I saved, removed one, saved again: its submission was deleted.

**Result.** A Repeater whose limits, labels, prefill and conversion are all set on purpose, and kept on every rebuild.

[Back to all skills](../README.md)
