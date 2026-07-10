# Field Type Settings

> Configure display overrides and type-specific settings for boolean, phone, string, textarea, checkbox, picklist rating, and signature pad fields.

## Video Walkthroughs

{% embed url="https://vimeo.com/756782647" %}

{% embed url="https://vimeo.com/800580074" %}

## Overview

Flow Tool Kit lets you override how standard Salesforce field types display on your forms. Convert a boolean toggle into radio buttons, transform a picklist into a star rating, or turn a rich text field into a signature pad — all through the Form Builder without code.

## Boolean / Checkbox Fields

By default, boolean fields display as a modern **toggle switch**. You can override the display type in the field's **Checkbox Override Setting**:

| Display Type         | Description                                                                                                        |
| -------------------- | ------------------------------------------------------------------------------------------------------------------ |
| **Toggle** (default) | Modern toggle switch component                                                                                     |
| **Checkbox**         | Traditional small checkbox                                                                                         |
| **Picklist**         | Dropdown with True/False options                                                                                   |
| **Radio**            | Radio button group with True/False options                                                                         |
| **Buttons**          | Button group (same as picklist button overrides)                                                                   |
| **Attestation**      | Consent/certification card — a checkbox beside a rich-text statement in a brand-themed box that fills when checked |

![Boolean display type options](../.gitbook/assets/boolean-display-types.png)

### Custom True/False Labels

When using Picklist, Radio, or Buttons display types, you can override the option labels (for real picklist and multiselect fields, see [Picklist Option Labels](picklist-option-labels.md) for per-value custom labels with merge-field support):

* **True Label Override** — e.g., "Yes", "Agree", "Accept"
* **False Label Override** — e.g., "No", "Disagree", "Decline"

The underlying value is always boolean `true`/`false` regardless of the display label.

![Checkbox options override with Yes/No labels](../.gitbook/assets/checkbox-options-override.png)

### Making Booleans Required

The toggle and checkbox display types have a UX limitation with required fields — they default to `false`, so "required" effectively means "must be true." Use the **Picklist** or **Radio** display type instead: the field loads with no value selected, so requiring a selection forces an intentional choice between true and false.

### Attestation Selector

The **Attestation** display type renders a boolean as a consent/certification **card**: a checkbox sits beside a rich-text statement inside a bordered box, and the whole card is clickable. When the user checks it, the card fills with your brand color so the agreement visibly stands out.

![Selecting the Attestation display type and the card rendering in the preview](../.gitbook/assets/188-attestation-selector-demo.gif)

Unlike the other display types, Attestation replaces the plain **Custom Label** with a **Rich Text Label** field — write the full attestation statement (formatting, links, and merge fields) there. When you choose Attestation, the Form Builder hides the label, help text, prepend/append, and prompt inputs, since the rich-text statement is the only visible content. Leave the rich text blank and the field's standard label is used instead.

![A checked attestation card on a branded form](../.gitbook/assets/188-attestation-selector.png)

The card's border and fill follow your org's brand color across internal Lightning, Aura, and LWR Experience Cloud sites. The underlying value is still a boolean `true`/`false`.

## Phone Fields

{% embed url="https://vimeo.com/936810577" %}

### Phone Masking

Phone masking is **enabled by default** with US standard format: `(XXX) XXX-XXXX`. Users type digits only — parentheses, spaces, and dashes are inserted automatically.

![Phone masking auto-format in action](../.gitbook/assets/phone-masking-auto-format.png)

![Phone masking configuration in Form Builder](../.gitbook/assets/phone-masking-config.png)

### Phone Mask Formats

| Format                | Example                                 |
| --------------------- | --------------------------------------- |
| US Standard (default) | `(555) 555-5555`                        |
| Dashes Only           | `555-555-5555`                          |
| Additional formats    | Available in the Phone Masking picklist |
| None                  | Disables masking — accepts any input    |

### Phone Validation

* **With masking enabled**: Min/max length is enforced automatically. Users cannot submit a partial phone number.
* **With masking disabled**: Use the **Field Format (Regular Expression)** field and **Custom Formatting Alert Message** for custom phone validation.
* **Placeholder**: Set a placeholder matching the mask pattern (e.g., `(555) 555-5555`) so users know the expected format.

{% hint style="info" %}
If you need a phone format not in the list, contact Common Unite to request new masking formats in a future release.
{% endhint %}

## String & Email Fields

{% embed url="https://vimeo.com/936775504" %}

### Length Validation

* **Minimum Length**: Validates on blur — shows "entry is too short" error if below the minimum.
* **Maximum Length**: Defaults from the object schema. Can be overridden to a shorter value. Input stops at the limit — users cannot type beyond it.

![String min/max length configuration](../.gitbook/assets/string-min-max-config.png)

### Regex Pattern Validation

Enter a regular expression in **Field Format** and a user-friendly message in **Custom Formatting Alert Message**. The error displays when the value doesn't match the pattern on blur.

**Example**: Email field with regex `.*@salesforce\.com` shows "You must provide a Salesforce email" when a non-Salesforce email is entered.

## Text Area & Long Text Area Fields

{% embed url="https://vimeo.com/936783951" %}

* **Character Counter**: Automatically displays as the user types (e.g., "7 of 200"). No configuration needed.
* **Minimum / Maximum Length**: Same as string fields. Override the schema default maximum to a lower value.
* **Custom Height**: Set a CSS height value (e.g., `250px`) in the **Height** field to control the initial textarea size. Users can still manually resize.

## Picklist Rating Selector

{% embed url="https://vimeo.com/775921691" %}

Convert any picklist field into an interactive star/icon rating selector by selecting **Icon Buttons** as the display type override.

![Icon buttons rating selector](../.gitbook/assets/icon-buttons-rating.png)

### Rating Configuration

| Setting                 | Description                                                    |
| ----------------------- | -------------------------------------------------------------- |
| **Selected Icon Color** | Color of selected icons (e.g., green, gold)                    |
| **Icon Size**           | Size of the rating icons                                       |
| **Icon Type**           | Which icon to use: star/favorite (default), smiley faces, etc. |
| **Label Alignment**     | Center, left, or right alignment of the question text          |
| **Label Size**          | Adjustable label size to emphasize the question                |

The number of icons matches the number of picklist values. Hovering over an icon shows the picklist value label. Selecting an icon lights it up along with all icons to its left (standard rating behavior). The underlying data is still a standard picklist value, integrating with Salesforce reporting.

## Survey Buttons

Render any picklist as **vertical, full-width option cards** with the look and feel of a modern survey tool: each option is a large tap-friendly card with a radio indicator, and the selected card outlines and tints with your org's brand color.

Select a picklist field and set **Picklist Display Type** to **Survey Buttons** in Picklist Override Settings:

![Switching a picklist to Survey Buttons and selecting options in the preview](../.gitbook/assets/246-survey-buttons-demo.gif)

* Works on every form factor; unlike the Radio display type, it never falls back to a dropdown on phones, making it a strong default for mobile-first forms.
* The full picklist toolkit applies: subset and reorder options with Override Available Picklist Options, relabel them with [Picklist Option Labels](picklist-option-labels.md), and use required, help text, and conditional rules as usual.
* Selecting a card stores the standard picklist API value; clicking the selected card again clears a non-required field.
* [Likert Matrix sections](likert-matrix-sections.md) reuse this exact rendering for their stacked mobile layout, so surveys look consistent across the whole form.

![Survey Buttons rendering a Conversion Status picklist as option cards](../.gitbook/assets/246-survey-buttons.png)

## Visual Picker

Turn any picklist or multiselect picklist into a grid of **selectable cards**, each showing an SLDS icon or one of your org's public image assets. Hovering a card fades the media into the option's label (phones show the label as an always-on caption instead), and selected cards outline and tint in your org's brand color.

![Visual picker cards on a picklist and a multiselect, with hover revealing the labels](../.gitbook/assets/247-visual-picker-demo.gif)

Set **Picklist Display Type** to **Visual Picker** in Picklist Override Settings, then click **Customize Visual Picker** to map each option:

* **Type** picks the media per option. **Icon** (the default) opens the icon picker with its standard, custom, and doctype groups; **Image Asset** lists the org's public image assets, scaled to fit the card.
* **Custom Label** works exactly like Override Option Labels, which this modal replaces while Visual Picker is active: saved values keep their API names, empty inputs keep the default label, and merge fields are supported. The label is what the hover reveal (or the phone caption) displays.

![Mapping icons, image assets, and custom labels per option in the Customize Visual Picker editor](../.gitbook/assets/247-visual-picker-modal-demo.gif)

A few behaviors to know:

* **Column(s) Size** shapes the card grid exactly as it does for radio options: auto gives four cards per row on desktop, or choose 1 through 12 columns. Phones always render two per row.
* **Override Available Picklist Options** subsets and reorders the cards, and icons paint in the org brand color in every context (internal, Aura sites, and LWR sites).
* Multiselect fields render the same cards with checkbox behavior so several stay selected; on a single picklist, clicking the selected card again clears a non-required field.
* Options without a mapped icon or asset fall back to a neutral icon, so a newly added picklist value never renders an empty card.

![Choosing the column count and subsetting which options appear](../.gitbook/assets/247-visual-picker-columns-demo.gif)

## Signature Pad

{% embed url="https://vimeo.com/891254284" %}

Convert a **Rich Text** field into a drawable signature pad for collecting e-signatures.

![Signature pad configuration toggle](../.gitbook/assets/signature-pad-config.png)

![Signature pad on a form](../.gitbook/assets/signature-pad.png)

### Configuration

1. Create a **Rich Text** field on the object (e.g., label it "E-Signature").
2. Add the field to your form in Form Builder.
3. Open the field customization > **Rich Text Override Settings**.
4. Toggle on **Signature Pad**.

### How It Works

* Users draw their signature directly on the pad.
* On save, the signature is stored as an **image file** inside the rich text field.
* The signature is visible on Salesforce record page layouts.
* External document generation tools can access the image from the rich text field.
* You can toggle between Signature Pad and Rich Text display modes without losing data.

## Tips & Considerations

* **All overrides are purely visual** — the underlying Salesforce field type and data format don't change. A boolean displayed as "Yes/No" radio buttons still stores `true`/`false`.
* **Signature pad requires a Rich Text field** — this is not available on other field types.
* **Phone masking is enabled by default** — turn it off explicitly if you don't want auto-formatting.
* **Rating selectors work with any picklist** — the number of icons matches the number of picklist values automatically.

## Related Pages

* [Input Field Configuration](input-field-configuration.md) — field configuration overview
* [Field Validation](field-validation.md) — min/max, regex, required rules
* [Field Labels & Help Text](field-labels-help-text.md) — label customization
* [Conditional Logic](conditional-logic.md) — show/hide/require/disable rules
