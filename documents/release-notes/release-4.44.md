# Release 4.44

The Record Picker for lookup fields: filtered suggestions that follow the form's other answers, a second detail line and an extra search field, and working lookups for portal users who can edit a record but not create one.

## 🆕 Record Picker for lookups (#661)

![Setting up the Record Picker on Parent Account](https://raw.githubusercontent.com/common-unite/Flow_Tool_Kit_Public/main/documents/screenshots/661-record-picker-demo.gif)

- **A new Lookup Field Display Type, Record Picker**, for lookups that point at one object. Choose it on the field's Field tab in Form Builder, then open **Record Picker Settings**.
- **Filters that follow the form.** Add rows such as `Account Type` equals `{{Type}}`; the suggestions narrow as soon as that answer changes. A row whose merged value is blank is skipped, so the picker shows everything until the answer is given. Filter logic such as `1 AND (2 OR 3)` and cross-object paths are supported.
- **A second line under each suggestion and an extra search field.** Show the Account Number, Phone, Website or a picklist under each name, and let people search by it.
- **"Search Accounts..." placeholder** by default, like the standard lookup, unless the field has its own placeholder.
- New field `Form_Component_Field__c.recordPickerConfig__c` holds the settings, and `referenceFieldOverrideType__c` has a new value, `recordpicker`.

## 🆕 Change Field in the Form Builder (#738)

![Choosing another field in the Change Field modal](https://raw.githubusercontent.com/common-unite/Flow_Tool_Kit_Public/main/documents/screenshots/738-change-field-modal.jpg)

- **Point a section field at a different field without rebuilding it.** A new **Change Field** button sits beside the merge field button everywhere the field quick buttons show: the field editor toolbar, the Form Component Outline, the Customize Section Fields list and the hover bar over a field in the preview. Built for forms where an admin or an AI agent picked the wrong field.
- **Every setting is kept unless it is not valid for the new field.** Labels, help text, widths, position, conditional rule, prompts, required and read-only always stay. A setting that belongs to another data type resets to its default, and the modal lists what will reset, and why, before you confirm.
- **Picklist settings that name values** (option subset and order, option labels, visual picker options) are kept only when every value they name exists on the new picklist with the same API name.
- **Lookup settings** are kept when the new lookup points at the same object.
- **Minimum and maximum field references** are kept when the new field can still use the field they name, and removed when it cannot, for example when a date field becomes a text field.
- **Only fields not already in the section are offered**, grouped by data type with the current type first. Any data type can be chosen.
- **Not offered for** address parts, Likert rows and Table Builder columns. Conditional rule conditions and merge fields that name the old field are not rewritten.
- **Fixed along the way:** clearing a setting that names a field or a form, such as Min Field, is now saved on record-based form components. It was kept before.

## 🛠 Lookups for users who can edit but not create (#717)

- **Portal users now get a working lookup.** A user who can edit the object but not create it (the usual Customer Community Plus setup) sees the Record Picker automatically instead of a blank box. Users who can only read the object still see the related record's name, read-only (4.42). No setting to change; a field set to Form Component, Start New Form or View/Edit Form Submission keeps that display.

## 🛠 A clear message when someone cannot see a form submission (#737)

- **Portal users no longer get a source configuration error.** When a user opened a form for a Form Submission they had no access to, including through a lookup set to View/Edit Form Submission, the form reported a missing Form Template Source configuration. It now says "You can't view this form. You may not have access to it, or it may no longer exist."
- **Form Submissions are private to external users by default.** To let portal users open submissions they do not own, add a sharing set or sharing rule on Form Submission; it has Account and Contact lookups to match on.

## 🛠 Upgrades to 4.43 no longer fail on the Form Template Page record page (#739)

- **Fixed an upgrade failure introduced in 4.43.** The Form Template Page record page tested the Component Type picklist for Flow, Lightning Web Component and Display Text. Orgs first installed before those values existed do not have them, and the install rejected the page with "is an invalid field value". The page now names only Field Set, Repeater and Table, and shows every other type without naming it.
- **If you could not upgrade to 4.43,** upgrade straight to this release. Orgs that added the missing picklist values by hand as a workaround need no further change.

## 📖 New guide: Open A Form From A Lookup (#740)

- **One place for Form Component, Start New Form and View/Edit Form Submission**: setup, inline or modal, Review Mode, and troubleshooting.
- **Explains what makes the opened form editable.** It follows the lookup field: when the lookup is read-only for a user, the form it opens is view-only, even if they can edit the Form Submission itself. The guide lists every cause and the permissions portal users need.

## 🛠 Form Builder live editor stays on the field (#741)

- **Moving between fields no longer outlines the whole section.** Crossing the small gap between two fields briefly selected their section, with its Add fields tray, before the next field. The field now stays outlined until the pointer reaches the next one. The section still outlines from its header or from space outside its fields.

## 🎨 Styling

- **A picked record in the Record Picker matches your other fields**, instead of Salesforce's grey read-only look.
- **Read-only lookups match your other read-only fields**, instead of a darker grey fill.

## Considerations

- **Guests never get the automatic picker**, because guest profiles cannot edit most objects. A guest gets the Record Picker when you choose it, and needs object Read, field access on the fields you display, search or filter on, and a **guest sharing rule** on the object. Without the sharing rule the picker finds nothing and shows no error.
- **Portal users see only records their sharing allows.**
- **No "no matches" message.** When nothing matches, the suggestion list does not open; Salesforce's picker does not report empty results. Explain the filter in the field's label or help text.

Full guide: [Use the Record Picker](../how-to-guides/use-the-record-picker.md).
