# ftk-start

The front door: takes a plain request and runs the right skills in the right order.

Run it as `/flow-tool-kit:ftk-start`, or just describe what you want and Claude picks it.

## What it's for

Takes a request in your own words and sends it to the right skills in the right order. You never need to know the other skill names. Examples: "convert this FormAssembly form into a form template", "make these into form components", "turn this into a screen flow", "design a grant application on Outbound Funds".

It also asks the few things only you can answer, once per organization:

- Is this org on the **free** or the **paid** Flow Tool Kit edition? This decides whether forms are built on the source object (Contact, Account and so on) with Form Builder field mapping, or directly on Form Submission. The answer is stored with the org catalog and every skill reads it.
- Which **audiences** will use the form: guest (public site), portal (signed-in site users) or internal staff? Access fixes are built per audience.
- Do you want a **brand kit** (colors, fonts and voice pulled from the organization's website)? It is optional. If a saved kit already exists in the org, it offers to reuse it.

If the request itself is unclear, it asks a few clarifying questions before it plans, each with its best guess, so you can just say yes.

Once the source is read, it checks what a complete Form Template still needs and asks only what is missing, in one short round, with a sensible default for each: what program the form is for (with the program's page, so the form reads in that program's voice), whether to build as metadata or load as records for fast prototyping, the confirmation message (the general idea and the tone), who the emails go to and come from (the confirmation and any staff notification), whether Save Progress and the resume link are on, the header or banner image and logo, who reviews submissions, and anything else the build needs that the source did not give. Say "yes to all" and it uses the defaults.

## When it's used

Any time you ask for Flow Tool Kit work in plain words. Claude picks it from the request.

## What you say

- "I need to convert our FormAssembly patient form to Flow Tool Kit."
- "Design a grant application on Outbound Funds."
- "Turn this Google Form into a form template."
- "Start a form project for our volunteer sign-up."
- "Make these three forms share their address and contact blocks."

## Inputs

The request; the source (a FormAssembly export or link, a PDF, a Google Form, an existing Flow or Form Template) or a brief; the org your Claude is connected to.

## Outputs

A short plan of which skills will run and what each produces, then one short round of gap questions after the source is read, then the work itself, step by step. It asks only what it cannot find in the org or the source. It keeps these habits: it catalogs the org first so nothing is rebuilt, keeps sections local unless they repeat, shows you the design before anything touches the org, and runs the Flow Section and custom LWC checks.

## How it connects

- **Calls:** [org-catalog](org-catalog.md) (always first), [form-migrate](form-migrate.md) or brief mode, [formassembly-capture](formassembly-capture.md), [brand-kit](brand-kit.md), [form-design](form-design.md), [build-template](build-template.md), [build-form-component](build-form-component.md), [build-flow-section](build-flow-section.md), [build-custom-lwc](build-custom-lwc.md), [new-mapping-flow](new-mapping-flow.md), [flow-access-fix](flow-access-fix.md), [field-audit](field-audit.md), and the site skills when the request is about a site.
- **Called by:** Nothing. It is the entry point.

## Why it's valuable

You get the Flow Tool Kit method by asking in plain words, and every request lands in the same tested sequence. You never have to remember which skill comes next.

## Where it runs

Claude Code (local or web) and claude.ai chat. It plans and asks; the skills it calls say where they run.

## Walkthrough demo

All names and data below are invented. Read the lines aloud as a video script: your words, then what Claude says and does, then the result.

**You:** I work with Riverbend Arts Fund. They have a FormAssembly grant application and want it on Flow Tool Kit. Can you start that?

**Claude:** Happy to. Before I plan, three quick questions I cannot find in the org. First, is Riverbend on the free or the paid Flow Tool Kit edition? Second, who will fill this in: the public, signed-in portal users, or staff? Third, do you want a brand kit pulled from their website?

**You:** Paid edition. The public fills it in, and staff review it internally. Yes to the brand kit.

**Claude:** Noted: paid edition, guest and internal audiences, brand kit on. I read your org first. It already has an address block and a contact block as Form Components, so I will reuse those. Here is the plan: read the FormAssembly form, ask you about anything it leaves out, pull the brand kit from the website, design the form, build the template, add the confirmation email, build the conversion flow that saves answers to Contacts, then fix access for the guest user. Shall I go?

**You:** Go.

**Claude:** I read the form: 3 pages, 26 questions, 4 show and hide rules. A few things it does not say. Here is what I will use unless you change it. 1. Confirmation message: thank them, say the panel decides by the end of March, and give the grants inbox for questions, in a warm, plain tone. 2. Emails: a confirmation to the applicant from your grants address, and a notice to the grants team when an application arrives. 3. Save Progress and a resume link: on, since this is a long application. 4. Header: the logo and banner photo from the brand kit. 5. Reviews: the grants committee reviews submissions in Salesforce. Yes to all?

**You:** Yes, but the panel decides by mid-April.

**Claude:** Mid-April it is. Starting the design.

**Result.** Claude runs the skills in that order and reports after each one. You typed three short sentences and answered one round of questions, mostly with yes.

[Back to all skills](../README.md)
