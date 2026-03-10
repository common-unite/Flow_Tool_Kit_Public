# Stage Indicator

> Display Flow stage progress as a visual path, vertical steps, or base indicator on Flow Screens.

## Overview

Form (Stage Indicator) renders a visual progress indicator that shows users where they are in a multi-step Flow. It integrates with the Flow's native `$Flow.CurrentStage` and `$Flow.ActiveStages` system variables, providing a polished alternative to the built-in progress indicator.

The component supports three display types: a horizontal path (similar to Salesforce Path), vertical steps, and a compact base indicator.

## Where to Use It

- **Flow Screen**

![Stage indicators showing navigation progress](../screenshots/form-template-framework/overview/stage-indicators-navigation.png)

## Properties

### Inputs

| Property | Type | Required | Default | Description |
|---|---|---|---|---|
| `currentStage` | String | Yes | $Flow.CurrentStage | The name of the current active stage |
| `activeStages` | String[] | Yes | $Flow.ActiveStages | Collection of all active stage names |
| `type` | String | Yes | base | Display type: `base`, `vertical`, or `path` |
| `variant` | String | Yes | base | Visual variant: `base` or `shaded` |
| `completeStages` | String[] | No | — | Collection of stage names marked as complete |
| `allComplete` | Boolean | No | false | Mark all stages as complete |
| `hasError` | Boolean | No | true | When false, shows an error icon on the current stage |
| `customClass` | String | No | — | Custom CSS classes for the outer container |
| `preventNavigation` | Boolean | No | false | Prevent users from clicking stages to navigate |
| `topMargin` | String | No | slds-m-top_none | Top margin SLDS class |
| `bottomMargin` | String | No | slds-m-bottom_none | Bottom margin SLDS class |

### Outputs

| Property | Type | Description |
|---|---|---|
| `selectedStage` | String | The stage name clicked by the user (when navigation is allowed) |
| `completeStages` | String[] | Updated collection of complete stage names |

## Common Patterns

### 1. Flow Stage Progress Bar
Bind `currentStage` to `{!$Flow.CurrentStage}` and `activeStages` to `{!$Flow.ActiveStages}`. The indicator automatically shows progress through your Flow's defined stages.

### 2. Path-Style Progress
Set `type=path` for a Salesforce Path-style horizontal progress bar. Use `completeStages` to mark earlier stages as done.

### 3. Vertical Step Indicator
Set `type=vertical` for a vertical step list. Ideal for sidebar layouts or narrow screen areas.

## Tips & Considerations

- **Stage Navigation**: By default, users can click on previous stages to navigate backward. Set `preventNavigation=true` to disable this and force linear progression.
- **Error States**: Set `hasError=false` to display an error icon on the current stage — useful for indicating validation failures before allowing the user to proceed.
- **Styling**: Use `customClass` to add SLDS utility classes for additional styling (e.g., padding, background colors).
