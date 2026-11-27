# flow-access-fix

Fixes 'You do not have the level of access necessary' on a flow, and wires new flows so it never happens.

Run it as `/flow-tool-kit:flow-access-fix`, or just describe what you want and Claude picks it.

## What it's for

Fixes the message 'You do not have the level of access necessary to perform the operation you requested' (FLOW_ACCESS_RESTRICTED) on a screen flow, a Flow Section or an Experience Cloud form, and wires every new flow so it never happens. It covers three audiences, which ftk-start asks about: guest, portal and internal. The flow is granted to each audience's permission set.

Two fixes, checked in order: the flow is marked 'requires additional permission to run'; then the running user's permission set grants that flow. Then it checks the subflows and Apex actions the flow calls, and object and field access.

For guest forms it also handles:
- **Guest sharing rules.** Guests see nothing without one. If a guest flow reads records (events, public Campaigns, programs), it checks the org for a guest sharing rule and proposes the narrowest one (object, criteria, read only).
- **Save Progress and Stages.** A guest form with Save Progress or Stages mode needs system-mode org copies of the (Form) Upsert | Overridable flow; Save Progress also needs the (Form) Prefill | Template copy so the person can resume. It checks for them, proposes them, and grants them to the guest.

## When it's used

Automatically whenever that message appears near a flow; when build-flow-section or new-mapping-flow build a flow a guest or portal user runs; or directly: my form says I do not have access.

## What you say

- "My form says I do not have the level of access necessary."
- "Fix the access error on the volunteer form."
- "The guest user cannot save progress on this form."
- "Wire this new flow for portal users."
- "Why can the public not see the events in this picker?"

## Inputs

The flow (or the Flow Section's flow name) and the running user (the site's guest user for a site).

## Outputs

The fixes applied, a deploy, a reload as the guest or portal user, and confirmation the message is gone, with a short list of what was changed and why.

## How it connects

- **Calls:** Nothing.
- **Called by:** [build-flow-section](build-flow-section.md), [new-mapping-flow](new-mapping-flow.md), [build-site-pages](build-site-pages.md); standalone.

## Why it's valuable

It is the most common Flow Tool Kit support question on sites. The fix is two specific steps, and the second silently does nothing without the first. It also proposes the narrowest guest sharing rather than opening records wide.

## Where it runs

Claude Code (it deploys). In chat it can diagnose and give you the exact changes.

## Walkthrough demo

All names and data below are invented. Read the lines aloud as a video script: your words, then what Claude says and does, then the result.

**You:** The public Harbor Food Bank pantry form shows 'You do not have the level of access necessary' when someone clicks Next.

**Claude:** That is FLOW_ACCESS_RESTRICTED. I checked in order. The flow 'Pantry Visit | Lookup Site' was not marked as requiring a permission, so I turned that on. Then I added the flow to the guest user's permission set. That cleared the first error, but a second appeared: the flow reads Pantry Site records, and guests see none. I checked and there is no guest sharing rule. I propose one: Pantry Site, where Active is true, read only. Should I add it?

**You:** Yes.

**Claude:** Added. I also saw the form has Save Progress on, so I checked for system-mode copies of (Form) Upsert | Overridable and (Form) Prefill | Template. They were missing, so I created them and granted them to the guest. I reloaded the form as a guest: Next works, and a saved form resumes.

**Result.** A short change list, and a form that works for the public without opening any records beyond active pantry sites.

[Back to all skills](../README.md)
