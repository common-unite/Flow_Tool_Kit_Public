# new-record-page-form

Puts Flow Tool Kit's own form component on a site page or a Lightning record page and sets it up right there: simple forms and record displays with no Flow and no custom code.

Run it as `/flow-tool-kit:new-record-page-form`, or just describe what you want and Claude picks it.

## What it's for

It is less a builder than a pattern guide. Flow Tool Kit's form component can be dropped straight onto an Experience Cloud page or a Lightning record page and configured on the page, SLDS styled: pick a form built in Form Builder, tick a few settings, and the page loads the record, validates and saves it. No page layouts, no Dynamic Forms, no Flow and no custom Lightning web component. The skill says which of the two package components fits (Form (Component) on Lightning pages, Form (Dynamic Component) on sites), documents every setting each one takes, and places it by hand in Lightning App Builder or Experience Builder, or, in Claude Code, as page metadata that deploys with your project. It then sets up access for each audience and checks the form as each of them. The form shows its Save button. Saving each change as it is made, with no Save button, is an option you can ask for; it needs a small wrapper component, which the skill writes only then, or when a form must be baked into source on a Lightning record page.

## When it's used

- Simple site forms with no complex process: a Contact Us form that creates a Case, a mailing-list signup that creates a Lead. A guest form still goes through flow-access-fix and sf-guest-audit.
- Showing a record on a site page: Account details, a Campaign's details on an event page, a signed-in member's own Account.
- Custom record-page layouts inside Salesforce: several forms on one record page, each a slice of the record.
- From design-to-blocks and build-site-pages when a site section needs a simple form or a record display, and from build-form-component when a form should show on a page.

## What you say

- "Add a Contact Us form to the site that creates a Case."
- "Put a newsletter signup on the home page that creates a Lead."
- "Show members their household's account details on the portal."
- "Put the Volunteer Profile form on the Contact page."
- "Can that form save as people type?" (the autosave option)

## Inputs

A Form Component built in Form Builder (or by build-form-component), the page it goes on (a Lightning record page or a site page), and the audiences from the project config: staff, portal members, site guests.

## Outputs

The package component placed and set up on the page, by hand or as FlexiPage or site page metadata in the project. Access granted per audience, a published site where there is one, and a check as each audience. Only for autosave, or a form baked into source on a Lightning record page: a small wrapper component with its Jest test.

## How it connects

- **Calls:** [flow-access-fix](flow-access-fix.md) and [sf-guest-audit](sf-guest-audit.md) for guest forms; [build-site-pages](build-site-pages.md) to place it on a site page as metadata.
- **Called by:** [design-to-blocks](design-to-blocks.md) and [build-site-pages](build-site-pages.md) when a section needs a simple form or a record display; [build-form-component](build-form-component.md); or directly.

## Why it's valuable

You can build a complete custom experience, on a site and inside Salesforce, without writing a Flow or a custom component, and admins keep editing every form in Form Builder.

## Where it runs

Claude Code places it as metadata, deploys and checks it. claude.ai chat gives the click-by-click setup in App Builder or Experience Builder.

## Walkthrough demo

All names and data below are invented. Read the lines aloud as a video script: your words, then what Claude says and does, then the result.

**You:** Harbor Food Pantry wants a Contact Us form on its LWR site that opens a Case, and members should see their household's details once they sign in.

**Claude:** Neither needs a Flow or code. On the Contact Us page I placed Form (Dynamic Component) with your Contact Us form on Case, no record, and a thank-you message after a save. On the member home page I placed Form (Component) with the Household Details form on Account and the lookup path User.Contact.AccountId, so each member sees their own household. FlowToolKit LWR Support is in the Theme Footer. Want me to set up guest access?

**You:** Yes, and publish it.

**Claude:** flow-access-fix gave the guest user Create on Case and access to the form's fields only, and sf-guest-audit found nothing else the guest can reach. Published. As a guest I sent a test message: the thank-you shows and the Case is there. As a member I see my household, and a member who may only read it sees it read only.

**You:** Could staff's Contact form save as they type?

**Claude:** It can, as an option: autosave needs a small wrapper component around the same form, and it hides the Save button. Most record page forms keep the Save button, so I left it as is unless you want it.

**Result.** A working Contact Us form and a member account view on the site, set up on the page, with nothing custom to maintain.

[Back to all skills](../README.md)
