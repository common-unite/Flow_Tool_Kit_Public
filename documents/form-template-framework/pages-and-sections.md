# Pages and Sections

> How Form Template Pages and Sections work — ordering, configuration, and relationship to form components.

## Video Walkthroughs

{% embed url="https://vimeo.com/974649164" %}

{% embed url="https://vimeo.com/976267542" %}

![Form Builder embedded in a template page](../screenshots/form-template-framework/pages-and-sections/form-builder-in-page.png)

## Page Structure

Each `Form_Template_Page__c` record represents one step in the multi-page form. Pages are displayed one at a time with navigation controls.

### Page Fields

| Field | Type | Description |
|-------|------|-------------|
| **Form Template** | Lookup | Parent template this page belongs to |
| **Position** | Number | Display order (sorted ascending) |
| **Label** | Text | Page title shown in navigation |
| **Active** | Checkbox | Whether this page is included |
| **Conditional Logic** | Text | Conditions for showing/hiding this page |

### Page Ordering

Pages are sorted by the **Position** field (ascending numeric). Best practice:
- Use increments of 10 (10, 20, 30) to leave room for insertions
- Gaps are fine — only the relative order matters
- Duplicate positions cause unpredictable ordering

## Section Structure

Each `Form_Template_Page_Section__c` record represents one component within a page. A page can have multiple sections, each rendering a different component. A section's **Component Type** (set in the page section configurator) determines what it renders — a Field Set, Repeater, or Table form component, a **Flow** (see [Flow Sections](#flow-sections) below), a custom **Lightning Web Component**, or static **Display Text**.

### Section Fields

| Field | Type | Description |
|-------|------|-------------|
| **Form Template Page** | Lookup | Parent page this section belongs to |
| **Position** | Number | Display order within the page |
| **Form** | Text | QualifiedApiName of the form component to render |

### Multiple Sections Per Page

When a page has multiple sections, each section renders its form component in order. This lets you combine form components for different objects on the same page:

```
Page: "Contact & Organization"
├── Section 1 (Position: 10) → "Contact_Info" form component (Contact object)
└── Section 2 (Position: 20) → "Org_Details" form component (Account object)
```

## Flow Sections

A section can render a **Screen Flow** instead of a form component. In the page section configurator, set **Component Type** to **Flow** — the source field becomes a **Flow** picklist.

### Why a picklist (and what it lists)

The picklist shows **only active flows that were built from the `(Form) Flow Section | Template` flow template** (shipped in the `FlowToolKit` package). That template comes pre-wired with the input and output variables the form runtime exchanges with each section — `record`, `recordId`, `review`, the navigation button labels (`buttonLabel_Back` / `buttonLabel_Next` / `buttonLabel_Finish` / `buttonLabel_SaveProgress`), the current `stage` and `section` records, and `SectionQualifiedApiName` — so a flow created from it drops into a page section and participates in form navigation, prefill, and review without any extra wiring.

The **`section`** input (the `Form_Template_Page_Section__c` record) is what lets a flow persist its own repeater/table rows correctly: stamp `Internal_SectionId__c = {!section.Id}` on each row so the form filters them back into this section on reload, and read `{!section.Form_Template_Page__c}` to set the resume page. The **`stage`** input (the current `Form_Submission_Stage__c`) lets a flow read or update stage progress in Stages mode.

A flow built from scratch will **not** appear, because it lacks that variable contract. (If a section already stores a flow name that isn't template-derived — for example one saved before this requirement — it still shows in the list, labeled *"Currently selected (not a Form Flow Section template)"*, so the saved value is never lost.)

### Create a new flow from the template

1. Go to **Setup → Flows → New Flow**.
2. Open the **All + Templates** tab in the flow gallery.
3. Select **(Form) Flow Section | Template** and click **Create**. This copies the template into a new flow that already contains the required input/output variables.
4. Build your screens between the template's start and output-assignment elements. **Leave the input and output variables in place** — renaming or removing them breaks the data exchange with the form.
5. **Save** and **Activate** the flow.
6. Back in the page section configurator, set **Component Type = Flow** and choose your new flow from the picklist.

> **Not seeing your flow?** Confirm it is **Active** and that it was **created from the template** (not from scratch). The picklist lists active, template-derived flows only.

### Flow sections in Stages mode

A flow section works in both linear and [Stages mode](stages-mode.md). The form template passes the **effective** button labels into the flow, so they match what the runtime expects:

- **Linear mode** — `buttonLabel_Back` / `buttonLabel_Next` carry the page's configured labels. When the flow finishes, the form advances to the next page (or submits on the last page).
- **Stages mode** — the labels become **Return** (`buttonLabel_Back`) and **Mark Complete** (`buttonLabel_Next` / `buttonLabel_Finish`). When the flow finishes, the stage is marked **Done** and the user returns to the stages overview; **Return** sends them back to the overview without completing the stage.

> The `buttonLabel_Next` value feeds both the Next and Finish inputs — your flow shows **Next** on intermediate screens and **Finish** on its last screen, and finishing returns control to the form.

#### Save Progress

When **Allow Save Progress** is enabled on the template, the form also passes `buttonLabel_SaveProgress`. Add a button bound to that label in your flow and wire it to a **Screen Action** that calls your upsert (auto-launched) flow. Saving this way persists the in-progress record **without ending the flow** — the user stays on the current screen.

### Finishing and saving — the data contract

The form template hands data to the flow through the input variables and reads it back through the **output variables** when the flow finishes. A flow built from the template already has these wired; your job is to keep them populated.

**What the flow returns on finish.** When your flow completes (the user clicks the **Finish** / **Mark Complete** button), the form reads these outputs:

- **`record`** — the main `Form_Submission__c` values the section collected.
- **`relatedRecords`** — the child rows (repeater/table) the section manages. Stamp `Internal_SectionId__c = {!section.Id}` on each so the form keeps them grouped with this section.
- **`buttonClickedLabel`** — set this to the label of the button the user clicked; it's how the form knows the flow finished on a forward action and should advance the page.
- **`isValid`** — let the form know whether the flow's own screens validated.

**Return the saved record Ids when you upsert.** Whenever a Screen Action saves (Save Progress, or a step that writes mid-flow), assign the **Id that the upsert returns back onto the record(s) in your flow's collection** — `record.Id`, and the Id of each row in `relatedRecords`. This is required because `FlowToolKit__ExternalId__c` (the upsert key the form stamps on every row) is a **unique** field:

- The **first** save inserts the row and the database assigns it an `Id`.
- A **later** save of the same logical row must be an **update by `Id`**. If the row still has no `Id`, the platform treats it as a new insert and rejects it with `DUPLICATE_VALUE` on `FlowToolKit__ExternalId__c` (the existing row already owns that key).

> If you see `duplicate value found: FlowToolKit__ExternalId__c`, the flow saved a record but didn't capture the returned `Id` back into the collection it saves from. Add an Assignment after the upsert that copies the saved Ids back onto your record / `relatedRecords` variables.

**Restart-on-invalid behaviour.** A page can hold more sections than just the flow. When the flow finishes but **another section on the page fails validation**, the form stays on the page and the flow section **re-renders, re-prefilled with the values just entered** (rather than sitting on a blank "finished" screen). The user fixes the other section and completes the flow again. Because the form has already captured the flow's `record`/`relatedRecords`, and those rows carry their Ids once you've returned them, the re-save updates the same rows instead of creating duplicates.

## Page Conditional Logic

Pages can be conditionally shown or hidden based on field values from **previous** pages.

**Supported conditions**:
- Field value equals / not equals
- Field is blank / not blank
- AND / OR combinations

**Limitation**: Conditions can only reference fields from earlier pages — not the current page or future pages. This is because the form data for later pages hasn't been entered yet.

### Example

Page 3 ("Spouse Information") is only shown when the "Marital Status" field on Page 1 equals "Married" or "Domestic Partnership".

## Related Pages

- [Creating Templates](creating-templates.md) — step-by-step template creation
- [Form Templates Reference](form-templates.md) — screen component properties
- [Page Conditional Logic](page-conditional-logic.md) — detailed conditional logic guide
