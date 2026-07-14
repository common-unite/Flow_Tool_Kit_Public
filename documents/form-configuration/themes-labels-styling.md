# Themes, Labels & Styling
> Control the visual appearance of your forms with themes, provide translatable labels for multilingual support, and apply custom CSS overrides through style sheets.

## Video Walkthroughs

{% embed url="https://vimeo.com/755158586" %}

{% embed url="https://vimeo.com/815680609" %}

## Overview

Flow Tool Kit provides four mechanisms for customizing the look and text of your forms:

1. **Themes** (Form_Theme__mdt): Color schemes, backgrounds, and spacing applied to form headers, sections, and fields
2. **Labels** (Form_Label__mdt + Form_Label_Translation__mdt): Reusable, translatable text strings for field labels, help text, and other UI text
3. **Per-Template Style Sheets** (Form_Template__c.Style_Sheet__c): Custom CSS from a Static Resource, automatically scoped to a single Form Template
4. **Org-Wide Style Sheets** (Form_Style_Sheet__mdt): Custom CSS loaded globally for every form in the org

Together, these give admins full control over how forms look and what text they display, across languages and branding requirements. Not sure which to use? Start with the [Custom Styling Overview](custom-styling-overview.md).

## Themes (Form_Theme__mdt)

### What Themes Control

Themes define colors and backgrounds at three levels: the form heading, form body/sections, and accordion sections.

### Theme Properties

#### Heading Styles
| Field | Type | Default | Description |
|---|---|---|---|
| `headingBackgroundColor__c` | Text (7) | None | Background color for the header area (HEX, RGB, or RGBA) |
| `headingBackgroundImage__c` | Text | None | Background image URL for the header |
| `headingBackgroundImagePosition__c` | Text | None | CSS background-position value |
| `headingBackgroundImageSize__c` | Text | None | CSS background-size value |
| `headingFontColor__c` | Text (7) | None | Title text color |
| `headingSubtitleFontColor__c` | Text (7) | None | Subtitle text color |
| `headingIconColor__c` | Text (7) | None | Header icon color |

#### Form Body Styles
| Field | Type | Default | Description |
|---|---|---|---|
| `formBackgroundColor__c` | Text (7) | None | Background color for the form body (HEX, RGB, RGBA) |
| `formBackgroundImage__c` | Text | None | Background image URL for the form body |
| `formBackgroundImagePosition__c` | Text | None | CSS background-position value |
| `formBackgroundImageSize__c` | Text | None | CSS background-size value |
| `brandColor__c` | Text (7) | None | Primary brand color |

#### Section Styles
| Field | Type | Default | Description |
|---|---|---|---|
| `sectionBackgroundColor__c` | Text (7) | None | Background color for form sections |
| `sectionBackgroundImage__c` | Text | None | Background image URL for sections |
| `sectionBackgroundImagePosition__c` | Text | None | CSS background-position value |
| `sectionBackgroundImageSize__c` | Text | None | CSS background-size value |

#### Accordion Styles
| Field | Type | Default | Description |
|---|---|---|---|
| `accordionBackgroundColor__c` | Text (7) | #939393 | Background color for accordion headers |
| `accordionFontColor__c` | Text (7) | None | Font color for accordion headers |

#### Border & Spacing
| Field | Type | Description |
|---|---|---|
| `borderColor__c` | Text (7) | Border color |
| `borderRadius__c` | Text (7) | Border radius (e.g., "8px") |
| `borderSize__c` | Text (7) | Border width (e.g., "1px") |

#### Prompt Styles
| Field | Type | Description |
|---|---|---|
| `promptColor__c` | Text (7) | Background color for help prompts |
| `promptFontColor__c` | Text (7) | Font color for help prompts |

#### Administrative
| Field | Type | Description |
|---|---|---|
| `Description__c` | Text (255) | Admin description |
| `Delete__c` | Checkbox | Soft delete marker |
| `PreventDelete__c` | Checkbox | Prevent deletion (developer-controlled) |

### How to Apply a Theme

1. **On a Form**: In Form Builder, assign the theme to the Form record (Form__mdt.Theme__c)
2. **On a Section**: Override the form-level theme on individual sections (Form_Section__mdt.Theme__c)
3. **At Runtime**: Use the `themeOverrideName` property on Flow Form, Data Table, or Header to dynamically apply a theme
4. **In the Header**: Use `themeOverrideId` on the Header component

### Theme Inheritance
- Section-level themes override form-level themes
- Runtime `themeOverrideName` overrides the form's metadata-assigned theme
- Properties not set on a theme fall back to defaults

## Labels (Form_Label__mdt)

### What Labels Provide

Labels are reusable text strings that support translation. Instead of hardcoding field labels, help text, or section titles, reference a Form Label record. When the user's language changes, the label automatically displays the appropriate translation.

### Label Properties

| Field | Type | Default | Description |
|---|---|---|---|
| `Value__c` | LongTextArea (131072) | None | The default label text |
| `Group__c` | Text (255) | Global | Organizational grouping |
| `Tag__c` | Text (255) | None | Tag for categorization |
| `isRichText__c` | Checkbox | false | Whether the value contains HTML rich text |

### Label Translations (Form_Label_Translation__mdt)

| Field | Type | Required | Description |
|---|---|---|---|
| `Form_Label__c` | Form_Label__mdt | Yes | Parent label |
| `Language__c` | Picklist | Yes | ISO language code (87 supported languages) |
| `Value__c` | LongTextArea (131072) | No | Translated text |
| `isRichText__c` | Checkbox | No | Whether translated value contains rich text |

### How to Use Labels

1. **Create a Label**: Add a `Form_Label__mdt` record with the default language text
2. **Add Translations**: Create `Form_Label_Translation__mdt` records for each language
3. **Reference in Forms**: In Form Builder, assign labels to field labels, help text, placeholders, and section titles
4. **Language Selection**: Use the `languageOverride` property on Flow Form, or allow guest users to select their language in Experience Cloud

### Supported Languages
Form Labels support 87 language codes, including all major Salesforce-supported languages and regional variants (e.g., `en_US`, `fr_FR`, `es_MX`, `zh_CN`, `ar`, `ja`, `ko`).

## Per-Template Style Sheets (Form Template)

### What Per-Template Style Sheets Do

A Form Template can carry its own CSS style sheet, applied to **that template only**, with automatic isolation. The template's record Id is injected as a CSS class on its container, and every selector in the sheet is automatically prefixed with it at load time, so the CSS cannot affect other forms, other templates, or the surrounding page. `:root` selectors map to the template container itself, the right place for CSS custom properties.

### How to Assign One

1. **Create a Static Resource**: a single `text/css` file, or a zip containing `.css` files
2. Open the **Form Template record page** → **Form Theme & Stylesheet** tab
3. Pick the sheet with the **Style Sheet Selector**; options are grouped by namespace (or Local) and then by zip file, with each resource's Description shown beneath its name
4. The reference is stored in `Form_Template__c.Style_Sheet__c` as `ResourceName` (or `Namespace__ResourceName`, or `.../path/inside.css` for zip entries)

### Behavior Notes

- The CSS text is read server-side and injected by the form: no cross-origin fetches, nothing added to `document.head`
- **`@import` is not supported**: a sheet containing one is skipped entirely (fail-safe) rather than loaded unscoped
- Clearing the Style Sheet field removes the injected styles on the next load
- Content is cached (Platform Cache); after editing a resource's body, allow a few minutes or rename the resource
- Loads **in addition to** themes and org-wide style sheets; use it for template-specific branding on top of your standard theme

## Style Sheets (Form_Style_Sheet__mdt)

### What Style Sheets Do

Style Sheets load custom CSS from a Static Resource to override default form styling **globally, for every form in the org**. This is the most powerful (and most advanced) customization option: it gives you full CSS control over form elements. For styling a single template, prefer a [Per-Template Style Sheet](#per-template-style-sheets-form-template).

### Style Sheet Properties

| Field | Type | Description |
|---|---|---|
| `StaticResourceName__c` | Text (255) | API name of the Static Resource containing CSS |
| `Path__c` | Text (255) | Path to the CSS file within the resource. For a zip file: `ResourceName/folder/file.css`. For a single file: just the resource name |
| `NamespacePrefix__c` | Text (255) | Namespace prefix if the Static Resource is in a managed package |

### How to Use Style Sheets

1. **Create a Static Resource**: Upload a CSS file (or zip with CSS files) as a Static Resource
2. **Create a Style Sheet Record**: Add a `Form_Style_Sheet__mdt` record referencing your Static Resource
3. **The CSS loads globally**: Style Sheet CSS applies to all forms in the org (it's loaded via `loadStyle`)

### CSS Specificity Notes
- Style Sheet CSS loads at the global level (same cascade as Experience Cloud themes)
- To override internal SLDS elements, you may need `!important`
- Component-scoped CSS (in the LWC `.css` file) has higher specificity than Style Sheet CSS due to LWC scoping attributes

## Common Patterns

### 1. Branded Form
Create a theme with your company's brand color, heading background, and font colors. Assign it to your forms in Form Builder. All forms using that theme maintain consistent branding.

### 2. Multilingual Survey
Create Form Labels for all user-facing text. Add translations for each target language. Use `languageOverride` in your Flow to render the form in the user's preferred language. In Experience Cloud, use the `guestLanguage` output to detect auto-selected language.

### 3. Dark Theme Accordion
Create a theme with dark `accordionBackgroundColor__c` and light `accordionFontColor__c`. Apply to forms that use accordion layout for a polished dark-mode experience.

## Tips & Considerations

- **Color Format**: Theme color fields accept 7-character values. Use HEX format (e.g., `#FF5733`). RGB and RGBA are also supported.
- **Background Images**: Theme image fields accept URLs. Use content assets, static resources, or external URLs. Pair with `position` and `size` fields for proper placement.
- **Label Caching**: Labels are cached in Platform Cache (FlowToolKit.FormComponents partition) for performance. Changes may take a moment to reflect.
- **Style Sheet Scope**: Form_Style_Sheet__mdt CSS is global; it affects all forms in the org, not just specific forms. Use specific selectors (under `.flowForm`, or under a template's injected Id class) to target only the elements you want to change.
- **Theme vs Style Sheet**: Use themes for standard color/background customization. Use a Per-Template Style Sheet when one template needs CSS-level control. Use org-wide Style Sheets only for CSS conventions that should apply everywhere (custom animations, complex layout changes, etc.). See the [Custom Styling Overview](custom-styling-overview.md) for the full decision guide.
