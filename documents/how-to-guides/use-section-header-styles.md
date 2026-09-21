# Use Section Header Styles

> Choose how a section's header looks. Outlined draws a border round the whole section with the title sitting on the top line.

{% hint style="info" %}
**Prerequisites**: A form built in the **Form Builder** with a section whose header is shown as **Header**. The border color, width and corner radius come from the form's **Form Theme**, so assign a theme to see your brand applied.
{% endhint %}

## What It's For

A section header names a group of questions. **Classic** is the standard header: a title, an optional subtitle and icon, and a line under the title. **Outlined** turns the section into a labelled box, the way paper forms and many older online forms group their questions: a border runs all the way round the section and the title sits on the top line, with the line cleared behind it.

![Three Outlined sections in the Form Builder preview](https://raw.githubusercontent.com/common-unite/cUnite_FormBuilder/master/documents/screenshots/690-outlined-section-header.png)

## Choose a Header Style

1. In the **Form Builder**, open the section's editor.
2. On the **Content** tab, set **Section Header** to **Header**.
3. Choose **Header Style**: **Classic** or **Outlined**.
4. Enter the **Section Title** and, if you like, a **Section Subtitle**.

The preview updates as soon as you change the style. A section with no Header Style set uses Classic, so existing sections look the same as before.

## How Outlined Looks

| Part | Where it comes from |
| --- | --- |
| Border color | The theme's **Border Color** |
| Border width | The theme's **Border Size** (1px when blank or 0) |
| Corner radius | The theme's **Border Radius** |
| Title | Sits on the top border, lined up with the first field |
| Subtitle and help text | Inside the box, just under the top border |
| Section background | Fills the inside of the box only |

Outlined sections never show an icon, so the icon picker is hidden while Outlined is selected. When there is no subtitle, the title is a little larger.

## Tips

- Outlined applies only when the header is shown as **Header**. Divider, Accordion and Hide ignore it.
- Mixing Classic and Outlined in one form works; each section draws its own header.
- To make the border more prominent, raise **Border Size** on the Form Theme.
