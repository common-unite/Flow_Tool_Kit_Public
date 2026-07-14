# Field Type Settings

> Configure display overrides and type-specific settings for boolean, phone, string, textarea, number, checkbox, picklist rating, and signature pad fields.

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
* **Minimum / Maximum Height**: Set CSS height values (e.g., `250px`) to control the textarea size. Maximum Height is available on plain text areas and rich text alike.

### Text (String) fields as a Text Area

Any standard Text field can render as a multi-line text area: set **String Display Type** to **Text Area** in the field's String Override Settings. The character counter, minimum/maximum length, and the height controls all apply, so a 255-character field can collect a short paragraph without switching the schema to a Long Text Area.

### Read-only long text: clamped scroll box

Set a **Maximum Height** on a long text or rich text field and its **read-only** rendering (review screens, read-only forms, formula-driven rich text output) clamps to that height inside a bordered, scrollable box. Very long content stays visually contained with an obvious scroll affordance instead of stretching the page. Edit mode is unaffected beyond the standard textarea sizing.

## Number Fields

Number, currency, and percent fields can render as something more interactive than a plain input. Select the field and choose a **Number Display Type** in Number Override Settings:

![The Number Display Type dropdown, the Edit Preset Amounts editor, and stepper, slider, and preset chips rendering in the preview](../.gitbook/assets/254-number-overrides-demo.gif)

| Display Type       | Description                                                                                     |
| ------------------ | ----------------------------------------------------------------------------------------------- |
| **Default**        | A standard number input.                                                                        |
| **Stepper**        | Minus and plus buttons flank the formatted input.                                               |
| **Slider**         | A draggable range; uses the field's Min/Max (0 to 100 when unset).                              |
| **Preset Amounts** | Quick-pick amount chips you define, with an optional custom-value input.                         |

The field's currency or percent formatting applies in every mode, and the standard field toolkit (custom labels, help text, required, prompts, sizing) works throughout. Formula fields are read-only, so they never offer these overrides.

### Min, Max, and Step

The field's **Min** and **Max** values bound the stepper's clamping and the slider's range. The **Step** value sets how much the Stepper buttons and Slider move per step — set Step to `1` so a stepper counts by whole dollars instead of pennies. Step is an increment only: it never restricts what a respondent can type, so a Step of 5 still allows 12.50 to be entered directly.

![A stepper with Min 1, Max 100, and Step 1 incrementing the Quantity field](../.gitbook/assets/254-number-stepper-demo.gif)

A slider with no Min/Max set runs 0 to 100; setting Min and Max (and an optional Step) reshapes the range and its granularity.

![A percent slider bounded 0 to 100 with a Step of 10](../.gitbook/assets/254-number-slider-demo.gif)

### Preset Amounts

Choose **Preset Amounts** and click **Edit Preset Amounts** to open the editor. Each preset is a label/value pair — the label is the chip respondents see, the value is the number saved into the field. Reorder or delete rows, and turn on **Allow Custom Values** to offer an **Other** chip:

* Selecting **Other** reveals a free-entry input (its placeholder defaults to "Custom {label}", overridable via the field's Placeholder setting).
* A value that matches no preset automatically selects **Other** and shows the input, so a prefilled or unusual amount is never orphaned.
* On narrow containers (a small device or a cramped page column) the chips and the custom input each take a full row; on wider layouts the chips take about three-quarters of the width with the input beside them.

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

## Dynamic Selector Overrides

Certain fields are really references in disguise: a text field that stores an SLDS icon name, an email template, a public image asset, or a style sheet. When a field's **API name** signals one of these purposes, Form Builder dynamically offers the matching selector as a display type, and the respondent (usually an admin filling out a configuration form) picks from a real list instead of typing a raw value.

| Selector | Offered when the API name contains (case-insensitive) |
| --- | --- |
| **Icon Selector** | `icon` |
| **Email Template Selector** | `emailtemplate`, `email_template` |
| **Image Asset Selector** | `bannerimage`, `banner_image`, `tileimage`, `tile_image`, `imageasset`, `image_asset`, `assetfile`, `asset_file` |
| **Style Sheet Selector** | `stylesheet`, `style_sheet` |

The option appears in the field's display-type dropdown (String Display Type for text fields, Picklist Display Type for picklists) only when the name matches, the field is updateable, and a text field is at least 40 characters long. Fields named with `formqualifiedapiname` are related but different: they always render the form component selector automatically, with their own Form Selector Settings (target object and table-component toggle), and never show display-type overrides.

A few behaviors to know:

* The selector writes a plain text or picklist value into the field, and the value saves with the form like any other answer. Nothing writes to the record until the form itself saves.
* The full field toolkit applies: custom labels with merge fields, label size and position, help text, and the required flag all render through the standard label pipeline.
* The icon selector offers the complete current SLDS icon set across the utility, standard, custom, and doctype groups.

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
