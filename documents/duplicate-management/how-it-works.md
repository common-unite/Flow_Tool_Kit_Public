# How It Works

> What happens, step by step, each time a duplicate record set is created, decided, merged or rebuilt, so you know where your own automation fits.

This page is for admins and developers who want to add their own flows or triggers around duplicate management. It describes the logic and the reasons for it. You never call any of this directly: it runs from Salesforce's own duplicate processing, the extension's triggers on **Duplicate Record Set** and **Duplicate Record Item**, and the rebuild.

## The two rules everything follows

1. **Duplicate record sets are the single source of truth.** The banner, the count, the review and the rebuild all read the sets. Nothing re-runs matching rules on page load.
2. **A Not a Match set is a permanent decision.** The extension never deletes one and never adds records to one. Rebuilds and the cleanup skip them entirely. The only change the extension ever makes to a Not a Match set is to remove records Salesforce adds to it later, so the decision keeps covering exactly the records that were reviewed.

## When a record is saved

This path runs for every user who creates or edits a record, including guest and portal users, with no permissions from the extension.

1. The user saves the record. If a duplicate rule has **Report** checked and the record matches others, Salesforce creates a duplicate record set, or adds the record to an existing set for that rule. It does this after the save, in the background, as the **Automated Process** user.
2. The extension's trigger on **Duplicate Record Item** runs for the new items:
   * **Records added to a Not a Match set are removed.** Salesforce adds new matches into every existing set for the rule, including decided ones. Removing them keeps the decision exact.
   * **Open sets that now hold a rejected pair are split.** If a set holds two records someone marked Not a Match, it is split into the largest groups that do not contain a rejected pair, and a group already covered by another set is not duplicated. This is the same grouping a rebuild uses.
   * **Counts are recalculated** for every record in the affected sets.

Because Salesforce does this work in the background, the Potential Duplicates number updates a few seconds after the save, not during it.

The saving user needs nothing from the extension: tested with a guest user on a public site, Salesforce created the set as Automated Process and the extension's trigger counted it there. What the saving user does affect is the match itself. A duplicate rule that enforces sharing only compares the new record with records that user can see, which for a guest is none; see [Setup](setup.md#bypass-sharing-rules-when-the-public-creates-records).

## When a reviewer marks records Not a Match

1. For each selected record, the review flow creates a duplicate record set with Match Status **Potential Match** and adds the two records to it: the record the review started from and the selected one.
2. It then changes the set's Match Status to **Not a Match**. The set is created open and changed afterwards on purpose: records added to a set that is already Not a Match are removed by the rule above.
3. The trigger on **Duplicate Record Set** sees the change to Not a Match. It splits every open set that holds the pair and deletes any that are left with fewer than two records, then recounts everyone involved.

## When records are merged

1. The review flow runs a standard Salesforce merge through the Merge Records action. For contacts in different households, it merges the household accounts first, in their own transaction, then the contacts.
2. Salesforce updates the duplicate record items of the record that was merged away. Where the surviving record is already in the set, the merged record's item is deleted. Where it is not, the item is moved to the surviving record.
3. The item deletion fires the extension's trigger, which queues a short background job. It is queued because Salesforce saves the surviving record after the trigger runs, so a count written during the merge would be overwritten.
4. The job deletes open sets left with fewer than two records and recounts everyone involved, including the surviving record. Not a Match sets are never deleted here: if one of its records is merged away or deleted, the decision stays in place in case the record is restored.
5. The banner on the surviving record checks every second for the new count and updates within a few seconds.

## When a set is deleted, restored or edited by hand

* **Deleted:** Salesforce deletes the set's items without firing their triggers, so the extension notes the set's members just before the delete and recounts them just after.
* **Restored from the recycle bin:** the members are recounted.
* **Match Status changed to Not a Match by hand:** the same as a reviewer's decision.
* **Match Status changed back to Potential Match:** the decision is withdrawn and the set is an open potential duplicate again, so the records' counts and banners update straight away.
* **A Not a Match set deleted:** the decision is withdrawn. The next rebuild, or the next save of either record, finds the pair again.

## When a rebuild runs

1. **The rebuild batch** takes the object's records 200 at a time. For each batch it:
   * Asks Salesforce's duplicate search which records match, under each chosen duplicate rule.
   * Drops pairs marked Not a Match on any rule for the object.
   * Groups the matches with the open sets that already hold those records, the way Salesforce shapes its own sets, splitting around rejected pairs.
   * Creates sets for new groups, joins records to existing ones, and combines open sets that turn out to hold one group.
   * Stamps **Last Matched Date** on each confirmed set and each confirmed record's item, and records the matching rules and confidence.
   * Recounts everyone affected.
2. **When every batch has finished**, the rebuild checks that no batch failed and that the user has View All on the object. If both are true, it starts the cleanup.
3. **The cleanup** reads the open sets of the rebuilt rules that existed before the rebuild started. It removes items the rebuild did not stamp, deletes sets left with fewer than two records, and recounts. It never reads Not a Match sets, sets of other rules, or anything created during the rebuild.

The cleanup waits for the end of the run because Salesforce's matching is not always symmetric: one record's search can miss a partner whose own search finds it. A pair is kept if either side found it anywhere in the run.

## Adding your own automation

* **Record-triggered flows and Apex triggers** can run on Duplicate Record Set and Duplicate Record Item alongside the extension's triggers. Salesforce does not guarantee the order in which several triggers on one object run, so do not rely on the extension's changes being there already. React to the change you care about, such as Match Status becoming Not a Match.
* **To react to records gaining or losing potential duplicates**, trigger on the record's **Potential Duplicates** field instead, for example a record-triggered flow on Contact when the value becomes greater than 0. It is the extension's final answer, written after the sets are settled. See [Reporting and Tasks](reporting-and-tasks.md#create-review-tasks-automatically).
* **To change what happens during a review**, override the review flow. See [Customizing the Review](customizing-the-review.md).
* **To rebuild from your own processes**, call the **Reprocess Duplicate Rules** action.
* **Leave the Match Status values as they are.** The extension looks for the exact value **Not a Match**. You can add values, but renaming or removing either packaged value would stop decisions from being recognized.
