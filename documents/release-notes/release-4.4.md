# Release 4.4

## 🆕 Non-Linear Navigation without Stages Mode (#301)

Stages Mode has always let respondents jump freely between pages. The new **Non-Linear Navigation** template checkbox brings the same freedom to linear templates: click any page on the **vertical stage indicator** and jump straight to it - no validation gate on leaving (required fields still enforce at submit), with the respondent's stage records updated exactly as Stages Mode would.

**Availability rule:** the toggle only applies when the Stage Indicator Type is `vertical` and Stages Mode is off - Stages Mode already allows free navigation, and the setting hides in Form Template Settings while Stages Mode is on.

![The Non-Linear Navigation toggle in Form Template Settings](https://raw.githubusercontent.com/common-unite/Flow_Tool_Kit_Public/main/documents/screenshots/301-non-linear-navigation-toggle.png)

## 🆕 Exclusive values in multiselect picklists (#305, #308)

Some answers rule out every other answer - and now the form knows it. When a multiselect option's value is one of the **exclusive values** below (case-insensitive), selecting it clears every other selection and locks the remaining options until it is unchecked, across all display types (Multiselect Checkbox, Select All variant, Badge, Combobox, and Visual Picker):

- `None of the Above`
- `None`
- `Prefer not to say`
- `Prefer not to answer`
- `Prefer not to disclose`
- `Not Applicable`
- `N/A`

No configuration needed - name the picklist value one of these and the behavior applies. Two exclusive values in one picklist mutually exclude each other.

![Selecting Prefer not to say clears and locks the other options](https://raw.githubusercontent.com/common-unite/Flow_Tool_Kit_Public/main/documents/screenshots/305-exclusive-multiselect-values-demo.gif)

- **`All of the Above` inverts**: selecting it selects every non-exclusive option, exactly like Select All; unchecking clears the selection.
- **By design**: the Select All display type hides its synthetic Select All button whenever the picklist contains an exclusive value - the two could never sensibly coexist. Remove the exclusive value and the button returns.
- **Behavior change**: multiselects with an existing bare `None` value (e.g. Dietary Restrictions) previously allowed None alongside other choices; None is now exclusive.
- The **Contact 1/2 Race & Ethnicity** multiselects gained a `Prefer not to say` value (#308), which pairs with this behavior out of the box.

## 🆕 Review Mode: the whole submission at a glance (#291)

A new **Review Mode** checkbox on the **Form (Template)** component turns it into an internal review panel. Instead of the page-by-page form, the review page loads as the **only** page: every answer from every page, grouped under its page and section headings - no stage indicators, no page navigation, no button bar. Drop it on the Form Submission record page and staff read the entire response top to bottom.

- **Available on** Lightning record, app, and home pages plus Flow screens (input-only). Deliberately not offered in Experience Cloud - this is an internal tool.
- **Works on any template** - the review summary is generated on the fly, whether or not the template's Enable Review Screen setting is on.
- **Read Only decides the tool**: with Read Only, a sealed summary whose per-section **View** modal only displays; without it, per-section **Edit** modals whose **Save** validates the section (errors block the save and hold the modal open) and persists immediately - no separate Submit for corrections. **Cancel** rolls the answers back to exactly what the modal opened with.
- The edit modal is titled by the section's own header (rich text rendered properly), and the review layout steps its hierarchy: page title, indented section titles, indented field rows.
- **Attestation hardening along the way**: required attestation cards now show their validation message below the card with a red error tint (previously the message rendered inside the toggle), the button top-aligns to the card, and the button's fill renders correctly in both SLDS and SLDS2 themes.

## 🆕 Nullable Fields: let blank answers clear data during conversion (#306)

Conversion mapping has always been protective - the Strip Null Values action removes blank answers before writing, so a matched record is only ever enriched, never wiped. But sometimes blank *is* the answer: a respondent clearing their phone number or unchecking a consent box expects the record to follow. The new **Nullable Fields** setting on the Form Template opts specific fields into clearing while everything else keeps the protection.

Pick fields with the new selector under **Data Conversion Settings → Advanced Data Mapping Overrides** - choose any object in your org, add from its updateable fields, and the choices group into a card per object:

![Choosing objects and fields in the Nullable Fields selector](https://raw.githubusercontent.com/common-unite/Flow_Tool_Kit_Public/main/documents/screenshots/306-nullable-fields-selector-modal-demo.gif)

The template shows the selection as badges grouped by object, with inline remove:

![Nullable Field badges grouped by object with inline remove](https://raw.githubusercontent.com/common-unite/Flow_Tool_Kit_Public/main/documents/screenshots/306-nullable-fields-badges-demo.gif)

- **Works everywhere conversion runs**: all six packaged conversion flows (Account, Contact, Lead, Case, Opportunity, Campaign Member) pass the template's value into their Strip Null Values calls automatically. Checkboxes clear to `false` (a checkbox cannot hold null).
- **Extensible by field name**: add a `Nullable_Fields__c` Long Text field to any object and it renders the same selector in the Form Builder - scope it to one object (simple CSV storage) or leave it Universal (object-keyed JSON map).
- **Flow-friendly**: the action's **Nullable Fields (CSV or JSON)** input also takes a hand-built string - `Email, Phone` from a formula, or a JSON map like `{"Contact":["Email"]}` where only the stripped record's object entry applies.
- **Loud failures**: invalid or non-updateable field names and malformed JSON fault the conversion with a clear `Nullable Fields:` error instead of being silently skipped; blank input, a bare comma, and `{}` are safe no-ops.
- **If you override conversion flows**: overrides cloned before this release don't have the new binding - add the template's `Nullable Fields` field to each Remove Null Values action's input to adopt the behavior.

## 🛠 Visual picker: alignment, selected icon color, bolder hover label (#310)

- **Cards align with the other inputs**: the outer edges of the first and last cards now sit flush with the fields above and below (the gutters between cards are unchanged). Two compounding causes fixed: the native `fieldset`'s default browser padding leaks through under Lightning Web Security where global SLDS resets can't reach, and the grid's pinned 100% width meant gutter-compensating margins shifted the row instead of widening it.
- **Selected icon takes the brand color**, matching the selected card's border; unselected icons stay neutral. This also repairs the original icon coloring, which used a legacy styling-hook prefix that modern Lightning Web Security ignores - icons had been rendering grey in every state.
- The **hover label overlay is now bold** for readability over the faded card media.

## 🛠 Likert matrix now accepts answers from guest users (#319)

Guest (unauthenticated) visitors on Experience Cloud sites saw likert matrix rows render read-only and could not select any option, even with full field-level edit access granted. Salesforce never grants guest users record *update* permission, and the matrix was checking that edit-mode permission for everyone; every other input type was unaffected because standard create-mode forms check *create* permission instead. Likert rows (and the running-total score) now treat a field as writable when the user can set it on either create or update, so guests answer normally while genuinely read-only users still see a locked matrix.

## ⚡ Faster Experience Cloud form loading (#314)

A ground-up performance pass on the form template runtime for public sites. Measured on a 7-page grant application template as a returning guest visitor: **page load dropped from ~5.6s to ~3.2s**, and **entering a step dropped from ~8.5s to ~1.5s**. The engine now platform-caches the expensive form-metadata lookups that previously ran on every page view, starts its main server call earlier instead of waiting on record-schema round trips, and quietly pre-warms every form on the template during the idle moments after the page loads - so clicking into a never-visited step usually needs no server trip at all. Every optimization ships with equivalence tests proving the engine emits byte-identical form definitions.

**Two notes for admins:** (1) these gains rely on Platform Cache - make sure your org allocates capacity to the `FlowToolKit.FormComponents` partition (Setup → Platform Cache), or the engine falls back to uncached queries on every load. (2) The very first page load after installing an upgrade compiles component definitions server-side (~7s once per org); load your public form page once after upgrading so a real visitor doesn't pay it.

## 🛠 Form Template theme colors reach every button and indicator (#311)

Assigning a theme to a Form Template now propagates its brand and border colors to the parts of the template that previously ignored them: stage-mode buttons, the docked footer buttons (including hover, pressed, and focus states of both filled and outline styles), and the vertical stage indicator's current-step marker. Section-level theme overrides still win locally, exactly as before.

## 🛠 Long-text fields no longer show a required error the moment you click in (#312)

Focusing an empty required long-text, textarea, or rich-text input flashed the "complete this field" error immediately on focus. Validation for the focused field now waits for focus-out, matching how every other input type behaves.

## 🛠 Guest save failures now explain the fix (#313)

When a guest submission failed because the Form Submission Upsert flow was left running in Default Mode, the error surfaced as a raw `CANNOT_INSERT_UPDATE_ACTIVATE_ENTITY` fault. That situation is now detected and translated into a plain-language message pointing at the fix: run the flow elevated (System Context Without Sharing).
