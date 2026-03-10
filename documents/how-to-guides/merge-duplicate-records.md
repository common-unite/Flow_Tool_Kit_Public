# How To: Merge Duplicate Records

> Use the Record Merge invocable action to merge duplicate records in a Flow.

{% hint style="info" %}
**Prerequisites**: Flow Tool Kit installed. This action works in any Flow — no form required.
{% endhint %}

## Video Walkthrough

{% embed url="https://vimeo.com/995196324" %}

## Overview

![Merge records side-by-side comparison](../screenshots/screen-components/merge-records/merge-records-comparison.png)

The Record Merge invocable action lets you merge duplicate Salesforce records directly from a Flow. It works like the standard Salesforce merge but is available as a Flow action, so you can build merge workflows, automate deduplication, or let users trigger merges from screen flows.

## Step 1: Create a Flow

1. Open **Setup → Flows** and create a new Flow.
2. For user-triggered merges, use a **Screen Flow**. For automated merges, use an **Auto-Launched Flow**.

## Step 2: Identify the Records to Merge

You need:
- A **master record** — the record that survives after the merge
- One or more **duplicate records** — records that will be merged into the master

In a screen flow, you might:
1. Use a Data Table to display potential duplicates
2. Let the user select which record is the master
3. The remaining selected records are the duplicates

## Step 3: Add the Record Merge Action

1. Add an **Action** element to your Flow.
2. Search for **Record Merge** (under FlowToolKit actions).
3. Configure:

| Input | Description |
|-------|-------------|
| **Master Record ID** | The ID of the record to keep |
| **Duplicate Record IDs** | The IDs of records to merge into the master |

## Step 4: Handle Related Records

When records merge:
- **Child records** (related lists) are reparented to the master record
- **Duplicate records** are deleted after the merge
- Standard Salesforce merge behavior applies for field value conflicts

{% hint style="warning" %}
**Merge is permanent.** Merged records cannot be unmerged. Always confirm with the user before executing a merge in a screen flow.
{% endhint %}

## Common Patterns

### User-Driven Merge Flow
1. Screen: Show potential duplicates in a Data Table
2. Screen: Let user select the master record
3. Action: Execute Record Merge
4. Screen: Confirmation message

### Automated Deduplication
1. Scheduled Flow runs daily
2. Query for records matching duplicate criteria
3. Group by matching key
4. Execute Record Merge for each group

## Related Pages

- [Record Operations Reference](../invocable-actions/record-operations.md) — all record operation actions
- [Use Data Tables](use-data-tables.md) — display records for selection
- [Feature Overview](../welcome/feature-overview.md) — all invocable actions
