# Edit A Related Record

> Put a form for the **parent** record on a child record's page. Stand on a Contact, edit its Account.

{% hint style="info" %}
**Prerequisites**: a Form Component built on the parent object. See [Build A Form](build-a-form.md).
{% endhint %}

## Overview

By default the **Form (Component)** edits the record whose page it sits on. Put it on a Contact page and it edits that Contact.

**Edit Related Record** changes the target. The component follows a lookup field from the page's record, loads the record on the other end, and renders your form against that record instead. Saving writes to the related record, not the page's record.

The common case: a Contact page that edits the Contact's Account, so staff update company details without leaving the person they are working on.

It works through any lookup on the page's object, so the same setting covers a Contact editing its Account, an Account editing its parent Account, a Case editing its Contact, or a custom lookup you built yourself.

## Step 1: Build the form on the parent object

The form is built on the object you want to **edit**, not the object whose page you are on.

For a Contact page that edits the Account, build the Form Component with **Account** as its object. It never needs to know a Contact is involved.

## Step 2: Add the component to the child record page

1. Open the child object's record page in **Lightning App Builder**.
2. Drag **Form (Component)** onto the canvas.
3. Set **Form Qualified Api Name** to the form you built in Step 1.

## Step 3: Point it at the lookup

1. Check **Edit Related Record**.
2. Set **Lookup Field API Name** to the API name of the lookup field on the page's object.

| Page object | To edit | Lookup Field API Name |
| ----------- | ------- | --------------------- |
| Contact | its Account | `AccountId` |
| Account | its parent Account | `ParentId` |
| Case | its Contact | `ContactId` |
| Contact | a custom lookup | `FlowToolKit__Primary_Contact__c` |

Use the plain field API name. A qualified name like `Contact.AccountId` is also accepted.

### Going more than one lookup away

To reach a record two lookups away, write the full path. Walk through the **relationship** name, not the Id field:

| Page object | To edit | Path |
| ----------- | ------- | ---- |
| Contact | its Account's parent Account | `Contact.Account.ParentId` |
| Case | its Contact's Account | `Case.Contact.AccountId` |

```
Contact.Account.ParentId      correct
Contact.AccountId.ParentId    wrong
```

`AccountId` is the field holding the Id. `Account` is the relationship you walk through. Only the **last** segment is an Id field; everything between the object and it is a relationship name.

To find a relationship name, open the lookup field in Setup: it is usually the field's API name without the `Id` suffix (`AccountId` gives `Account`), and for custom lookups it is the `__c` name with `__r` instead (`Primary_Contact__c` gives `Primary_Contact__r`).

{% hint style="warning" %}
**Changed in v4.14.** Before v4.14 only the plain field API name worked, even though the help text asked for `ObjectName.FieldApiName`. A component configured with the qualified form rendered nothing at all, with no error. Both forms work from v4.14 on, so existing configurations start working on upgrade with no change needed.

The two properties were also renamed for clarity in the same release: **Use Related Field Form** became **Edit Related Record**, and **Related Field Api Name** became **Lookup Field API Name**. Only the labels changed, so nothing you have already configured is affected.
{% endhint %}

## Step 4: Save and test

1. **Save** the page and activate it if it is new.
2. Open a record where the lookup is populated. The form loads the related record's values.
3. Change a field and save. Confirm the change lands on the **related** record.

## How it resolves

Understanding the order helps when it does not behave as expected:

1. The component reads the page's object from the record page itself.
2. It loads every lookup field on that object, plus the full path when you gave it one.
3. It walks the path segment by segment to get the Id at the end. A blank lookup anywhere along the way stops the walk.
4. It works out the object that final lookup points to and renders your form against it.
5. Saving updates that record.

## Blank lookups

When a lookup along the path is empty on a given record, no related record resolves and the component has nothing to edit. Give those pages a different treatment (component visibility on the page, for example) rather than expecting the form to create the missing record.

## Experience Cloud

The same two properties exist on the Experience Cloud version of the component and behave identically. Pass the page's record id into **Record Id** as usual; the traversal happens from there.

## Template Fields Editor

The **Template Fields Editor** component carries the same **Lookup Field API Name** property and traverses in exactly the same way. It has no separate checkbox: leave the property blank to edit the page's own record, or name a lookup to edit the record on the other end of it.

## Limits

* **Every lookup in the path must be populated.** If a Contact has no Account, `Contact.Account.ParentId` resolves to nothing and there is no record to edit. The component edits an existing related record; it never creates one.
* **Free text, not a picker.** The path is typed, and a field or relationship name that does not exist makes the component **render nothing at all**, with no error message. An empty space where the form should be almost always means a misspelled path, so check that first.
* **The form must be built on the object the lookup points to.** A Contact form pointed at `AccountId` will not render.

## Related

* [Host Form On Record Page](../form-template-framework/how-to/host-form-on-record-page.md) - the same idea for the Form (Template) component, which resolves a whole Form Template from a lookup and supports multi-level traversal.
* [Configure Lookup Fields](configure-lookup-fields.md) - lookup fields inside a form.
