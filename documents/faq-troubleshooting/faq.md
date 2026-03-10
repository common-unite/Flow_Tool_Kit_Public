# Frequently Asked Questions

> Quick answers to the most common Flow Tool Kit questions.

## General

### What Salesforce editions does Flow Tool Kit support?

Flow Tool Kit works on any Salesforce edition that supports Lightning Web Components and Screen Flows — Enterprise, Unlimited, Performance, and Developer editions. It does **not** work on Professional or Essentials editions.

### Does Flow Tool Kit work with custom objects?

Yes. Flow Tool Kit works with any standard or custom object. When you create a form component in Form Builder, you select the target object — it can be any object in your org.

### How is form component configuration stored?

All form component configuration is stored as **Custom Metadata Type** records (`Form__mdt`, `Form_Section__mdt`, `Form_Field__mdt`, etc.). This means your form component definitions are metadata — they deploy between orgs the same way custom fields and page layouts do, and they don't count against your data storage limits.

### Can I use Flow Tool Kit in Experience Cloud?

Yes. Flow Tool Kit includes dedicated Experience Cloud components with property editors for admin configuration. See [Experience Cloud](../experience-cloud/experience-cloud-components.md) for setup details.

### Is Flow Tool Kit free?

Flow Tool Kit is available on the [AppExchange](https://appexchange.salesforce.com/appxListingDetail?listingId=a0N4V00000HC4zCUAT). Check the listing for current pricing and licensing details.

## Form Builder

### How do I access Form Builder?

Open the **App Launcher** (waffle icon) and search for "Form Builder". You need the **Form Builder Admin** or **Form Builder Manager** permission set to see the tab. See [Installation](../getting-started/installation.md).

### Can I copy a form component from one org to another?

Yes, two ways:
1. **JSON Export/Import** — In Form Builder, export your form component as JSON, then import it in the target org
2. **Metadata Deployment** — Deploy the CMDT records (Form__mdt, Form_Section__mdt, Form_Field__mdt) using change sets, SFDX, or a deployment tool like Gearset or Copado

See [Deploying Metadata](../deployment/deploying-metadata.md) for details on deployment options.

### How many fields can a form component have?

There's no hard limit imposed by Flow Tool Kit. However, very large form components (50+ fields) may impact page load time. Consider splitting large form components into multiple sections or using the [Form Template Framework](../form-template-framework/form-templates.md) for multi-page forms.

### Can I use the same form component for multiple objects?

No. Each form component is tied to a single Salesforce object. If you need similar form components for different objects, create separate form components for each object.

## Flow Form (Runtime)

### My form fields aren't showing up in the Flow

Check these common causes:
1. **Missing permission set** — the running user needs the **Form Flow User** permission set (at minimum)
2. **Wrong object** — verify the Flow Form's `object` property matches the form component's object
3. **Missing record variable** — make sure you've assigned a record variable of the matching object type

### How do I get the user's input after the form screen?

After the screen element, reference `{!FlowForm.record}` — this gives you the SObject record with all the values the user entered. Use it in Create Record or Update Record elements.

### Can I pre-fill the form with existing data?

Yes. Pass an existing record into the Flow Form's `record` input property. The form will display the record's current values, and the user can edit them.

### How do I make a form read-only?

Set the `readOnly` property to `true` on the Flow Form component. The form renders all fields as read-only display values.

## Conditional Logic

### My conditional visibility rule isn't working

1. **Check the field API name** — conditional rules reference fields by API name, not label
2. **Check the comparison value** — picklist values are case-sensitive
3. **Check the logic operator** — AND requires all conditions true, OR requires any one condition true
4. **Check the field is on the form** — the controlling field must be on the same form as the dependent field

### Can I show/hide entire sections?

Yes. Conditional visibility can be set at both the field level and the section level. In Form Builder, click on a section header to access its conditional visibility settings.

## Deployment

### What do I need to deploy when moving form components between orgs?

Deploy the Custom Metadata Type records that define your form components:
- `Form__mdt` — form component definitions
- `Form_Section__mdt` — section definitions
- `Form_Field__mdt` — field definitions
- `Form_Style_Sheet__mdt` — themes (if customized)
- `Form_Labels__mdt` — labels/translations (if used)

See [Deployment Overview](../deployment/deployment-overview.md) for the complete deployment guide.

### Can I use change sets to deploy form components?

Yes. Custom Metadata Type records are supported in change sets. Add the CMDT records for your form components, sections, fields, themes, and labels to your change set.

## Permission Sets

### Which permission set should I assign to form builders?

Use **Form Builder Manager** for users who build and manage form components but aren't System Administrators. It grants full access to Form Builder, form component metadata, and form templates. See [Permission Sets](../getting-started/permission-sets.md).

### Do end users who fill out forms need a permission set?

Yes. Assign the **Form Flow User** permission set — it provides the minimum access needed to render and interact with forms in Flows.

## Related Pages

- [Troubleshooting](troubleshooting.md) — step-by-step solutions for specific issues
- [Getting Started](../getting-started/installation.md) — installation and setup guide
- [Feature Overview](../welcome/feature-overview.md) — everything Flow Tool Kit can do
