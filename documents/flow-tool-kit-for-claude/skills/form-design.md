# form-design

Turns what a form asks into a build-ready design: plan.json plus a review canvas.

Run it as `/flow-tool-kit:form-design`, or just describe what you want and Claude picks it.

> **Requirement: Design on your claude.ai account.** Whatever Claude plan you are on, you need the Design feature turned on for your claude.ai account to see the review canvas and comment on it (in an organization, an admin may have to enable it). Without it the build still runs from plan.json, but you cannot review the design visually; you get only a plain review page.

## What it's for

Turns what a form asks (from form-migrate or a brief) into a design ready to build, in two forms that always agree: plan.json, the design as data, which the build reads; and a review canvas drawn with Flow Tool Kit's Forms design system, one artboard per page, with every conditional field shown and marked, plus a field audit board. The design system ships in the plugin and is installed into your own Design workspace.

Before it draws, it checks what a complete Form Template needs that the source did not say, and asks only that, in one short round with a default for each: the program the form serves (so it can write in that program's voice), whether to build as metadata or load as records for fast prototyping, the confirmation message's idea and tone, who the emails go to and come from, Save Progress and the resume link, the logo and banner, and who reviews submissions. When ftk-start already asked, it uses those answers and does not ask again.

## When it's used

After the source is read (and the optional brand kit), or directly: design this form, redesign this template. Also to change a design live in a client review.

## What you say

- "Design this form."
- "Redesign the volunteer template with a shorter first page."
- "Show me what the confirmation email will look like."
- "Mock up this grant application for the client review."
- "Change page 2 to put the budget table first and redraw it."

## Inputs

The form-migrate description (or the brief), the org catalog, the optional brand kit, and Flow Tool Kit's form-type rules.

## Outputs

- plan.json: pages, sections, components, every field with its control, width, copy and Salesforce field. Every section is marked reuse, extend or new, and every new or extended component records its shape (metadata component, record component or JSON), which Claude recommended with the reason and you chose. The gap round's answers, and every default it took, are recorded in it so the review can change them.
- The review canvas.
- The confirmation and resume emails, drawn on the canvas.
Sections that need a Flow Section or custom LWC are marked for [build-flow-section](build-flow-section.md) or [build-custom-lwc](build-custom-lwc.md).

## How it connects

- **Calls:** Hands plan.json to [build-template](build-template.md) and [build-form-component](build-form-component.md).
- **Called by:** [ftk-start](ftk-start.md). Requires a fresh [org-catalog](org-catalog.md).

## Why it's valuable

It carries house design rules you could not guess: the form-type rules table (header, buttons, indicator, page headings, first page), page descriptions of at least two sentences, every section titled, counted time estimates, confirmation messages with real next steps, and drawing only what Flow Tool Kit can actually build, so the build matches the drawing.

## Where it runs

Claude Code and claude.ai chat. The review canvas needs a claude.ai account with Design; without it, plan.json alone still drives the build.

## Walkthrough demo

All names and data below are invented. Read the lines aloud as a video script: your words, then what Claude says and does, then the result.

**You:** Design the Maple Clinic patient intake from that description. Keep it to three pages.

**Claude:** I checked the org catalog and the brand kit. Design: page 1 'About you' reusing your Contact Details component; page 2 'Insurance' with the member ID shown only when Insured is Yes; page 3 'Consent' with an e-signature. It is a long-form intake, so it gets Save Progress and a review screen. Estimated time: about 8 minutes. I drew it on the canvas, one artboard per page, with the conditional field marked.

**You:** Make the page 3 description friendlier.

**Claude:** Changed it in plan.json and redrew page 3: 'Almost done. Please read the consent below and sign. Your care team will call within two business days to confirm your first visit.'

**Result.** An approved plan.json and a canvas link. Nothing has touched the org yet.

[Back to all skills](../README.md)
