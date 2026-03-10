# Header
> A configurable header component that displays titles, subtitles, icons, rich text, and optional custom buttons across Flow Screens, App Pages, Record Pages, and Experience Cloud.

## Overview

Form (Header) provides a consistent, themeable header for your Flow screens and Lightning pages. It displays a title, subtitle, help text, icon, and optional rich text content — all styled by the Flow Tool Kit theme system. It can also host custom buttons, making it a dual-purpose navigation and display component.

Header is one of the most versatile Flow Tool Kit components because it works everywhere: Flow Screens, App Pages, Record Pages, Home Pages, and Experience Cloud pages. Use it to add branded section headers, informational banners, or navigational buttons to any page.

## Where to Use It

- **Flow Screen** (with full button support)
- **App Page**
- **Record Page**
- **Home Page**
- **Experience Cloud** (Community Page and Default)

## Video Walkthrough

{% embed url="https://vimeo.com/732573675" %}

## Quick Start

1. **Add to Screen** — Drag "Form (Header)" onto a Flow Screen or Lightning page.
2. **Set Title** — Enter a title (e.g., "Contact Information").
3. **Add an Icon** — Set an SLDS icon name (e.g., "standard:contact") for a visual anchor.
4. **Optional: Theme** — Assign a Form Theme for custom colors and styling.
5. **Optional: Buttons** — On Flow Screens, add custom buttons to the header for inline navigation.

## Properties

### Inputs (Flow Screen)

| Property | Type | Required | Default | Description |
|---|---|---|---|---|
| `title` | String | No | — | Header title text |
| `subtitle` | String | No | — | Subtitle text displayed below the title |
| `helpText` | String | No | — | Help text content |
| `iconName` | String | No | — | SLDS icon name (e.g., "standard:account", "utility:info") |
| `richText` | String | No | — | Rich text HTML content displayed in the header area |
| `showHeader` | Boolean | No | true | Show or hide the header |
| `topMargin` | String | No | — | SLDS margin class for top spacing |
| `themeOverrideId` | String | No | — | QualifiedApiName of a Form Theme metadata record |
| `buttons` | Button[] (Apex-Defined) | No | — | Collection of custom buttons to display in the header |
| `groupButtons` | Boolean | No | false | Group buttons together without spacing |
| `numberOfButtonsToShow` | Integer | No | 3 | Buttons visible before overflow menu |

### Inputs (App/Record/Home Page)

| Property | Type | Required | Default | Description |
|---|---|---|---|---|
| `title` | String | No | — | Header title text |
| `subtitle` | String | No | — | Subtitle text |
| `iconName` | String | No | — | SLDS icon name |
| `richText` | String | No | — | Rich text HTML content |
| `topMargin` | String | No | — | Top margin (dropdown: none through xx-large) |
| `themeOverrideId` | String | No | — | Theme Override QualifiedApiName |

### Outputs (Flow Screen only)

| Property | Type | Description |
|---|---|---|
| `buttonClicked` | Button (Apex-Defined) | The Button object that was clicked |

## How It Works

**Theme Integration**: Header uses the Form Theme system to apply consistent styling. Assign a theme via `themeOverrideId` to control colors, fonts, and spacing. The same theme can be shared across Header, Flow Form, and Data Table for visual consistency.

**Button Hosting**: On Flow Screens, the header can display custom buttons alongside the title. These buttons communicate via the FlowButton message channel, just like the standalone Custom Buttons component. The `buttonClicked` output returns the clicked button for Flow routing.

**Rich Text**: The `richText` property accepts HTML content, allowing you to display formatted text, links, or embedded content in the header area. This is useful for instructions, disclaimers, or dynamic content driven by Flow variables.

## Works With

| Component | Integration |
|---|---|
| **Flow Form** | Share the same theme for consistent styling; header sits above the form |
| **Custom Buttons** | Header can host buttons with the same Button[] collection |
| **Themes** | Styled by Form Theme metadata |
| **Data Table** | Visual pairing — header above, table below |

## Common Patterns

### 1. Branded Section Header
Add Header to a Flow Screen with title "Step 2: Employment Details", subtitle "Please provide your current employer information", and icon "standard:opportunity". Assign your company's theme.

### 2. Information Banner
Set `richText` to HTML content with important notices or instructions. Hide the title/subtitle and use only rich text for a clean banner display.

### 3. Header with Action Buttons
On a Flow Screen, pass a Button[] collection to the header to display "Save", "Cancel", and "Help" buttons alongside the title. Use `buttonClicked` output to route the flow.

## Tips & Considerations

- **SLDS Icons**: Use the Lightning Design System icon reference to find valid icon names. Format is `category:name` (e.g., "standard:account", "utility:settings", "action:new_task").
- **Theme Consistency**: For a polished look, use the same `themeOverrideId` on your Header, Flow Form, and Data Table components.
- **Experience Cloud**: Header works in Experience Cloud with RelaxedCSP capability. Themes apply the same way as in Lightning.
- **Top Margin**: Use SLDS margin classes to control spacing between the header and the component above it. Common values: `slds-m-top_none`, `slds-m-top_small`, `slds-m-top_medium`, `slds-m-top_large`.
- **Multiple Headers**: You can use multiple Header components on the same screen to create visual sections between groups of components.
