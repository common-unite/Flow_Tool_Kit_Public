# Customizing the Review

> The review is a Flow, so your duplicate process can be your process: extra checks before a merge, cleanup after it, or a different household model.

## Why it is a Flow

Merging duplicates is rarely just "pick the survivor". Organizations need to check a donor's giving history before merging, combine affiliations or program enrollments afterwards, notify a record owner, or log why a pair was kept apart. A fixed merge screen does one thing its own way. The review flow gives you the building blocks and lets you arrange them:

* Flow Tool Kit's **Merge Records** screen component, which compares any records side by side and returns the principal record and the values chosen for it
* The **Merge Records** Flow action, which performs a true Salesforce merge
* Standard Flow elements for everything else

## Override the packaged flow

**(Duplicate) Review Possible Duplicates | Overridable** is installed as an overridable flow. Open it in Flow Builder, use **Save As** to create your override, change it, and activate it. The Review button on the banner then runs your version.

Keep these in your override, because the banner depends on them:

| Variable | Direction | Contract |
| --- | --- | --- |
| `recordId` | Input | The record the review was started from |
| `objectApiName` | Input | Its object API name; the packaged flow branches on it |
| `survivingRecordId` | Output | After a merge, the surviving record's Id. The banner opens that record when it is not the one the user was on, and refreshes the count. Leave it blank when nothing was merged. |

You do not need to recount anything or clean up duplicate record sets in your flow. The extension's triggers do both after every Not a Match decision, merge and set change.

## Ideas for your override

**After a contact merge**, show the surviving contact's affiliations, relationships or program enrollments in a data table and let the reviewer remove or combine the ones the merge duplicated.

**Before a merge**, check something the merge would lose. For example, warn when both contacts have recurring donations, or block the merge when the records belong to different owners who have not agreed.

**Record why pairs were kept apart**: add a text area to the Not a Match path and store the reason on a custom field of the Not a Match duplicate record set.

**Support another object**: the packaged flow branches on `objectApiName` for Account, Contact, Lead and Individual. Add a branch with a Get Records element, the Merge Records screen and the Merge Records action for your object.

## Household record type

The household step recognizes households by the Account record type developer name in the flow's `householdRecordTypeName` variable, **HH_Account** by default (the NPSP household record type). If your households use another record type, change the variable's default value in your override. If your org has no household model, the step is skipped automatically and nothing needs changing.

## Rebuild in your own automation

The **Reprocess Duplicate Rules** Flow action behind the rebuild screen is available to any flow:

| Input | Required | Notes |
| --- | --- | --- |
| Object API Name | Yes | For example `Contact`, `Account`, `Lead` or a custom object with a duplicate rule |
| Duplicate Rule Name(s) | No | Developer names separated by semicolons; blank for every active rule on the object |
| Batch Size | No | 1 to 200, default 200. Lower it only if a very large duplicate cluster hits a limit |

| Output | Notes |
| --- | --- |
| Job Id | The queued rebuild job |
| Is Success | False when the rebuild could not start |
| Error Message | Why, for example an object with no active duplicate rule |
