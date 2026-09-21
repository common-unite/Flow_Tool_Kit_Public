# Reviewing and Merging

> What reviewers see on a record page, and what each decision does.

## The banner

When a record shares an open duplicate record set with other records, the **Duplicate Matches** banner appears at the top of the page: "We found 2 potential duplicates of this Contact", with a **Review** button. It counts records, not sets, so a record matched by two rules is counted once, and records marked Not a Match are not counted at all.

## The review

**Review** opens the review flow in a window over the page. It works on Accounts, Contacts, Leads and Individuals. It lists the potential duplicates with their key details, and the reviewer selects up to two of them and chooses what should happen.

### Not a Match

Choose **Not a Match: they are different from this record** when the selected records are different people or organizations. For each selected record, the review records a decision against the record the reviewer started from. The decision is a duplicate record set with Match Status **Not a Match**.

From then on:

* The pair no longer appears in the banner or its count, for anyone.
* Any other open set holding the pair is split so the two records are never grouped together again.
* Rebuilds skip the pair.
* When Salesforce later adds new records to the Not a Match set, they are removed, so the decision always covers exactly the records that were reviewed.

The decision is about the pair only. If one of the records is a genuine duplicate of a third record, that match is still shown.

### Deciding a whole set at once

Match Status is a field on the duplicate record set, so an admin or data steward can also decide a whole set from the Duplicate Record Set record: set **Match Status** to **Not a Match**, and every pair in the set is rejected. Three records make three pairs, four make six.

When a set holds some real duplicates and some records that only look alike, work in this order:

1. **Merge the records that are the same person.** The survivor stays in the set.
2. **Then set Match Status to Not a Match** on the set. What is left, the survivor and the others, are now recorded as different from each other.

Marking first and merging afterwards also works, because a merge moves the merged record's place in the set to the survivor, but merging first keeps the decision easy to read.

To undo a decision, delete the Not a Match duplicate record set. The next rebuild, or the next save of either record, finds the pair again.

### Merge

Choose **Merge: they are the same as this record** to combine the selected records with this one. The compare screen shows every field where the records differ, side by side:

* The record you started from is listed first and is the principal by default. Pick **Use as principal** on another column to keep that record instead.
* For each field, pick the value to keep. **Select All** takes every value from one record.

**Next** runs a standard Salesforce merge: the other records are merged into the principal, and their related records move to it. If the record you were on was merged away, the page opens the surviving record. The banner updates within a few seconds as the counts are recalculated.

## Households are merged first

When the contacts being merged belong to different household accounts, merging the contacts alone would leave a household behind: an account with fewer members, or none at all, and its name, greeting and address details orphaned.

So the review merges the households first:

1. It shows the household compare screen, with the household of the contact you started from as the principal, and says how many members of the other household will move.
2. **Next** merges the households. Every member of the other household moves into the principal household.
3. The review goes straight on to the contact compare screen, and the contacts are merged within the same household.

The household merge is saved before the contact compare screen opens, so household automation, such as NPSP's household naming and rollups, is started by the household merge exactly as it would be for a household merged by hand.

## After a merge

Salesforce leaves duplicate record sets behind when records are merged. Depending on the set, it either deletes the merged record's entry or moves it to the surviving record, and a set can end up holding a single record. The extension cleans this up automatically in the background: sets with fewer than two records are deleted and the counts of everyone involved are recalculated. Nothing needs to be run by hand.
