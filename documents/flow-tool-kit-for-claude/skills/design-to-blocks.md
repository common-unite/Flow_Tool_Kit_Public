# design-to-blocks

Designs an Experience Cloud page with Flow Tool Kit's Site Blocks and produces page.json.

Run it as `/flow-tool-kit:design-to-blocks`, or just describe what you want and Claude picks it.

> **Requirement: Design on your claude.ai account.** Whatever Claude plan you are on, you need the Design feature turned on for your claude.ai account to see the review canvas and comment on it (in an organization, an admin may have to enable it). Without it the build still runs from page.json, but you cannot review the design visually; you get only a plain review page.

## What it's for

Designs an Experience Cloud page, landing page, program portal or microsite with Flow Tool Kit's Site Blocks (site design blocks, record cards, the dynamic repeater, and the standard HTML Editor component). It works the way form-design does for forms: research and intake, draw page.json as a review canvas with the real Site Blocks at desktop and phone width, review by comments pinned on the canvas, then hand page.json to build-site-pages. It also turns a design someone else drew (screenshots, recording frames, another tool) into site design blocks.

The **HTML Editor component** (the standard Experience Cloud component, richTextValue) is used for rich copy that blocks do not cover. The skill says when to use it, the constraints to test, and shows a worked example.

## When it's used

When a client needs a site page, landing page or portal designed, or when an outside design must become blocks.

## What you say

- "Design a landing page for our summer program."
- "Make a program portal home page with a list of open programs."
- "Turn these screenshots into site design blocks."
- "Draw the About page for Willow Creek Land Trust."
- "Apply the comments from the client review to the page."

## Inputs

The organization, its pages and their audiences, the brand picks (or the saved brand kit), the objects and filters for any repeater, which pages are record pages, and who approves copy.

## Outputs

page.json per page plus site.json, and a review canvas with one artboard per page at desktop and phone width. A change goes into the JSON and only the affected artboards are redrawn, so what is approved is what is built.

## How it connects

- **Calls:** Hands page.json to [build-site-pages](build-site-pages.md).
- **Called by:** [ftk-start](ftk-start.md). Reads the saved [brand-kit](brand-kit.md).

## Why it's valuable

It mirrors the forms pipeline, so design and build always agree, and it only draws blocks that really exist.

## Where it runs

Claude Code and claude.ai chat. The review canvas needs a claude.ai account with Design.

## Walkthrough demo

All names and data below are invented. Read the lines aloud as a video script: your words, then what Claude says and does, then the result.

**You:** Willow Creek Land Trust wants a home page for their trail volunteer program, with a hero, three upcoming work days from the org, and a sign-up button.

**Claude:** I used their saved brand kit: forest green and a rounded sans font. Plan: a hero with the trail photo and a Sign up button; a Repeater of upcoming Work Days showing date, trail and spots left, pulled from the Work Day object; a short rich section using the HTML Editor for the safety notes; a footer. Which Work Days should the Repeater show, and filtered how?

**You:** Open ones in the next 60 days, sorted by date.

**Claude:** Done. I drew the page at desktop and phone width on the canvas. On the phone, the Repeater cards stack one per row.

**You:** Make the hero shorter on the phone.

**Claude:** Changed in page.json and redrew only the phone hero.

**Result.** An approved page.json and site.json, ready for build-site-pages.

[Back to all skills](../README.md)
