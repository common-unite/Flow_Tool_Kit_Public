# What's New

> The latest features and improvements in Flow Tool Kit.

## Latest Release: v5.4

{% hint style="info" %}
**Install or upgrade:** get the latest release from the [Common-Unite install page](https://install.common-unite.com/products).
{% endhint %}

**New features**

- **Email fields check for a complete address** (a name, an @ and a domain with a dot) before the form moves on, with [ready-made patterns](../form-configuration/field-validation.md#built-in-email-address-check) to paste into a Field Format.
- **Banner**: one shared header with each template's own logo and colors, plus an org default logo.
- **Help links** (What's New, Slack Support, Office Hours) in the Form and Table Builder.

**Bug fixes**

- **Review screen**: dates show as saved in any time zone, and File Upload fields list their files by name.
- **Installs in orgs without Orders**: Flow Tool Kit no longer stops with "orders aren't enabled" (every version from 4.42.0.3 through 5.3.0.2).
- **A flow's sheet shows only the flow's own buttons**, with no extra Close under them.
- **Add to Account** links the Contact to the converted Account, and **converted Opportunities** are named from the submission's Subject.
- **15-character Ids in email links** reach the prefill flow as 18-character Ids.

See the [5.4 release notes](../release-notes/release-5.4.md) for every new feature and fix.

## v5.3

- **Typing keeps every character**: in Form Templates with a page or section conditional rule (from 5.0 on), a pause mid-word could drop characters or empty the field. Every character now stays, on every host. Forms without those rules never had the problem.
- **Save Progress email**: on ordinary (non-stages) forms, respondents get an email with a link that reopens their draft when they save.
- **PDF on the confirmation email**: attach a PDF of the answers to the confirmation email.
- **Picklist option descriptions**: a short description under each picklist option, set in the Form Builder.
- **Header Tags and a Banner header** for every new Form Template.
- **Export and import Form Components** between orgs.
- **Reprocess many submissions at once**, with a summary before anything changes.
- **Open Web Form** on Form Templates, and a link can now fill in a Time field.

See the [5.3 release notes](../release-notes/release-5.3.md) for the upgrade checklist and every fix.

## v4.1

99 ready-made Form Submission fields (132 to 231) so new forms need zero field creation: generic question shapes, rating-scale batteries sized for instant Likert sections, nonprofit staples, and demographics, all with full value sets and permission set coverage. Plus a thirteen-component grant application demo, the guest first-save fix, and record forms working on objects without MRU. See the [4.1 release notes](../release-notes/release-4.1.md).

## The 4.0 Milestone

Flow Tool Kit 4.0 marks a major milestone: forty-six releases of new capability rolled into one recommended version. The [4.0 release notes](../release-notes/release-4.0.md) collate everything shipped since 3.196, led by eight spotlight features:

- **Stages Mode**: long forms as a non-linear stage overview with statuses, time estimates, collaborative progress records, and a [live public demo](https://common-unite.my.site.com/s/form-template/a0fRQ000003mUy9/affordable-housing-land-trust-application?language=en_US)
- **Save & Resume + Autosave**: silent draft saves plus single-use emailed resume links
- **The Survey Suite**: Likert Matrix sections, Survey Buttons, and Visual Picker cards
- **Number inputs, grown up**: steppers, sliders, and preset amount chips
- **Iframe Embed Mode**: any form on any website, with reCAPTCHA and auto-resizing
- **Prefill Flow + Guest Save Override**: extend prefill, validation, and guest saves with Flow, not code
- **Form Template Sources**: one template powering hundreds of campaigns, events, or programs
- **Per-Template Style Sheets**: scoped CSS per template with an upgrade-safe starter

{% hint style="info" %}
See the [full 4.0 release notes](../release-notes/release-4.0.md) for every new feature, improvement, and fix since 3.196.
{% endhint %}

### v3.241 highlights

Key highlights from recent releases:

- **Number display types** (v3.241): number, currency, and percent fields as a Stepper (minus/plus with a configurable increment), a Slider, or Preset Amount chips with an optional custom-value input, currency and percent formatting intact in every mode
- **Dynamic selector display types** (v3.241): fields named for icons, email templates, image assets, or style sheets get real pickers, including the complete current SLDS icon set
- **Form template save-flow fix** (v3.241): the packaged save flow now ships active; form template saves for standard and guest users work out of the box; if your users hit save errors on templates, this fix alone is worth the upgrade
- **Text fields as text areas + read-only clamp** (v3.241): any Text field can render multi-line, and Maximum Height clamps long read-only content into a scrollable box
- **Likert Matrix sections** (v3.240): survey-style question grids with a shared answer scale, two modes (Picklist and scored Number), a live total row, and optional stamping of the running score into a number field
- **Survey Buttons + Visual Picker display types** (v3.240): picklists as full-width option cards or icon/image cards with brand-tinted selection

## Previous Releases

| Version | Highlights |
|---------|-----------|
| [v5.4](../release-notes/release-5.4.md) | Email address check, Banner logo and colors from the template, help links in the builders, review screen dates and uploads, installs without Orders |
| [v5.3](../release-notes/release-5.3.md) | Typing keeps every character, Save Progress email, PDF on the confirmation email, picklist option descriptions, Header Tags, Form Component export and import |
| [v4.0](../release-notes/release-4.0.md) | Cumulative milestone release: Stages Mode, Save & Resume, Survey Suite, number inputs, iframe embed, prefill flow, template sources, style sheets |
| [v3.241](../release-notes/release-3.241.md) | Number display types, dynamic selectors, save-flow fix, section overlap fix |
| [v3.240](../release-notes/release-3.240.md) | Likert Matrix sections, Survey Buttons, Visual Picker |
| [v3.239](../release-notes/release-3.239.md) | Critical flow-save fix, autosave, option labels, style sheets, stage indicators |
| [v3.238](../release-notes/release-3.238.md) | Upgrade-safe (unrestricted) config picklists |
| [v3.237](../release-notes/release-3.237.md) | JSON page-section save fixes, cross-org paste field skip |
| [v3.236](../release-notes/release-3.236.md) | Form Template import fix, style-injection hooks |
| [v3.235](../release-notes/release-3.235.md) | Page Sections Configurator epic |
| [v3.234](../release-notes/release-3.234.md) | Page-sections foundation |
| [v3.211](../release-notes/release-3.211.md) | Formula recalculation, conditional logic improvements |
| [v3.208](../release-notes/release-3.208.md) | Earlier feature release |

## Stay Updated

- **Install**: the [Common-Unite install page](https://install.common-unite.com/products) always has the latest release
- **Slack**: [join the Flow Tool Kit community](https://common-unite.my.site.com/slack) and ask questions there
- **Office hours**: [book a spot in our daily office hours](https://calendly.com/common-unite/daily-office-hours)
- **Vimeo**: [Flow Tool Kit Video Library](https://vimeo.com/showcase/flowtoolkit) for video walkthroughs of new features
- **LinkedIn**: Follow [@flowgrammer](https://www.linkedin.com/in/flowgrammer/) for feature announcements and tips
- **AppExchange**: [Flow Tool Kit listing](https://appexchange.salesforce.com/appxListingDetail?listingId=a0N4V00000HC4zCUAT)
