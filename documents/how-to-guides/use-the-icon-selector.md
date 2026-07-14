# How To: Use the Icon Selector

> Let users pick a Salesforce (SLDS) icon (like `utility:up`) from a visual picker on a record page and stamp it into a field, without typing the raw icon name.

{% hint style="info" %}
**Prerequisites**: A Lightning record page for the object you want to add the picker to, and a **Text** or **Picklist** field on that object to store the icon name.
{% endhint %}

## What It's For

The **Form (Icon Selector)** is a Lightning App Builder component that renders Flow Tool Kit's grouped icon picker (Icon Type → Icon) directly on a record page. When a user chooses an icon, the selected value (for example `utility:activity`) is **saved immediately** to the field you configured: no Save button, no hand-typing of icon API names.

Use it anywhere you store an icon name on a record and want admins or users to choose it visually: for example a theme accent icon, a navigation/menu entry icon, or a section header icon.

It is one of a family of record-page **selector** components that all write a chosen value into a field:

| Component | Picks… | Stores… |
|-----------|--------|---------|
| **Form (Icon Selector)** | an SLDS icon | `utility:up` |
| Form (Image Asset Selector) | a public image asset | image path |
| Form (Theme Selector) | a Form Theme | theme API name |
| Form (Email Template Selector) | an email template | template developer name |
| Form Component Selector | a form/table component | component name |

## Step 1: Create or Choose a Field

Add (or pick) a field on the object to hold the icon name. It must be one of:

- **Text** field with a **length of at least 40** characters (icon API names can be long, e.g. `utility:advanced_function`), **or**
- a **Picklist** field whose values are icon API names (use this when you want to restrict users to a curated set of icons).

{% hint style="warning" %}
Long Text Area and Multi‑Select Picklist fields are intentionally **not** offered; only Text and Picklist are valid.
{% endhint %}

## Step 2: Add the Component to a Record Page

1. Open the record page in **Lightning App Builder** (Setup → Edit Page from a record, or Lightning App Builder directly).
2. From the **Components** panel, drag **Form (Icon Selector)** onto the page.
3. In the component's properties, set the configuration below.
4. **Save** and **Activate** the page.

## Step 3: Configure the Component

| Property | Required | Description |
|----------|----------|-------------|
| **Field Api Name** | Yes | The Text or Picklist field the icon is saved to. This is a **dropdown** of the object's eligible fields; you don't type the API name. |
| **Selector Label** | No | Overrides the label shown above the picker. Default: *Select Icon*. |
| **Margin Top / Bottom** | No | SLDS spacing above/below the component. |
| **Padding Horizontal** | No | SLDS horizontal padding inside the component. |

`Object Api Name` and `Record Id` are supplied automatically by the record page; you do not set them.

## How It Behaves

- **Pick a type, then an icon.** Choosing the **Icon Type** (group) just filters the icon list; it does not save anything. Choosing an actual **icon** saves it.
- **Auto-save.** Selecting an icon writes it to the field immediately and shows a success toast. Field-level security and updateability are respected: if the running user can't edit the field, the picker hides itself and shows a message.
- **Lives in sync.** If you place more than one selector (or a compatible component) on the same record page bound to the **same** field, they stay in sync live: changing one updates the others on the spot.
- **Existing values.** If the field already holds a value that isn't a valid icon name, the picker starts empty so you can choose cleanly (the underlying value is left untouched until you pick).

## Troubleshooting

| Symptom | Cause / Fix |
|---------|-------------|
| The component shows an error/﻿hides itself | The configured field isn't a Text(≥40)/Picklist field, or the user lacks edit access to it. Pick an eligible field or grant access. |
| The chosen field isn't in the **Field Api Name** dropdown | The field isn't an updateable Text(≥40) or Picklist field on this object. |
| Picking the **Icon Type** doesn't save | That's expected; the type is a filter. Pick an icon from the second dropdown to save. |

## Related

- [Configure Themes and Styling](configure-themes-and-styling.md)
- [Build a Form](build-a-form.md)
