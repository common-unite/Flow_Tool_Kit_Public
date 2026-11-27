# build-table

Builds a Table page section or table screen component, with its row form.

Run it as `/flow-tool-kit:build-table`, or just describe what you want and Claude picks it.

## What it's for

A Table is a form component rendered as a page section of type Table, or as the **Form (Table)** flow screen component. It shows a few key columns, one line per row; New, Edit and Clone open a window with the **row form**, a second component holding every question of one row. Use it for many rows (about five or more) or many questions per row, or to keep a long page compact. This skill sets the table component and its key columns, the row form, the bulk form, the actions with their labels and window wording, the display settings and the Section Tag a prefill flow fills, checks them against your org's property list and writes them where they belong.

## When it's used

After [repeating-data](repeating-data.md) chose a Table, when build-template reports a Table section, or directly: list the 20 volunteers in a table, keep this section compact and edit each row in a window.

## What you say

- "List the 20 volunteers in a table."
- "Keep this section compact; edit each row in a window."
- "Show first name, last name and email, and put the rest in the edit window."
- "Let staff change several selected rows at once on the flow screen."
- "Rename the delete window to Remove this volunteer?"

## Inputs

The decision from repeating-data or from you (rows, the key columns, every question of one row, where it goes, the shapes, prefill), the connected org, and its Data Conversion Tag(s) values.

## Outputs

Two components, both built by build-form-component: the **table component** with three or four key columns, and the **row form** with every question, as a named record or metadata component (the window loads it by name, so it is never JSON). Then one checked spec per Table, written into plan.json, onto an existing section record, or as the flow screen component. The row form name goes in both fields that read it, so the form and the record page's Page Section Preview open the same window.

The check fails New, Edit or Clone with no row form, a row form given as JSON or equal to the table component, an unknown row style, and bulk edit without a bulk form. It warns when the rule points to a Repeater instead, and names the settings a page section does not apply.

## How it connects

- **Calls:** [build-form-component](build-form-component.md) for the table component and the row form, [new-mapping-flow](new-mapping-flow.md) for the prefill flow and any custom row conversion, [build-flow-section](build-flow-section.md) for a Table inside a Flow Section.
- **Called by:** [repeating-data](repeating-data.md), [build-template](build-template.md); standalone.

## Why it's valuable

A Table has traps that only show once people use it: an empty edit window when the row form is missing, a window showing only the key columns when the table component is reused as the row form, and a maximum the Table does not enforce. On a page section the display switches apply only in the Page Section Preview, and bulk edit is a flow screen feature. The skill says these plainly before you rely on them, and finishes with a Preview Form walk of New, Edit, Clone and Delete.

## Where it runs

Claude Code (local or web) does everything, including deploying a flow that carries the component. claude.ai chat writes and checks the spec, and with a Salesforce connector updates an existing section record.

## Walkthrough demo

All names and data below are invented. Read the lines aloud as a video script: your words, then what Claude says and does, then the result.

**You:** The Lakeshore Cleanup Day sign-up form needs a volunteer roster. Teams bring up to 20 people, and each has nine questions.

**Claude:** A Table, from the spec: the table shows First name, Last name and Email, and Add or Edit opens a window called Volunteer details with all nine questions. The row form must be a named component, so build-form-component made Volunteer Details as a record component and the table component with the three columns. The check passed. One thing to know: the Table does not enforce a maximum, so if 20 is a hard limit, the conversion should check the count.

**You:** That's fine, 20 is a guide. Build it.

**Claude:** Put on the section in plan.json and rebuilt. In Preview Form, Add opens the window with every question and required ones enforced, Edit shows the row's answers, and Remove asks first, then deletes the saved row on save. At phone width the three columns still read.

**Result.** A compact roster section where each volunteer's full details are one click away.

[Back to all skills](../README.md)
