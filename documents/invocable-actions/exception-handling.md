# Exception Handling

> Invocable action for throwing custom exceptions in Flows, useful for triggering faults in platform event handlers and error scenarios.

## Throw Custom Exception

**Action Label**: Throw Custom Exception
**Category**: Flow Tool Kit

Throws a custom Apex exception with the specified message. This causes the Flow to enter its fault path, where you can handle the error with a fault connector. Primarily used within Platform Event-triggered Flows to signal errors that should be caught by the fault handling mechanism.

### Inputs

| Property | Type | Required | Description |
|---|---|---|---|
| `message` | String | Yes | The error message text |

### Outputs

None. This action throws an exception, so execution moves to the fault path.

### Usage

1. Add the "Throw Custom Exception" action to a Flow
2. Set the error message (e.g., "Submission conversion failed: required field missing")
3. Connect a fault connector from this action to your error handling logic
4. In the fault handler, log the error, send notifications, or take corrective action

{% hint style="warning" %}
This action intentionally causes a fault. Always ensure you have a fault connector configured, or the Flow will fail with an unhandled exception.
{% endhint %}

## Get Readable Fault Message

**Action Label**: Get Readable Fault Message
**Category**: Flow Tool Kit

Turns a flow fault into a sentence a person can act on. When a validation rule refuses a Create or Update, Salesforce hands the flow text like *"The flow tried to update these records: 001... This error occurred: FIELD_CUSTOM_VALIDATION_EXCEPTION: ... You can look up ExceptionCode values in the SOAP API Developer Guide."* This action returns only the rule's own error message, so a fault screen, toast or email shows the reason and not record Ids and SOAP text.

This walkthrough adds the action to a fault path in Flow Builder, then runs the flow so a validation rule refuses the change.

{% embed url="https://vimeo.com/1242033904" %}

### Inputs

| Property | Type | Required | Description |
|---|---|---|---|
| Fault Message | String | Yes | The fault, usually `{!$Flow.FaultMessage}` |
| Fallback Message | String | No | Shown when the fault is not a validation rule. Leave blank to show the cleaned detail instead |

### Outputs

| Property | Type | Description |
|---|---|---|
| Readable Message | String | The validation rule's own sentence, or the fallback, or the cleaned detail |
| Is Validation | Boolean | True when a validation rule refused the change |

### Usage

1. On the element that can fail (Create Records, Update Records, an action), add a **Fault** path.
2. On the fault path, add **Get Readable Fault Message** and set **Fault Message** to `{!$Flow.FaultMessage}`.
3. Show the action's **Readable Message** on a screen, in a toast or in an email instead of `{!$Flow.FaultMessage}`.
4. Use **Is Validation** in a Decision when a rule's refusal needs a different path from an unexpected error.

## Related Pages

- [Form Submission Actions](form-submission-actions.md): often used together in conversion flows
- [Overridable Conversion Flows](../form-template-framework/how-to/overridable-conversion-flows.md)
