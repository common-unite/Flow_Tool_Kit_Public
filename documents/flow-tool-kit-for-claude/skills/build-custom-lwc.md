# build-custom-lwc

Builds a custom Lightning web component on Flow Tool Kit's contract when Flow and templates cannot do it well.

Run it as `/flow-tool-kit:build-custom-lwc`, or just describe what you want and Claude picks it.

## What it's for

When something cannot be done well in Flow or a Form Template, Claude says so plainly, recommends a Lightning web component, and builds it on Flow Tool Kit's injection contract, placed in a Form Component section or a Form Template page section.

Triggers that mean 'this needs an LWC': options that must be dynamic or come from a roster; a live calculation as the person types that reads a table; a custom interface for managing child rows; a widget Flow Tool Kit has no control for, such as a map or a calculator display.

**House pattern:** the component never hand-builds inputs. It renders the admin's own form inside itself and adds only the calculation or behavior; derived values go back through the form's transformation record; titles live on the page section. **Matching styles:** the form inside renders through the Flow Tool Kit form wrapper, so it inherits the template's styles. Anything else the component draws uses Flow Tool Kit's --ftk-* CSS variables with fallbacks, for example var(--ftk-color-primary, #0176d3), so it follows the brand color without a redeploy.

## When it's used

Automatically from the escalation ladder when a section needs it, or directly: build a component that calculates the membership fee as they type.

## What you say

- "Build a component that calculates the membership fee as they type."
- "The shift options come from a roster, build a picker."
- "I need a map on this form."
- "Make a component to manage child rows."
- "This widget needs to match the form's colors."

## Inputs

The section's design, the target surface (Form Component section or Form Template page section), and who runs it (guest, portal or internal).

## Outputs

- The component: it receives the record and its flags and sends each change back as one formfieldchange event (bubbling and composed); on page sections, child rows go through relatedrecordchange; an optional validate() feeds the form's error summary.
- Its Jest tests.
- The Apex and permission set it needs (field access for every field it touches, Apex class access, custom metadata access).
- Deployment, and the section pointed at the component by its full name.

## How it connects

- **Calls:** [flow-access-fix](flow-access-fix.md), [new-invocable](new-invocable.md) for Apex.
- **Called by:** [build-template](build-template.md), [form-design](form-design.md) and [form-migrate](form-migrate.md) through the escalation ladder; [ftk-start](ftk-start.md).

## Why it's valuable

It carries about 30 recorded pitfalls: namespaces in a subscriber org, Lightning caching old builds for minutes, field access for new Form Submission fields, a re-render loop, and events that do not bubble.

## Where it runs

Claude Code.

## Walkthrough demo

All names and data below are invented. Read the lines aloud as a video script: your words, then what Claude says and does, then the result.

**You:** Cedar Valley Youth Soccer charges a fee that depends on the player's age group and whether they are a returning player. It should show as the parent fills in the form.

**Claude:** That is a live calculation that reads a table of fees, which a native control cannot do. It needs a custom component. I will build one that renders your form inside itself, so the fields keep the template's styling, and adds only the fee calculation. The fee comes from a custom metadata table, so you can change prices without code.

**Claude:** Built: the component, its tests, the permission set for the fee table and the Registration Fee field, and deployed. A fee card sits under the form, and it uses the brand color, so a new theme changes it without a redeploy. In Preview, choosing Under 10 and Returning shows 45 dollars.

**Result.** One component, its tests and the section pointing at it. The fee table is editable by an admin.

[Back to all skills](../README.md)
