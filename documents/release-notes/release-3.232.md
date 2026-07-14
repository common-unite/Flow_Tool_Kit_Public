# Flow Tool Kit v3.232 Release Notes

## New Features

### Section Divider Styles

A Divider section used to render a single plain line. Now it offers a **Divider Style** picker with 12 designed, theme-driven styles (labeled rules, a brand bookmark, a centered icon chip, ornamental dots, a gradient fade, and more) so you can break a form into segments that actually look like section headings.

![Choosing a divider style in the Form Builder](https://raw.githubusercontent.com/common-unite/Flow_Tool_Kit_Public/main/documents/screenshots/147-divider-style-picker-demo.gif)

Every style is drawn from Lightning Design System building blocks and colored entirely from the form's **Form Theme** (border color, border size, brand color, and heading font/icon colors) so dividers match the rest of your form automatically. When a theme leaves a value blank, the divider falls back to the org's own Experience Cloud (LWR and Aura) or internal Lightning brand colors.

![A themed divider rendering on a form](https://raw.githubusercontent.com/common-unite/Flow_Tool_Kit_Public/main/documents/screenshots/147-divider-render-demo.gif)

**What you can do.**

- Choose one of 12 divider styles per Divider section: Simple Line, Compact, Centered Label, Caps Label + Rule, Bookmark, Ornamental Dots, Pill Label, Chevron Flank, Double Rule, Centered Icon, Gradient Fade, and Tag.
- Add a label that supports rich text and resolves merge fields (e.g. `{!Account.Name}`), just like a header.
- Pick an SLDS icon for the icon-bearing styles; leave it blank to show no icon.
- Drive all color and thickness from your Form Theme: change the theme and every divider restyles at once, including the simple line's thickness via Border Size.

### Rich Text Message Cards

A Rich Text section can now render as a themed **status message card** (info, warning, error, or success) instead of plain text. Pick a **Message Variant** in the Form Builder and the section becomes a designed card with a colored left edge, a tinted fill, and a status icon. Perfect for validation summaries, callouts, and confirmations.

![Choosing a Message Variant and the card rendering live in the preview](https://raw.githubusercontent.com/common-unite/Flow_Tool_Kit_Public/main/documents/screenshots/148-message-variant-card-demo.gif)

**What you can do.**

- Set a Rich Text section's **Message Variant** to Info, Warning, Error, or Success, or leave it **Default** for plain rich text.
- Write the message with rich text and merge fields; a bold first line reads as the card heading.
- Colors come from SLDS status tokens and fall back through Experience Cloud (`--dxp-*`) and Lightning (`--lwc-*`) tokens, so the card matches a branded site across LWR, Aura, and internal Lightning.

### Attestation Field Override

Boolean fields gain a new **Attestation** display type: a consent/certification **card** instead of a bare toggle. A checkbox sits beside a rich-text statement inside a brand-themed box, and clicking anywhere on the card checks it. When checked, the card fills with your brand color so the agreement clearly stands out, ideal for consent, certifications, and terms acknowledgements.

![Selecting the Attestation display type in the Form Builder](https://raw.githubusercontent.com/common-unite/Flow_Tool_Kit_Public/main/documents/screenshots/188-attestation-selector-demo.gif)

![A checked attestation card on a branded form](https://raw.githubusercontent.com/common-unite/Flow_Tool_Kit_Public/main/documents/screenshots/188-attestation-selector.png)

**What you can do.**

- Set a boolean field's **Checkbox Display Type** to **Attestation** to render it as a clickable consent card.
- Write the statement in the new **Rich Text Label** field (full rich text, links, and merge fields) instead of a plain label.
- The whole card toggles the value; when checked it fills with your brand color, drawn from Experience Cloud (`--dxp-*`) and Lightning (`--lwc-*`) brand tokens so it matches branded LWR, Aura, and internal Lightning.
- The Form Builder automatically hides the label, help text, prepend/append, and prompt inputs for this type; the rich-text statement is the only content.
