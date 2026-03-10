# Exception Handling

> Invocable action for throwing custom exceptions in Flows — useful for triggering faults in platform event handlers and error scenarios.

## Throw Custom Exception

**Action Label**: Throw Custom Exception
**Category**: Flow Tool Kit

Throws a custom Apex exception with the specified message. This causes the Flow to enter its fault path, where you can handle the error with a fault connector. Primarily used within Platform Event-triggered Flows to signal errors that should be caught by the fault handling mechanism.

### Inputs

| Property | Type | Required | Description |
|---|---|---|---|
| `message` | String | Yes | The error message text |

### Outputs

None — this action throws an exception, so execution moves to the fault path.

### Usage

1. Add the "Throw Custom Exception" action to a Flow
2. Set the error message (e.g., "Submission conversion failed: required field missing")
3. Connect a fault connector from this action to your error handling logic
4. In the fault handler, log the error, send notifications, or take corrective action

{% hint style="warning" %}
This action intentionally causes a fault. Always ensure you have a fault connector configured, or the Flow will fail with an unhandled exception.
{% endhint %}

## Related Pages

- [Form Submission Actions](form-submission-actions.md) — often used together in conversion flows
- [Overridable Conversion Flows](../form-template-framework/how-to/overridable-conversion-flows.md)
