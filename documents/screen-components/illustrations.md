# Illustrations & Display
> Display Salesforce Lightning Design System illustrations on Flow Screens, App Pages, Record Pages, and Experience Cloud — great for empty states, loading screens, and informational pages.

## Overview

Form (Illustration) renders built-in SLDS illustrations on any Lightning surface. These are the same illustrations Salesforce uses for empty states, error pages, and informational displays. Use them to add visual polish to your Flows — whether it's a friendly "all done" screen, a "no records found" state, or a branded welcome page.

The component is intentionally simple: pick an illustration, set a size, and optionally add a title and subtitle. It works everywhere Lightning components are supported.

## Where to Use It

- **Flow Screen**
- **App Page**
- **Record Page**
- **Home Page**
- **Experience Cloud** (Community Page and Default)

## Quick Start

1. **Add to Screen** — Drag "Form (Illustration)" onto your Flow Screen or Lightning page.
2. **Choose an Illustration** — Select from 22 available illustrations (e.g., "Gone Fishing", "Desert", "Setup").
3. **Set the Size** — Choose `small` or `large`.
4. **Add Text** — Optionally set a title and subtitle to display below the illustration.

## Properties

### Inputs

| Property | Type | Required | Default | Description |
|---|---|---|---|---|
| `type` | String | Yes | Base | The illustration to display. See available illustrations below |
| `size` | String | Yes | small | Illustration size: `small` or `large` |
| `title` | String | No | — | Title text displayed below the illustration |
| `subtitle` | String | No | — | Subtitle text displayed below the title |

### Available Illustrations

| Value | Description |
|---|---|
| `Base` | Default illustration |
| `Camping` | Camping scene |
| `Maintenance` | Under maintenance |
| `Desert` | Desert landscape |
| `Road` | Road/journey illustration |
| `No Access` | Access denied |
| `Balloon` | Hot air balloon |
| `Lightning` | Lightning bolt |
| `Axe` | Axe illustration |
| `Not Available` | Content not available |
| `Fishing` | Fishing scene |
| `Mountain` | Mountain landscape |
| `No Events` | No events to show |
| `No Tasks` | No tasks to show |
| `Setup` | Setup/configuration |
| `Gone Fishing` | Gone fishing (popular for "all done" states) |
| `No Access #2` | Alternative access denied |
| `No Content` | No content available |
| `No Preview` | No preview available |
| `Preview` | Preview illustration |
| `Research` | Research/search illustration |
| `Approval` | Approval process illustration |

### Outputs

This component has no outputs.

## How It Works

The component renders a standard SLDS illustration SVG with optional text below it. On App Pages, Record Pages, and Home Pages, the `type` and `size` properties are presented as dropdown picklists. On Flow Screens, they're text inputs where you enter the value directly — enabling dynamic illustration selection via Flow variables.

## Works With

| Component | Integration |
|---|---|
| **Custom Buttons** | Pair with auto-action buttons for timed splash screens |
| **Header** | Stack a header above an illustration for branded pages |

## Common Patterns

### 1. Completion Screen
After a successful form submission, show the "Gone Fishing" illustration with title "All Done!" and subtitle "Your application has been submitted successfully."

### 2. Empty State
On a screen that conditionally shows data, use "No Content" or "Desert" with title "No Records Found" when there's nothing to display.

### 3. Auto-Advancing Splash
Combine a "Lightning" illustration with title "Loading your form..." and a Custom Buttons component with `enable_AutoAction=true` and `autoActionTimeout=3000`. The screen shows for 3 seconds, then auto-advances.

### 4. Error / Access Denied
Use "No Access" with title "You don't have permission to view this page" and subtitle with instructions to contact their administrator.

## Tips & Considerations

- **Dynamic Selection**: On Flow Screens, the illustration `type` is a String input, so you can set it dynamically from a Flow variable or formula. This enables conditional illustrations based on flow context.
- **Size**: `small` works well for inline displays (within a form or page section). `large` is better for full-page states like completion or error screens.
- **Mobile**: Illustrations scale responsively and display well on mobile devices.
- **No Output**: This is a display-only component with no outputs. It's purely visual.
