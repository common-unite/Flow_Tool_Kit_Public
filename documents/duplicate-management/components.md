# Components

> Everything the extension installs, where each piece is used, and who needs access to it.

The extension is free and needs nothing paid. Everything below runs on standard Salesforce and the free Flow Tool Kit base package. Because the review is an overridable flow, you can also add paid or third-party screen components to your own version of it.

## Lightning component

### Duplicate Matches

A banner for Lightning record pages that replaces the standard **Potential Duplicates** card.

| | |
| --- | --- |
| **Where** | Account, Contact, Lead and Individual record pages, and custom objects that have the Potential Duplicates field (see [Custom objects](#custom-objects)) |
| **Shows** | "We found N potential duplicates of this Contact" and a **Review** button, only when the record's Potential Duplicates number is above 0 |
| **Review** | Opens **Review Possible Duplicates** in a window over the page, passing the record Id and object |
| **After the review** | Refreshes the page; after a merge it opens the surviving record and refreshes again until the new count arrives |
| **Setup** | [Add the Duplicate Matches banner](setup.md#add-the-duplicate-matches-banner) |

It reads the count through Lightning Data Service, so it costs no Apex call and no duplicate search when a page opens.

## Flows

### (Duplicate) Rebuild Duplicate Record Sets

A screen flow for admins. It picks an object and, optionally, some of its duplicate rules, and starts a rebuild. Run it from Setup, **Flows**, or add it to an app page or the utility bar. See [Rebuilding Duplicate Record Sets](rebuilding-duplicate-sets.md).

### (Duplicate) Review Possible Duplicates | Overridable

The screen flow behind the banner's **Review** button. It lists the record's open potential duplicates, and for the selected ones it records a **Not a Match** decision or runs a household-aware **merge**. It handles Accounts, Contacts, Leads and Individuals, and it is overridable so you can change it without code. See [Reviewing and Merging](reviewing-and-merging.md) and [Customizing the Review](customizing-the-review.md).

It uses two components from the base package: the **Merge Records** screen component for the side-by-side comparison, and the **Merge Records** action for the merge itself.

## Flow action

### Reprocess Duplicate Rules

Starts a rebuild for one object. The rebuild flow uses it, and you can call it from your own flows: a schedule-triggered flow for a nightly rebuild, or the end of a data import. Inputs and outputs are listed in [Customizing the Review](customizing-the-review.md#rebuild-in-your-own-automation).

Everything else the extension does happens in its triggers and background jobs, which you do not call. [How It Works](how-it-works.md) describes each one.

## Fields

| Field | On | Purpose |
| --- | --- | --- |
| **Potential Duplicates** (`cUnite_Potential_Duplicates__c`) | Account, Contact, Lead, Individual | How many other records share an open duplicate record set with this one. Read-only, kept current automatically. |
| **Match Status** (`cUnite_Match_Status__c`) | Duplicate Record Set | **Potential Match** (the default) or **Not a Match**, the reviewer's decision |
| **Last Matched Date** (`cUnite_Last_Matched_Date__c`) | Duplicate Record Set, Duplicate Record Item | When a rebuild last confirmed the match |
| **Matching Rules** (`cUnite_Matching_Rules__c`) | Duplicate Record Item | Which matching rules found this record |
| **Match Confidence** (`cUnite_Match_Confidence__c`) | Duplicate Record Item | The highest confidence Salesforce reported for the match |

The `cUnite_` prefix on the API names keeps these fields apart from any field your org already has with a similar name.

### Custom objects

Rebuilds and Not a Match work on any object with a duplicate rule, custom objects included. To give a custom object the count and the banner too, create a **Number** field on it, with 0 decimal places, named **`cUnite_Potential_Duplicates__c`** (recommended) or **`Potential_Duplicates__c`**. Then run a rebuild for the object.

The extension uses the first of these it finds on an object, in this order:

1. The packaged **Potential Duplicates** field, on Account, Contact, Lead and Individual
2. Your own `cUnite_Potential_Duplicates__c`
3. Your own `Potential_Duplicates__c`

Only a Number field that is not a formula is used. If you already have an unrelated field called `Potential_Duplicates__c` on an object, name the new one `cUnite_Potential_Duplicates__c` so it is picked first.

The packaged review lists and merges Accounts, Contacts, Leads and Individuals. For a custom object, add a branch for it in your override of the review flow; see [Customizing the Review](customizing-the-review.md#ideas-for-your-override).

## Permission sets

| Permission set | Assign to | Why |
| --- | --- | --- |
| **Flow Tool Kit: Duplicate Management Admin** | The admins and data stewards who run rebuilds, and who should also have **View All Data** | Grants the rebuild flow and action, and edit access to every extension field, which the rebuild writes. A rebuild only searches records its user can see, so pair it with View All Data. |
| **Flow Tool Kit: Duplicate Management Reviewer** | Everyone who reviews duplicates from record pages | Grants the review flow, read access to the fields, and edit access to **Match Status**. It does not grant delete on duplicate record sets, so unless a profile grants it, reviewers can create Not a Match decisions but cannot undo them. |

**Nobody else needs either permission set.** Users, guest users and portal users who only create and edit records need nothing from the extension. When they save a record, Salesforce itself creates any duplicate record sets in the background, and the extension's triggers keep the sets and counts right from there. Triggers do not need Apex class access, and the counts are written in system mode so that no field permissions are needed. See [How It Works](how-it-works.md).

A reviewer merges records with their own access, like any Salesforce merge: they need edit and delete access to the records they merge.
