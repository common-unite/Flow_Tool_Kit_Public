# Prefill Templates

> Set default field values on a Form Template record, no Flow logic required. Pre-populate visible fields and inject backend values for data conversion.

## Video Walkthroughs

{% embed url="https://vimeo.com/974644468" %}

{% embed url="https://vimeo.com/976718699" %}

## Overview

Pre-fill templates let you configure default field values directly on a Form Template record. When the form loads, those values are automatically populated: both visible fields (name, email type) and backend fields (campaign ID, lead source) that drive data conversion. This eliminates the need for Flow assignment elements or complex flow logic.

![Pre-fill template editor on a form template record](../.gitbook/assets/prefill-template-editor.png)

![Form loaded with pre-filled values](../.gitbook/assets/form-with-prefilled-values.png)

## Configuration

1. Navigate to your **Form Template** record.
2. Click **Edit Prefilled Template** (or "Edit Prefilled Values").
3. Click the field picker to browse all fields from the form submission object.
4. Select the fields you want to pre-fill.
5. Set a value for each selected field.
6. Click **Save Template**.

![Edit Prefilled Template button](../.gitbook/assets/edit-prefilled-template-btn.png)

## What You Can Pre-fill

Pre-fill works for **any field** on the form submission object, whether the field is displayed on the form or not:

| Category                    | Examples                                                                                       |
| --------------------------- | ---------------------------------------------------------------------------------------------- |
| **User-visible fields**     | First Name, Last Name, Email Type, Phone Type, Title                                           |
| **Backend / hidden fields** | Campaign ID, Campaign Member Status, Lead Source                                               |
| **Data conversion drivers** | Values that control which records are created during conversion (e.g., "New Volunteer" status) |

## Common Patterns

### 1. Default Contact Preferences

Set Email Type to "Work" and Phone Type to "Work" so users don't have to select these on every form.

### 2. Campaign Member Injection

Pre-fill the Campaign ID and Campaign Member Status (e.g., "New Volunteer") as backend values. When the form submission converts, the system automatically creates a Campaign Member with the correct status; the user never sees these fields.

### 3. Lead Source Tracking

Set Lead Source to identify where submissions came from (e.g., "Website", "Event Registration"). This value is injected behind the scenes and flows through to the converted Lead record.

### 4. Rapid Form Scaling

Build a single form template and use pre-fill values to customize it for different contexts. Combined with [Campaign Integration](campaign-integration.md), you can serve dozens of campaigns from one template with different default values.

## Who Can Read the Pre-fill Template

The form reads the pre-fill template as the person loading the form. If that person cannot read the Form Submission record that holds the defaults, the form opens without them, while your own preview still shows every default because you can read the record. From 4.46 the form says so in a warning toast that stays until closed. The toast is written for you, the administrator, and carried by the person who hit it: it says the pre-fill template is not shared with them and asks them to contact you. The browser console names the record and the sharing rule that fixes it. The same applies to a pre-fill template set on a repeater or table section.

Form Submission is **Private** for external users, so every site guest and every portal user needs a sharing rule that covers your pre-fill template records:

1. **Setup → Sharing Settings → Form Submission Sharing Rules → New**.
2. Rule type: **Based on criteria**.
3. Criteria: **Is Pre-fill Template** equals **True**.
4. Share with: the site's guest user (a guest user sharing rule) or the portal users' public group.
5. Access level: **Read Only**.

{% hint style="warning" %}
**Write the criteria on the Is Pre-fill Template checkbox, not on the record type.** The Pre-fill Template record type is only a default: a pre-fill template record can carry any record type, and a rule written on the record type stops matching the moment someone assigns a different one. Is Pre-fill Template is the field that defines a pre-fill template, so it keeps matching whatever the record type.
{% endhint %}

## Tips & Considerations

* **No Flow needed**: pre-fill values are configured entirely on the Form Template record. You can create dozens of form solutions without ever opening Salesforce Flow.
* **Backend values are powerful**: the most impactful pre-fill values are often ones users never see: campaign assignments, lead sources, and data conversion parameters.
* **Overridable**: users can change pre-filled visible values on the form. Backend values that aren't on the form cannot be changed by users.
* **Works with save progress**: pre-filled values persist across save-and-resume sessions.

## Related Pages

* [Form Templates](form-templates.md): form template record configuration
* [Campaign Integration](campaign-integration.md): linking templates to campaigns
* [Submission Conversion](submission-conversion.md): how pre-filled values drive data conversion
* [Overview](overview.md): Form Template Framework overview
