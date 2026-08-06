# LWR Sites: Add the Component Support Block

> **Required for LWR (Build Your Own / Microsite) sites.** Aura-based Experience sites and Lightning
> pages are unaffected and need no change.

## What you need to do

Place the **FlowToolKit LWR Support** component once on any LWR site that shows a Flow Tool
Kit form, then publish the site.

1. Open your LWR site in Experience Builder.
2. Add **FlowToolKit LWR Support** to a page that every visitor loads. The site's template
   footer is the usual choice, because it appears on every page.
3. **Publish the site.** Placement alone does nothing until you publish.

The component renders nothing. It has no properties and no visible output.

## Why it is needed

Flow Tool Kit loads several of its heavier pieces on demand rather than up front, so a form only pays
for the parts it actually uses. That is what keeps form pages fast.

LWR sites build their JavaScript bundle at **publish time**, from the components it can see on your
pages. Anything loaded on demand is invisible to that analysis, so it never makes it into the bundle,
and the browser cannot find it later. The Component Support block exists purely to be visible to the
publish-time analysis. Placing it tells the site "include these too."

Aura sites do not work this way. They can fetch a component definition on demand at runtime, which is
why they need no equivalent step.

## How to tell if it is missing

The form area stays blank or shows a loading spinner that never resolves, and the browser console
reports an error containing **`LWR3008`** naming a Flow Tool Kit module.

If you see that, the fix is always the same: place the component, publish, reload.

## Which sites are affected

Any LWR site where a form uses one of the on-demand pieces, which includes most real forms:

- Lookup fields that open a search modal
- Table and repeater sections
- Rich text with flow buttons
- Record forms and inline record editing
- Field-level selector overrides (icon, email template, image, stylesheet)
- Illustration artwork
- The form builder and its previews

Rather than audit which of these your forms use, place the component on every LWR site that shows a
form. There is no cost to placing it on a site that turns out not to need it.

## Verifying

After publishing, open a form page on the site as a real visitor would, ideally in a private window,
and confirm the form renders and the console has no `LWR3008` error. Test the paths your forms
actually use, in particular any lookup search, table or repeater section.
