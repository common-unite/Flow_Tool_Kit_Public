# build-site-pages

Lands site design blocks in an Experience Cloud site and proves they render.

Run it as `/flow-tool-kit:build-site-pages`, or just describe what you want and Claude picks it.

## What it's for

Lands page.json in an Experience Cloud site (LWR first, Aura noted) and proves it renders. It generates the site views from the blocks, applies the palette through the branding set and head design tokens, deploys the whole bundle, publishes the site, and checks every section on the live preview at desktop and phone width, headless, including as a guest. It ships two helpers: site publish, and guest site setup.

## When it's used

After design-to-blocks, or whenever block JSON must reach an LWR site without placing blocks by hand in Experience Builder.

## What you say

- "Build the site pages from page.json."
- "Publish the Willow Creek home page."
- "Set up the guest user for this site."
- "Check the live page at phone width."
- "The site changes are not showing, republish and verify."

## Inputs

page.json and site.json from design-to-blocks, the site, and the saved brand kit.

## Outputs

The deployed bundle, a published site, and a report with a result per section at desktop and phone width, plus the guest check.

## How it connects

- **Calls:** [flow-access-fix](flow-access-fix.md) for the audiences' access.
- **Called by:** [ftk-start](ftk-start.md); follows [design-to-blocks](design-to-blocks.md).

## Why it's valuable

An LWR site serves what was published last, so an unpublished deploy looks like nothing happened. This skill deploys, publishes and checks as a real visitor, so you know the page works before the client sees it.

## Where it runs

Claude Code. It deploys and runs headless browser checks, so it works in the web environment too.

## Walkthrough demo

All names and data below are invented. Read the lines aloud as a video script: your words, then what Claude says and does, then the result.

**You:** Build the Willow Creek volunteer page we just approved.

**Claude:** Generating the site views from page.json and applying the forest green palette through the branding set. Deploying the bundle to your sandbox. Publishing the site now. The checks run headless against the live preview.

**Claude:** Results: hero ok at 1280 and 390 wide; the Work Days Repeater shows 3 cards and says 'no results' correctly when filtered to a month with none; the HTML Editor safety notes render; the footer is on every page. As a guest, the page loads and the Work Day cards appear. One guest finding: Spots Left was blank because the guest cannot read that field, so I ran flow-access-fix and granted it.

**Result.** A live, published page with a check report per section, and the guest able to see it.

[Back to all skills](../README.md)
