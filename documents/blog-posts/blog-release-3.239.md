# Flow Tool Kit 3.239: A Critical Flow Builder Fix, Autosave, and Smarter Surveys Infrastructure

**TL;DR: Salesforce quietly changed how Flow Builder talks to component property editors, and it broke adding Form components to new flows in every org. Version 3.239 fixes it, and every org should upgrade today. The upgrade is one click: open Setup, go to Installed Packages, and click Upgrade to Recommended Version. While you are there, you also get autosave, custom picklist option labels, per-template style sheets, and clickable progress indicators.**

## First, the important one: upgrade now

If your admins add Flow Tool Kit components to screen flows, this release is not optional.

Salesforce changed the internal format Flow Builder uses to pass element information to component property editors. On newly created flows, that change corrupted the automatically assigned Record input into an invalid reference, and the flow refused to save with a confusing error:

> The type for the input parameter "Record" doesn't match the type for the assigned value.

Existing flows kept working, which made this one sneaky: everything looked fine until someone built something new. Version 3.239 fixes all eleven Flow Tool Kit screen-component property editors in one pass, and the fix handles both the old and new Salesforce formats, so it is safe no matter which release wave your org is on.

We also flagged 3.239 as the package's recommended version. That means your Salesforce admins will find an **Upgrade to Recommended Version** link right on the Installed Packages page in Setup. One click, no install URL hunting.

[SCREENSHOT PLACEHOLDER: Installed Packages page showing the Upgrade to Recommended Version link]

If a flow was already saved with the bad reference, remove and re-add the component, or point its Record input at the screen component's own record output.

## Autosave: drafts that save themselves

Form Templates can now save the respondent's in-progress submission automatically and silently as they work. No Save Progress click, no lost answers when a laptop lid closes.

Autosave is completely interaction-driven. Choose **Upon Change** and the draft saves three seconds after the respondent stops typing, with a guarantee that continuous typing still checkpoints every fifteen seconds. Or pick a ten- or thirty-second checkpoint clock that only starts once the respondent actually touches the form, and never writes when nothing changed. Readers never trigger saves; guests and embedded forms are fully supported.

[SCREENSHOT PLACEHOLDER: Enable Autosave and Autosave Mode settings]

## Custom picklist option labels, with a party trick

Your picklist values are named for your database. Your respondents should never have to read them. Any picklist or multiselect field can now display per-form custom option labels while the stored values keep their API names, so reports, flows, and integrations are untouched.

The party trick: labels run through the merge pipeline, so an option's wording can react to the respondent's other answers in real time. Label an option `Tasks ({{Priority}})` and it re-renders as "Tasks (Medium)" the instant they pick Medium.

[SCREENSHOT PLACEHOLDER: Override Option Labels editor and live preview]

## Per-template style sheets

Each Form Template can now carry its own CSS style sheet, selected right on the template record and injected scoped to that template alone. Brand one application form to the hilt without touching any other form on the page.

## Progress indicators that respondents can actually use

The vertical progress indicator grew up this release, in both Stages Mode and classic linear forms:

- Completed pages show a green check, the current page shows a pencil, in-progress pages show a clock, and pages needing attention show a warning, all in your org's brand color.
- Respondents can click backward any time, and click forward to any page they have already visited. Nobody gets stranded on page one after going back to fix an answer.
- Linear forms now track per-page progress on the same stage records Stages Mode uses, so completed pages stay completed across navigation and resumes.
- Stages Mode gained layout options: hide the progress banner, hide the field counts, or display your template's branded header component right on the overview.

[SCREENSHOT PLACEHOLDER: vertical indicator with status markers]

## Also in this release

- A template-level **Submit Button Label** now controls the true final submit wherever it renders, and the review-screen opener got its own label with a "Continue to Review" default.
- The Log Conversion Event flow action learned log-only mode and a Dispatch Return Event toggle, and all fifteen packaged conversion flows now call it directly.
- Every packaged flow is self-documenting: forty flows and more than five hundred elements carry admin-facing descriptions you can read right in Flow Builder.
- Question and section numbering merge fields, screen-reader improvements for custom labels and help text, resume-link email fallbacks, and a batch of Form Builder fixes.

Full details in the [3.239 release notes](https://github.com/common-unite/Flow_Tool_Kit_Public/releases/tag/release/3.239.0.1).

## What's next

A Likert matrix section type is already built and in verification: rows of same-scale questions rendered as a compact radio grid, with picklist and number modes, a live running total for screeners like the GAD-7, and automatic collapse to stacked questions on phones. Look for it in 3.240.

Questions or feedback? Reach us at support@common-unite.com.
