# Open A Form From A Lookup

> Replace a lookup field with the form behind it: the related record's own form, a new submission of a Form Template, or an existing Form Submission. The lookup field also decides whether that form opens editable or view-only.

![Start New Form and View/Edit Form Submission](https://raw.githubusercontent.com/common-unite/Flow_Tool_Kit_Public/main/documents/screenshots/391-lookup-override-types-demo.gif)

{% hint style="info" %}
**Prerequisites**: a form with a lookup field. For **Start New Form** the lookup must point at Form Template; for **View/Edit Form Submission** it must point at Form Submission. See [Build A Form](build-a-form.md).
{% endhint %}

## The Three Ways

On the field's **Field** tab in Form Builder, **Lookup Field Display Type** offers these alongside **Default** and **Record Picker**:

| Display type | Offered when the lookup points at | What it shows |
| --- | --- | --- |
| **Form Component** | Any object | The related record, rendered through a Form Component you choose. Changes save automatically. |
| **Start New Form** | Form Template | A new submission of the template, started in place |
| **View/Edit Form Submission** | Form Submission | The existing submission, opened in place |

The lookup input itself is hidden whenever one of these is chosen, so people are never shown a record picker they are not meant to use.

## Set It Up

1. Open **Form Builder**, select your form, and click the lookup field in the outline.
2. On the **Field** tab, set **Lookup Field Display Type**.
3. For **Form Component**, choose the Form Component that renders the related record.
4. For **Start New Form** and **View/Edit Form Submission**, choose how it appears:

| Setting | What it does |
| --- | --- |
| **Inline** | Renders the form directly in place of the lookup |
| **Button / Modal** | Renders a button that opens the form in a modal. Keeps the host form readable when the opened form is long. |
| **Button Label**, **Modal Header**, **Modal Subheader** | Text for the button and the modal. The header defaults to the field's label. |
| **Review Mode** (View/Edit Form Submission only) | Opens the submission as a one-page summary of every answer, with no stage indicators or page navigation |

5. Save the form.

### Start New Form uses the record you are on

Start New Form passes the **host record** into the new form, not the template chosen in the lookup. When the host object is configured as a Form Template Source, the new submission picks up that configuration: its template, theme, prefill, subtitle, banner and submit label, and it is linked back to the host record. When the host object has no source configuration, the template in the lookup is used.

## Editable Or View-Only: The Lookup Field Decides

**The form opened from a lookup is editable only when the lookup field itself is editable for the person viewing it.** This is the control: make the lookup read-only to show the related record or submission as view-only, and editable to let people work on it.

The lookup field is read-only, and so is the form it opens, when any of these is true:

| Cause | Where it is set |
| --- | --- |
| The field is set to **Read Only** in Form Builder | The field's settings |
| The whole host form is read only | The component's read-only setting on the page or Flow screen |
| The user can neither create nor edit the host object | Profile or permission sets, object permissions |
| The user can neither create nor edit the lookup field | Field-level security |

What happens when the lookup is read-only:

| Display type | Result |
| --- | --- |
| **Form Component** | The related record displays read-only and nothing saves |
| **Start New Form** | No form opens. The field shows as a normal read-only lookup. |
| **View/Edit Form Submission** | The submission opens view-only |

{% hint style="warning" %}
**Access to the opened record does not override the lookup.** A user who can edit a Form Submission still sees it view-only when the lookup that opens it is read-only for them. Check the **host** object and the **lookup field** first, not the Form Submission or the related object.
{% endhint %}

The opened form still applies its own checks on top. A user needs edit access to the Form Submission, or to the related record, to save changes there.

### Common setups

| Goal | Configure |
| --- | --- |
| Staff edit, portal users only view | Leave the field editable. Give portal users read-only access to the host object or to the lookup field. |
| Everyone only views | Set the field to **Read Only** in Form Builder |
| A read-only summary of a submission | **View/Edit Form Submission** with **Review Mode**, and the field set to **Read Only** |
| Portal users fill in the form | Give them Edit on the host object and edit on the lookup field. Keep every other host field read-only through field-level security if they should not change it. |

## When People Cannot Edit The Host Object

Some objects cannot be made editable for some users at all. The user's license or the product may cap the object at read-only, or allow changes only through system automation. On those objects the lookup is always read-only for those users, so any form opened from it is view-only for them.

In that case, open the form somewhere the user can edit:

* **Show the Form Submission directly.** Put the **Form (Template)** component on its own page and pass it the submission's record Id. See [Host Form On Record Page](../form-template-framework/how-to/host-form-on-record-page.md).
* **Write back to the host record with automation.** Let a conversion flow update the read-only record when the submission is submitted. Automation runs outside the user's own access. See [Overridable Conversion Flows](../form-template-framework/how-to/overridable-conversion-flows.md).

## Guests and External Users

* **Guests always see Form Component read-only.** Salesforce does not let guest users update records through this path.
* **External users follow the same lookup rule as everyone else.** Portal users often have read-only access to the host object, which makes the opened form view-only. That is the most common reason a portal user reports "the form shows but I can't edit it".
* **Sharing still applies to the opened record.** A portal user needs a sharing set or sharing rule to open a Form Submission they do not own; without one they see "You can't view this form."

## Other Behavior

* **An empty Form Submission lookup renders nothing** for View/Edit Form Submission, because there is no submission to open.
* **A lookup pointing at the record it sits on renders nothing**, so a form never renders itself inside itself.
* **Required wins over Read Only.** A field that is required, by the field's own settings or by the object's schema, is not made read-only by the Form Builder **Read Only** setting. Access limits still apply.
* **Closing the modal does not save.** Use Auto Save, Save Progress or your own automation if a dismissed modal should keep its progress.

## Troubleshooting

| Symptom | Likely cause |
| --- | --- |
| The form opens but every field is read-only | The lookup is read-only for this user: check object Edit on the host object and edit access on the lookup field, then the field's **Read Only** setting |
| It works for staff but is read-only for portal users | Portal users have read-only access to the host object, or the object cannot be made editable for their license |
| **Start New Form** shows a plain lookup instead of a form | The lookup is read-only for this user |
| **View/Edit Form Submission** shows nothing | The lookup is empty, or it points at the record the form sits on |
| "You can't view this form" | The user cannot read the Form Submission; add a sharing set or sharing rule |
| The display type is missing from the list | The lookup does not point at Form Template or Form Submission |

## Related Pages

* [Configure Lookup Fields](configure-lookup-fields.md): the standard lookup with a search modal
* [Use the Record Picker](use-the-record-picker.md): a searchable lookup with filters
* [Edit A Related Record](edit-a-related-record.md): a Form Component on a record page that edits a related record
* [Host Form On Record Page](../form-template-framework/how-to/host-form-on-record-page.md): the Form (Template) component on its own
