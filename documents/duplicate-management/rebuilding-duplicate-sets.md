# Rebuilding Duplicate Record Sets

> Change a rule, rebuild, and trust your duplicate record sets again.

## When to rebuild

Salesforce checks for duplicates only when a record is saved. Rebuild an object whenever the answer to "which of my existing records match?" may have changed:

* After you create, edit, activate or deactivate a **matching rule** or **duplicate rule**
* After a data import or migration that loaded records without duplicate rules running
* After installing the extension, so every record gets its Potential Duplicates number
* On a schedule, if records often change in ways that affect matching

## Run a rebuild

1. In Setup, open **Flows**, then **(Duplicate) Rebuild Duplicate Record Sets**, and click **Run**. You can also add the flow to a Lightning app page or the utility bar for your data stewards.
2. Choose the **object**. The list shows every object with an active duplicate rule.
3. Choose which **duplicate rules** to rebuild, or leave them all unchecked to rebuild every active rule for that object.
4. Click **Next**. The flow confirms that the rebuild started and shows its job Id.

Follow progress in Setup, **Apex Jobs**. Allow about 10 minutes per 100,000 records.

{% hint style="warning" %}
Run rebuilds as a user with **View All Data**. A rebuild searches only records its user can see, and it skips the cleanup when the user cannot see every record, so that nothing is removed on the basis of an incomplete search.
{% endhint %}

## What a rebuild does

For every record of the object, the rebuild asks Salesforce which records it matches under each chosen duplicate rule, the same search Salesforce runs when a record is saved. Then it brings your duplicate record sets in line with the answer:

| Situation | Result |
| --- | --- |
| A pair matches and no set holds it | A new set is created for the pair, in the same shape Salesforce uses |
| A pair matches and an open set already holds it | The set is kept and its **Last Matched Date** is updated |
| A record matches records in several open sets for the same rule | The sets are combined into one, like Salesforce does |
| The pair was marked **Not a Match** | Skipped; no set is ever created for it |
| An open set, or a record in one, no longer matches | Removed when the run finishes (see below) |

Each duplicate record item records which matching rules found it and the match confidence, so you can see why records were grouped. A rerun over unchanged data creates nothing new.

### The cleanup at the end of the run

Removing what the rules no longer find waits until the whole run has finished. Salesforce's matching is not always symmetric: in a large org one record's search can miss a partner whose own search finds it. The rebuild counts a pair as a match when either record's search finds the other, so it can only know a pair is gone once every record has been searched.

When the run finishes, a short cleanup pass goes through the open sets of the rebuilt rules:

* Records the run did not confirm are removed from their sets.
* Sets left with fewer than two records are deleted.
* Everyone affected gets their Potential Duplicates number recounted.

The cleanup never touches:

* **Not a Match sets.** Your decisions are kept.
* **Sets of rules you did not rebuild.**
* **Sets and records added while the rebuild was running**, such as a record a user saved in the meantime.
* **Anything, if any part of the run failed.** Records in a failed part were never searched, so nothing is removed until a clean run.

In testing on 100,000 contacts with 20,000 existing sets, the cleanup finished in 16 seconds and removed exactly the sets whose records had stopped matching.

## Rebuild on a schedule

To rebuild nightly or weekly without anyone running the flow:

1. Create a **Schedule-Triggered Flow** and set the frequency and start time.
2. Add an **Action** element, search for **Reprocess Duplicate Rules**, and set **Object API Name**, for example `Contact`. Leave **Duplicate Rule Name(s)** blank for every active rule, or list developer names separated by semicolons.
3. Activate the flow.

After the first scheduled run, open Setup, **Apex Jobs**, and confirm that a **DuplicateSweep_Batch** job followed the **DuplicateReprocess_Batch** job. If it did not, the user the schedule runs as does not have View All on the object, so the rebuild created and confirmed sets but skipped the cleanup.

The same action can be called from any flow, for example after a data import completes.
