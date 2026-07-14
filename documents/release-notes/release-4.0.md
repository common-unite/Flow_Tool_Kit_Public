# Flow Tool Kit 4.0: Everything New Since 3.196

> Forty-six releases, December 2025 through July 2026, in one place: every new capability, improvement, and fix, with documentation links and live demos.

## ✨ Highlights

### Stages Mode: long forms, reimagined

The biggest rethinking of how long forms work. Instead of a forced Next/Back march, respondents land on a **stage overview**, where every page is listed with a status badge (Complete, In progress, Todo, Optional), a time estimate, and a description, and they complete stages in any order. Progress lives in real Form Submission Stage records, so several people can collaborate on one submission, **Mark Page Complete** stamps who finished what and when, and admins report on progress like any other data. The vertical progress rail doubles as a live map: check, pencil, clock, warning, and lock markers show each stage's true state, and clicking navigates. Layout options let each template hide the progress banner, hide completed fields, or crown the overview with a branded template header.

- **Stage overview home screen**: every page listed with a status badge, time estimate, and description; respondents work in any order
- **Real progress records**: stage status lives on Form Submission Stage records, so several people can collaborate and admins report on progress like any other data
- **Mark Page Complete**: stamps who finished each stage and when
- **Live progress rail**: check, pencil, clock, warning, and lock markers double as click-to-navigate
- **Per-template layout options**: hide the progress banner, hide completed fields, or show a branded template header

![Full Stages Mode walkthrough on a public site: landing on the stage overview, opening a stage, saving progress, and marking stages complete](../.gitbook/assets/125-stages-public-walkthrough-demo.gif)

**[Try Stages Mode live](https://common-unite.my.site.com/s/form-template/a0fRQ000003mUy9/affordable-housing-land-trust-application?language=en_US)**: the walkthrough above is a real public application form. Click through the stages, save progress, and mark pages complete, no login required.

📚 [Stages Mode](../form-template-framework/stages-mode.md)

### Never lose a respondent: Save & Resume + Autosave

Two features that together make abandoning a long form painless to recover from. **Autosave** silently saves drafts as respondents work: debounced on change or on a 10/30-second checkpoint clock, never writing when nothing changed, coordinating with manual Save Progress, and working for guests and iframe embeds. **Save & Resume via Email** adds a "Draft saved N minutes ago" indicator and an *Email me a resume link* button that sends a single-use, cryptographically random link returning the respondent to their exact saved state. Tokens clear on use and expire after seven days, email templates are admin-controlled per template, and a record-triggered flow lets admins send start-link invitations.

- **Autosave**: debounced saves on change plus 10/30-second checkpoints; never writes when nothing changed
- **Works everywhere**: guests, iframe embeds, and alongside manual Save Progress
- **"Draft saved" indicator**: respondents always know their work is safe
- **Email me a resume link**: a single-use, cryptographically random link back to the exact saved state
- **Admin-controlled**: per-template email templates, seven-day token expiry, and a record-triggered flow for start-link invitations

![Autosave in action](../.gitbook/assets/216-autosave-demo.gif)

📚 [Save and Resume Forms](../form-template-framework/how-to/save-and-resume-forms.md)

### The Survey Suite: Likert Matrix, Survey Buttons, Visual Picker

Form Builder became a survey tool. **Likert Matrix sections** render a battery of same-scale questions as one compact grid: rows are real fields, columns share one answer scale, and every click stores ordinary field data. Number mode scores the survey with a custom answer scale, a live total row, and a Total Score Result Field that stamps the running score into a number field for zero-code automation. **Survey Buttons** render any picklist as tap-friendly, full-width option cards that never collapse to a dropdown on phones. **Visual Picker** turns options into selectable icon or image cards with hover label reveal and brand-color selection; multiselects get checkbox behavior.

- **Likert Matrix sections**: batteries of same-scale questions as one compact grid; every answer stores as ordinary field data
- **Scored surveys**: number mode adds a custom answer scale, a live total row, and a Total Score Result Field for zero-code automation
- **Survey Buttons**: any picklist as tap-friendly, full-width option cards that never collapse to a dropdown on phones
- **Visual Picker**: icon or image cards with hover label reveal and brand-color selection; multiselects get checkbox behavior

![A scored Likert matrix updating its total live](../.gitbook/assets/144-likert-number-demo.gif)

![Visual picker cards](../.gitbook/assets/247-visual-picker-demo.gif)

📚 [Likert Matrix Sections](../form-configuration/likert-matrix-sections.md) · [Field Type Settings](../form-configuration/field-type-settings.md)

### Number inputs, grown up: Steppers, Sliders, Preset Amounts

Any number, currency, or percent field can render as a **stepper** (minus/plus buttons with an admin-configurable increment that never restricts typing), a **slider** (0–100 by default, honoring Min/Max/Step), or **preset amount chips**, the donation-page pattern, with an optional Other chip revealing a free-entry input. Currency and percent formatting apply in every mode, and the layout adapts to the container's real width, not just the device.

- **Stepper**: minus/plus buttons with an admin-set increment that never restricts what respondents can type
- **Slider**: 0–100 by default; honors the field's Min, Max, and Step the moment you set them
- **Preset Amounts**: label/value chips with an optional Other chip revealing a free-entry input
- **Formatting intact**: currency symbols and percent signs follow the field in every mode
- **Container-aware layout**: adapts to the space the form actually has, not just the device size

![Stepper, slider, and preset chips](../.gitbook/assets/254-number-overrides-demo.gif)

📚 [Field Type Settings: Number Fields](../form-configuration/field-type-settings.md#number-fields)

### Put any form on any website: Iframe Embed Mode

A Force.com Site serves your forms to the world: no Salesforce UI, no login. Choose a Flow, Form Template, or Record Form in the **Embed Code Generator** tab, copy the snippet, and paste it into WordPress, Squarespace, or any site. The iframe auto-resizes, publishes completion events via postMessage, respects guest-user security, and supports org-wide Google reCAPTCHA configured in one custom setting.

- **Embed Code Generator**: pick a Flow, Form Template, or Record Form and copy the snippet
- **Works on any site**: WordPress, Squarespace, or hand-rolled HTML
- **Auto-resizing iframe**: the frame grows with the form and publishes completion events via postMessage
- **Guest-safe**: respects guest-user security, with org-wide Google reCAPTCHA in one custom setting

![The Embed Code Generator](../.gitbook/assets/100-embed-code-generator.png)

📚 [Iframe Embed](../advanced-topics/iframe-embed.md)

### Prefill Flow + Guest Save Override: extend with Flow, not code

No screenshot does this one justice, and it may be the most powerful capability in the release. Every Form Template can name a **Prefill Flow**: an autolaunched flow or screen flow that runs before the form renders, built entirely in Flow Builder. Your flow receives the working Form Submission, already carrying the template's prefill values and any URL parameters, and whatever it returns becomes the form's starting state. Query the running user's records and greet them with a half-completed form. Seed repeater and table sections with related records, routed by migration-safe **Section Tags**. With the screen-flow variant, put screens in front of the form itself: a welcome page, terms acceptance, or a custom eligibility check.

The same contract handles validation. Set `hasError` with a rich-text `errorMessage` and the form never renders; the respondent sees your message on a branded error illustration instead: "you have already submitted," "applications for this program are closed," "this invitation was for someone else." One recipe worth stealing: when your flow finds an in-progress draft, hand off to the packaged send-resume-link flow and tell the respondent a resume link is waiting in their inbox. They return to their exact saved state instead of starting over or double-submitting.

Because it is ordinary Flow, it scales like Flow. Point every template at one shared prefill flow or give each template its own, and factor the common pieces (user matching, eligibility rules, draft detection) into subflows you reuse everywhere. Clonable starters ship in both autolaunched and screen-flow forms, a five-variable contract keeps the surface small, and a matching **Guest Save Override** flow defines the DML interface for guest saves: subscribers elevate deliberately, the package never does. Don't sleep on this feature.

- **Runs before render**: an autolaunched or screen flow you build entirely in Flow Builder
- **Prefill anything**: user records, URL parameters, and prefill template values all meet in one input variable
- **Seed related records**: fill repeater and table sections, routed by migration-safe Section Tags
- **Gate the form**: set `hasError` and a rich-text message ("already submitted," "not eligible") and the form never renders
- **Resume-link recipe**: detect an in-progress draft and email the respondent back to their saved state
- **Scales like Flow**: shared or per-template flows, reusable subflows, clonable starters in both flavors

📚 [Prefill Flow](../form-template-framework/prefill-flow.md)

### Build one form. Use it everywhere: Form Template Sources

One template can power hundreds of campaigns, events, programs, or cohorts. Each **source record** drives its own name, dates, availability window, branding, prefill values, and confirmation messaging, and every submission stamps its Source Id for downstream conversion and reporting. The **Template Source Editor** record-page component manages it all with tabbed navigation, auto-save, and a live form preview.

- **One template, many contexts**: campaigns, events, programs, or cohorts, each driven by its own source record
- **Per-source everything**: name, dates, availability window, theme, prefill values, confirmation message, and email template
- **Source Id stamping**: every submission knows exactly which campaign or event it belongs to
- **Template Source Editor**: a tabbed record-page component with auto-save and a live form preview

![The Template Source Editor](../.gitbook/assets/form-template-source-editor-demo.gif)

📚 [Form Template Sources](../form-template-framework/form-template-sources.md)

### Your brand, down to the pixel: Per-Template Style Sheets

Each Form Template can carry its own CSS. Pick a style-sheet static resource from a grouped, described selector, and the sheet injects scoped to that template's output: one template can look like a wedding invitation while another stays corporate, on the same org. An install-only starter stylesheet ships un-managed so upgrades never overwrite your customizations, stable style hooks mark every field wrapper and template container, and a reorganized [Custom Styling Overview](../form-configuration/custom-styling-overview.md) hub documents every layer of the cascade.

- **CSS per template**: pick a style-sheet static resource from a grouped, described selector
- **Scoped injection**: one template's look can never leak into other forms or the page around it
- **Upgrade-safe starter**: ships un-managed, so upgrades never overwrite your customizations
- **Stable style hooks**: every field wrapper and the template container are dependable CSS targets
- **One documentation hub**: the Custom Styling Overview maps every layer of the styling cascade

![Choosing a per-template style sheet](../.gitbook/assets/221-style-sheet-selector-demo.gif)

📚 [Custom Styling Overview](../form-configuration/custom-styling-overview.md)

---

## 🆕 New Features

### Form Building & Display Types

- **Custom Picklist Option Labels**: per-form display wording for any picklist or multiselect while stored values keep their API names; labels run through the merge pipeline and re-render live as other answers change. (3.239) 📚 [Picklist Option Labels](../form-configuration/picklist-option-labels.md) ![Option labels with live merge fields](../.gitbook/assets/223-option-labels-merge-demo.gif)
- **Attestation display type**: booleans render as a clickable consent card: checkbox beside a rich-text statement, brand-color fill when checked. (3.234) ![Attestation card](../.gitbook/assets/188-attestation-selector-demo.gif)
- **Dynamic Selector display types**: fields named for icons, email templates, image assets, or style sheets get real pickers, including the complete SLDS icon set (629 icons added). (3.241) 📚 [Field Type Settings](../form-configuration/field-type-settings.md#dynamic-selector-overrides)
- **Text fields as Text Areas**: any standard Text field renders multi-line with counter and height controls; Maximum Height clamps read-only long text into a scrollable box. (3.241)
- **Review Display Type**: design read-only "review your answers" screens in the same WYSIWYG editor. (3.210)
- **Question & Section Numbering**: `{{fieldnumber}}` / `{{sectionnumber}}` merge fields count visible fields and renumber live as conditional logic changes. (3.239)
- **Inline Label Width**: a per-field slider (10–90%) aligns inline labels on a shared edge. (3.227)
- **Per-field Help Text display modes**: Hover Bubble, Below Label, or Below Field. (3.234)
- **Boolean toggle Label Position**: Above / Left / Right with rich-text label support. (3.234)
- **Theme Label Color + Default Label Size**: a theme paints and sizes every label in a form. (3.234)
- **LWC Section Type**: embed any custom Lightning Web Component inside a form section with live record data, change events, and validation. (3.213) 📚 [LWC Section Type](../advanced-topics/lwc-section-type.md)
- **Section Divider Styles**: 12 designed, theme-driven divider styles with rich-text labels and icons. (3.234) ![Divider style picker](../.gitbook/assets/147-divider-style-picker-demo.gif)
- **Rich Text Message Cards**: render rich text as themed info/warning/error/success status cards. (3.234) ![Message cards](../.gitbook/assets/148-message-variant-card-demo.gif)
- **Record Compare for quizzes**: compare submitted values against a stored answer key. (3.196)

### Form Templates & Pages

- **Form Template Page Conditional Logic**: show or hide entire pages from Form Submission values with an expression builder; navigation, stages, and outputs adjust automatically. (3.211) ![Page conditional logic](../.gitbook/assets/68-page-conditional-logic.png) 📚 [Page Conditional Logic](../form-template-framework/page-conditional-logic.md)
- **Native Page Sections configurator**: live-preview add/reorder/delete on the record page, replacing the old screen flow; up to 15 sections per page; Display Text and LWC section types; in-place Customize modal. (3.234)
- **Form Templates on any record page**: dynamic Related Field resolution walking lookups up to grandparents, plus a fallback template for App/Home pages. (3.239) ![Record page resolution](../.gitbook/assets/234-record-page-resolution-demo.gif) 📚 [Host a Form on a Record Page](../form-template-framework/how-to/host-form-on-record-page.md)
- **URL Parameter Mapping**: map query parameters (pv1–pv9, UTM, payment intents) into form values on template load. (3.217) 📚 [URL Parameter Mapping](../form-template-framework/url-parameter-mapping.md)
- **Stage Mode Layout options**: hide the progress banner, hide completed fields, or show a branded template header per template. (3.239)
- **Final Submit Button Label**: label the true final submit distinctly from the button that opens review. (3.239)
- **Carousel Finish Button**: configurable finish action on the last carousel section with full-form validation. (3.211)

### Data, Conversion & Automation

- **Record-Based Components**: form/table/repeater configurations stored as real records, the foundation of the JSON-config architecture. (3.200)
- **Form Conversion Templates + Log Conversion Event**: the conversion pipeline's template plumbing and packaged event logging, later upgraded with log-only mode, a return platform event for external orchestration, and 200-request bulk safety. (3.199 → 3.239)
- **Fifteen self-documenting conversion flows**: every packaged flow and 500+ elements carry admin-facing descriptions; all call the logging action directly. (3.239) 📚 [Overridable Conversion Flows](../form-template-framework/how-to/overridable-conversion-flows.md)
- **Get SObject Type action**: record Id in, SObject API name out, in memory (~1ms). (3.210)
- **Flow Invoker action**: launch an autolaunched Flow from anywhere. (3.200)
- **Form (Navigate) action**: one LWC action with Web Page / Record Page / Experience Page modes replaces three Aura actions. (3.222)
- **Flow Tool Kit Settings**: org-wide hierarchy custom setting, starting with the Google reCAPTCHA site key. (3.220)

### Scheduling & Specialized Inputs

- **Schedule Mode for the Date/Time Picker**: generate calendar slots from configuration (days, times, ranges, skip dates) with no pre-fetched records. (3.206) 📚 [Date Time Picker](../screen-components/date-time-picker.md)
- **Three-mode form configuration**: Component / Variable / Custom JSON across form, table, and repeater, in Flow and Experience Cloud, with a unified configurator and a standalone JSON editor. (3.206)
- **Hide State/Province for stateless countries** in address sections. (3.200)

### Experience & Polish

- **Scroll Into View**: forms scroll smoothly into view on each render; templates scroll to top on page navigation. (3.231, 3.229)
- **Gradient Header Theme**: un-themed headers get a brand-aware gradient; themed headers can opt in. (3.219)
- **Spinner illustration + Auto-Navigate**: a full-screen branded loading overlay and auto-advance after async work. (3.222)
- **Approval illustration scene**. (3.197)
- **Loading overlay during prefill**: instant render with a delayed spinner while the prefill flow runs. (3.230)

---

## 📈 Improvements

### Builder & Admin Experience

- Form Builder and pickers no longer truncate at 61 forms per object; flat queries replace the capped subquery. (3.226)
- The section customize experience (Actions, Conversion Rules, Repeater/Table Settings) is driven by flowForm JSON configurations with an extensible Client Conversion Config slot. (post-3.241)
- Object selector groups the four framework objects under **Form Template Framework**, separate from your custom objects. (3.241)
- Static text accepted where variables were once required: header titles, button labels, calendar labels. (3.210, 3.206, 3.231)
- Searchable comboboxes, dual listboxes, breadcrumb navigation, and date/multiselect inputs across the property editors. (3.197, 3.206)
- Consistent Top/Bottom Margin controls on every visible component. (3.208)
- Admins bypass the platform cache and always see fresh metadata. (3.199)
- Attestation rich-text editing gains a code-snippet button and a persisted Rich/Plain toggle. (3.235)

### Performance

- Platform-cache expansion for conditional logic, sections, and form values; daily cache reset scheduled on install. (3.205)
- Data table: single-pass categorization and O(n) tree-view lookups. (3.205)
- Targeted `describeSObjects` replaces global describes; bulk static-resource and picklist queries replace N+1 chains. (3.205)
- Date/Time Picker and property-editor hot paths cached and de-quadraticized. (3.206)

### Accessibility & Mobile

- Screen-reader wiring: labels and help text programmatically linked, including radio/checkbox group names. (3.239)
- Radio group keyboard navigation follows the WAI-ARIA roving-tabindex pattern. (3.231)
- Encrypted and custom-lookup fields are keyboard-tabbable. (3.229)
- Mobile docked buttons keep Next/Submit visible with Save Progress in the overflow menu; safe-area padding for the iPhone home indicator. (3.231, 3.216)
- Vertical stage indicators expose real percent-complete to assistive tech. (3.239)

### Theming & Rendering

- Theme overrides, label colors, and custom style sheets reach JSON-rendered page sections on every render path. (3.235)
- Address pickers match name-based address fields (NPC and industry patterns). (3.215)
- Encrypted fields route through the UI API for platform-standard masking. (3.227)
- Repeater calculated totals render immediately on Experience Cloud. (3.227)
- Stages buttons, overview subtitle, and scroll-into-view refinements. (3.231)
- Resume-link email recipient resolution falls through four sources. (3.239)

---

## 🛠️ Fixes

Eighty-six fixes shipped across the range. The ones you would have noticed:

- **CRITICAL: components added to new flows failed to save**: Flow Builder on newer API versions corrupted the auto-assigned Record input; all eleven property editors now normalize both formats. Every org that builds new flows should be past 3.239. (3.239)
- **Form template saves for standard and guest users**: the packaged save flow now ships active; a new unique identifier restores its original replay-safe design. (3.241)
- **Lightning Out guest forms were completely broken**: a Locker Service double-proxy violation, fixed across 17 components with zero extra network calls. (3.215)
- **Config values rejected on upgraded orgs**: internal config picklists are now unrestricted, permanently future-proofing new options. (3.238)
- **Duplicate submissions** for non-guest users on Return / Save Progress / Mark Complete, and guest/iframe first-save reliability. (3.231)
- **Form Builder crashes**: repeater/table preview crash, record-page config rendering, JSON save cloning itself on every save, cross-org config paste, fast-navigation form wipe. (3.237–3.241)
- **Form Template section overlap**: a legacy negative margin painted each section over its neighbor. (3.241)
- **File uploads**: second upload overwriting the first, conditional logic support, fault handling, preview-link and deletion controls. (3.211–3.212)
- **reCAPTCHA in embeds**: works on external sites, with a timeout safeguard and one-setting org-wide key. (3.220–3.221)
- **SPA navigation state**: Experience Cloud record navigation resets accumulated state. (3.206)
- **Percent Min/Max scale**, phone validation on blur, theme heading colors under SLDS2, address review crash, encrypted-field focus traps, LWR navigation errors, stage indicator reverts, radio overflow on rounded corners, and dozens more small paper cuts. (throughout)

---

## 📚 Documentation

Everything above is documented on this site. Start at [Feature Overview](../welcome/feature-overview.md), then:
[Stages Mode](../form-template-framework/stages-mode.md) · [Save & Resume](../form-template-framework/how-to/save-and-resume-forms.md) · [Prefill Flow](../form-template-framework/prefill-flow.md) · [Likert Matrix](../form-configuration/likert-matrix-sections.md) · [Field Type Settings](../form-configuration/field-type-settings.md) · [Picklist Option Labels](../form-configuration/picklist-option-labels.md) · [Custom Styling](../form-configuration/custom-styling-overview.md) · [Iframe Embed](../advanced-topics/iframe-embed.md) · [LWC Section Type](../advanced-topics/lwc-section-type.md) · [Page Conditional Logic](../form-template-framework/page-conditional-logic.md) · [Conversion Flows](../form-template-framework/how-to/overridable-conversion-flows.md)

## Upgrade

4.0 is flagged as the package's recommended version: open Setup → Installed Packages → **Upgrade to Recommended Version**.
