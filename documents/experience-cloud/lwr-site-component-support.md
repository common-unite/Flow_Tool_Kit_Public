# LWR Sites: Setup and Considerations

> **For LWR (Build Your Own (LWR) / Microsite) sites.** LWR sites build and serve pages differently from Aura sites, so a few settings and habits matter that Aura sites never need. Aura sites and Lightning pages are unaffected by everything on this page.

## Checklist

| Do this | Why | Symptom when missing |
| --- | --- | --- |
| Place the **FlowToolKit LWR Support** component once, then publish | LWR bundles only the components it can see at publish time | Form area blank or spinning, `LWR3008` in the browser console |
| Turn on **Allow guest users to access public APIs** | Forms load field details and records through Salesforce's public APIs, which LWR blocks for guests unless this is on | The form does not load for guests (for example "Unauthorized access") |
| Turn on **Let guest users view asset files** when forms use image assets | Guests can only load asset files the site shares with them | Picker images or background images are missing for guests |
| **Publish the site** after every Flow Tool Kit upgrade | LWR serves the component code captured at its last publish | Fixes from an upgrade do not appear on the site |

Both guest settings are under **Setup → Digital Experiences → All Sites → Workspaces → Administration → Preferences**. **Allow guest users to access public APIs** is not in the site's deployable metadata, so set it by hand on every site, in every org, including after a sandbox refresh or a site deployment.

## Place the Component Support block

1. Open your LWR site in Experience Builder.
2. Add **FlowToolKit LWR Support** to a page that every visitor loads. The site's template footer is the usual choice, because it appears on every page.
3. **Publish the site.** Placement alone does nothing until you publish.

The component renders nothing. It has no properties and no visible output.

### Why it is needed

Flow Tool Kit loads several of its heavier pieces on demand rather than up front, so a form only pays for the parts it actually uses. That is what keeps form pages fast.

LWR sites build their JavaScript bundle at **publish time**, from the components it can see on your pages. Anything loaded on demand is invisible to that analysis, so it never makes it into the bundle, and the browser cannot find it later. The Component Support block exists purely to be visible to the publish-time analysis. Placing it tells the site "include these too."

Aura sites do not work this way. They can fetch a component definition on demand at runtime, which is why they need no equivalent step.

### Which forms need it

Any LWR site where a form uses one of the on-demand pieces, which includes most real forms:

- Lookup fields that open a search modal
- Table and repeater sections
- Rich text with flow buttons
- Record forms and inline record editing
- Field-level selector overrides (icon, email template, image, stylesheet)
- Illustration artwork
- The form builder and its previews

Rather than audit which of these your forms use, place the component on every LWR site that shows a form. There is no cost to placing it on a site that turns out not to need it.

## Guest users

### Allow guest users to access public APIs

Flow Tool Kit forms read the object's field details and the record through Salesforce's standard data APIs (Lightning Data Service). On an LWR site, guests cannot use those APIs until **Allow guest users to access public APIs** is on, so the form does not load for them. The Record Picker needs it for the same reason.

### Let guest users view asset files

Visual Picker images and form, section and header background images come from public image assets. Guests can only load them when **Let guest users view asset files, library files, and CMS content available to the site** is on.

Flow Tool Kit builds asset URLs from the site's own path on LWR (for example `/portal/sfsites/c/file-asset/<asset>`), because an LWR site serves nothing at the domain root. Before 4.45, asset images used a URL from the domain root, which an LWR site does not serve, so they did not load on LWR sites. Upgrade to 4.45 or later and publish the site.

### Flows that guests run

A flow that guests run, for example one shown with the **Form (Dynamic Flow)** component, must be restricted to permission sets and granted to the guest user:

1. In the flow's properties, turn on **Override default behavior and restrict access to enabled profiles or permission sets**, and activate the flow.
2. Add the flow to a permission set (**Flow Access**) and assign that permission set to the site's guest user.

Without this, a flow requires the **Run Flows** permission, which guest users never have, and the site shows "You do not have the level of access necessary to perform the operation you requested." This applies to Aura sites too.

Guests still need the object, field and sharing access that the form itself uses. See [Deploy to Experience Cloud](../how-to-guides/deploy-to-experience-cloud.md).

## Publish after every upgrade

An LWR site keeps serving the component code it captured at its last publish. After you upgrade Flow Tool Kit, open each LWR site in Experience Builder and **Publish**, or the site keeps running the previous version's components. Aura sites pick up the new version without publishing.

## Verifying

After publishing, open a form page on the site as a real visitor would, in a private window, and check:

- The form renders, and the browser console has no `LWR3008` error.
- Any Visual Picker images and background images show.
- The paths your forms actually use work, in particular lookup search, table and repeater sections, and flows.

## Troubleshooting

| Symptom | Likely cause |
| --- | --- |
| Form area blank or spinning, `LWR3008` in the console | Component Support block missing, or the site was not published after placing it |
| Guests see "Unauthorized access" or no form | **Allow guest users to access public APIs** is off |
| Picker or background images missing for guests | **Let guest users view asset files** is off, or the site runs a version before 4.45 |
| "You do not have the level of access necessary" where a flow should be | The flow is not restricted to permission sets and granted to the guest user |
| An upgrade's fixes do not show on the site | The site was not published after the upgrade |

## Related Pages

- [Deploy to Experience Cloud](../how-to-guides/deploy-to-experience-cloud.md): adding forms to site pages and guest permissions
- [Upgrading Versions](../deployment/upgrading-versions.md): steps after every upgrade
- [Use the Record Picker](../how-to-guides/use-the-record-picker.md): guest and LWR notes for the Record Picker
