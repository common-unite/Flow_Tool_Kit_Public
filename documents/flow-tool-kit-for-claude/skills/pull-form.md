# pull-form

Pulls one Form Builder form's whole metadata tree into your project.

Run it as `/flow-tool-kit:pull-form`, or just describe what you want and Claude picks it.

## What it's for

Pulls one Form Builder form's complete metadata (the form, its sections, fields, conditional logic, conditions, and the Form Labels its text uses with their translations) from the org into the project, so it can be versioned, moved to another org or packaged. It also lists what the form needs from outside itself: other forms it places or opens from a Record Card button, its Form Object and Theme, the image files (Asset Files) its image sections, banners, Record Cards and visual picker options show, the flows its flow sections and buttons run, and the Lightning web components its LWC sections load. Ask for the dependencies too, and it pulls the org's own ones in the same step.

## When it's used

Directly, for example 'pull the scholarship form into the repo' or 'copy this form from the sandbox to production'. Also after building a metadata component that should live in source control.

## What you say

- "Pull the scholarship form into the repo."
- "Copy this form from the sandbox to my other org."
- "Put the Pantry Visit form in source control."
- "Retrieve everything the volunteer form depends on."
- "Get the whole tree for Patient Intake."

## Inputs

The form's name and the connected org.

## Outputs

The form's full metadata in the project, ready to deploy elsewhere, with a list of what lies outside the form (pulled too when you ask). It also flags a Record Type Id in a condition, with how to find the matching Id in the target org, and an LWC section that needs a component on an LWR site to load it.

## How it connects

- **Calls:** Nothing.
- **Called by:** Standalone; [build-form-component](build-form-component.md) may call it after authoring.

## Why it's valuable

Flow Tool Kit forms span five related metadata types plus Form Labels, and often lean on image files, flows and components outside them. Pulling one by hand misses pieces, and the missing piece only shows in the other org. This gets the whole tree in one step and names everything else it needs.

## Where it runs

Claude Code (it writes files and runs the sf CLI).

## Walkthrough demo

All names and data below are invented. Read the lines aloud as a video script: your words, then what Claude says and does, then the result.

**You:** Pull the Lakeside Library Friends membership form into the repo.

**Claude:** Pulling 'Membership Signup' from the connected org. I found the form, 4 sections, 22 fields, 3 conditional logic records with 5 conditions, and 6 Form Labels. Retrieved all of it into the project under the forms folder. Outside the form it shows your library logo in its banner and runs the Renewal Reminder flow from a button.

**You:** Will it deploy to another org as is?

**Claude:** Once the logo and the flow come with it. Shall I pull them too? Then one deploy carries the whole form.

**You:** Yes, pull them.

**Claude:** Done: the logo file and the Renewal Reminder flow are in the project beside the form.

**Result.** The complete form metadata and the logo and flow it uses, ready to commit or deploy.

[Back to all skills](../README.md)
