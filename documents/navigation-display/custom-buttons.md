# Custom Buttons
> Replace or extend the default Flow navigation buttons with fully configurable custom buttons — including modals, reCAPTCHA, auto-actions, and docked footers.

## Overview

Form (Buttons) replaces the standard "Next", "Previous", and "Finish" buttons on a Flow Screen with custom buttons that you configure. Each button can trigger Flow navigation, open a confirmation modal, validate forms, integrate with reCAPTCHA, or fire on a timer — giving you complete control over the user experience.

You can configure up to 5 buttons directly in the property editor, or pass an Apex-Defined `Button[]` collection for dynamic button generation. Buttons communicate with other Flow Tool Kit components (Flow Form, Header, Data Table) via the FlowButton message channel, enabling features like form validation before navigation.

## Where to Use It

- **Flow Screen**

## Quick Start

1. **Add to Screen** — In Flow Builder, drag "Form (Buttons)" onto your screen element.
2. **Enable a Button** — In the property editor, enable Button 1 and set its label (e.g., "Save & Continue").
3. **Set the Action Type** — Choose the button type: NEXT (navigate forward), BACK (navigate back), FINISH (end flow), or TRIGGER (fire an event without navigating).
4. **Optional: Add a Modal** — Enable the confirmation modal to show a dialog before the action executes.
5. **Use the Output** — After the screen, check `buttonClickedLabel` or `buttonClickedValue` to determine which button was clicked.

## Properties

### Inputs

| Property | Type | Required | Default | Description |
|---|---|---|---|---|
| `buttons` | Button[] (Apex-Defined) | No | — | Collection of Button objects for dynamic button generation (overrides manual config) |
| `buttonAlignment` | String | No | center | Horizontal alignment: `start`, `center`, or `end` |
| `numberOfButtonsToShow` | Integer | No | 3 | Number of buttons visible before extras go into an overflow menu |
| `groupButtons` | Boolean | No | false | Group buttons together without spacing (button group style) |
| `docked` | Boolean | No | false | Display buttons in a docked footer at the bottom of the screen |
| `footer` | Boolean | No | false | Display buttons in a standard footer |
| `disableButtons` | Boolean | No | false | Disable all buttons |
| `showAsPath` | Boolean | No | — | Display buttons as a Salesforce Path-style progress indicator |
| `currentStage` | String | No | — | Current stage name when displayed as a Path |

#### Per-Button Properties (repeated for buttons 1-5)

Each button (1-5) has the following properties. Button 1 uses the base property name; buttons 2-5 append the number (e.g., `label2`, `type3`).

| Property | Type | Default | Description |
|---|---|---|---|
| `buttonNEnabled` | Boolean | false | Enable this button |
| `type` | String | NEXT | Action type: `NEXT`, `BACK`, `FINISH`, `TRIGGER`, `URL` |
| `label` | String | Continue | Button display text |
| `value` | String | Button | Value returned in `buttonClickedValue` when clicked |
| `variant` | String | neutral | SLDS button variant: `neutral`, `brand`, `destructive`, `success`, `brand-outline`, `destructive-text`, `inverse` |
| `iconName` | String | — | SLDS icon name (e.g., "utility:save") |
| `iconPosition` | String | Right | Icon position: `Left` or `Right` |
| `triggerName` | String | — | Name used with TRIGGER type for message channel communication |
| `hideButton` | Boolean | false | Conditionally hide this button |
| `bypassValidation` | Boolean | false | Skip form validation when this button is clicked |
| `enableModal` | Boolean | false | Show a confirmation modal before executing the action |
| `modalHeading` | String | — | Modal title text |
| `modalSubheading` | String | — | Modal subtitle text |
| `modalBody` | String | — | Modal body content |
| `modalTheme` | String | slds-theme_default | SLDS theme class for the modal |
| `modalConfirmButtonLabel` | String | Confirm | Label for the modal confirm button |
| `modalCancelButtonLabel` | String | Cancel | Label for the modal cancel button |
| `reCAPTCHA_Enabled` | Boolean | false | Require reCAPTCHA verification before this button's action |
| `reCAPTCHA_Threshold` | Integer | — | Minimum reCAPTCHA score (0-100) required to proceed |
| `enable_AutoAction` | Boolean | false | Auto-click this button after a timeout |
| `autoActionTimeout` | String | 10000 | Milliseconds before the auto-action fires |

### Outputs

| Property | Type | Description |
|---|---|---|
| `buttonClicked` | Button (Apex-Defined) | The full Button object that was clicked |
| `buttonClickedLabel` | String | Label of the clicked button |
| `buttonClickedValue` | String | Value of the clicked button |
| `buttonClickedDateTime` | DateTime | Timestamp of the button click |
| `actionClickedDateTime` | DateTime | Timestamp of any action (use as a reactive trigger) |

## How It Works

**Button Types**:
- **NEXT** — Navigates to the next screen (equivalent to standard Next button)
- **BACK** — Navigates to the previous screen
- **FINISH** — Ends the flow (equivalent to standard Finish button)
- **TRIGGER** — Fires a message channel event without navigating. Use the `triggerName` to identify which trigger was fired. Other components can listen for this trigger.
- **URL** — Navigates to an external URL

**Validation Integration**: By default, buttons that navigate (NEXT, FINISH) trigger form validation on all Flow Form components on the screen. Set `bypassValidation=true` to skip validation (useful for "Save as Draft" or "Cancel" buttons).

**Modal Confirmation**: When `enableModal` is enabled, clicking the button opens a dialog instead of immediately executing. The user must click "Confirm" to proceed or "Cancel" to stay.

**Auto-Action**: When `enable_AutoAction` is enabled, the button automatically fires after the `autoActionTimeout` period. Useful for timed screens like assessments or auto-advancing splash pages.

**Docked Footer**: When `docked=true`, the buttons stick to the bottom of the viewport and remain visible as the user scrolls through long forms.

## Works With

| Component | Integration |
|---|---|
| **Flow Form** | Triggers form validation before navigation; receives validation results via FlowButton message channel |
| **Header** | Header component can also display buttons with the same configuration |
| **Data Table** | Button clicks can be used to process table changes |
| **reCAPTCHA** | Integrates reCAPTCHA verification per-button for Experience Cloud security |

## Common Patterns

### 1. Save and Continue
Configure Button 1 as NEXT with label "Save & Continue" (brand variant). Add Button 2 as BACK with label "Go Back" (neutral variant). Add Button 3 as TRIGGER with label "Cancel" and a confirmation modal asking "Are you sure you want to cancel?".

### 2. Docked Navigation with Validation Bypass
Enable `docked=true`. Add a "Submit" button (FINISH, brand variant) and a "Save Draft" button (TRIGGER, neutral variant, `bypassValidation=true`). The Submit button validates the form; Save Draft skips validation.

### 3. Auto-Advancing Splash Screen
Add a single hidden button with `enable_AutoAction=true` and `autoActionTimeout=5000`. The screen automatically advances after 5 seconds. Pair with the Illustration component for a loading screen.

## Tips & Considerations

- **Hide Standard Buttons**: When using Custom Buttons, hide the standard Flow navigation buttons by unchecking "Show Footer" in the Flow Screen element properties. Otherwise users see two sets of buttons.
- **Button Collection vs Manual**: Use the `buttons` input (Button[] collection) for dynamic scenarios where button labels/types come from Flow variables. Use manual configuration (button1-5) for static setups.
- **Overflow Menu**: When you have more buttons than `numberOfButtonsToShow`, extras appear in a dropdown overflow menu. Set this based on your screen width.
- **Output Routing**: Use `buttonClickedValue` in Flow Decision elements to route logic based on which button was clicked. Each button should have a unique `value`.
- **reCAPTCHA**: reCAPTCHA integration requires additional setup (site key configuration). See the reCAPTCHA Security documentation for details.
