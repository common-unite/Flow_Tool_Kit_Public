# Section Frame and Header

> Choose the box around a section first, then how its header sits in or on that box.

{% hint style="info" %}
**Prerequisites**: A form built in the **Form Builder**. Border color, width and corner radius come from the form's **Form Theme**, so assign a theme to see your brand applied.
{% endhint %}

## What It's For

Every section has two appearance choices, and they are edited together at the top of the section's **Content** tab:

- **Section Frame**: whether the section has a box around it.
- **Section Header**: how the section's title is shown, and for a header, where the title sits relative to the frame.

![The Section Frame and Section Header groups on the Content tab](https://raw.githubusercontent.com/common-unite/Flow_Tool_Kit_Public/main/documents/screenshots/694-section-frame-editor.png)

## Choose a Frame

1. In the **Form Builder**, open the section's editor.
2. On the **Content** tab, under **Section Frame**, choose a **Frame**:

| Frame | What it draws |
| --- | --- |
| **None** | No border. The section sits directly on the form. |
| **Box** | A border around the section. |
| **Shadow** | A border around the section with a drop shadow. |

**Visual picker**, the toggle in the Section Frame heading, makes the section selectable inside a repeater. It replaces the frame, so the Frame choice is disabled while it is on.

## Choose a Header

Under **Section Header**, choose how the title is shown: **Header**, **Divider**, **Accordion** or **Hide**. For **Header**, choose a **Header Style**:

| Header Style | Where the title sits | Works with frame |
| --- | --- | --- |
| **Classic** | Above the section content. With a frame, the header rides on top of the box | Any |
| **Classic Spread** | Title on the left, icon on the far right edge of the section | Any |
| **Card** | A title band across the top inside the box, filled with the theme's **Heading Background Color** | Box or Shadow |
| **Title on border** | On the frame's top border line, with the line cleared behind it | Box or Shadow |
| **Stacked** | A display header above the content: eyebrow, pretitle, large title, body, tags and footer, one under the other | Any |

Card and Title on border are offered only when the frame is **Box** or **Shadow**. If you change the frame to **None**, the header goes back to **Classic**. Divider, Accordion and Hide ignore Header Style.

### Where the icon goes

Each style puts the section icon in a different place, and each lines up with something the reader can already see:

- **Classic**: on the section's edge, which is the frame's border when there is a frame and the start of the header rule when there is not. The title follows the icon. With no icon the title sits on the first field label.
- **Classic Spread**: at the far right, its edge on the same line the fields end on. The title stays on the first field label.
- **Card**: before the title inside the band.
- **Title on border**: riding the top border at the right, in the theme's icon color, on the same line the fields end on.
- **Stacked**: in the eyebrow row, before the eyebrow text and at its size.

![A Title on border section with a Shadow frame](https://raw.githubusercontent.com/common-unite/Flow_Tool_Kit_Public/main/documents/screenshots/694-title-on-border-shadow.png)

## Stacked Header

Stacked turns a section's header into a display header: the kind you see at the top of a landing page or an application step. Use it to open a form, a page, or an important step, where a plain title is not enough.

![A Stacked header with every part filled in](https://raw.githubusercontent.com/common-unite/Flow_Tool_Kit_Public/main/documents/screenshots/720-stacked-header.png)

### The parts

Choose **Stacked** as the Header Style, and these fields appear under it. Every part is optional except the title, and each shows only when it has a value.

| Field | What it shows |
| --- | --- |
| **Eyebrow** | A short label above everything else, in small capitals, with the section icon in front of it |
| **Pretitle** | A short line between the eyebrow and the title, such as a program name or `Step {{$Page.Number}} of {{$Page.Count}}` |
| **Section Title** | The large display title |
| **Body** | A paragraph under the title that says what the section is for |
| **Tags** | Short labels drawn as pills. Separate them with semicolons: `About 5 minutes; Save and resume` |
| **Tags Position** | Where the tags go: **Below body** (the default), **Above eyebrow**, **Above pretitle** or **Above title** |
| **Footer** | A closing line, always last, such as who to contact with questions |
| **Header Bottom Margin** | The space between the header and the section's content |

![Stacked selected in the Form Builder, with the live preview](https://raw.githubusercontent.com/common-unite/Flow_Tool_Kit_Public/main/documents/screenshots/720-stacked-header-form-builder.png)

Every text part is rich text and accepts merge fields, including the page and template fields described in [Template, Page and Section Merge Fields](../form-template-framework/template-page-section-merge-fields.md). The inputs show as a single line until you click into one; then the full rich text editor opens.

![Switching a section to Stacked and filling it in](https://raw.githubusercontent.com/common-unite/Flow_Tool_Kit_Public/main/documents/screenshots/720-stacked-header-demo.gif)

### Spacing and colors

- Every line of the stack sits the same distance apart. Only the title and the body sit closer, because they read as a pair.
- The header adds no space of its own above or below. The section's top margin sets the space above it, and **Header Bottom Margin** sets the space below.
- The title uses the theme's title color and the eyebrow its subtitle color. The tag outlines and fill use the theme's **Brand Color**, or the org's brand color when the theme sets none.

For a site or theme that needs different spacing or sizes, these CSS custom properties override the defaults: `--ftk-hero-line-gap` (1rem between lines), `--ftk-hero-lead-gap` (0.5rem between title and body), `--ftk-hero-title-size`, `--ftk-hero-lead-size`, `--ftk-hero-eyebrow-size` and `--ftk-hero-title-font`.

## Form Template Page Sections

Page sections on a Form Template have the same Frame and Header Style.

1. Open the page section and click **Customize**.
2. Under **Content**, choose **Frame**, the first item.
3. Pick a **Frame** and, when the section's header is shown as Header, a **Header Style**.

The same rules apply: Card and Title on border need Box or Shadow, and Frame None resets them to Classic. Stacked works with any frame; its fields are in the **Header** panel of the Customize window. With Box or Shadow, the frame wraps the whole page section: its header, intro text and the form, table, flow or component inside. With Title on border, the frame draws the page section's title and subtitle, so the form inside doesn't show a second title. The header's rich text appears at the top inside the frame.

![The Frame panel in the page section Customize window](https://raw.githubusercontent.com/common-unite/Flow_Tool_Kit_Public/main/documents/screenshots/694-page-section-frame-panel.png)

## How Title on Border Looks

| Part | Where it comes from |
| --- | --- |
| Border color | The theme's **Border Color** |
| Border width | The theme's **Border Size** (1px when blank or 0) |
| Corner radius | The theme's **Border Radius** |
| Title | Sits on the top border, lined up with the first field |
| Subtitle and help text | Inside the box, just under the top border |
| Section background | Fills the inside of the box only |
| Icon | Rides the top border at the right, in the theme's icon color |

When there is no subtitle, the title is a little larger. The icon appears only if the section has one.

## Stored Values

For data loads, Flows, and orgs on Flow Tool Kit 4.38 to 4.40, where the builder shows these as separate settings:

| In the builder | Field | Value |
| --- | --- | --- |
| Frame: None | Section Class (`sectionTheme__c`) | `clean` or blank |
| Frame: Box | Section Class | `box` |
| Frame: Shadow | Section Class | `shadow` |
| Visual picker | Section Class | `visualPicker` |
| Header Style: Classic | Header Style (`Header_Style__c`) | `classic` or blank |
| Header Style: Classic Spread | Header Style | `classicSpread` |
| Header Style: Card | Header Style | `card` |
| Header Style: Title on border | Header Style | `outlined` |
| Header Style: Stacked | Header Style | `hero` |
| Pretitle | Header Kicker (`Header_Kicker__c`) | rich text |
| Body | Header Lead (`Header_Lead__c`) | rich text |
| Tags | Header Tags (`Header_Tags__c`) | text, semicolon separated |
| Tags Position | Header Tags Position (`Header_Tags_Position__c`) | `belowLead` (blank), `aboveEyebrow`, `aboveKicker`, `aboveTitle` |
| Footer | Header Footer (`Header_Footer__c`) | rich text |
| Header Bottom Margin | Header Bottom Margin (`Header_Bottom_Margin__c`) | an SLDS margin class such as `slds-m-bottom_medium` |

On a Form Template Page Section, the frame is stored in **Section Frame** (`Section_Frame__c`: `clean`, `box` or `shadow`) and the header style in **Header Style** (`Header_Style__c`). Blank means None and Classic, so existing page sections are unchanged.

A section saved in 4.38 to 4.40 with **Outlined** and no frame still draws Title on border and still shows it in the builder. The builder only changes it when you change the frame.

## Tips

- Frame one level only. A framed page section around a form whose own sections are framed looks like a box within a box.
- Mixing header styles in one form works; each section draws its own header.
- Use Stacked once per page, at the top. Several display headers in a row compete with each other.
- Keep the eyebrow and pretitle to a few words; the title carries the message.
- Classic Spread reads best when the section is wide. On a narrow screen the icon still goes to the right edge, which can leave a long gap after a short title.
- To make the border more prominent, raise **Border Size** on the Form Theme.
