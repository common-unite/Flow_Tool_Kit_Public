# DateTime Utility Actions
> Invocable Actions for converting between Salesforce DateTime values and UNIX timestamps in Flows.

## Overview

These utility actions convert between Salesforce's DateTime format and UNIX epoch timestamps (seconds since January 1, 1970). This is essential when integrating with external systems, APIs, or JavaScript-based components that use UNIX timestamps instead of Salesforce's native DateTime format.

Both actions appear under the **Flow Tool Kit** category in Flow Builder.

## Actions

### Convert Datetime to UNIX Timestamp

**Action Name**: `Convert Datetime value to UNIX timestamp (seconds)`

Convert a Salesforce DateTime value into a UNIX timestamp (number of seconds since epoch).

#### Inputs

| Parameter | Type | Required | Description |
|---|---|---|---|
| `dt` | DateTime | Yes | The Salesforce DateTime value to convert |

#### Outputs

| Parameter | Type | Description |
|---|---|---|
| `timestamp` | Long | UNIX timestamp in seconds |

#### Example
`2024-01-15T14:30:00Z` → `1705326600`

---

### Convert UNIX Timestamp to Datetime

**Action Name**: `Convert UNIX timestamp (seconds) to Datetime value`

Convert a UNIX timestamp back into a Salesforce DateTime value.

#### Inputs

| Parameter | Type | Required | Description |
|---|---|---|---|
| `timestamp` | Integer | Yes | UNIX timestamp in seconds |

#### Outputs

| Parameter | Type | Description |
|---|---|---|
| `dt` | DateTime | Salesforce DateTime value |

#### Example
`1705326600` → `2024-01-15T14:30:00Z`

## Common Patterns

### 1. External API Integration
When calling an external API that returns timestamps as UNIX epoch values, use **Convert UNIX Timestamp to Datetime** to convert them to Salesforce DateTime for storage or display.

### 2. JWT / Token Expiration
When working with JWT tokens or OAuth flows, token expiration times are often UNIX timestamps. Convert them to DateTime to compare with `{!$Flow.CurrentDateTime}` and determine if a token has expired.

### 3. Scheduling Calculations
Convert a DateTime to UNIX timestamp, add seconds (e.g., 3600 for one hour), then convert back. This provides precise time arithmetic without dealing with DateTime formula complexity.

### 4. JavaScript Integration
When passing DateTime values to JavaScript-based LWC components or external libraries that expect epoch timestamps, convert before passing.

## Tips & Considerations

- **Seconds, Not Milliseconds**: These actions use seconds. JavaScript's `Date.now()` returns milliseconds — divide by 1000 before passing to the Datetime converter.
- **Timezone**: UNIX timestamps are UTC by default. The conversion to/from Salesforce DateTime preserves UTC. Display timezone handling is separate.
- **Integer Limits**: The UNIX timestamp input uses Integer type, which supports dates up to approximately year 2038 (the "Year 2038 problem"). The output uses Long type which supports larger values.
- **Null Handling**: Passing a null DateTime or null timestamp will cause an error. Validate inputs before calling these actions.
