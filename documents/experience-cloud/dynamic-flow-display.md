# Dynamic Flow Display
> Embed any Flow as a component, modal, or button on Experience Cloud pages, App Pages, Record Pages, and Home Pages — with full property passing and display control.

## Overview

Form (Dynamic Flow) lets you place any Screen Flow onto a Lightning page as an inline component, a modal dialog, or a clickable button — without building custom components. Point it at a Flow API name, choose a display type, and it renders the flow wherever you need it.

This is especially valuable in Experience Cloud, where you often need to embed flows in community pages with specific display behaviors. Instead of using the standard "Flow" component with limited configuration, Dynamic Flow gives you control over how the flow appears and interacts with the page context.

## Where to Use It

- **App Page**
- **Home Page**
- **Record Page**
- **Experience Cloud** (Community Page and Default — with custom property editor)

## Quick Start

1. **Add to Page** — Drag "Form (Dynamic Flow)" onto your Lightning page in App Builder or Experience Builder.
2. **Set the Flow** — Enter the Flow API Name of the Screen Flow you want to display.
3. **Choose Display Type** — Select `component` (inline), `modal` (dialog), or `button` (click to launch).
4. **Optional: Set Label** — If using `button` or `modal` display type, set a label for the button.
5. **Publish** — Save and activate the page.

## Properties

### Inputs (App/Home Page)

| Property | Type | Required | Default | Description |
|---|---|---|---|---|
| `flowApiName` | String | Yes | — | API Name of the Screen Flow to display |
| `buttonLabel` | String | No | — | Label for the button (used with `button` and `modal` display types) |
| `recordId` | String | No | — | Record Id to pass to the flow (optional on App/Home pages) |
| `displayType` | String | No | component | How to render the flow: `component`, `modal`, or `button` |
| `modalSize` | String | No | large | Modal size when displayType is modal: `small`, `medium`, `large`, or `full` |

### Inputs (Record Page)

| Property | Type | Required | Default | Description |
|---|---|---|---|---|
| `flowApiName` | String | Yes | — | API Name of the Screen Flow |
| `buttonLabel` | String | No | — | Button label text |
| `displayType` | String | No | component | Display type: `component`, `modal`, `button` |
| `modalSize` | String | No | large | Modal size: `small`, `medium`, `large`, `full` |

*Record Id is automatically provided by the page context on Record Pages.*

### Inputs (Experience Cloud)

Experience Cloud uses a custom property editor for configuration. Properties are stored as a JSON string.

| Property | Type | Required | Default | Description |
|---|---|---|---|---|
| `properties` | String | — | — | JSON configuration (managed by the property editor) |
| `recordId` | String | No | {!recordId} | Record Id from the page context |

The property editor provides a visual interface for setting Flow API Name, display type, modal size, and other options.

### Outputs

This component has no Flow outputs (it is not a Flow Screen component — it embeds flows on Lightning pages).

## How It Works

**Display Types**:
- **Component** — The flow renders inline, directly embedded in the page where you placed the component. It behaves like any other page component.
- **Modal** — The flow renders inside a modal dialog. On Record Pages and App Pages, the modal opens automatically when the page loads. In Experience Cloud, behavior can be configured via the property editor.
- **Button** — A button appears on the page. When clicked, the flow opens in a modal. The `buttonLabel` controls the button text.

**Record Context**: On Record Pages, the component automatically passes `recordId` to the flow. On App Pages and Home Pages, you can manually set a `recordId`. In Experience Cloud, `{!recordId}` binds to the page context.

**Modal Sizing**: When using `modal` or `button` display types, `modalSize` controls the dialog width:
- `small` — narrow dialog
- `medium` — standard width
- `large` — wide dialog (default)
- `full` — full viewport width

## Works With

| Component | Integration |
|---|---|
| **Any Screen Flow** | Embeds any Screen Flow — not limited to Flow Tool Kit flows |
| **Experience Cloud** | Custom property editor for community page configuration |
| **Record Pages** | Automatic record context passing |

## Common Patterns

### 1. Inline Flow on Record Page
Place Dynamic Flow on an Account record page with `displayType=component`. Set `flowApiName` to your "Quick Edit Account" flow. The flow renders inline with the record Id automatically passed.

### 2. Button-Triggered Modal
On an Experience Cloud page, set `displayType=button` with `buttonLabel="Submit Request"`. Users click the button and a modal opens with your intake flow. Set `modalSize=large` for forms with many fields.

### 3. Auto-Opening Modal
On a Record Page, set `displayType=modal` with `modalSize=medium`. When users navigate to the record, the flow immediately opens in a modal. Useful for guided record setup or required data collection.

## Tips & Considerations

- **Flow API Name**: Use the Flow's API Name, not its label. Find this in Setup > Flows.
- **Not a Flow Screen Component**: Dynamic Flow is a Lightning page component, not a Flow Screen component. You place it on pages in App Builder / Experience Builder, not inside other flows.
- **Experience Cloud Property Editor**: In Experience Cloud, the property editor serializes all configuration as JSON. This enables richer configuration options than standard Lightning page properties allow.
- **Flow Inputs**: The component automatically passes `recordId` to the flow. If your flow needs additional inputs, consider using the Experience Cloud property editor's configuration options.
- **Versioning**: The component runs the active version of the specified flow. Activating a new version immediately updates what users see.
- **Performance**: Inline flows (`component` display type) load when the page loads. For heavy flows, consider `button` display type so users only load the flow when they need it.
