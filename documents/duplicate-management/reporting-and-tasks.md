# Reporting and Tasks

> Turn potential duplicates into a work queue: list views, reports, dashboards and automatic review tasks.

The standard Potential Duplicates card is calculated when a page opens, so there is nothing to report on. The extension stores the answer on the record instead.

## The Potential Duplicates field

Every Account, Contact, Lead and Individual has **Potential Duplicates**: the number of other records that share an open duplicate record set with it, across all duplicate rules, not counting records marked Not a Match.

It is kept current without anyone running anything:

* When Salesforce creates or changes duplicate record sets as records are saved
* When a reviewer marks records Not a Match or merges them
* When a set is deleted, restored from the recycle bin, or changed by hand
* After every rebuild

The value is blank on records that have never had a potential duplicate, and 0 on records whose duplicates have all been resolved. Filter on **greater than 0** to catch both.

## List views

Create a list view on Contacts (or Accounts, Leads) with the filter **Potential Duplicates greater than 0**, and add the field as a column sorted high to low. Data stewards open each record and use the banner's **Review** button.

## Reports and dashboards

Use the standard report types for the object, for example **Contacts & Accounts**, and filter or group by Potential Duplicates. Useful dashboard components:

* Records with potential duplicates, by record owner
* Records with potential duplicates, created this month
* Total potential duplicates over time, using a reporting snapshot

For detail on the sets themselves, create a custom report type on **Duplicate Record Sets** with **Duplicate Record Items**. The extension adds:

| Field | On | Use it to |
| --- | --- | --- |
| **Match Status** | Duplicate Record Set | Separate open sets (Potential Match) from decisions (Not a Match) |
| **Last Matched Date** | Duplicate Record Set, Duplicate Record Item | See when a rebuild last confirmed the match |
| **Matching Rules** | Duplicate Record Item | See which matching rules found the record |
| **Match Confidence** | Duplicate Record Item | Prioritize the strongest matches |

## Create review tasks automatically

A record-triggered flow can assign a task the moment a record gets potential duplicates:

1. Create a **Record-Triggered Flow** on Contact, triggered when a record is updated, running **after save**.
2. Set the entry condition to **Potential Duplicates greater than 0**, and choose **Only when a record is updated to meet the condition requirements**, so the task is created once rather than on every edit.
3. Add a **Create Records** element for a **Task**: subject "Review potential duplicates", **Related To** the contact, **Assigned To** your data steward or a queue, due in a few days.
4. Activate the flow.

When the steward resolves the duplicates, the number returns to 0. A second flow, or the same flow with a decision, can close the open task when that happens.

The same pattern works for Accounts and Leads, and a scheduled flow can instead send each owner a weekly digest of their records with potential duplicates.
