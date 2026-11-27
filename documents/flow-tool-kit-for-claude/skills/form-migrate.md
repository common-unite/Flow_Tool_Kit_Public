# form-migrate

Bring us whatever form you have. It reads it and records exactly what it asks, does and where its answers go.

Run it as `/flow-tool-kit:form-migrate`, or just describe what you want and Claude picks it.

## What it's for

Reads an existing form from any source and writes down what it really does, so it can be rebuilt on Flow Tool Kit. It is the read-the-source step of every conversion.

FormAssembly (a live form, an export or the connector settings) and PDF forms (fillable or flat) are the featured paths. Brief mode needs no form at all: describe the form you are building and it produces the same description. It also reads Word documents, a custom HTML form on any website (by address or a saved page), Google Forms, Microsoft Forms, Jotform, Typeform, Wufoo, Cognito, Gravity Forms and other builders, screenshots or photos of a paper form, a spreadsheet listing the questions, an existing Form Template and a Claude Design canvas. For anything unfamiliar it falls back to a careful general read, then asks only what is still missing in one short round.

## When it's used

By ftk-start whenever a request starts from an existing form, or directly: what does this form actually do?

## What you say

- "What does this FormAssembly form actually do?"
- "Read this PDF application and list every question."
- "Here's a Word document of our client registration form."
- "Here are photos of our paper sign-up sheet."
- "Here is a Google Form link, convert it."
- "Document the show/hide rules on this form."
- "Describe a three-page volunteer form: info page, contact and demographics, then a release with e-signature."

## Inputs

One source. The connected org is used to check the fields answers would write to.

## Outputs

- A normalized description of the form: every question, choice, condition and calculation, with its source IDs.
- A field plan. A question that belongs on a standard or custom object (name, email, phone, organization, address) is planned as a mapped form on that object, landing on an existing Form Submission field first; a new field is made only when none fits.
- A mapping workbook the form owner can mark up (OK, SKIP or a different field name), which it reads back in.
- A plain-language summary of what the old form did.

## How it connects

- **Calls:** Hands off to [form-design](form-design.md) and [new-mapping-flow](new-mapping-flow.md). Its escalation ladder decides when a section needs a [build-flow-section](build-flow-section.md) or a [build-custom-lwc](build-custom-lwc.md).
- **Called by:** [ftk-start](ftk-start.md); [formassembly-capture](formassembly-capture.md) hands it each form.

## Why it's valuable

It is the hardest part of a conversion to get right. For every claim it records how it knows it (parsed, typed by hand, none exist, not captured, unknown), so an empty list is never mistaken for 'this form has no logic'. It carries fixes for parsing problems that silently lose data.

## Where it runs

Claude Code and claude.ai chat. Plain Python, nothing to install; PDF forms need poppler (one install line). In chat, Claude extracts what the source will give it.

## Walkthrough demo

All names and data below are invented. Read the lines aloud as a video script: your words, then what Claude says and does, then the result.

**You:** Here is the link to Maple Clinic's patient registration form on FormAssembly. What does it do?

**Claude:** I read the live form. It has 3 pages and 31 questions. Page 1 is contact details, page 2 is insurance, page 3 is a consent with a signature. Four rules: the insurance member ID only shows when 'Insured' is Yes; two others reveal a guardian block for patients under 18. The Salesforce prefill and post connectors are not visible from the public form, so I have marked them 'not captured'. Do you have a connector export, or should I leave them for later?

**You:** Leave them for now, we are rebuilding the mapping anyway.

**Claude:** Understood. Here is the field plan: name, email, phone and address land on Contact through a mapped form using the packaged Contact fields. Member ID and consent date need two new Form Submission fields. I saved the mapping workbook; you can mark it up and I will read it back.

**Result.** A normalized description, a field plan and a one-page summary of what the old form did, ready for form-design.

[Back to all skills](../README.md)
