# Record Operation Actions
> Invocable Actions for advanced record operations in Flows — upsert with duplicate bypass, future DML, record merging, lead conversion, new records with defaults, duplicate checking, and record querying.

## Overview

Flow Tool Kit provides several Invocable Actions that extend Salesforce's standard Flow record operations. These actions handle scenarios that standard Flow elements can't — like upserting while bypassing duplicate rules, performing DML in a future context, merging records, converting leads, and creating new records with calculated defaults.

All actions appear under the **Flow Tool Kit** category in Flow Builder's Action element.

## Actions

### Upsert Record(s) Bypass Duplicate Rules

**Action Name**: `Upsert Record(s) Bypass Duplicate Rules`

Insert or update records while ignoring duplicate rules. Useful when you know a record might match a duplicate rule but want to proceed anyway (e.g., merging data from an external system).

#### Inputs

| Parameter | Type | Required | Description |
|---|---|---|---|
| `bypassDuplicateRules` | Boolean | Yes | Set to true to bypass duplicate rules |
| `record` | SObject | No | Single record to upsert |
| `recordCollection` | SObject[] | No | Collection of records to upsert |

#### Outputs

| Parameter | Type | Description |
|---|---|---|
| `record` | SObject | The upserted record (with Id populated) |
| `recordCollection` | SObject[] | The upserted collection |

---

### Future DML Operation

**Action Name**: `Future DML Operation`

Perform DML operations asynchronously using `@future`. This is useful when you need to make callouts in the same transaction or when you want to avoid mixed DML errors.

#### Inputs

| Parameter | Type | Required | Description |
|---|---|---|---|
| `record` | SObject | Yes | The record to process |
| `type` | String | Yes | DML operation type: `Insert`, `Update`, `Delete`, or `Publish` |

#### Outputs

None — the operation runs asynchronously.

---

### Merge Records

**Action Name**: `Merge Records`

Merge duplicate Account, Contact, Case, or Lead records. The winning record absorbs the child records and field values from the losing records.

#### Inputs

| Parameter | Type | Required | Description |
|---|---|---|---|
| `mergeToRecord` | SObject | Yes | The "winning" record — other records merge into this one |
| `duplicateRecords` | SObject[] | Yes | Collection of "losing" records to merge into the winner |

#### Outputs

| Parameter | Type | Description |
|---|---|---|
| `isSuccess` | Boolean | Whether the merge completed successfully |
| `failedDuplicates` | SObject[] | Records that failed to merge |
| `errorMessage` | String | Error details if the merge failed |

---

### Convert Lead Record

**Action Name**: `Convert Lead Record`

Convert a Lead into a Contact and Account (and optionally an Opportunity). Provides full control over the conversion parameters that standard Flow elements don't expose.

#### Inputs

| Parameter | Type | Required | Description |
|---|---|---|---|
| `leadId` | Id | Yes | The Lead record Id to convert |
| `accountId` | Id | No | Existing Account Id to link to (skip new Account creation) |
| `contactId` | Id | No | Existing Contact Id to link to (skip new Contact creation) |
| `opportunityId` | Id | No | Existing Opportunity Id |
| `createOpportunity` | Boolean | No | Whether to create an Opportunity (default: false) |
| `convertedStatus` | String | No | The converted Lead Status value |

#### Outputs

| Parameter | Type | Description |
|---|---|---|
| `leadId` | Id | The original Lead Id |
| `accountId` | Id | The Account Id (created or existing) |
| `contactId` | Id | The Contact Id (created or existing) |
| `opportunityId` | Id | The Opportunity Id (if created) |
| `isSuccess` | Boolean | Whether the conversion succeeded |

---

### New Record with Defaults

**Action Name**: `New Record with Defaults`

Create a new record variable with all default values set and formula fields calculated. This gives you a properly initialized record template — something standard Flow's "Create Records" element can't do without saving first.

*Has a Custom Property Editor for visual configuration.*

#### Inputs

| Parameter | Type | Required | Description |
|---|---|---|---|
| `objectName` | String | No | The SObject API name |
| `template` | SObject | No | Template record with default values to override. You can also assign a RecordTypeId here |

#### Outputs

| Parameter | Type | Description |
|---|---|---|
| `template` | SObject | A new record with defaults set and formulas calculated |

---

### Check for Duplicates

**Action Name**: `Check for Duplicates`

Use Salesforce's duplicate rules to find potential duplicate records. Returns matching records and a confidence indicator.

#### Inputs

| Parameter | Type | Required | Description |
|---|---|---|---|
| `record` | SObject | Yes | The record to check for duplicates |
| `ruleName` | String | No | Matching Rule developer name(s) to use. Separate multiple with semicolons |
| `duplicateRuleName` | String | No | Duplicate Rule developer name(s) to use. Separate multiple with semicolons |

#### Outputs

| Parameter | Type | Description |
|---|---|---|
| `hasDuplicates` | Boolean | Whether duplicates were found |
| `mostConfidentMatch` | SObject | The highest-confidence duplicate match |
| `duplicates` | SObject[] | All matching duplicate records |
| `duplicateIds` | String[] | Ids of all duplicate records |
| `totalDuplicates` | Integer | Total number of duplicates found |

---

### Query Records

**Action Name**: `Query Records`

*Available in the unlocked package.* Execute dynamic queries with flexible options for field access, object access, and sharing rules.

#### Inputs

| Parameter | Type | Required | Description |
|---|---|---|---|
| `objectName` | String | Yes | SObject API name to query |
| `allObjects` | Boolean | Yes | Bypass object-level access check |
| `allFields` | Boolean | Yes | Return all accessible fields (not just selected ones) |
| `allData` | Boolean | Yes | Bypass sharing rules (without sharing) |
| `queryFilter` | String | No | WHERE clause (without the "WHERE" keyword) |
| `querySort` | String | No | ORDER BY clause |
| `queryLimit` | Integer | No | Maximum records to return (1-50,000) |

#### Outputs

| Parameter | Type | Description |
|---|---|---|
| `records` | SObject[] | Query results |

---

### Query Records with Template

**Action Name**: `Query Records with Template`

*Available in the unlocked package.* Query records using a template record's field values as the WHERE clause. Non-null fields on the template become equality conditions.

#### Inputs

| Parameter | Type | Required | Description |
|---|---|---|---|
| `template` | SObject | Yes | Record template — non-null field values become query conditions |
| `returnLimit` | Integer | Yes | Maximum records to return (default: 10,000) |

#### Outputs

| Parameter | Type | Description |
|---|---|---|
| `records` | SObject[] | Query results |

---

### Get Record Types

**Action Name**: `Get Record Types`

Return the active record types accessible to the running user for a given object. Use this to populate record type pickers or make decisions based on available record types.

#### Inputs

| Parameter | Type | Required | Description |
|---|---|---|---|
| `ObjectName` | String | Yes | SObject API name |

#### Outputs

| Parameter | Type | Description |
|---|---|---|
| `recordTypes` | RecordType[] | Active, accessible record types |
| `defaultRecordType` | RecordType | The user's default record type |

## Tips & Considerations

- **Bypass Duplicate Rules**: Use judiciously. Bypassing duplicate rules can create data quality issues. Consider logging when duplicates are bypassed.
- **Future DML**: Operations run asynchronously — you can't use the result immediately in the same flow. Use for fire-and-forget scenarios.
- **Merge Limits**: Salesforce allows merging up to 3 records at a time (1 winner + 2 losers for most objects).
- **Lead Conversion Status**: If `convertedStatus` is not specified, the action uses the first converted status it finds. Ensure your org has a converted Lead Status defined.
- **Query Security**: The Query Records action's `allObjects`, `allFields`, and `allData` flags bypass security — use them only when appropriate and understand the implications.
