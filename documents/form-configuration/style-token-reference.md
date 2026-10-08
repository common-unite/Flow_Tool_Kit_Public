# CSS Style Token Reference

> All 156 Flow Tool Kit style tokens, generated from the same catalog the style editor uses.

A **token** is a CSS custom property, such as `--ftk-color-primary`. Every control in the style editor sets one, and a stylesheet can set the same ones.

| You are | Start with |
| --- | --- |
| An administrator | [Form Styles](form-styles.md). The editor sets tokens for you, so you do not need this page |
| A developer writing CSS | [Custom Styling Overview](custom-styling-overview.md) for where a stylesheet loads and how it combines with the editor, then the tables below |
| Either, matching a control to its token | The **In the style editor** column of the tables below |

Downloads: [CSV token list](../resources/form-style-tokens.csv) · [JSON token list](../resources/form-style-tokens.json) · [Form Template CSS example](../resources/form-template-styles.css) · [Custom-metadata CSS example](../resources/org-form-styles.css).

## How to read a row

| Column | Meaning |
| --- | --- |
| **Token** | The CSS custom property name. It is case-sensitive and has no Salesforce namespace prefix |
| **In the style editor** | Where an administrator sets it. A token set from two places lists both. **No control** means the editor has no slider or box for it: set it in a stylesheet, or include it in the JSON you bring in with **Import**. An imported value is then listed under **Other saved overrides** in Advanced |
| **Value type** | The kind of CSS value it takes: a color, a length such as `0.5rem`, a plain number for a scale, and so on |
| **What it does** | The part of the form it changes |
| **Falls back to** | What is used when the token is not set, read left to right: a more general token first, then the built-in default. A name starting `--ftk-` is another token. Plain words such as **Component default**, **Salesforce/site default** or **Responsive title size** describe a built-in value that is not a token; the page the form runs in, or the component itself, decides it |
| **From CSS alone** | **Yes**: setting the token in a stylesheet is enough. **Partly**: Flow Tool Kit's own markup follows the token, but Salesforce's own inputs, buttons or icons follow it only when it is saved in the editor, or when the stylesheet adds a companion rule. See [Native controls](#native-controls-and-css-only-tokens) |

For example, `--ftk-input-radius` falls back to `--ftk-radius-medium`. A form with only `--ftk-radius-medium` set still rounds its inputs, and setting `--ftk-input-radius` changes the inputs alone.

One control in the editor can set several tokens. **Advanced → Choices → Answer buttons → Corners**, for example, sets the survey, joined and separated answer corners together, so those three tokens show the same place.

## Rules for values

- **Sizes.** Prefer rem. `1rem` is the page's base font size, usually 16px.
- **Scales.** A token ending in `-scale` is a plain multiplier. Write `1.25`, not `125%`. A scale of `1` changes nothing.
- **Not set and zero are different.** Leave a declaration out to inherit. `0`, `none` and a transparent color are values, and they override.
- **A token changes what reads it.** It is not a reset of every similar Salesforce control on the page.
- **Defaults vary by host.** The same unset token can resolve differently in Lightning Experience, on an Aura site and on an LWR site, and two tokens have no effect on LWR sites. See [Differences between hosts](custom-styling-overview.md#differences-between-hosts).
- **Older tokens stay supported.** The catalog includes tokens with no control in the editor; a saved value for one still applies.
- **Private names.** Anything starting `--_ftk-` is internal and can change in any release.

## Where to declare tokens

In a **Form Template stylesheet**, use `:root`. The loader maps it to that template's container:

```css
:root {
    --ftk-input-surface: #f5f8fc;
    --ftk-input-radius: 0.5rem;
    --ftk-input-padding-inline: 0.875rem;
}
```

In a **custom-metadata stylesheet**, also declare tokens under `:root`. That loader does not rewrite selectors, and only Flow Tool Kit components read these properties, so the values reach templates, the builder preview and every component placed directly on a Flow screen without restyling the rest of the page. The class `.form-template-container` is always present on templates and builder previews, but a component placed directly on a Flow screen carries it only once org defaults are saved. Use that class, or a narrower ancestor selector, for a rule that should affect one place only.

A value saved in the style editor, as an org default or a template override, normally wins over a stylesheet declaration of the same token, because the editor's values are written inline on the form's outer element. An `!important` declaration on that same element takes control on purpose; in a custom-metadata stylesheet that means declaring it on `.form-template-container`, not on `:root`. A Classic Theme you created, or a setting on the component, can still win for the property it sets. See the [cascade examples](custom-styling-overview.md#how-css-interacts-with-editor-values-and-classic-themes).

## Native controls and CSS-only tokens

Some tokens style controls that Salesforce draws, such as native inputs, buttons and icons. Saving one of those tokens in the style editor, or bringing it in with Import, switches on the extra rules that carry the value into the Salesforce control. A stylesheet does not switch them on. So a token marked **Partly** below changes Flow Tool Kit's own markup from CSS alone, and does not reach the Salesforce controls listed here:

| Token | From CSS alone it does not reach |
| --- | --- |
| `--ftk-control-scale` | height of inputs, dropdowns and record pickers; height of buttons and file upload buttons; size of toggles, sliders, time pickers, text areas, checkboxes and button icons; size of icon buttons and button menus; the size of the attestation checkbox; text size of record pickers, input fields, dual listboxes, dropdown options, and radio and checkbox labels |
| `--ftk-radius-scale` | corners of buttons and file upload buttons |
| `--ftk-font-scale` | text size of field labels |
| `--ftk-border-scale` | border thickness of inputs, dropdowns, text areas, record pickers, dual listboxes and checkboxes |
| `--ftk-color-text` | placeholder text color of inputs, text areas and dropdowns |
| `--ftk-font-size` | text size of field labels; text size of record pickers, input fields, dual listboxes, dropdown options, and radio and checkbox labels |
| `--ftk-joined-choice-padding-inline` | padding of the joined button group that Salesforce draws |
| `--ftk-attestation-target-size` | the size of the attestation checkbox |
| `--ftk-button-radius` | corners of buttons and file upload buttons |
| `--ftk-input-height` | height of inputs, dropdowns and record pickers |
| `--ftk-button-font-size` | text size of buttons and file upload buttons |
| `--ftk-button-height` | height of buttons and file upload buttons |
| `--ftk-icon-button-size` | size of icon buttons and button menus |
| `--ftk-radius-medium` | corners of buttons and file upload buttons |
| `--ftk-border-width` | border thickness of inputs, dropdowns, text areas, record pickers, dual listboxes and checkboxes |
| `--ftk-control-height` | height of inputs, dropdowns and record pickers; height of buttons and file upload buttons; size of icon buttons and button menus; the size of the attestation checkbox |
| `--ftk-input-placeholder-color` | placeholder text color of inputs, text areas and dropdowns |

**The supported route is to save these 17 tokens in the style editor,** as an org default or on the template. A stylesheet can still own every other token beside them.

If CSS must own one of them, the stylesheet has to add its own rule for each Salesforce control. For button text size in a Form Template stylesheet:

```css
:root { --ftk-button-font-size: 1rem; }
lightning-button:not(.slds-datepicker lightning-button) .slds-button,
lightning-file-upload .slds-file-selector__button {
    font-size: var(--ftk-button-font-size);
}
```

Rules like this are yours to maintain: they depend on Salesforce's markup, they work only where Salesforce renders with synthetic shadow DOM, and they are not published for the other tokens. In a custom-metadata stylesheet, start each selector with `.flowForm` so it does not reach buttons elsewhere on the page. Do not rely on the internal class names the editor adds, or on `--_ftk-*` variables.

## Token categories

### Form fields

| Token | In the style editor | Value type | What it does | Falls back to | From CSS alone |
| --- | --- | --- | --- | --- | --- |
| `--ftk-spacing-scale` | Basics → Form fields → Field spacing | number | Scales only the vertical gaps between field rows. | 1 | Yes |
| `--ftk-control-scale` | Basics → Form fields → Input size | number | Scales inputs, their text, inner padding and icons, choice controls, and buttons together. | 1 | Partly |
| `--ftk-radius-scale` | No control | number | Scales the rounding of input, button, choice, and card corners. | 1 | Partly |
| `--ftk-font-weight-label` | Basics → Form fields → Label weight | font-weight | Controls how light or bold field labels appear. | 400 | Yes |
| `--ftk-border-scale` | Basics → Form fields → Border thickness | number | Scales input, textarea, choice, button, and section border thickness. | 1 | Partly |
| `--ftk-radius-medium` | Basics → Form fields → Corner radius | length or percentage | One corner radius for inputs, buttons, choices, and containers. | Component default | Partly |

### Text

| Token | In the style editor | Value type | What it does | Falls back to | From CSS alone |
| --- | --- | --- | --- | --- | --- |
| `--ftk-font-scale` | Basics → Text → Text size | number | Scales field labels, help text, headings, stage text, and unformatted rich text. Input text follows Input size. | 1 | Partly |
| `--ftk-font-family` | Basics → Text → Font | font-family | Font for the whole form. | Salesforce/site default | Yes |

### Form layout

| Token | In the style editor | Value type | What it does | Falls back to | From CSS alone |
| --- | --- | --- | --- | --- | --- |
| `--ftk-section-padding-inline` | Basics → Form layout → Horizontal padding | length | Sets left and right padding inside form sections. | Existing section padding | Yes |
| `--ftk-section-padding-block` | Basics → Form layout → Vertical padding | length | Sets top and bottom padding inside form sections. | Existing section padding | Yes |
| `--ftk-layout-spacing-scale` | No control | number | Scales padding around form sections without changing field gaps or input padding. | 1 | Yes |

### Color

| Token | In the style editor | Value type | What it does | Falls back to | From CSS alone |
| --- | --- | --- | --- | --- | --- |
| `--ftk-color-primary` | Basics → Colors → Brand | color | Primary actions and selected controls; inherits host brand unless explicitly overridden | Salesforce/site default | Yes |
| `--ftk-color-option` | Basics → Colors → Choice text | color | Text in radio choices, checkboxes, pills, and dropdown options. Selected brand buttons use Brand text. | Salesforce/site default | Yes |
| `--ftk-color-label` | Basics → Colors → Field labels | color | Text above or beside each field, independent of Input text and Choice text. | Salesforce/site default | Yes |
| `--ftk-color-text` | Basics → Colors → Input text; Advanced → Inputs → Colors → Input text | color | Text entered in inputs and textareas. Field labels, choices, and form content keep their own colors. | Salesforce/site default | Partly |
| `--ftk-color-on-primary` | Basics → Colors → Brand text | color | Foreground on selected/primary surfaces | Salesforce/site default | Yes |
| `--ftk-color-footer` | Advanced → Other components → Feedback and footer → Footer background | color | Docked action bar surface | #ffffff | Yes |
| `--ftk-color-footer-border` | Advanced → Other components → Feedback and footer → Footer border | color | Docked action bar top boundary | transparent | Yes |

### State

| Token | In the style editor | Value type | What it does | Falls back to | From CSS alone |
| --- | --- | --- | --- | --- | --- |
| `--ftk-color-primary-hover` | Advanced → Other components → Interaction colors → Brand hover color | color | Primary hover shade; follows primary unless overridden; optional override | Derived from primary color | Yes |
| `--ftk-color-primary-active` | Advanced → Other components → Interaction colors → Brand pressed color | color | Primary pressed shade; follows primary unless overridden; optional override | Derived from primary color | Yes |
| `--ftk-focus-ring` | No control | box-shadow | Visible keyboard focus; optional override | Derived from primary color | Yes |
| `--ftk-color-danger` | Advanced → Other components → Feedback and footer → Error color | color | Color of field errors: the error border, icon and message, the required mark, and the attestation error tint. | #ba0517 | Yes |

### Surfaces

| Token | In the style editor | Value type | What it does | Falls back to | From CSS alone |
| --- | --- | --- | --- | --- | --- |
| `--ftk-color-background` | Basics → Colors → Form background | color | Background behind the entire form template. Transparent lets the page background show through. | transparent | Yes |

### Typography

| Token | In the style editor | Value type | What it does | Falls back to | From CSS alone |
| --- | --- | --- | --- | --- | --- |
| `--ftk-font-size` | Advanced → Text → Typography → Body and input text size | font-size | Sets inherited body and input text size. Native controls may grow to fit larger text. Labels and headings have separate controls. | Salesforce/site default | Partly |
| `--ftk-line-height` | Advanced → Text → Typography → Line spacing | number or length | Line spacing for body text, rich text and multiline inputs. Headings retain independent spacing. | Salesforce/site default | Yes |

### Labels and help

| Token | In the style editor | Value type | What it does | Falls back to | From CSS alone |
| --- | --- | --- | --- | --- | --- |
| `--ftk-font-size-label` | Advanced → Text → Labels and help → Label size | font-size | Default label size | scales with --ftk-font-scale → 0.75rem | Yes |
| `--ftk-label-gap` | Advanced → Text → Labels and help → Space below labels | length | Gap below default field labels | 0.125rem | Yes |
| `--ftk-help-font-size` | Advanced → Text → Labels and help → Help text size | font-size | Help text size for labels and help. Specific overrides take priority over shared controls. | --ftk-font-size-small → scales with --ftk-font-scale → 0.65rem | Yes |
| `--ftk-help-color` | Advanced → Text → Labels and help → Help text color | color | Help text color for labels and help. Specific overrides take priority over shared controls. | --ftk-color-text-muted → #939393 | Yes |

### Headers

| Token | In the style editor | Value type | What it does | Falls back to | From CSS alone |
| --- | --- | --- | --- | --- | --- |
| `--ftk-font-size-heading` | Advanced → Headings → Text → Heading size | font-size | Section title size | scales with --ftk-font-scale → 1.25rem | Yes |
| `--ftk-font-weight-heading` | Advanced → Headings → Text → Heading weight | font-weight | Section title weight | 700 | Yes |
| `--ftk-heading-background` | Advanced → Headings → Appearance → Background | color | Default header surface | unset | Yes |
| `--ftk-heading-border-color` | Advanced → Headings → Appearance → Rule color | color | Default header rule color | Salesforce/site default | Yes |
| `--ftk-heading-border-width` | Advanced → Headings → Appearance → Rule thickness | border-width | Default header rule thickness | scales with --ftk-border-scale → 2px | Yes |
| `--ftk-font-family-heading` | Advanced → Headings → Text → Heading font | font-family | Section-heading typeface independent of body copy | Salesforce/site default | Yes |
| `--ftk-heading-letter-spacing` | Advanced → Headings → More heading details → Title letter spacing | letter-spacing | Section-heading tracking | normal | Yes |
| `--ftk-heading-text-transform` | Advanced → Headings → More heading details → Capitalization | text-transform | Section-heading case treatment without changing authored text | none | Yes |
| `--ftk-header-shadow` | Advanced → Headings → Appearance → Shadow | box-shadow | Header shadow for headers. Specific overrides take priority over shared controls. | --ftk-shadow-medium → 0 0 3px rgba(0,0,0,0.16) | Yes |
| `--ftk-heading-line-height` | No control | number or length | Heading line spacing for headers. Specific overrides take priority over shared controls. | 1 | Yes |
| `--ftk-header-radius` | Advanced → Headings → More heading details → Corners | length | Header corners for headers. Specific overrides take priority over shared controls. | --ftk-radius-medium → scales with --ftk-radius-scale → 0.5rem | Yes |
| `--ftk-header-padding-block` | Advanced → Headings → Spacing → Vertical padding | length | Header vertical padding for headers. Specific overrides take priority over shared controls. | --ftk-section-padding → 0.5rem | Yes |
| `--ftk-header-padding-left` | Advanced → Headings → Spacing → Left padding | length | Header left padding for headers. Specific overrides take priority over shared controls. | --ftk-section-padding-inline → --ftk-section-padding → 0.8rem | Yes |
| `--ftk-header-padding-right` | Advanced → Headings → Spacing → Right padding | length | Header right padding for headers. Specific overrides take priority over shared controls. | --ftk-section-padding-inline → --ftk-section-padding → 0 | Yes |
| `--ftk-header-subtitle-color` | Advanced → Headings → More heading details → Subtitle color | color | Header subtitle color for headers. Specific overrides take priority over shared controls. | --ftk-color-text-muted → Salesforce/site default | Yes |

### Spacing

| Token | In the style editor | Value type | What it does | Falls back to | From CSS alone |
| --- | --- | --- | --- | --- | --- |
| `--ftk-field-gap` | No control | length | Additional field separation | 0 | Yes |

### Shape

| Token | In the style editor | Value type | What it does | Falls back to | From CSS alone |
| --- | --- | --- | --- | --- | --- |
| `--ftk-container-border-width` | Advanced → Form card → Appearance → Border thickness | border-width | Decorative template framing independent of essential field boundaries | 0px | Yes |

### Sections

| Token | In the style editor | Value type | What it does | Falls back to | From CSS alone |
| --- | --- | --- | --- | --- | --- |
| `--ftk-plain-section-padding-top` | No control | length | Plain section padding - top for sections. Specific overrides take priority over shared controls. | --ftk-section-padding-top → --ftk-section-padding-block → scales with --ftk-layout-spacing-scale → 0 | Yes |
| `--ftk-boxed-section-padding-top` | No control | length | Boxed section padding - top for sections. Specific overrides take priority over shared controls. | --ftk-section-padding-top → --ftk-section-padding-block → scales with --ftk-layout-spacing-scale → 0 | Yes |
| `--ftk-plain-section-padding-right` | No control | length | Plain section padding - right for sections. Specific overrides take priority over shared controls. | --ftk-section-padding-right → --ftk-section-padding-inline → scales with --ftk-layout-spacing-scale → 0.3rem | Yes |
| `--ftk-boxed-section-padding-right` | No control | length | Boxed section padding - right for sections. Specific overrides take priority over shared controls. | --ftk-section-padding-right → --ftk-section-padding-inline → --ftk-section-padding → scales with --ftk-layout-spacing-scale → 0.4rem | Yes |
| `--ftk-plain-section-padding-bottom` | No control | length | Plain section padding - bottom for sections. Specific overrides take priority over shared controls. | --ftk-section-padding-bottom → --ftk-section-padding-block → scales with --ftk-layout-spacing-scale → 0 | Yes |
| `--ftk-boxed-section-padding-bottom` | No control | length | Boxed section padding - bottom for sections. Specific overrides take priority over shared controls. | --ftk-section-padding-bottom → --ftk-section-padding-block → --ftk-section-padding → scales with --ftk-layout-spacing-scale → 0.75rem | Yes |
| `--ftk-plain-section-padding-left` | No control | length | Plain section padding - left for sections. Specific overrides take priority over shared controls. | --ftk-section-padding-left → --ftk-section-padding-inline → scales with --ftk-layout-spacing-scale → 0.3rem | Yes |
| `--ftk-boxed-section-padding-left` | No control | length | Boxed section padding - left for sections. Specific overrides take priority over shared controls. | --ftk-section-padding-left → --ftk-section-padding-inline → --ftk-section-padding → scales with --ftk-layout-spacing-scale → 0.4rem | Yes |
| `--ftk-section-header-gap` | Advanced → Sections → Appearance → Space below header | length | Gap below section header for sections. Specific overrides take priority over shared controls. | --ftk-section-padding-top → --ftk-section-padding-block → scales with --ftk-layout-spacing-scale → 0.75rem | Yes |
| `--ftk-section-radius` | Advanced → Sections → Appearance → Corners | length | Section corners for sections. Specific overrides take priority over shared controls. | --ftk-radius-medium → scales with --ftk-radius-scale → 5px | Yes |
| `--ftk-section-border-width` | Advanced → Sections → Appearance → Border thickness | border-width | Section border width for sections. Specific overrides take priority over shared controls. | --ftk-border-width → scales with --ftk-border-scale → 1px | Yes |
| `--ftk-section-border-color` | Advanced → Sections → Appearance → Border color | color | Section border color for sections. Specific overrides take priority over shared controls. | --ftk-color-border → #dddddd | Yes |
| `--ftk-section-shadow` | Advanced → Sections → Appearance → Shadow | box-shadow | Section shadow for sections. Specific overrides take priority over shared controls. | --ftk-shadow-medium → 0 7px 10px rgba(0,0,0,0.25) | Yes |

### Form card

| Token | In the style editor | Value type | What it does | Falls back to | From CSS alone |
| --- | --- | --- | --- | --- | --- |
| `--ftk-form-card-radius` | Advanced → Form card → Appearance → Corners | length | Form card corners for form card. Specific overrides take priority over shared controls. | --ftk-radius-large → --ftk-radius-medium → scales with --ftk-radius-scale → 10px | Yes |
| `--ftk-form-card-shadow-hover` | Advanced → Form card → Hover appearance → Hover shadow | box-shadow | Form card hover shadow for form card. Specific overrides take priority over shared controls. | --ftk-shadow-medium → 0 10px 15px rgba(0,0,0,0.2), 0 4px 6px rgba(0,0,0,0.15) | Yes |
| `--ftk-form-card-shadow` | Advanced → Form card → Appearance → Shadow | box-shadow | Form card shadow for form card. Specific overrides take priority over shared controls. | --ftk-shadow-medium → 0 4px 6px rgba(0,0,0,0.1), 0 1px 3px rgba(0,0,0,0.08) | Yes |
| `--ftk-form-card-surface` | Advanced → Form card → Appearance → Background | color | Form card background for form card. Specific overrides take priority over shared controls. | --ftk-color-surface → #ffffff | Yes |
| `--ftk-form-card-border-color` | Advanced → Form card → Appearance → Border color | color | Form card border color for form card. Specific overrides take priority over shared controls. | --ftk-color-border-muted → transparent | Yes |

### Text fields

| Token | In the style editor | Value type | What it does | Falls back to | From CSS alone |
| --- | --- | --- | --- | --- | --- |
| `--ftk-read-only-radius` | Advanced → Inputs → Read-only and rich text → Read-only corners | length | Read-only text corners for text fields. Specific overrides take priority over shared controls. | --ftk-radius-medium → scales with --ftk-radius-scale → 0.25rem | Yes |
| `--ftk-read-only-border-width` | Advanced → Inputs → Read-only and rich text → Read-only border thickness | border-width | Read-only text border width for text fields. Specific overrides take priority over shared controls. | --ftk-border-width → scales with --ftk-border-scale → 1px | Yes |
| `--ftk-read-only-border-color` | Advanced → Inputs → Read-only and rich text → Read-only border color | color | Read-only text border color for text fields. Specific overrides take priority over shared controls. | --ftk-color-border → #e5e5e5 | Yes |
| `--ftk-richtext-radius` | Advanced → Inputs → Read-only and rich text → Rich-text editor corners | length | Rich-text editor corners for text fields. Specific overrides take priority over shared controls. | --ftk-radius-medium → scales with --ftk-radius-scale → Salesforce/site default | Yes |
| `--ftk-input-radius` | Advanced → Inputs → Size and shape → Corners | length | Input corners for text fields. Specific overrides take priority over shared controls. | --ftk-radius-medium → Salesforce/site default | Yes |
| `--ftk-textarea-radius` | Advanced → Inputs → Text area details → Corners | length | Textarea corners for text fields. Specific overrides take priority over shared controls. | --ftk-input-radius → --ftk-radius-medium → Salesforce/site default | Yes |
| `--ftk-input-border-color` | Advanced → Inputs → Colors → Border | color | Input border color for text fields. Specific overrides take priority over shared controls. | --ftk-color-border → Salesforce/site default | Yes |
| `--ftk-textarea-border-color` | Advanced → Inputs → Text area details → Border | color | Textarea border color for text fields. Specific overrides take priority over shared controls. | --ftk-input-border-color → --ftk-color-border → Salesforce/site default | Yes |
| `--ftk-input-surface` | Advanced → Inputs → Colors → Background | color | Input background for text fields. Specific overrides take priority over shared controls. | --ftk-color-control-surface → Salesforce/site default | Yes |
| `--ftk-textarea-surface` | Advanced → Inputs → Text area details → Background | color | Textarea background for text fields. Specific overrides take priority over shared controls. | --ftk-input-surface → --ftk-color-control-surface → Salesforce/site default | Yes |
| `--ftk-input-padding-inline` | Advanced → Inputs → Size and shape → Horizontal padding | length | Input horizontal padding for text fields. Specific overrides take priority over shared controls. | --ftk-input-padding-x → Salesforce/site default | Yes |
| `--ftk-textarea-padding-inline` | Advanced → Inputs → Text area details → Horizontal padding | length | Textarea horizontal padding for text fields. Specific overrides take priority over shared controls. | --ftk-input-padding-inline → --ftk-input-padding-x → Salesforce/site default | Yes |
| `--ftk-textarea-padding-block` | Advanced → Inputs → Text area details → Vertical padding | length | Textarea vertical padding for text fields. Specific overrides take priority over shared controls. | --ftk-input-padding-y → Salesforce/site default | Yes |
| `--ftk-input-height` | Advanced → Inputs → Size and shape → Input height | length | Input height for text fields. Specific overrides take priority over shared controls. | --ftk-control-height → scales with --ftk-control-scale → 2rem | Partly |
| `--ftk-input-placeholder-color` | Advanced → Inputs → Colors → Placeholder text | color | Placeholder text in empty inputs and text areas. Follows an authored input text color unless overridden. | --ftk-color-text → Salesforce/site default | Partly |

### Survey choices

| Token | In the style editor | Value type | What it does | Falls back to | From CSS alone |
| --- | --- | --- | --- | --- | --- |
| `--ftk-survey-height` | Advanced → Choices → Answer buttons → Minimum height | length | Survey choice minimum height for survey choices. Specific overrides take priority over shared controls. | --ftk-control-height → scales with --ftk-control-scale → 3rem | Yes |
| `--ftk-survey-radius` | Advanced → Choices → Answer buttons → Corners | length | Survey choice corners for survey choices. Specific overrides take priority over shared controls. | --ftk-radius-medium → scales with --ftk-radius-scale → 0.625rem | Yes |
| `--ftk-survey-border-width` | Advanced → Choices → Answer buttons → Border thickness | border-width | Survey choice border width for survey choices. Specific overrides take priority over shared controls. | --ftk-border-width → scales with --ftk-border-scale → 1.5px | Yes |
| `--ftk-survey-border-color` | Advanced → Choices → Answer buttons → Border color | color | Survey choice border color for survey choices. Specific overrides take priority over shared controls. | --ftk-color-border → #e5e5e5 | Yes |
| `--ftk-survey-surface` | Advanced → Choices → Answer buttons → Background | color | Survey choice background for survey choices. Specific overrides take priority over shared controls. | --ftk-color-control-surface → #ffffff | Yes |
| `--ftk-survey-padding-inline` | Advanced → Choices → Answer spacing → Answer horizontal padding | length | Survey horizontal padding for survey choices. Specific overrides take priority over shared controls. | --ftk-input-padding-x → scales with --ftk-control-scale → 0.875rem | Yes |
| `--ftk-survey-padding-block` | Advanced → Choices → Answer spacing → Answer vertical padding | length | Survey vertical padding for survey choices. Specific overrides take priority over shared controls. | --ftk-input-padding-y → scales with --ftk-control-scale → 0.75rem | Yes |

### Joined choices

| Token | In the style editor | Value type | What it does | Falls back to | From CSS alone |
| --- | --- | --- | --- | --- | --- |
| `--ftk-joined-choice-padding-inline` | Advanced → Choices → Answer spacing → Joined answer padding | length | Joined-choice horizontal padding for joined choices. Specific overrides take priority over shared controls. | --ftk-input-padding-x → scales with --ftk-control-scale → 1rem | Partly |
| `--ftk-joined-choice-radius` | Advanced → Choices → Answer buttons → Corners | length | Joined-choice corners for joined choices. Specific overrides take priority over shared controls. | --ftk-radius-medium → 0.25rem | Yes |

### Separated choices

| Token | In the style editor | Value type | What it does | Falls back to | From CSS alone |
| --- | --- | --- | --- | --- | --- |
| `--ftk-separated-choice-height` | Advanced → Choices → Answer buttons → Minimum height | length | Separated-choice minimum height for separated choices. Specific overrides take priority over shared controls. | --ftk-control-height → auto | Yes |
| `--ftk-separated-choice-radius` | Advanced → Choices → Answer buttons → Corners | length | Separated-choice corners for separated choices. Specific overrides take priority over shared controls. | --ftk-radius-medium → scales with --ftk-radius-scale → 0.25rem | Yes |
| `--ftk-separated-choice-line-height` | Advanced → Choices → Answer spacing → Separated answer line spacing | number or length | Separated-choice line spacing for separated choices. Specific overrides take priority over shared controls. | --ftk-line-height → 1.875rem | Yes |
| `--ftk-separated-choice-padding-inline` | Advanced → Choices → Answer spacing → Separated answer horizontal padding | length | Separated-choice horizontal padding for separated choices. Specific overrides take priority over shared controls. | --ftk-input-padding-x → scales with --ftk-control-scale → 1rem | Yes |
| `--ftk-separated-choice-padding-block` | Advanced → Choices → Answer spacing → Separated answer vertical padding | length | Separated-choice vertical padding for separated choices. Specific overrides take priority over shared controls. | --ftk-input-padding-y → scales with --ftk-control-scale → 0 | Yes |

### Visual choices

| Token | In the style editor | Value type | What it does | Falls back to | From CSS alone |
| --- | --- | --- | --- | --- | --- |
| `--ftk-visual-choice-radius` | Advanced → Choices → Visual cards → Corners | length | Visual-choice corners for visual choices. Specific overrides take priority over shared controls. | --ftk-radius-medium → scales with --ftk-radius-scale → 0.625rem | Yes |
| `--ftk-visual-choice-border-width` | Advanced → Choices → More choice details → Visual card border thickness | border-width | Visual-choice border width for visual choices. Specific overrides take priority over shared controls. | --ftk-border-width → scales with --ftk-border-scale → 1.5px | Yes |
| `--ftk-visual-choice-border-color` | Advanced → Choices → Visual cards → Border color | color | Visual-choice border color for visual choices. Specific overrides take priority over shared controls. | --ftk-color-border → #e5e5e5 | Yes |
| `--ftk-visual-choice-surface` | Advanced → Choices → Visual cards → Background | color | Visual-choice background for visual choices. Specific overrides take priority over shared controls. | --ftk-color-control-surface → #ffffff | Yes |

### Matrix

| Token | In the style editor | Value type | What it does | Falls back to | From CSS alone |
| --- | --- | --- | --- | --- | --- |
| `--ftk-matrix-radius` | Advanced → Other components → More matrix details → Frame corners | length | Matrix frame corners for matrix. Specific overrides take priority over shared controls. | --ftk-radius-medium → scales with --ftk-radius-scale → 0.5rem | Yes |
| `--ftk-matrix-card-radius` | Advanced → Other components → More matrix details → Card corners | length | Matrix card corners for matrix. Specific overrides take priority over shared controls. | --ftk-radius-large → scales with --ftk-radius-scale → 0.75rem | Yes |
| `--ftk-matrix-secondary-font-size` | Advanced → Other components → More matrix details → Supporting text size | font-size | Matrix secondary text size for matrix. Specific overrides take priority over shared controls. | --ftk-font-size-small → scales with --ftk-font-scale → 0.75rem | Yes |
| `--ftk-matrix-secondary-color` | Advanced → Other components → More matrix details → Supporting text color | color | Matrix secondary text color for matrix. Specific overrides take priority over shared controls. | --ftk-color-text-muted → #444444 | Yes |
| `--ftk-matrix-choice-border-width` | Advanced → Other components → More matrix details → Answer border thickness | border-width | Matrix choice border width for matrix. Specific overrides take priority over shared controls. | --ftk-border-width → scales with --ftk-border-scale → 2px | Yes |
| `--ftk-matrix-choice-surface` | Advanced → Other components → Tables and matrix questions → Matrix answer background | color | Matrix choice background for matrix. Specific overrides take priority over shared controls. | --ftk-color-control-surface → #ffffff | Yes |
| `--ftk-matrix-shade` | Advanced → Other components → Tables and matrix questions → Matrix shading | color | Matrix shaded background for matrix. Specific overrides take priority over shared controls. | --ftk-color-surface-muted → #f3f3f3 | Yes |
| `--ftk-matrix-border-color` | Advanced → Other components → Tables and matrix questions → Matrix borders | color | Matrix frame border color for matrix. Specific overrides take priority over shared controls. | --ftk-color-border → #e5e5e5 | Yes |
| `--ftk-matrix-divider-color` | Advanced → Other components → Tables and matrix questions → Matrix borders | color | Matrix divider color for matrix. Specific overrides take priority over shared controls. | --ftk-color-border → #f0f0f0 | Yes |
| `--ftk-matrix-choice-border-color` | Advanced → Other components → Tables and matrix questions → Matrix borders | color | Matrix choice border color for matrix. Specific overrides take priority over shared controls. | --ftk-color-border → #aeaeae | Yes |

### Checkboxes

| Token | In the style editor | Value type | What it does | Falls back to | From CSS alone |
| --- | --- | --- | --- | --- | --- |
| `--ftk-attestation-radius` | Advanced → Choices → More choice details → Attestation corners | length | Attestation corners for checkboxes. Specific overrides take priority over shared controls. | --ftk-radius-medium → scales with --ftk-radius-scale → 0.25rem | Yes |
| `--ftk-attestation-surface` | Advanced → Choices → Checkboxes and attestations → Attestation background | color | Attestation background for checkboxes. Specific overrides take priority over shared controls. | --ftk-color-control-surface → --ftk-color-surface-muted → #f3f3f3 | Yes |
| `--ftk-attestation-target-size` | Advanced → Choices → More choice details → Attestation checkbox size | length | Attestation target size for checkboxes. Specific overrides take priority over shared controls. | --ftk-control-height → Salesforce/site default | Partly |
| `--ftk-checkbox-radius` | Advanced → Choices → More choice details → Checkbox corners | length | Checkbox corners for checkboxes. Specific overrides take priority over shared controls. | --ftk-radius-small → --ftk-radius-medium → Salesforce/site default | Yes |
| `--ftk-checkbox-border-color` | Advanced → Choices → Checkboxes and attestations → Checkbox border | color | Checkbox border color for checkboxes. Specific overrides take priority over shared controls. | --ftk-color-border → Salesforce/site default | Yes |
| `--ftk-checkbox-surface` | Advanced → Choices → Checkboxes and attestations → Unchecked background | color | Unchecked checkbox fill. Follows Input background; a specific override takes priority. | --ftk-color-control-surface → Salesforce/site default | Yes |

### Calendar

| Token | In the style editor | Value type | What it does | Falls back to | From CSS alone |
| --- | --- | --- | --- | --- | --- |
| `--ftk-calendar-day-size` | Advanced → Other components → Calendar popup → Day size | length | Calendar day size for calendar. Specific overrides take priority over shared controls. | --ftk-control-height → scales with --ftk-control-scale → 2.15rem | Yes |
| `--ftk-calendar-font-size` | Advanced → Other components → Calendar popup → Text size | font-size | Calendar text size for calendar. Specific overrides take priority over shared controls. | --ftk-font-size → scales with --ftk-font-scale → 1.25rem | Yes |
| `--ftk-calendar-border-width` | Advanced → Other components → Calendar popup → Border thickness | border-width | Calendar border width for calendar. Specific overrides take priority over shared controls. | --ftk-border-width → scales with --ftk-border-scale → 1px | Yes |
| `--ftk-calendar-border-color` | Advanced → Other components → Calendar popup → Border color | color | Calendar border color for calendar. Specific overrides take priority over shared controls. | --ftk-color-border → rgba(0,0,0,0.1) | Yes |

### Modals

| Token | In the style editor | Value type | What it does | Falls back to | From CSS alone |
| --- | --- | --- | --- | --- | --- |
| `--ftk-modal-surface` | Advanced → Other components → Dialogs and dividers → Dialog background | color | Modal background for modals. Specific overrides take priority over shared controls. | --ftk-color-surface → #ffffff | Yes |

### Tables

| Token | In the style editor | Value type | What it does | Falls back to | From CSS alone |
| --- | --- | --- | --- | --- | --- |
| `--ftk-table-shadow` | Advanced → Other components → Table and divider details → Table shadow | box-shadow | Table shadow for tables. Specific overrides take priority over shared controls. | --ftk-shadow-medium → 0 7px 10px rgba(0,0,0,0.25) | Yes |
| `--ftk-table-shade` | Advanced → Other components → Tables and matrix questions → Table shading | color | Table shaded background for tables. Specific overrides take priority over shared controls. | --ftk-color-surface-muted → #f3f2f2 | Yes |
| `--ftk-table-surface` | Advanced → Other components → Tables and matrix questions → Table background | color | Table background for tables. Specific overrides take priority over shared controls. | --ftk-color-surface → #ffffff | Yes |

### Dividers

| Token | In the style editor | Value type | What it does | Falls back to | From CSS alone |
| --- | --- | --- | --- | --- | --- |
| `--ftk-divider-subtitle-color` | Advanced → Other components → Table and divider details → Divider subtitle color | color | Divider subtitle color for dividers. Specific overrides take priority over shared controls. | --ftk-color-text-muted → #706e6b | Yes |
| `--ftk-divider-rule-color` | Advanced → Other components → Dialogs and dividers → Divider color | color | Divider rule color for dividers. Specific overrides take priority over shared controls. | --ftk-color-border-muted → #c9c7c5 | Yes |

### Buttons

| Token | In the style editor | Value type | What it does | Falls back to | From CSS alone |
| --- | --- | --- | --- | --- | --- |
| `--ftk-button-radius` | Advanced → Buttons → Size and shape → Corners | length | Button corners for buttons. Specific overrides take priority over shared controls. | --ftk-radius-medium → Salesforce/site default | Partly |
| `--ftk-button-font-size` | Advanced → Buttons → Size and shape → Button text size | font-size | Text size for action buttons, independent of their height and other form text. | --ftk-font-size → scales with --ftk-control-scale → 0.8125rem | Partly |
| `--ftk-button-height` | Advanced → Buttons → Size and shape → Button height | length | Button height for buttons. Specific overrides take priority over shared controls. | --ftk-control-height → scales with --ftk-control-scale → Salesforce/site default | Partly |
| `--ftk-icon-button-size` | Advanced → Buttons → Icon buttons → Icon button size | length | Icon button size for buttons. Specific overrides take priority over shared controls. | --ftk-control-height → Salesforce/site default | Partly |

### Shared overrides

| Token | In the style editor | Value type | What it does | Falls back to | From CSS alone |
| --- | --- | --- | --- | --- | --- |
| `--ftk-color-text-muted` | No control | color | Secondary help foreground | Component default | Yes |
| `--ftk-color-surface` | Basics → Colors → Card background | color | Background of cards, choice tiles, and panels. Input field background can be changed separately. | Component default | Yes |
| `--ftk-color-border` | Basics → Colors → Borders | color | Essential field boundaries | Component default | Yes |
| `--ftk-color-border-muted` | No control | color | Decorative container boundaries | Component default | Yes |
| `--ftk-font-size-small` | No control | font-size | Help text size | Component default | Yes |
| `--ftk-border-width` | No control | border-width | Boundary thickness | Component default | Partly |
| `--ftk-input-padding-x` | No control | length | Horizontal control padding | Component default | Yes |
| `--ftk-input-padding-y` | No control | length | Vertical control padding | Component default | Yes |
| `--ftk-control-height` | No control | length | Control minimum target height | Component default | Partly |
| `--ftk-shadow-medium` | No control | box-shadow | Container elevation | Component default | Yes |
| `--ftk-color-surface-muted` | No control | color | Subtle secondary surfaces | Component default | Yes |
| `--ftk-radius-small` | No control | length or percentage | Compact control corners | Component default | Yes |
| `--ftk-section-padding` | No control | length | One CSS length shared by boxed section sides/bottom and standard headers. Use the separate section-content edge controls for independent spacing. | Component default | Yes |
| `--ftk-section-padding-top` | Advanced → Sections → Individual side padding → Top | length | Controls only the top inset of plain and boxed section content. Header padding and special address/image layouts remain separate. | --ftk-section-padding-block → Component default | Yes |
| `--ftk-section-padding-right` | Advanced → Sections → Individual side padding → Right | length | Controls only the right inset of plain and boxed section content. Header padding and special address/image layouts remain separate. | --ftk-section-padding-inline → Component default | Yes |
| `--ftk-section-padding-bottom` | Advanced → Sections → Individual side padding → Bottom | length | Controls only the bottom inset of plain and boxed section content. Header padding and special address/image layouts remain separate. | --ftk-section-padding-block → Component default | Yes |
| `--ftk-section-padding-left` | Advanced → Sections → Individual side padding → Left | length | Controls only the left inset of plain and boxed section content. Header padding and special address/image layouts remain separate. | --ftk-section-padding-inline → Component default | Yes |
| `--ftk-radius-large` | No control | length | Template card corners; separate scale for large surfaces | Component default | Yes |
| `--ftk-color-control-surface` | Basics → Colors → Input background | color | Fill inside inputs, textareas, dropdowns, survey choices, visual pickers, and attestation cards. | Component default | Yes |

### Stacked headers

| Token | In the style editor | Value type | What it does | Falls back to | From CSS alone |
| --- | --- | --- | --- | --- | --- |
| `--ftk-hero-title-size` | Advanced → Headings → Stacked header → Title size | font-size | Title size for the Stacked header style. Shared text and layout scales apply until a specific value is set. | --ftk-font-size-heading → scales with --ftk-font-scale → Responsive title size | Yes |
| `--ftk-hero-eyebrow-size` | Advanced → Headings → Stacked header → Eyebrow size | font-size | Eyebrow size for the Stacked header style. Shared text and layout scales apply until a specific value is set. | scales with --ftk-font-scale → 0.75rem | Yes |
| `--ftk-hero-kicker-size` | Advanced → Headings → Stacked header → Pretitle size | font-size | Pretitle size for the Stacked header style. Shared text and layout scales apply until a specific value is set. | scales with --ftk-font-scale → 0.9375rem | Yes |
| `--ftk-hero-lead-size` | Advanced → Headings → Stacked header → Body size | font-size | Body size for the Stacked header style. Shared text and layout scales apply until a specific value is set. | scales with --ftk-font-scale → 1.125rem | Yes |
| `--ftk-hero-footer-size` | Advanced → Headings → Stacked header → Footer size | font-size | Footer size for the Stacked header style. Shared text and layout scales apply until a specific value is set. | scales with --ftk-font-scale → 0.875rem | Yes |
| `--ftk-hero-tag-size` | Advanced → Headings → Stacked header → Tag text size | font-size | Tag text size for the Stacked header style. Shared text and layout scales apply until a specific value is set. | scales with --ftk-font-scale → 0.8125rem | Yes |
| `--ftk-hero-line-gap` | Advanced → Headings → Stacked header → Space between lines | length | Space between lines for the Stacked header style. Shared text and layout scales apply until a specific value is set. | scales with --ftk-layout-spacing-scale → 1rem | Yes |
| `--ftk-hero-lead-gap` | Advanced → Headings → Stacked header → Title to body gap | length | Title to body gap for the Stacked header style. Shared text and layout scales apply until a specific value is set. | scales with --ftk-layout-spacing-scale → 0.5rem | Yes |
| `--ftk-hero-max-width` | Advanced → Headings → Stacked header → Maximum text width | length | Maximum text width for the Stacked header style. Shared text and layout scales apply until a specific value is set. | 44rem | Yes |

### Section surfaces

| Token | In the style editor | Value type | What it does | Falls back to | From CSS alone |
| --- | --- | --- | --- | --- | --- |
| `--ftk-section-surface` | Advanced → Sections → Appearance → Frame background | color | Default fill of Box, Shadow, Card and Title on border frames. An explicit Classic Theme section background takes priority. | transparent | Yes |
