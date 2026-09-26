# Use Rich Text Message Cards

> Turn any Rich Text section into a themed status card (info, warning, error, or success) with a colored left edge, a tinted fill, and a status icon, or set it apart with a Highlight rule.

{% hint style="info" %}
**Prerequisites**: A form built in the **Form Builder** with a **Rich Text** section.
{% endhint %}

## What It's For

A Rich Text section normally renders as plain text. With a **Message Variant**, the same section becomes a designed **message card**, useful for validation summaries, callouts, tips, or confirmations. The card's color, left accent edge, and icon are driven entirely by Lightning Design System status tokens, so it matches your org's branding across internal Lightning and Experience Cloud (LWR and Aura) sites.

![Choosing a Message Variant and the card rendering live in the preview](../.gitbook/assets/148-message-variant-card-demo.gif)

## The Variants

| Variant     | Renders as                     |
| ----------- | ------------------------------ |
| **Default** | Plain rich text (no card)      |
| **Info**    | Blue card with an info icon    |
| **Warning** | Amber card with a warning icon |
| **Error**   | Red card with an error icon    |
| **Success** | Green card with a success icon |
| **Highlight** | A brand-colored rule down the left edge, no card, fill or icon |

## Step 1: Add a Rich Text Section

In the Form Builder, use the **Insert New Section** menu (＋) on any section and choose **Rich Text** under _Formatting_.

## Step 2: Pick a Message Variant

Expand the **Section Rich/Plain Text** panel and choose a **Message Variant**. Leave it on **Default** to keep the content as plain rich text.

## Step 3: Write the Message

Use the rich text editor to write your message. A bold first line reads as the card's heading, followed by the body. The text supports rich formatting and resolves merge fields (e.g. `{{FlowToolKit__Contact1_First_Name__c}}`), just like a header.

**Example (Info):**

> **Before you continue** You can save and resume this form anytime. We'll email you a secure link to pick up right where you left off. Fields marked with an asterisk (\*) are required.

![The Info variant rendered on a form](../.gitbook/assets/148-message-variant-info-card.png)

## Highlight

**Highlight** sets a passage apart without making it look like a status message. It draws a single rule in your brand color down the left edge of the text, with no box, fill or icon, so it reads as part of the form rather than as an alert. Use it for a policy, a deadline or a note the reader should not skip, where Info would suggest something is wrong.

![A Highlight passage inside a framed section](https://raw.githubusercontent.com/common-unite/cUnite_FormBuilder/master/documents/screenshots/719-highlight-block.png)

The rule sits on the same edge as the fields, so the text lines up with the inputs below it.

![Choosing Highlight in the Form Builder](https://raw.githubusercontent.com/common-unite/cUnite_FormBuilder/master/documents/screenshots/719-highlight-block-demo.gif)

**Form Template page sections** have the same choice. In the page section's **Customize** window, a **Display Text** section's **Message Variant** includes Highlight, and so does **Header Text Variant**, which styles the text shown with a section's header.

## Theming

The card takes its accent color from your org's SLDS status tokens: no per-card color settings. Highlight's rule takes the org's or site's brand color (`--lwc-brandPrimary`). Each variant maps to a standard status color (info/warning/error/success), and when a token isn't present in a given runtime it falls back through the Experience Cloud (`--dxp-*`) and Lightning (`--lwc-*`) tokens to a sensible default, so the card looks right everywhere it renders.

{% hint style="success" %}
Because the colors are token-driven, the card automatically matches a branded Experience Cloud site's status palette.
{% endhint %}
