# new-invocable

Scaffolds a bulk-safe Invocable Action Apex class and, always, its test class, whose tests create no data, for when Flow cannot do the job.

Run it as `/flow-tool-kit:new-invocable`, or just describe what you want and Claude picks it.

## What it's for

Scaffolds a new Invocable Action class in the standard pattern for your own flows: request and result inner classes, one process method per request, bulk-first (gather Ids, query once, no SOQL or DML per request), a custom exception, and a human-readable label and description for admins. Every query and save sits in a small data-access seam, one statement per method. The test class is always written with the class, and its tests use in-memory records with fake Ids and a mock of the seam: no inserts, updates or other DML, no queries against your org's data, no SeeAllData, and nothing that needs a record to exist. So they pass the same way in any org and leave nothing behind, including a 200-request bulk test that checks the seam is called once. Classes are public, and you pick your own action category (or none). Flow first, Apex only when Flow cannot.

## When it's used

When a flow step genuinely needs Apex, or directly: make an invocable action that formats this address.

## What you say

- "Make an invocable action that formats this address."
- "I need Apex to calculate a pledge total from several Opportunities."
- "Scaffold an invocable with a test class."
- "Add a test that runs the real query too."
- "Wrap this callout so a flow can use it."
- "Make this action bulk-safe."

## Inputs

The class name, what it does, its action category, and the object whose records it reads (and whether it saves them).

## Outputs

The Apex class and its test class in the project, always both, with inputs and outputs as InvocableVariables with admin-readable labels and descriptions, and no system mode unless you say so.

Coverage, plainly: the mock-only tests do not run the few lines inside the seam that do the real query or save. Because those methods are one line each, the rest of the class is covered and the total stays well above the 75 percent Salesforce requires for a production deploy (about 90 percent for the worked example, estimated by line count until the tests run in your org). If you want the seam's lines run too, ask for a database test: an Apex test's inserts are rolled back when it ends and never show in your org, but it has to satisfy your org's validation rules, so it is not added by default.

## How it connects

- **Calls:** Nothing.
- **Called by:** [build-flow-section](build-flow-section.md) and [new-mapping-flow](new-mapping-flow.md); standalone.

## Why it's valuable

It keeps your Apex in the same shape Flow Tool Kit's own invocables use: thin, bulk-safe and described for admins, with tests that are safe to run in any org because they never touch its data.

## Where it runs

Claude Code.

## Walkthrough demo

All names and data below are invented. Read the lines aloud as a video script: your words, then what Claude says and does, then the result.

**You:** Riverbend Arts Fund needs a flow step that totals a donor's pledges across open Opportunities.

**Claude:** Flow can loop and sum, but across thousands of donors that hits limits, so I will write a small invocable. I will call it Pledge Total, in your category 'Riverbend Actions'. Input: a list of Contact Ids. Output: the total per Contact. It queries once for all Contacts, so it is safe in bulk.

**Claude:** I wrote the class and its test class together. The one query sits in a small data-access seam. The tests build pledges in memory with made-up Contact Ids, swap the seam for a mock, and run 200 Contacts at once: every total is checked, the seam is asked once, and nothing is inserted or read from your org. I deployed both and ran the tests: they pass, and coverage is well above the 75 percent a production deploy needs. The only lines not run are the query itself, which the mock stands in for.

**Result.** Two classes in the project, the action and its tests, and an action called Pledge Total that appears in Flow Builder with a plain-language description. The tests left no records behind.

[Back to all skills](../README.md)
