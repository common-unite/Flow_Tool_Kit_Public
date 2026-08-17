# Inject Custom Settings

> Add your own fields and business process configuration to the Form Template Settings and Data Conversion Settings tabs, without forking anything Flow Tool Kit ships.

{% hint style="info" %}
**Prerequisites**: Access to Form Builder and permission to create Custom Metadata records. See [Form Components System](https://github.com/common-unite/cUnite_FormBuilder/blob/master/documents/form-configuration/form-components-system.md) for how form components work generally.
{% endhint %}

## The problem this solves

The **Form Template Settings** and **Data Conversion Settings** tabs on a Form Template are components Flow Tool Kit ships and controls. They cover availability windows, pre-fill, navigation, confirmation pages, conversion rules, and so on.

They do not cover *your* organization's settings. If your intake process needs a Review Committee lookup, a Funding Round picklist, or a flag that drives your own automation, there was previously nowhere on the Form Template to put it. Adding a field to the object was easy; getting it to appear on the settings tab was not.

Every Flow Tool Kit upgrade replaces those components, so editing them directly was never an option.

## How it works

Each fixed settings tab now ends with an **empty section that Flow Tool Kit deliberately leaves for you**. That section points at a Custom Metadata form record you are free to fill:

| Settings tab | Form record to add your fields to |
| --- | --- |
| Form Template Settings | `Form Template Settings (Custom)` |
| Data Conversion Settings | `Form Template Conversion Rules (Custom)` |

Both records ship unprotected, so they are yours to extend. Flow Tool Kit never writes to them, which means an upgrade cannot overwrite your work.

Your fields render inside our tab, under a collapsible heading, alongside the settings we ship.

## Add a custom setting

### 1. Create the field on Form Template

Create the field on the `Form Template` object exactly as you would any custom field. It is your field, in your namespace, on your object.

Nothing about this step is Flow Tool Kit specific. Set the type, help text, and field-level security as normal, and make sure the profiles or permission sets that manage templates can edit it.

### 2. Open the custom form in Form Builder

In Form Builder, open the form matching the tab you want to extend:

* **Form Template Settings (Custom)** to extend the settings tab
* **Form Template Conversion Rules (Custom)** to extend the conversion tab

Both arrive with a single empty section, ready for fields.

### 3. Add your field to the section

Drag your new field into the section and configure it the way you would in any Flow Tool Kit form: width, help text, required, conditional logic, default values.

Everything the form builder offers is available here. These are ordinary form fields; the only thing special about them is where they render.

### 4. Save and reload the Form Template

Save the form, then reload a Form Template record. Your field appears on the tab, below the settings Flow Tool Kit ships, under its own collapsible heading.

## Driving business processes from your settings

Because your fields live on the `Form Template` record, everything downstream can read them. A field added this way is a normal field on a normal record, so:

* **Record-triggered Flows** on `Form Template` see it like any other field.
* **Submission conversion** can read it when deciding what to create. See [Submission Conversion](https://github.com/common-unite/cUnite_FormBuilder/blob/master/documents/form-template-framework/submission-conversion.md).
* **Overridable conversion Flows** can branch on it, which is the usual place organization-specific logic belongs. See [Overridable Conversion Flows](https://github.com/common-unite/cUnite_FormBuilder/blob/master/documents/form-template-framework/how-to/overridable-conversion-flows.md).
* **Validation rules and formulas** treat it as any other field on the object.

A common shape: add a picklist that names your process variant, set it per template, and branch your overridable conversion Flow on it. The admin configures behaviour on the template itself, rather than in a Flow they have to remember to keep in step.

## Which tab to use

Put a setting on the tab where an admin would look for it.

**Form Template Settings** is the right home for anything about how the form behaves or who can reach it: availability, routing, ownership, approval, categorization.

**Data Conversion Settings** is the right home for anything about what happens to a submission after it arrives: what gets created, which records connect, which of your processes runs.

The split matters more than it looks. An admin who cannot find a setting will assume it does not exist.

## What upgrades do

Flow Tool Kit ships the two custom form records but never writes to them after that, so your fields survive upgrades untouched.

The sections we ship on the settings tabs *are* replaced on upgrade, which is why the extension point exists. Adding your fields to the custom form rather than editing ours is what keeps them safe.

## Limits

* The custom form renders **inside** the tab, in a fixed position at the end. You cannot interleave your fields between ours.
* Sections you add to the custom form all render within that one region.
* The fields must exist on `Form Template`. This extension point does not render fields from other objects.

## Related

* [Form Components System](https://github.com/common-unite/cUnite_FormBuilder/blob/master/documents/form-configuration/form-components-system.md)
* [Overridable Conversion Flows](https://github.com/common-unite/cUnite_FormBuilder/blob/master/documents/form-template-framework/how-to/overridable-conversion-flows.md)
* [Submission Conversion](https://github.com/common-unite/cUnite_FormBuilder/blob/master/documents/form-template-framework/submission-conversion.md)
* [Creating Templates](https://github.com/common-unite/cUnite_FormBuilder/blob/master/documents/form-template-framework/creating-templates.md)
