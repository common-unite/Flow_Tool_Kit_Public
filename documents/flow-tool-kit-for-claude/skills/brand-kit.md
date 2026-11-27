# brand-kit

Optional: pulls an organization's colors, fonts, images and voice from its website, saved in the org for reuse.

Run it as `/flow-tool-kit:brand-kit`, or just describe what you want and Claude picks it.

## What it's for

Gathers an organization's look and voice from its website (logos, colors, fonts, button and border styles, photos, and the program page's own words) so forms and site pages look and read like the organization made them. Colors and fonts are read from the site's own stylesheets by default. It then asks: 'Do you want exact colors and fonts from the rendered page? That needs Chrome access.'

It also writes a program voice for each form. When the gap round names the program a form serves, it reads that program's page and writes its own names, phrasing and sample copy, so intro descriptions, blurbs, site and form blocks, question labels, help text and the confirmation sound like that program. Skip the question and the form uses the organization's general voice. This works even with no saved brand kit.

## When it's used

Only if you say yes when ftk-start asks 'Want to choose a brand kit?' Or directly: pull the branding from this website. Run again when the website has changed.

## What you say

- "Pull the branding from riverbendartsfund.example."
- "Want a brand kit? Yes, use their website."
- "Refresh the brand kit, their site changed."
- "Use the saved brand kit for this form."
- "What colors and fonts does their site use?"

## Inputs

The organization's main website and the page for the program the form serves.

## Outputs

- A brand kit: logos, colors with where each is used, fonts, styles, every image tagged with its page, and a copy file with the program page's wording.
- A picker, as a file in your project (plus an optional claude.ai artifact), where you choose logo, banner, photos, colors and tone.
- Once you confirm the kit, it is saved to the org so it travels with it: colors, fonts and logo go into the Form Style defaults (blank fields only, never overwriting), chosen images are loaded as public Asset Files filed in the Asset Library folders Flow Tool Kit's image picker reads (images already in the org are reused), and tone and program wording go in a brand file in the Asset Library.

## How it connects

- **Calls:** Nothing.
- **Called by:** [ftk-start](ftk-start.md). Feeds [form-design](form-design.md), [build-template](build-template.md), [build-email-templates](build-email-templates.md) and [build-site-pages](build-site-pages.md).

## Why it's valuable

A converted form that looks generic is the first thing a client notices. This makes the first draft look like the organization's own site. The Asset Library filing step is a Flow Tool Kit detail that is easy to miss: a deployed image does not show in the picker until it is filed there. A saved kit is reused on every later form in that org.

## Where it runs

Claude Code and claude.ai chat. The site crawl is plain Python with no browser.

## Walkthrough demo

All names and data below are invented. Read the lines aloud as a video script: your words, then what Claude says and does, then the result.

**You:** Yes, use Riverbend Arts Fund's website for the brand kit. The grant program page is riverbendartsfund.example/grants.

**Claude:** Reading the site. I found 2 logos, 9 photos, a deep teal (#0F5E63) used for buttons and headings, a warm sand background and a serif heading font. I read these from the stylesheets. Do you want exact colors and fonts from the rendered page? That needs Chrome access.

**You:** No, the stylesheet values are fine.

**Claude:** Here is the picker file. Pick a logo, one banner photo and the tone. The grants page speaks warmly and plainly, so I suggest 'warm, direct, no jargon'.

**You:** Logo 1, banner photo 4, warm and direct.

**Result.** The kit is saved: teal and sand in the org's Form Style defaults, the logo and banner filed in the Asset Library, and a brand file with the tone. Next form in this org, Claude asks: use your saved brand kit?

[Back to all skills](../README.md)
