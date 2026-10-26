# Form Template Mapping

> Put an Account, Contact or custom object form in a Form Template page section. Map its fields to Form Submission fields once, and the template treats it like any other section.

A Form Template page section used to hold only Form Submission forms. If you already had a good Account or Contact form, you had to rebuild it field by field on Form Submission before a template could use it.

Form Template Mapping removes that step. In the Form Builder you tell a form on another object which Form Submission field each of its fields stands for. The form then reads and writes the submission, never its own object. Conversion fills the real Account or Contact from the submission afterwards, the same as it does today.

![The Form Template Mapping tab on an Account form](../screenshots/955-form-template-mapping-tab.png)

## What you can do

* **Reuse a form you already built.** Place an Account, Contact, Lead, Case, Opportunity or custom object form in any Form Template page section.
* **Map once, use everywhere.** The map is saved on the form, so every template that uses the form gets it.
* **Prefill and live updates.** A mapped section shows values already on the submission, and a change to the same Form Submission field anywhere in the template shows up in it straight away.
* **Fill conversion without opening the flow.** Mapped fields reach the converted record through the packaged conversion flows; add a mapping and the next conversion picks it up.

## Map a form's fields

1. Open the **Form Builder** and pick the object (for example **Account**) and the form.
2. Open the **Form Template Mapping** tab, the last tab. It appears for any form that is not on Form Submission, Form Template, Form Template Page or Form Template Page Section.
3. In **Apply these mappings to**, choose where the map applies at conversion:
   * **All Accounts** (All plus the object's plural name): the map applies to every conversion of that object.
   * **One Form Submission lookup** (for example **Account**, or a second Account lookup such as an employer): the map applies only when conversion fills the record through that lookup. Use this when a submission converts to two records of the same object.
4. Each field on the form is listed, including fields used only in the form's conditional rules. For each one, pick the Form Submission field it feeds. Leave the picker blank to leave the field unmapped.
5. Click **Save**. The map is saved with the form, by the same Save as every other Form Builder change.

The count under the description (for example **7 of 7 fields mapped**) shows how many listed fields have a target.

### Which fields you can pick

The target picker only offers Form Submission fields whose type lines up with the source field, so you never see a choice that would fail.

| Source field type | Form Submission field offered |
| --- | --- |
| Checkbox, Phone, Email, URL, Date, Date/Time, Time | The same type |
| Lookup | A lookup to the same object, or a text field marked External Id |
| Rich text | Rich text |
| Text, long text | The same type (you are warned if the target is shorter) |
| Number, Currency, Percent | The same type with enough digits and decimal places |
| Picklist, multi-select picklist | Picklist, multi-select picklist, or text |

A few more rules:

* **One mapping per Form Submission field.** A Form Submission field can be mapped once per form; one source field can feed several Form Submission fields.
* **Restricted picklists.** If the Form Submission picklist is restricted, every active value of the source picklist must exist on it (matched by API name). Otherwise it is not offered.
* **Dependent picklists.** You are warned if the controlling field is not mapped too.
* **System fields are never offered.** Status, conversion, log, template link, owner, record type, source and id fields on Form Submission are left out, as are read-only fields and the record Id.

The same checks run again when you save, so a hand-edited or out-of-date map is caught.

## Place the form in a page section

1. Open a **Form Template Page** and add or edit a section.
2. In **Select Form Component**, the picker opens on **Form Submission**. Switch the object to the one your form is on.
3. Every form on that object is listed. Forms that carry a map show a **Mapped** pill.
4. Pick the form and save the section.

Closing the picker without picking a form puts the section back on its original object. A form picked without a map is reported on the Form Template record page, because nothing it collects would reach the Form Submission.

## How it behaves when someone fills in the form

* **The section only ever saves the Form Submission.** No Account, Contact or other record of the mapped object is created or updated by the form, on autosave, guest save, Save and Submit or any other save.
* **Values stay in step.** A change in the mapped section lands on the submission, and a change to the same Form Submission field in any other section, on this page or another, shows up in the mapped section as the respondent moves back and forward.
* **Required fields still block** Next and Submit.
* **Field-level security still applies** to the form's own fields.
* **Repeaters and tables.** A mapped form in a repeater or table row maps to that row's submission.
* **The PDF and print views** show mapped sections with the right values, labels and picklist values.

Two sections that map to the same Form Submission field stay in sync, and the last change wins. This already happens between two Form Submission sections; mapping just makes it more common.

## Conversion

The packaged conversion flows run a new action, **Form Submission | Apply Submission Field Maps**, right after the Transform and before Remove Null Values. It is already in Upsert Account, Upsert Contact, Upsert Lead, Process Case and Process Opportunity. Campaign Members is not covered yet.

The action reads the maps from the sections on the submission's Form Template and fills **only the fields the Transform left empty**. The Transform stays the source of truth: if it already set a value, that value is kept.

| Input | What it does |
| --- | --- |
| Form Submission | The submission, or the repeater or table row, being converted |
| Transformed Record | The record the Transform built, for example the Account |
| Form Submission Lookup Field | The lookup this record converts through, for example `FlowToolKit__Account__c`. Maps set to All apply, and maps set to this lookup apply; a map set to another lookup does not. Leave blank to apply every map for the object |
| Log Filled Fields | Writes a Success row to the Conversion Log naming the fields it filled |

| Output | What it holds |
| --- | --- |
| Record | The transformed record with the mapped values filled in |
| Skipped Mappings | One line per mapping that could not be written, with the submission field, target field, value and reason |
| Skipped Mapping Count | How many mappings were skipped |

A mapping that cannot be written (a missing or read-only field, the wrong type, a value too long, a value a restricted picklist does not hold, a fraction into a whole number) is skipped, not fatal. It is listed in Skipped Mappings and written to the Conversion Log as an Error row, and the conversion carries on.

**If you have overridden a conversion flow,** add the action yourself, between your Transform and Remove Null Values, and assign its Record output back to your record variable. See [Overridable Conversion Flows](how-to/overridable-conversion-flows.md).

## Limits

* The free version keeps its existing object limits.
* A page section cannot override the form's map yet; every template that uses the form uses the same map.
* Campaign Members conversion does not apply maps yet.

## Related Pages

* [Pages And Sections](pages-and-sections.md)
* [Submission Conversion](submission-conversion.md)
* [Overridable Conversion Flows](how-to/overridable-conversion-flows.md)
* [Form Template Sources](form-template-sources.md)
