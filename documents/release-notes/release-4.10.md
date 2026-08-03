# Release 4.10

## 🆕 Start a form, or open a submission, straight from a lookup (#391)

A **Form Template** or **Form Submission** lookup on a form component can now render the form itself in place of the lookup input. Two new options appear under **Lookup Field Display Type** in the Form Builder, and each is offered only when the lookup actually points at the matching object:

- **Start New Form**, on a Form Template lookup, begins a new submission of that template.
- **View/Edit Form Submission**, on a Form Submission lookup, opens the existing submission in place.

![Start New Form and View/Edit Form Submission](https://raw.githubusercontent.com/common-unite/Flow_Tool_Kit_Public/main/documents/screenshots/391-lookup-override-types-demo.gif)

### The record you are standing on is the source

This is the part worth understanding, because it is what makes the feature useful rather than just convenient.

**Start New Form passes the host record into the form, not the template you picked in the lookup.** So a Campaign, a Grant, an Account or any other record configured as a Form Template Source resolves through that configuration, and the new submission inherits everything the source defines: its theme, prefill template and prefill mapping, subtitle, banner image and submit button label, with `Source_Id__c` and the source lookup stamped onto the submission.

Put the same template behind the same lookup on two different Campaigns and each one opens branded, prefilled and titled for its own Campaign.

If the host object has no Form Template Source configuration, the template selected in the lookup is used instead, so the simple case still works with no setup. If the host record has not been saved yet and has no Id, the lookup value is used.

### Inline or behind a button

**Inline** renders the form directly in place of the lookup. **Button / Modal** renders a button that opens the form in a modal, which keeps the host form readable when the embedded form is long. The button label, modal heading and modal subheading are all configurable, and the button disables itself while the modal is open.

| Inline | Button / Modal |
| --- | --- |
| ![Inline](https://raw.githubusercontent.com/common-unite/Flow_Tool_Kit_Public/main/documents/screenshots/391-lookup-override-types-inline.png) | ![Modal](https://raw.githubusercontent.com/common-unite/Flow_Tool_Kit_Public/main/documents/screenshots/391-lookup-override-types-modal.png) |

In modal mode the form's page buttons render in the modal's own footer rather than docking to the bottom of the browser window, and the form keeps full ownership of validation, navigation and autosave. A form that is inactive or outside its start and close dates shows its **Not Available** message with no action buttons, exactly as it does inline.

### Notes

- The lookup input is hidden whenever either override is active, so users are not shown a record picker they are not meant to touch.
- Marking the field **read only** renders the embedded form read only.
- An empty Form Submission lookup renders nothing.
- A form that would render itself, where the host record Id equals the lookup value, renders nothing.
- Dismissing the modal mid-form is deliberately not handled by the framework. If you want save-on-dismiss or a confirmation prompt, wire it up with Auto Save on the page, Save Progress, or your own automation.

## 🆕 Site Design Blocks: four record-page primitives (#390)

The block library gains the four primitives that real program and funding pages are actually built from:

- **Facts** renders label/value rows as an "At a glance" or "Key facts" card, with a **Bars** display that turns numeric values into labelled horizontal bars for scoring rubrics. Values support `{{MergeField}}` record binding, so one block serves every opportunity page.
- **Timeline** shows a cycle's steps with real state per item: done, current, warning, or upcoming, in a horizontal stepper or a vertical numbered rail. It complements Steps, which stays the stateless how-it-works grid.
- **Quote** carries a pull quote with attribution, as a large standalone statement or an inset with a top rule, and supports buttons so a quote can hold its call to action.
- **Action Card** renders a deadline as "Closes in N days" with a progress bar across the open window, or a capacity pair like "7 of 20 seats". The deadline binds to a record date field, degrades to a closed state past the deadline, and stacks buttons with a microcopy line.

Three composition upgrades round it out:

- **The hero's split slot can hold an at-a-glance facts panel instead of an image**, which is the shape behind essentially every portal hero in our design studies: content left, key facts card right, one background spanning both.
- **Attach to previous block** joins adjacent blocks into one surface: the gap closes, adjoining corners square off, and matching backgrounds run together, so a composed dashboard reads as one card instead of four.
- **Heading Color and Text Color** controls on every block, for the deliberate muted tints a derived ink can never hit.

The Stats Bar and Cards blocks also traded their knob matrices for **named treatment pickers** covering the combinations the preset library actually uses. Existing pages keep rendering exactly as configured; the retired knobs simply stop being offered.

## 🎨 Style Design Blocks from your site's CSS (#395)

Every Site Design Block style now reads a `--ftk-site-*` design token, so a site stylesheet can retheme the entire block library, typography, surfaces, spacing, buttons, motion, without touching a block's configuration. See the new guide at `documents/experience-cloud/styling-design-blocks.md`.

## 🛠 Related records: add, edit, and delete reliably (#394, #397, #398)

Related-record sections (Repeater, Table, and custom LWC sections) got a reworked save pipeline for logged-in users:

- **Removing a saved related record now works everywhere, including on submissions that already converted (#397).** Deletes, creates, and updates run through the Form Submission Upsert flow the moment the form saves, instead of waiting for conversion to replay a JSON payload.
- **Clearing a value on a saved row now sticks (#394).** Previously an emptied text field, an unchecked checkbox, or a cleared date on a saved related row silently kept its old value.
- **Conversion can no longer duplicate related records (#397).** Rows created at save time are recognized by their unique id when the conversion payload replays, covering subscriber-customized override flows too.
- **The submission data table no longer spins forever (#398)** when a pending delete is hidden from view.

Guest submissions keep their existing conversion-time behavior, since guests cannot delete records.

## 🐛 Fixes

- **Design Block entrance animations actually fire now (#389).** Content no longer sits at opacity 0 waiting for an animation that never starts; the keyframe name was being routed through a CSS variable, which Lightning's scoped keyframes never resolve.

## 🔧 Under the hood

- The repo gains an LWC Jest harness (#396): 42 tests locking down related-record serialization, post-save reconciliation, and delete semantics, run locally with `npm test`.
