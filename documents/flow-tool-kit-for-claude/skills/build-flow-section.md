# build-flow-section

Builds Flow Sections: screen flows inside a Form Template page for logic plain questions cannot do.

Run it as `/flow-tool-kit:build-flow-section`, or just describe what you want and Claude picks it.

## What it's for

Builds Flow Sections, the screen flows an admin puts into a Form Template page for logic that plain questions cannot express, which pass their results back up to the Form Submission. Claude recognizes when a section needs one and builds it for you.

## When it's used

Automatically, from the escalation ladder (native control, then Flow Section, then custom LWC) when a section needs it, handed over by build-template; or directly: build a flow section that picks the household's primary contact.

## What you say

- "Build a flow section that picks the household's primary contact."
- "This section needs to look up records, make it a Flow Section."
- "Add a multi-page process inside one section."
- "Embed our existing screen flow in the form."
- "Add Save Progress inside this section."

## Inputs

The section's design (what it asks, what it reads from the org, what it returns), the template, and who runs it (guest, portal or internal).

## Outputs

A flow cloned from the packaged '(Form) Flow Section | Template' with:
- the full contract: record, related records, button label inputs, button clicked, isValid, section and stage, and review mode;
- only the fields it set returned, on a fresh record;
- the single button bar;
- Save Progress as a screen action when wanted;
- Ids handed back after a mid-flow save;
- the review screen;
- a Back that always works on the first screen: Back there is a Next under the hood, and Flow holds a Next on a blank required question whatever the buttons say, so that screen's questions are not required in Flow. When the person moves forward with one blank, the section sends them back to it with a message under the question instead;
- rows the person removes handed back flagged Is Deleted, so the save and the conversion delete them. A row simply left out would stay. Each section's rows are its own, so a Flow Section only ever hands back its own rows;
- activation, and the page section pointed at it.
Then [flow-access-fix](flow-access-fix.md) runs for each audience. Screen labels are plain words, and each element is described.

## How it connects

- **Calls:** [flow-access-fix](flow-access-fix.md), [new-invocable](new-invocable.md).
- **Called by:** [build-template](build-template.md), [form-design](form-design.md) and [form-migrate](form-migrate.md) through the escalation ladder; [ftk-start](ftk-start.md).

## Why it's valuable

It carries the recorded pitfalls: template inactive in tests, platform cache, Back and Finish routed by label, a required question that holds Back on the first screen, removed rows that never delete, a stale launch record, guest reads in System Mode passed through the FLS Record(s) Sanitizer.

## Where it runs

Claude Code (it builds and deploys flows).

## Walkthrough demo

All names and data below are invented. Read the lines aloud as a video script: your words, then what Claude says and does, then the result.

**You:** On the Harbor Food Bank renewal form, signed-in members should pick who the primary contact is from the people already in Salesforce on their household.

**Claude:** A plain question cannot do that, because the choices are the household's own Contact records in the org. That is a Flow Section. It will show a screen with a radio list of the household's Contacts and return only the Primary Contact Id. Members fill it in on the portal, so I will set it up for portal access.

**Claude:** Built from the packaged Flow Section template. It has one button bar, a review screen showing the name, and Save Progress in case the person leaves. The question is on the section's first screen, so it is not required in Flow: Back always returns to the previous page, and Continue with nothing picked comes back with "Answer this question to continue." I activated it, pointed the section on page 2 at it, and ran flow-access-fix for the members' permission set.

**You:** Can I see it work?

**Claude:** Yes. In Preview as a test member with three people on the household, the list shows all three, Back with nothing picked goes to page 1, and choosing Maria sets the Primary Contact on the submission.

**Result.** One active flow, a page section pointing at it, and portal members who can run it.

[Back to all skills](../README.md)
