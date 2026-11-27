# field-audit

Before you delete, relabel or change picklist values on a Form Submission landing field, shows which Flow Tool Kit places it affects: Form Templates, page sections, Form Components (metadata, record, JSON) and their rules, URL parameter mappings, merge tokens, email templates, prefill templates, mappings and Flow Tool Kit flows (conversion, prefill and Flow Section). It writes a data dictionary and reads no submission data except the prefill templates your templates name.

Run it as `/flow-tool-kit:field-audit`, or just describe what you want and Claude picks it.

## What it's for

An admin asking "if I delete, relabel or change picklist values on this Form Submission landing field, what does it affect?" can't easily see the Flow Tool Kit side of the answer. Templates, page sections and form components store field names as record data and JSON, a template names its conversion and prefill flows by API name in a picklist, and a Flow Section names the screen flow it shows. Salesforce's dependency tracking never sees any of that, so Setup's **Where is this used?** button can't answer it. This audit can.

It looks only at Flow Tool Kit places:

- **Form Templates:** URL parameter mapping, prefill values, nullable fields, header and footer forms, payment rules, merge tokens in the confirmation message, offline message, header, footer and review page text, and Form Template Sources.
- **Pages and page sections:** the form each section shows, page rules and section rules, table forms, and merge tokens in page and section text (labels, titles, descriptions, headers, dividers, section text).
- **Form Components** in all three sources (metadata, record and JSON built in place), including each form's own field and section rules.
- **Email templates** a Form Template names for its confirmation, save progress, start and resume emails: every merge field in their subject and body, in Lightning, Classic and Visualforce syntax.
- **Prefill templates** a template or page section names: which fields each one sets and any merge tokens in its values.
- **Mappings:** Form Template Mapping, read from both sides.
- **Flow Tool Kit flows:** the conversion flows a template or page section names (Conversion Map Flow, including the package default when it says Default), the template's prefill flow, the screen flow a Flow Section shows (a page section whose Component Type is Flow), any flow that uses a Flow Tool Kit action or screen component, and the subflows those flows call. A field filled from Get URL Parameters in one of them counts as a URL parameter mapping.

It does **not** count or list Apex, reports, page layouts, validation rules or flows outside Flow Tool Kit. Those are general metadata, and Salesforce's own **Where is this used?** already covers them. Before a change, use both: this audit for the Flow Tool Kit places, Where is this used? for the rest.

Each custom field is marked **Active** (Flow Tool Kit references or maps it, with the places listed) or **Unreferenced** (no Flow Tool Kit place references it). It is about references, not data: nothing is counted or sampled. The one exception: a prefill template is a Form Submission record you set up as configuration, so the audit reads the prefill templates your templates and sections name, by Id, only to learn which fields they set. It reads no other submissions, and it never writes their values to its files.

Form Template Mapping is how a form built on a source object (an Account form, a Contact form, your own object) feeds its Form Submission landing fields. The audit counts each mapping as a use of both the landing field and the source field, so a landing field used only through a mapping is Active, and the dictionary shows which form and template map it.

## When it's used

Before you delete, rename or change a picklist on a submission field. At the end of a build (the data dictionary for what was built). Before cleaning up fields Flow Tool Kit no longer uses.

## What you say

- "Can I delete the Shirt Size field?"
- "If I relabel Preferred Language, which forms and flows does it touch?"
- "I'm changing the picklist values on Volunteer Shift. What uses it?"
- "Which Form Submission fields does our Account form map to?"
- "Which conversion flows use the Garden Plot field?"
- "Make a data dictionary for our forms."
- "Which fields are missing descriptions or help text?"

## Inputs

The connected org.

## Outputs

A data dictionary (every field with its label, type, description, help text, the surfaces that use it, such as Form Template Mapping, and where it is used, including the flow, the element and why that flow counts as Flow Tool Kit's) and a verdict per field: Active or Unreferenced. Rule snippets show the picklist value a rule compares against. Missing descriptions and help text show up here.

## How it connects

- **Calls:** Nothing.
- **Called by:** [ftk-start](ftk-start.md) at the end of a build; standalone.

## Why it's valuable

These are the places an admin can't easily see. A Form Submission field has no one-to-one reference Salesforce tracks inside Flow Tool Kit: Where is this used? does not look inside stored JSON, a form's mappings or the flow a template names in a picklist. Because it reads configuration (and only the prefill templates you named), it is safe to run in an org whose submissions hold sensitive answers.

## Where it runs

Claude Code, or claude.ai chat with a Salesforce connector that can run queries. Flows need the Tooling API: in chat, a connector without it lists flows as not scanned. In chat, Claude reads only the flows templates and sections name, the screen flows Flow Sections show (and their subflows), to keep the number of queries down.

## Walkthrough demo

All names and data below are invented. Read the lines aloud as a video script: your words, then what Claude says and does, then the result.

**You:** We want to delete a batch of Form Submission fields. Which ones does Flow Tool Kit still use?

**Claude:** I checked every template, page section, form component, rule, merge token, email template, prefill template, mapping and Flow Tool Kit flow; the only submissions I opened were the prefill templates your templates name. Form Submission has 64 custom fields: 47 are Active and 17 are Unreferenced. 12 Active fields are missing help text.

**Claude:** Partner Phone looked unused, but the Partner Organization form on Account maps its Phone there through Form Template Mapping, so it is Active. Garden Plot is used only in Garden Plot Convert, the flow the Volunteer Application template names as its Contact 2 conversion flow, so it is Active too.

**You:** Show me the unreferenced ones.

**Claude:** Here are the 17, for example Shirt Size: no template, form, mapping or Flow Tool Kit flow references it. That covers Flow Tool Kit only, so open each field's Where is this used? in Setup for Apex, reports, layouts and other flows, and check with the client about the data before removing any. I will not delete anything; this is a report.

**Result.** A data dictionary file and a list of Active and Unreferenced fields, with every Flow Tool Kit place each one touches, to take to the client before the change.

[Back to all skills](../README.md)
