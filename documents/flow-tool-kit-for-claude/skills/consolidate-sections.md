# consolidate-sections

Optional: merges repeated JSON sections across templates into one shared component.

Run it as `/flow-tool-kit:consolidate-sections`, or just describe what you want and Claude picks it.

## What it's for

Every new section starts as JSON on the section, the simplest shape to build and change. So reuse found later shows up as the same questions built several times on different Form Templates. This skill finds those repeats across the whole org (org-catalog's repeated-sections finding), shows what each group shares and where each member differs, recommends one shared record component, and on your yes creates it and points each section at it. Each section keeps its own title, header and rules; only where its questions come from changes. It is optional and runs only when asked, or when build-template offers it once after a build. A form works the same whether its sections are ever consolidated or not.

## When it's used

Directly, any time: these forms all ask the same emergency contact questions, merge the repeated sections, which sections repeat across our forms. Also offered once by build-template after a build.

## What you say

- "These forms all ask the same emergency contact questions."
- "Merge the repeated sections into one shared component."
- "Which sections repeat across our templates?"
- "Make the household section shared."
- "Remove the old JSON now that the merge checked out."

## Inputs

The connected org and a recent org-catalog. Plans for any templates rebuilt from plan.json, so a rebuild does not put the old JSON back.

## Outputs

- **A dry run** that changes nothing: every group of sections on two or more templates that ask the same questions, what they share, each member's differences (a question it would lose or gain, a label, required, choices, a rule or a mapping), and the recommendation. You answer every difference; none is settled silently.
- **On your yes:** the shared record component (or metadata, in Claude Code, when you ask), each approved section repointed to it in one all-or-nothing step, and a rollback file that puts every section back exactly as it was.
- **A round trip** that reads every member again and confirms each merged section asks exactly the approved questions and every section kept separate is unchanged.
- **Cleanup, later and separately:** removing the old JSON kept on merged sections and any one-off record component nothing uses any more, only when you ask.

## How it connects

- **Calls:** [org-catalog](org-catalog.md) for the groups, [build-form-component](build-form-component.md)'s writer for the shared component, [convert-to-metadata](convert-to-metadata.md) when a shared record component is final, [flow-access-fix](flow-access-fix.md) when guests need the sharing rule for a record component.
- **Called by:** [build-template](build-template.md) (offered once after a build); standalone.

## Why it's valuable

One shared component means one change reaches every form that asks those questions. Doing it by hand risks quietly changing a form: a question dropped, a label or rule altered. Here every difference is shown and answered, the build refuses anything changed after you confirmed it, the round trip proves the result, and a rollback is ready before anything moves.

## Where it runs

claude.ai chat with a Salesforce connector does it all in records mode. Claude Code adds a shared component built as metadata. Chat without a connector cannot read the templates, and says so.

## Walkthrough demo

All names and data below are invented. Read the lines aloud as a video script: your words, then what Claude says and does, then the result.

**You:** Our Pinecrest Arts Center forms all ask for an emergency contact. Can that be one shared piece?

**Claude:** I refreshed the catalog and ran the dry run; nothing changed yet. In case of emergency is built three times: Summer Camp Registration, Volunteer Application and Studio Rental. The first two ask the same four questions; Studio Rental also asks Alternate phone. I recommend one shared record component, In_Case_Of_Emergency, used by all three, with Alternate phone added, so the other two forms would ask it too. Or merge the first two and keep Studio Rental as it is. Which?

**You:** Merge all three and add Alternate phone.

**Claude:** Created In_Case_Of_Emergency and repointed the three sections. The round trip found each one asking exactly the five approved questions, with its own title and rules kept. I walked each form in Preview Form. The old JSON is still on the three sections; tell me when you want it removed.

**Result.** One emergency contact block for three forms, merged only where you said, checked, and reversible.

[Back to all skills](../README.md)
