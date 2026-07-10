# Configure Themes And Styling

> Customize the visual appearance of your forms with themes, colors, and labels.

{% hint style="info" %}
**Prerequisites**: A form created in Form Builder. See [Build a Form](build-a-form.md).
{% endhint %}

## Video Walkthrough

{% embed url="https://vimeo.com/755158586" %}

## Overview

![Form translation toggle](../.gitbook/assets/form-translation-toggle.png)

Flow Tool Kit forms are styled through **Themes** — reusable styling configurations stored as Custom Metadata. You can change colors, fonts, spacing, and other visual properties without modifying code. You can also override field labels and add translations.

## Step 1: Create a Theme

1. Open **Form Builder**.
2. Navigate to the **Themes** section.
3. Click **New Theme**.
4. Configure the visual properties:

| Property                 | Description               | Example                                   |
| ------------------------ | ------------------------- | ----------------------------------------- |
| **Name**                 | Theme identifier          | "Corporate Blue"                          |
| **Primary Color**        | Main accent color         | `#0070D2`                                 |
| **Background Color**     | Form background           | `#FFFFFF`                                 |
| **Border Color**         | Field and section borders | `#DDDBDA`                                 |
| **Font Family**          | Text font                 | Salesforce Sans, Arial                    |
| **Font Size**            | Base text size            | `14px`                                    |
| **Section Header Style** | How section headers look  | Background color, text color, font weight |

5. Save the theme.

## Step 2: Apply the Theme to a Form

### In Form Builder

1. Open your form in Form Builder.
2. In the form settings, select your theme from the **Theme** dropdown.
3. Preview the changes in real-time.
4. Save.

### At Runtime (Override)

You can also override the theme at runtime via the Flow Form component:

* Set the `themeOverrideName` property to the theme's QualifiedApiName
* This lets you use the same form with different themes in different contexts

## Step 3: Customize Labels

Labels let you override field text without changing the underlying Salesforce field labels:

1. In Form Builder, navigate to **Labels**.
2. Create label overrides for specific fields:

| Setting          | Description                                             |
| ---------------- | ------------------------------------------------------- |
| **Field**        | The field to override                                   |
| **Custom Label** | The text to display instead of the default label        |
| **Language**     | Language code for translations (e.g., `en`, `es`, `fr`) |

3. Assign the label set to your form.

## Multilingual Forms

To support multiple languages:

1. Create label sets for each language.
2. On the Flow Form component, set the `languageOverride` property to the desired ISO language code.
3. The form renders with labels in that language.

{% hint style="info" %}
**Tip**: Use Flow logic to detect the user's language preference and pass it to `languageOverride` dynamically.
{% endhint %}

## Step 4: Style a Single Form Template with CSS (Optional)

When one Form Template needs styling beyond what its theme offers, assign it a CSS style sheet — automatically scoped so it can't affect any other form or the page around it:

1. Upload your CSS as a **Static Resource** (a single `text/css` file, or a `.css` file inside a zip).
2. Open the **Form Template record page** → **Form Theme & Stylesheet** tab.
3. Choose the sheet with the **Style Sheet Selector** — options are grouped by namespace/Local and zip file, with resource descriptions shown inline.
4. Preview the template — the styles apply to this template only.

![Assigning a per-template style sheet](../.gitbook/assets/221-style-sheet-selector-demo.gif)

{% hint style="info" %}
**Tip**: Start from the packaged `Flow_Form_Style_Override_Template` static resource — it demonstrates the supported selectors and CSS variables. Don't use `@import` (sheets containing it are skipped), and write `:root { ... }` to style the template container itself. See the [Custom Styling Overview](../form-configuration/custom-styling-overview.md) for how all the styling options fit together.
{% endhint %}

## Theme Best Practices

* **Create a "brand" theme** that matches your organization's visual identity — use it as the default
* **Keep it simple** — subtle color changes and consistent fonts are more professional than dramatic styling
* **Test with data** — themes look different with real data versus empty fields
* **Accessibility** — ensure sufficient contrast between text and background colors (WCAG AA minimum)
* **One theme, many forms** — create a small number of reusable themes rather than a custom theme per form

## Related Pages

* [Custom Styling Overview](../form-configuration/custom-styling-overview.md) — which styling option to use when, and how scoping works
* [Themes, Labels & Styling Reference](../form-configuration/themes-labels-styling.md) — all theme properties and configuration
* [Build a Form](build-a-form.md) — creating forms
* [Form Builder Reference](../screen-components/form-builder.md) — full editor documentation
