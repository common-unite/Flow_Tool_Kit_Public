# repeating-data

Listens to the outcome and decides Repeater or Table, then hands off to the build.

Run it as `/flow-tool-kit:repeating-data`, or just describe what you want and Claude picks it.

## What it's for

When a form or a screen flow must collect several of the same thing (household members, additional contacts, volunteers, line items, references, shifts), there are two ways to show it. A **Repeater** repeats one form component row by row, with every question on the page. A **Table** shows a few key columns, one line per row, and New and Edit open a window with every question of the row. This skill asks what you want to happen, recommends one with the reason, settles the questions both builds need answered, writes the build spec and hands it on. It builds nothing itself.

## When it's used

Automatically, when form-design, form-migrate or build-template meet a repeating field or section, or from ftk-start; or directly: should this be a repeater or a table, let people add more than one.

## What you say

- "Should the household members be a repeater or a table?"
- "Let people add more than one emergency contact."
- "The event needs up to 20 volunteers, each with nine questions."
- "Applicants list two references; keep the page short."
- "The plan has a Repeater the build can't place."

## Inputs

The outcome in your words: who fills it in, what they list, how many they usually have and at most, what each one needs, which two or three details tell rows apart, where it goes (a Form Template page section or a screen flow), whether the form starts with rows already on file, and what each row becomes in Salesforce.

## Outputs

A recommendation, Repeater or Table, with the reason and the alternative named, asked before anything is built. Then one build spec per section with:
- where it goes: a page section, where rows are Form Submissions under the main submission, or a screen flow component, where rows are any object the flow passes;
- the row component's shape: JSON on the section by default, a shared record component when reuse is known now, metadata later; a Table also gets a row form, which is always a named component;
- rows in: the Section Tag a prefill flow fills, and a Pre-fill Template for new rows;
- rows out: the Conversion Rule and Conversion Map Flow, and removed saved rows flagged so the save deletes them.

## How it connects

- **Calls:** [build-repeater](build-repeater.md) or [build-table](build-table.md) with the spec; [build-form-component](build-form-component.md) first for a new row component, table component or row form; [new-mapping-flow](new-mapping-flow.md) for the prefill flow or a custom row conversion; [build-flow-section](build-flow-section.md) for a screen inside a Flow Section.
- **Called by:** [form-design](form-design.md), [form-migrate](form-migrate.md), [build-template](build-template.md), [ftk-start](ftk-start.md); standalone.

## Why it's valuable

The choice is easy to get wrong in both directions: a Repeater of 20 full forms is a long scroll, and a Table for three short rows hides the questions behind a window. The rule is simple (a Table for about five or more rows or about eight or more questions per row, or to keep a long page compact) and the build scripts check it again. The questions it settles up front, the Section Tag, the conversion and the row form's shape, are the ones a build otherwise stops on halfway.

## Where it runs

Claude Code (local or web) and claude.ai chat. It talks and writes a spec; the build skills it hands to say where they run.

## Walkthrough demo

All names and data below are invented. Read the lines aloud as a video script: your words, then what Claude says and does, then the result.

**You:** The Maple Street Youth League registration form has to let a family add their children.

**Claude:** How many children does a family usually register, and what is the most? And what do you need to know about each one?

**You:** Usually two or three, never more than six. Name, birthdate, school and grade.

**Claude:** I recommend a **Repeater**: four questions and a few rows, so every question stays on the page as they type. A Table would hide the questions behind an Edit window. Should returning families start with the children you already have on file? And should each child become a Contact in the household?

**You:** Repeater. Yes to both.

**Claude:** Then the section gets the Section Tag Contacts for the prefill flow, and each row converts with the Contact rule. Minimum 0, maximum 6, the New button labelled Add. The four questions stay as JSON on the section, since nothing else asks them. I wrote the spec and handed it to build-repeater, and the prefill flow to new-mapping-flow.

**Result.** A Repeater chosen for a stated reason, and a build spec that already answers where the rows come from and where they go.

[Back to all skills](../README.md)
