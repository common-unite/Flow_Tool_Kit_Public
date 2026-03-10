# Form Configuration Actions

> Invocable actions that configure Form and Form Repeater components programmatically in Flows.

## Configure Form

**Action Label**: Configure Form
**Category**: Flow Tool Kit

Creates a `FormConfiguration` object that can be passed to the Flow Form component's `formConfiguration` input. This provides an alternative to setting individual properties directly on the screen component — useful when you want to compute configuration values in Flow logic before the screen.

### Inputs

| Property | Type | Required | Description |
|---|---|---|---|
| `themeOverrideName` | String | No | Theme QualifiedApiName for custom styling |
| `enableAccordion` | Boolean | No | Wrap sections in collapsible accordions |
| `wrapInAccordion` | Boolean | No | Wrap entire form in a single accordion |
| `titleTemplate` | String | No | Template string for accordion section titles |
| `accordionTitle` | String | No | Title for the accordion wrapper |
| `validateSections` | Boolean | No | Validate each section independently |
| `displayPrompts` | Boolean | No | Show field-level help prompts |
| `preventValidationBypass` | Boolean | No | Prevent users from bypassing validation |
| `returnVisibleFieldsOnly` | Boolean | No | Only return visible field values |
| `preventNulls` | Boolean | No | Remove null values from output |
| `marginBottom` | String | No | Bottom margin SLDS class |
| `requireAll` | Boolean | No | Make all fields required |
| `disableAll` | Boolean | No | Disable all fields |
| `disableAllHeaders` | Boolean | No | Disable section headers |

### Outputs

| Property | Type | Description |
|---|---|---|
| `FormConfiguration` | FormConfiguration (Apex-Defined) | Configuration object to pass to Flow Form |

### Usage

1. Add the "Configure Form" action before your screen element
2. Set the configuration properties based on Flow logic (e.g., `disableAll=true` when status is "Approved")
3. Pass the output `FormConfiguration` to the Flow Form's `formConfiguration` input on the screen

---

## Configure Form (Repeater)

**Action Label**: Configure Form (Repeater)
**Category**: Flow Tool Kit

Creates a `FormRepeaterConfiguration` object for the Repeater component. This action has 80+ configuration options covering all aspects of the Repeater: action permissions, button labels, display settings, selection behavior, edit modal, themes, validation, and responsive sizing.

### Key Input Categories

**Action Permissions**: `allowNew`, `allowEdit`, `allowDelete`, `allowClone`, `allowImport`, `allowReposition`, `allowSelect`, `allowViewDetails`

**Button Labels**: `newButtonLabel`, `editButtonLabel`, `deleteButtonLabel`, `cloneButtonLabel`, `importButtonLabel`

**Size & Bounds**: `max`, `min`, `maxSelection`, `smallSize`, `mediumSize`, `largeSize`

**Display**: `themeOverrideName`, `themeHeaderName`, `accordionTitle`, `enableAccordion`, `wrapInAccordion`, `dynamicHeaders`, `hideDivider`, `displayRepeaterButtonsAbove`, `subtitleTemplate`, `iconNameTemplate`

**Validation**: `requireAll`, `disableAll`, `displayPrompts`, `preventValidationBypass`

**Header**: `title`, `subtitle`, `helpText`, `iconName`, `richText`, `showHeader`, `topMargin`

**Edit Modal**: `editModalHeading`, `editModalSubheading`, `editModalReturnOnSelect`, `editReturnButtonLabel`

**Selection**: `navigateOnSelect`, `navigateToRecordOnSelect`, `selectionReturnFieldValue`, `showSelectedOnly`, `selectLabelWhenOff/On/Hover`, `selectIconWhenOff/On/Hover`

### Outputs

| Property | Type | Description |
|---|---|---|
| `formRepeaterConfiguration` | FormRepeaterConfiguration (Apex-Defined) | Configuration object to pass to Repeater |

### Usage

1. Add the "Configure Form (Repeater)" action before your screen element
2. Set the properties you need — only configured properties override defaults
3. Pass the output to the Repeater's `formRepeaterConfiguration` input

## Related Pages

- [Flow Form](../screen-components/flow-form.md) — consumes FormConfiguration
- [Repeater](../screen-components/repeater.md) — consumes FormRepeaterConfiguration
