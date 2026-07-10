# Custom Styling Overview

> One page to understand every way Flow Tool Kit forms can be styled — and which option to reach for first.

## The Styling Ladder

Flow Tool Kit offers three levels of visual customization. Start at the top; only move down when the level above can't express what you need.

| Level            | Feature                                                                                                                          | CSS required? | Scope                              | Reach for it when...                                                                                                     |
| ---------------- | -------------------------------------------------------------------------------------------------------------------------------- | ------------- | ---------------------------------- | ------------------------------------------------------------------------------------------------------------------------ |
| **1 — Basic**    | [Themes](themes-labels-styling.md#themes-form_theme__mdt) (`Form_Theme__mdt`)                                                    | No            | Form, section, or runtime override | You need brand colors, backgrounds, borders, label color/size, accordion styling                                         |
| **2 — Targeted** | [Per-Template Style Sheet](themes-labels-styling.md#per-template-style-sheets-form-template) (`Form_Template__c.Style_Sheet__c`) | Yes           | **One Form Template only**         | One template needs its own look — CSS is automatically isolated so it can never affect other forms or the page around it |
| **3 — Advanced** | [Org-Wide Style Sheets](themes-labels-styling.md#style-sheets-form_style_sheet__mdt) (`Form_Style_Sheet__mdt`)                   | Yes           | **Every form in the org**          | You're establishing global CSS conventions across all forms (e.g., an Experience Cloud brand layer)                      |

{% hint style="info" %}
Themes and style sheets **combine** — a template can use a theme for colors _and_ a per-template style sheet for the details the theme doesn't cover. Style sheet rules load after theme styles.
{% endhint %}

## Key Concepts

### The `.flowForm` wrapper

Every rendered form is wrapped in a stable `.flowForm` CSS class — it is the supported scope root for all custom CSS. Writing rules under `.flowForm` keeps them targeting form UI only:

```css
.flowForm .slds-input {
    border-radius: 0.5rem;
}
```

Additional stable class hooks inside the wrapper:

| Class                         | What it wraps                                   |
| ----------------------------- | ----------------------------------------------- |
| `.flowForm-field`             | Each rendered field (label + input + help text) |
| `.flow-form-help-below-label` | Help text displayed below a field label         |
| `.attestation-card`           | The attestation checkbox card                   |
| `.flow-form-docked-buttons`   | The docked navigation button footer             |
| `.form-vertical-indicator`    | The vertical stage indicator panel              |
| `.form-template-container`    | The outer Form Template container               |

### Automatic Form Template wrapper injection

When a Form Template renders, its **record Id is automatically injected as a CSS class** on the template's outer container. This is what powers per-template isolation: a per-template style sheet has every selector automatically prefixed with that class at load time, so:

* `body { background: pink; }` becomes `.a0C... body` — neutralized, it can never restyle the page.
* `:root { --brand: green; }` maps to the **template container itself** — the right place for CSS variables and container styling.
* Two templates on the same page each get only their own styles.

You can also target the injected class from an org-wide style sheet or Experience Cloud CSS to hand-scope rules to one template.

### Starting point: the override template

The packaged static resource **`Flow_Form_Style_Override_Template`** is a worked example of supported selectors and CSS custom properties (`--brand-color`, `--radio-size`, `--button-radius`, `--labelSize`, `--labelWeight`, and more). Copy it into your own static resource and edit from there.

### Rules of the road

* **No `@import`** in a per-template style sheet — the whole sheet is skipped (fail-safe) rather than loaded unscoped.
* **Zip or single file** — a style sheet static resource can be a single `text/css` file or a `.css` file inside a zip; the selector lists both.
* **Caching** — style sheet content is cached for performance. After editing a resource's body, allow a few minutes (or rename the resource) before expecting the change at runtime.
* **Org-wide sheets are global** — scope selectors carefully (under `.flowForm`, or under a template's injected Id class).

## Demo

Assigning a per-template style sheet from the Form Template record page:

![Per-template style sheet selector](../.gitbook/assets/221-style-sheet-selector-demo.gif)

## Related Pages

* [Themes, Labels & Styling Reference](themes-labels-styling.md) — every theme field, label setting, and style sheet property
* [How To: Configure Themes and Styling](../how-to-guides/configure-themes-and-styling.md) — step-by-step setup
