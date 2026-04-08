# Flow Tool Kit v3.218: Embed Forms on Any Website with Iframe Embed Mode

We're releasing Flow Tool Kit v3.218 with a major new feature: **Iframe Embed Mode**. You can now embed Flow Tool Kit forms on any external website using a simple copy-paste iframe snippet — no authentication required, no custom code needed.

## The Big Picture

Until now, embedding forms outside of Salesforce required either Experience Cloud or an authenticated Lightning Out setup. Both have their place, but many organizations just want to drop a form onto their existing website.

Iframe Embed Mode closes that gap. Create a Force.com Site, open the new Embed Code Generator tab, pick your form, and paste the snippet into your website. That's it.

![Embed Code Generator](../screenshots/100-embed-code-generator.png)

## What You Can Embed

**Flows** — Any active screen flow. Pass input parameters (pv1-pv9, recordId, submissionId) to pre-populate values or control flow behavior from the external page.

**Form Templates** — Multi-page Form Templates with all the features you'd expect: conditional logic, stage indicators, confirmation pages, and submission tracking.

**Record Forms** — Standalone record creation forms using Form Components. Select the object and optionally a specific form layout.

## How It Works

The setup takes about five minutes:

1. **Create a Force.com Site** — a Classic (Visualforce) site or an Aura Experience Cloud site. Either works.
2. **Set clickjack protection** to "No protection" on the Site detail page. This sounds alarming but is safe — the site only serves anonymous guest forms with no authenticated session to exploit.
3. **Assign the Form Flow User permission set** to the site's guest user.
4. **Open the Embed Code tab** in the Flow Tool Kit app, select your site and form, and click Copy to Clipboard.
5. **Paste the snippet** into your website's HTML.

The generated snippet includes everything: the iframe tag, auto-resize JavaScript that adjusts the iframe height as the form content changes, and a completion event listener that fires when the form is submitted.

Full setup instructions are in the [Iframe Embed documentation](https://docs.flowtoolkit.com/advanced-topics/iframe-embed).

## Under the Hood

The embed page is a lightweight Visualforce page that bootstraps Salesforce Lightning Out. Your form component renders inside the iframe with full Lightning styling. The parent page and iframe communicate via `postMessage` for resize events and form completion notifications.

We built a shared `iframeUtils` module that handles iframe detection, debounced resize observation, and completion messaging. This module is also used internally by form components to adapt their behavior when running in an embedded context.

## Critical Fix: Guest User Detection in Lightning Out

During development, we discovered that `@salesforce/user/isGuest` returns `false` in Lightning Out — even though the user is actually a guest. This is a Salesforce platform limitation: Lightning Out doesn't establish a proper guest user session, so client-side user modules can't determine the user type.

This caused real problems: confirmation pages didn't display after submission, duplicate records could be created, and guest-specific behavior (file upload tokens, button hiding, update guards) was silently disabled.

We fixed this across five components by adding `IS_IN_IFRAME` as a secondary check alongside `isGuest`. Apex correctly identifies guest users — it's only the client-side module that fails. This fix benefits all forms running in an embedded context, not just the new iframe feature.

## Other Fixes in This Release

**Address section rounded edges (#98)** — Sections with box or shadow styling now correctly apply rounded corners on address sections. A strict equality check was comparing a mutated class string instead of the original value.

**reCAPTCHA threshold comparison** — Changed from strict less-than to less-than-or-equal, so a score that exactly matches the threshold now passes instead of failing.

## Upgrade Notes

This release adds new metadata to your package:
- 1 Visualforce page (`EmbedForm`)
- 1 Apex class (`EmbedCodeGenerator_Controller`)
- 1 LWC component (`embedCodeGenerator`)
- 1 LWC module (`iframeUtils`)
- 1 Custom tab (`Embed Code Generator`)
- Permission set updates (page access + class access on all 3 permission sets)

The `iframeUtils` module modifies 5 existing LWC components to add the `IS_IN_IFRAME` guest user check. These changes are fully backwards compatible — existing forms in Lightning and Experience Cloud are unaffected.

Subscribers do **not** need to create a Force.com Site unless they want to use the iframe embed feature. The Embed Code Generator tab is available to all users with the Form Builder Admin or Form Builder Manager permission set.

## Get Started

Update to v3.218 from the [AppExchange](https://appexchange.salesforce.com) or your MetaDeploy installer, then check out the [Iframe Embed Guide](https://docs.flowtoolkit.com/advanced-topics/iframe-embed) for step-by-step setup instructions.
