# Collection & Data Utility Actions
> Invocable Actions for manipulating record collections and sanitizing data in Flows — subset extraction, null removal, position recalculation, FLS sanitization, null stripping, and exception handling.

## Overview

These utility actions solve common Flow pain points around working with record collections and data quality. They handle tasks like extracting a subset of records from a large collection, removing null records, recalculating sort positions, stripping null field values before updates, enforcing FLS permissions, and throwing custom exceptions.

All actions appear under the **Flow Tool Kit** category in Flow Builder.

## Actions

### Collection Subset

**Action Name**: `Collection Subset`

Extract a portion of a record collection by specifying start and end positions. Essential for pagination, chunking large collections for processing, or taking a sample from a large dataset.

#### Inputs

| Parameter | Type | Required | Description |
|---|---|---|---|
| `records` | SObject[] | Yes | The source collection |
| `chunkStart` | Integer | No | Starting position (0-based index) |
| `chunkEnd` | Integer | No | Ending position |

#### Outputs

| Parameter | Type | Description |
|---|---|---|
| `records` | SObject[] | The subset of records between start and end positions |

#### Example
From a collection of 1000 records, set `chunkStart=200` and `chunkEnd=400` to get the 200 records from positions 200-399.

---

### Remove Nulls from Collection

**Action Name**: `Remove Nulls from Collection`

Remove null entries from a record collection. This commonly occurs when looping and conditionally adding records — positions where records weren't added remain null.

#### Inputs

| Parameter | Type | Required | Description |
|---|---|---|---|
| `records` | SObject[] | No | Collection that may contain null records |

#### Outputs

| Parameter | Type | Description |
|---|---|---|
| `records` | SObject[] | Collection with null entries removed |

---

### Recalculate Position Values

**Action Name**: `Recalculate Position Values`

After a position/sort order value is changed on one record, recalculate all positions in the collection to maintain a consistent, gapless sequence. Returns separate collections for records that need updating and inserting.

#### Inputs

| Parameter | Type | Required | Description |
|---|---|---|---|
| `records` | SObject[] | Yes | Collection of records with position values |
| `fieldApiName` | String | Yes | API name of the position/sort order field |

#### Outputs

| Parameter | Type | Description |
|---|---|---|
| `updateCollection` | SObject[] | Records that need their position updated |
| `insertCollection` | SObject[] | Records that need to be inserted |
| `hasRecordsToUpdate` | Boolean | Whether there are records to update |
| `hasRecordsToInsert` | Boolean | Whether there are records to insert |

#### Example
You have tasks with a `Sort_Order__c` field. After a user reorders task #5 to position #2, pass all tasks through this action to recalculate positions 2-5 so they're sequential.

---

### FLS Record(s) Sanitizer

**Action Name**: `FLS Record(s) Sanitizer`

Remove field values that the running user doesn't have Field-Level Security (FLS) access to. Use this after a "Get Records" element with "Return All Fields" to ensure the user only sees fields they have permission to view.

#### Inputs

| Parameter | Type | Required | Description |
|---|---|---|---|
| `record` | SObject | No | Single record to sanitize |
| `records` | SObject[] | No | Collection to sanitize |

#### Outputs

| Parameter | Type | Description |
|---|---|---|
| `record` | SObject | Record with inaccessible field values removed |
| `records` | SObject[] | Collection with inaccessible field values removed |

---

### Strip Null Values

**Action Name**: `Strip Null Values`

Remove null field values from a record variable. This prevents overwriting existing field values with blanks when performing an Update Records operation.

#### Inputs

| Parameter | Type | Required | Description |
|---|---|---|---|
| `record` | SObject | Yes | Record to strip nulls from |

#### Outputs

| Parameter | Type | Description |
|---|---|---|
| `record` | SObject | Record with only non-null field values |

#### Example
After a Flow Form screen where the user only edits 3 of 20 fields, the other 17 fields are null on the output record. Without stripping nulls, updating the record would overwrite those 17 fields with blanks. Strip Null Values removes the null fields so only the 3 edited fields are included in the update.

---

### Throw Custom Exception

**Action Name**: `Throw Custom Exception`

Throw a custom Apex exception from a Flow. Useful for triggering fault paths in Platform Event-triggered flows or creating deliberate error conditions for testing.

#### Inputs

| Parameter | Type | Required | Description |
|---|---|---|---|
| `message` | String | Yes | The error message for the exception |

#### Outputs

None — this action throws an exception, which triggers the Flow's fault path.

## Common Patterns

### 1. Paginated Record Processing
Use **Collection Subset** to chunk a large collection into batches of 200 records for processing within governor limits. Loop through chunks using calculated start/end positions.

### 2. Safe Record Update
After a Flow Form screen: use **Strip Null Values** on the `changedRecordFieldsOnly` output, then update the record. Only fields the user actually changed are included in the DML.

### 3. Permission-Safe Display
After querying records with "Return All Fields" enabled: pass through **FLS Sanitizer** before displaying in a Flow Form or Data Table. Users only see field values they have permission to access.

### 4. Reorderable List
After a user reorders items in a Data Table with a position column: pass the collection through **Recalculate Position Values** to renumber everything cleanly, then update the records.

## Tips & Considerations

- **Strip Nulls vs Remove Nulls**: Different actions! Strip Null Values removes null *field values* from a single record. Remove Nulls from Collection removes null *records* from a collection.
- **FLS Sanitizer Timing**: Apply FLS sanitization AFTER querying and BEFORE displaying or processing. This ensures users only interact with data they have access to.
- **Position Gaps**: After Recalculate Positions, positions are sequential starting from 1. Previous gaps (1, 3, 5) become (1, 2, 3).
- **Exception Fault Path**: When using Throw Custom Exception, make sure your Flow has a fault path configured. Otherwise, the exception causes an unhandled error screen.
- **Collection Subset Bounds**: If `chunkEnd` exceeds the collection size, it returns records up to the end of the collection (no error).
