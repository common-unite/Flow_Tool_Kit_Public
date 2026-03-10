# Button Configuration

> Invocable action that creates custom Button objects for use with Flow Tool Kit screen components.

## Add New Button

**Action Label**: Add New Button
**Category**: Flow Tool Kit

Creates a `Button` Apex-Defined object and adds it to a button collection. Button collections are passed to screen components (Custom Buttons, Header, Data Table) to render configurable navigation and action buttons.

Call this action multiple times in sequence, passing the output collection back as input each time, to build up a collection of buttons.

### Inputs

| Property | Type | Required | Description |
|---|---|---|---|
| `buttons` | Button[] | No | Existing button collection to add to (pass from previous action) |
| `type` | String | No | Action type: `NEXT`, `BACK`, `FINISH`, `TRIGGER`, `URL` |
| `label` | String | No | Button display text |
| `value` | String | No | Value returned when the button is clicked |
| `variant` | String | No | SLDS button variant: `neutral`, `brand`, `destructive`, `success`, etc. |
| `iconName` | String | No | SLDS icon name (e.g., "utility:save") |
| `iconPosition` | String | No | Icon position: `Left` or `Right` |
| `triggerName` | String | No | Event name for TRIGGER type buttons |
| `hide` | Boolean | No | Conditionally hide this button |
| `bypassValidation` | Boolean | No | Skip form validation on click |
| `enableModal` | Boolean | No | Show confirmation modal before action |
| `modalHeading` | String | No | Modal title |
| `modalSubheading` | String | No | Modal subtitle |
| `modalBody` | String | No | Modal body content |
| `modalTheme` | String | No | SLDS theme class for the modal |
| `modalConfirmButtonLabel` | String | No | Modal confirm button text |
| `modalCancelButtonLabel` | String | No | Modal cancel button text |
| `reCAPTCHA_Enabled` | Boolean | No | Require reCAPTCHA verification |
| `reCAPTCHA_Threshold` | Decimal | No | Minimum reCAPTCHA score (0-100) |
| `elementApiName` | String | No | Target screen element API name |
| `enable_AutoAction` | Boolean | No | Auto-click after timeout |
| `autoActionTimeout` | String | No | Milliseconds before auto-action fires |

### Outputs

| Property | Type | Description |
|---|---|---|
| `buttons` | Button[] | Updated button collection (pass to the next Add New Button action or to a screen component) |

### Usage

Build a button collection by chaining actions:

1. **Action 1**: "Add New Button" — type=NEXT, label="Save & Continue", variant=brand → outputs `buttons`
2. **Action 2**: "Add New Button" — buttons=`{!Action1.buttons}`, type=BACK, label="Go Back", variant=neutral → outputs `buttons`
3. **Action 3**: "Add New Button" — buttons=`{!Action2.buttons}`, type=TRIGGER, label="Cancel", enableModal=true → outputs `buttons`
4. **Screen**: Pass `{!Action3.buttons}` to the Custom Buttons component's `buttons` input

{% hint style="info" %}
**When to use this vs manual button configuration**: Use the Add New Button action when button properties need to be dynamic (driven by Flow variables, formulas, or decision outcomes). Use the manual button configuration in the Custom Buttons property editor when buttons are static.
{% endhint %}

## Related Pages

- [Custom Buttons](../screen-components/custom-buttons.md) — renders button collections
- [Header](../screen-components/header.md) — can also host button collections
