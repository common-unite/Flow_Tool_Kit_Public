# Publish Message

> Publish validation messages to specific form sections via Lightning Message Channels on Flow Screens.

## Overview

Form (Publish Message) sends a validation status message to a specific form section identified by its QualifiedApiName. This allows other screen components or Flow logic to flag individual sections as valid or invalid, displaying error indicators on the targeted section.

This is a utility component — it doesn't render any visible UI. It publishes a message on the Flow_Form_Section_Validate message channel, which Flow Form listens for to update section-level validation indicators.

## Where to Use It

- **Flow Screen** (utility — no visible UI)

## Properties

### Inputs

| Property | Type | Required | Default | Description |
|---|---|---|---|---|
| `sectionQualifiedApiName` | String | No | — | QualifiedApiName of the form section to target |
| `isvalid` | Boolean | No | false | When false, the section displays an error indicator |
| `channel` | String | No | — | Message channel API name (datasource: Flow_Form_Section_Validate) |

## Common Patterns

### 1. Cross-Section Validation
Use a Flow decision element to evaluate business rules that span multiple sections. If a rule fails, set `isvalid=false` and target the relevant section's QualifiedApiName. The form section displays a red error indicator.

### 2. External Validation Result
After calling an external API or Apex action for validation, use Publish Message to flag the corresponding form section based on the result.

## Tips & Considerations

- **No Visible UI**: This component doesn't render anything on screen. Place it on the same screen as the Flow Form you want to validate.
- **Section Targeting**: The `sectionQualifiedApiName` must exactly match a section's QualifiedApiName from the Form metadata.
