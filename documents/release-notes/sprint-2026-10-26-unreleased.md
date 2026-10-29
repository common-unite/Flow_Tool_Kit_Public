# Unreleased: sprint 2026-10-26

## ⚠️ Upgrading: LWR sites need FlowToolKit LWR Support in the theme footer, then a publish

If a form on an LWR site shows no sections after this upgrade, or on the next publish of the site, the site needs two things: the **FlowToolKit LWR Support** component in the **Theme Footer** of its theme layout, and a **Publish**.

| Why | What you see without it |
| --- | --- |
| An LWR site serves the component code captured at its last publish, so an upgrade is not on the site until you publish | Blank form sections, `component/latest` requests failing with 401 or 503, `LWR3008` in the console |
| Since Winter '27 the LWR publisher bundles only what it reaches from the components on each page, and the Form Template loads its section forms on demand | A page holding only a Form Template publishes with no section forms, even on a site that worked before |

Steps: Experience Builder, any page, scroll to the Theme Footer, drag **FlowToolKit LWR Support** into an empty footer column, Publish, then open a form page by its own address in a private window. Full detail in [LWR Sites: Setup and Considerations](../experience-cloud/lwr-site-component-support.md) and [Upgrading Versions](../deployment/upgrading-versions.md). Aura sites and Lightning pages are unaffected.

## 🆕 Prefill from mapped sections

**Form Submission | Prefill From Mapped Record** fills a submission from records your prefill flow fetched, through the Submission Field Maps on your form components. The flow no longer needs a field-by-field mapping.

| Mode | Use it to |
| --- | --- |
| **Single** | Copy one record (an Account, a Contact, a Program) through every section mapped to its object. Chain one call per record. Works for guest users. |
| **Related** | Turn a collection (for example the other Contacts on the Account) into rows for the repeater or table section with a chosen Section Tag. |
| **Auto** | For users who may read the source records: read the lookups already set on the submission and copy those records as the running user. |

A value on the record replaces the submission value; a blank value never clears one.

Both starter prefill flows (`Form_Submission_Prefill` and `Form_Prefill_w_Screen_Template`) now show the pattern: the Pre-fill Mappings Transform sets defaults and lookups, then the action copies the Account, the primary Contact and the alternate Contacts. They are examples: keep the Transform for defaults, or remove it and let the mapped sections do the work. The starters now fetch all fields, so a newly mapped field needs no flow edit.

## 🆕 Page sections on other objects in Custom mode

A page section's Custom form can now be built on any object (Account, Contact, a custom object) from the new **Object** list, and mapped to Form Submission fields on the Form Template Mapping tab.

## 🆕 Mapped sections keep formulas current and stay in sync

Three behaviours for page sections mapped to another object:

- **Formulas recalculate from a mapped section.** A change in an Account or Contact section used to leave the Form Submission's formulas, and anything conditioned on them, at their last saved value. Now the first Form Submission section on the page recalculates once for every edit in a mapped section, the same as an edit in a Form Submission section, with no extra round trips when several sections draw formulas.
- **A mapped section recalculates once on load.** A prefilled or saved submission opens with current formula values instead of blank or stale ones. Repeater and data table rows are saved records and are left alone.
- **Sections on the same object stay in sync by the lookup they map.** Sections applied to the same Form Submission lookup share every field on every page of the template; sections on different lookups (Account and Parent Account, Primary and Alternate Contact) never touch; a form applied to **All** (every conversion) syncs with every section on that object on the page, through the fields it draws. The help text under **Apply these mappings to** states the rules, and the guide's [Several sections on the same object](../form-template-framework/form-template-mapping.md#several-sections-on-the-same-object) explains the two-record case.

## 🆕 One button bar on a page with a Flow section

A template page with a Flow section used to show two bars: the page's and the flow's. Now the flow chooses who drives, through two variables the Flow Section template already carries:

| The flow | Who drives | What happens |
| --- | --- | --- |
| Declares the text input `buttonTriggerName` | The page | The page's Continue, Submit, Back and Save Progress run the flow's docked buttons. Continue and Submit validate the flow; Back and Save Progress do not. On a flow with several screens, Continue moves to the next screen and Back to the previous one, and only the first screen's Back leaves the page. The flow's own bar hides itself. |
| Sets its output `hidePageButtons` to true | The flow | The page hides its own buttons on that page and the flow's docked bar drives, finishing with the clicked label as before. The flow can set it at start or change it on any screen. The review page always keeps its Submit. |
| Neither | As before | Both bars show, as in earlier releases. |

Flows cloned from the Flow Section template before this release keep working; add the two variables to adopt the single bar.

## 🆕 Rich text labels in the field editor

On a field's **Labels** tab, **Custom Label**, **Placeholder** and **Help Text** now work like a section title: they show formatted text, and clicking one opens the rich text editor. **Prepend** and **Append** stay plain.

These three values can now be longer than 255 characters, so a heavily styled label saves. Labels saved before the upgrade keep working with no change.

## 🛠 Fixes

- The Form Template Page preview shows section titles, icons, frame colours and fonts from the template's Style Editor settings. Before, a theme with white headings drew titles and icons white on white in the preview; the live form was unaffected.

- Conversions run again in an org with a custom Address or Geolocation field on Form Submission. The Setup action left the whole field out of the record it hands to the flow; its parts (street, city, latitude, longitude) are still there. Every conversion in such an org had failed since 5.0 with "A field wasn't found or isn't supported for Apex action".
- Conversions run again in an org with its own Form Submission field named like one of ours without the prefix (a `Submitted_By__c` beside `FlowToolKit__Submitted_By__c`). The package cannot read such a field, so it is left out of the Setup record and a debug log says so; read it in your own flow with a Get Records, or rename it. Every conversion in such an org had failed since 5.0 with "duplicate field selected".
- A long subtitle in a framed section with its title on the border no longer runs under the header icon; it wraps beside it.
- A repeater or data table inside a Flow section now lines up with the flow's form and the page's other sections; rows no longer sit 14px left and run past the page's edge. The Form Template Page preview shows the Flow section on the same edge as the page's own sections.
