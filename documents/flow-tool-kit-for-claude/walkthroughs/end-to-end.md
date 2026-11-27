# End-to-end walkthrough: a FormAssembly form becomes a working Flow Tool Kit form

This walkthrough follows one request from the first sentence to a form that saves records. It touches the main skills in order. All names and data are invented: the organization is Riverbend Arts Fund, and the form is its grant application. Read the lines aloud as a video script.

**Cast:** you (an implementation consultant) and Claude, with the `flow-tool-kit` plugin installed and connected to a Riverbend sandbox.

**Time on screen:** about 12 minutes.

---

## Scene 1. One sentence starts it ([ftk-start](../skills/ftk-start.md))

**You:** Riverbend Arts Fund has a grant application on FormAssembly. Move it to Flow Tool Kit. Here is the link.

**Claude:** Happy to. Three questions I cannot find in the org. Is Riverbend on the free or the paid Flow Tool Kit edition? Who fills this in: the public, signed-in portal users or staff? And do you want a brand kit pulled from their website?

**You:** Paid. The public applies, staff review. Yes to the brand kit.

**Claude:** Noted. I will read the org first, then plan.

*On screen: the three answers are stored with the org. Nothing has changed in the org yet.*

## Scene 2. Look before building ([org-catalog](../skills/org-catalog.md))

**Claude:** I cataloged the org: 9 Form Components and 3 Form Templates. A Contact Details block and a Mailing Address block already exist. There is also a mapped form on Contact that lands on the packaged Contact fields. I will reuse those and ask you before I do.

*On screen: the catalog file, with the two reusable blocks highlighted.*

## Scene 3. Read the old form ([form-migrate](../skills/form-migrate.md))

**Claude:** I read the FormAssembly form. It has 3 pages and 28 questions: applicant details, project and budget, then a certification with a signature. Three rules: a fiscal-sponsor block shows only when the applicant is not a registered nonprofit, and two budget fields are calculated. The Salesforce connectors are not visible from the public link, so I marked them not captured. Do you have the export?

**You:** Here is the connector export.

**Claude:** Thank you. The old form created a Contact and an Opportunity. Name, email, phone and address land on Contact through the mapped form. I need two new Form Submission fields: Requested Amount and Certification Date. Here is a workbook you can mark up. Anything you change, I read back.

*On screen: the plain-language summary and the mapping workbook.*

## Scene 4. The organization's look ([brand-kit](../skills/brand-kit.md))

**Claude:** From riverbendartsfund.example I found a deep teal for buttons and headings, a sand background and a serif heading font. I read these from the stylesheets, with no browser. Pick a logo and a banner from this file.

**You:** Logo 1, banner 4.

**Claude:** Saved to the org: the colors and fonts in the Form Style defaults where blank, and the images filed in the Asset Library. Next time, I will offer to reuse this kit.

## Scene 5. Design it ([form-design](../skills/form-design.md))

**Claude:** Here is the design. Page 1, Applicant, reuses Contact Details and Mailing Address. Page 2, Project and Budget, is new, with the fiscal-sponsor block marked conditional. Page 3, Certification, has the e-signature. It is a long form, so it gets Save Progress and a review screen, about 12 minutes. One section needs more than plain questions: the budget lines add up live. I will handle that as a custom component. The canvas has one artboard per page.

**You:** Change the page 2 description to be friendlier.

**Claude:** Changed in the plan and redrawn.

*On screen: the review canvas, the conditional field marked, and the confirmation email drawn on its own artboard.*

## Scene 6. Build the template ([build-template](../skills/build-template.md), [build-form-component](../skills/build-form-component.md))

**Claude:** Building from the approved plan. The template 'Grant Application' now has 3 pages, 6 sections and 28 fields, with the two new Form Submission fields. I reused Contact Details as it is, extended Mailing Address and built Project and Budget new. I read the template back and it matches the plan on every field and rule, and I walked each rule both ways in Preview.

## Scene 7. The live budget total ([build-custom-lwc](../skills/build-custom-lwc.md))

**Claude:** A live total that reads a table is beyond a native control, so I built a small Lightning web component. It renders the budget form inside itself, so it keeps the template's styling, and adds only the total card. It uses the brand color and will follow a theme change without a redeploy. Tests pass, and the section points at it.

*On screen: in Preview, typing three budget lines updates the total as the applicant types.*

## Scene 8. The confirmation email ([build-email-templates](../skills/build-email-templates.md))

**Claude:** I built the confirmation in the teal letterhead: a thank-you, the project title and requested amount merged in, what happens next and a contact. I also built the shared resume email for Save Progress. A test submission delivered both.

## Scene 9. Where the answers land ([new-mapping-flow](../skills/new-mapping-flow.md))

**Claude:** This is a paid org, so I use the packaged conversion flows and let Form Builder field mapping fill the fields. I hand-built only two things the maps cannot do: the Opportunity name combined from organization and project, and the Opportunity record type 'Grant'. Test submission: one Contact and one Opportunity, correct. A second submission with the same email updated the Contact instead of duplicating it.

## Scene 10. Let the public in ([flow-access-fix](../skills/flow-access-fix.md))

**Claude:** Because the public fills this in with Save Progress on, I checked the guest setup. I granted the flows to the guest permission set, created the system-mode copies of the Upsert and Prefill flows a guest needs to save and resume, and checked sharing: the form reads nothing from the org, so no guest sharing rule is needed. I reloaded as a guest: Next works and a saved application resumes.

## Scene 11. What was built ([field-audit](../skills/field-audit.md))

**Claude:** Last, the data dictionary: 28 fields, each with label, type, description, help text and where it is used. Two lack help text; I listed them.

**Result.** From one sentence and a few answers, you have a working grant application on Flow Tool Kit: designed on the organization's brand, built as a template with a live budget total, saving to Contacts and Opportunities, with a confirmation email, safe for the public, and documented. Every step was checked, and nothing was built before the plan was approved.

---

Other skills used in this pattern, when the request calls for them: [formassembly-capture](../skills/formassembly-capture.md) for a whole account, [build-flow-section](../skills/build-flow-section.md) for logic a custom component is not needed for, [pull-form](../skills/pull-form.md) to move the finished form to another org, and the site skills ([design-to-blocks](../skills/design-to-blocks.md), [build-site-pages](../skills/build-site-pages.md), [sf-guest-audit](../skills/sf-guest-audit.md)) when the form lives on an Experience Cloud site.

[Back to the documentation overview](../README.md)
