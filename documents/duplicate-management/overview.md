# Duplicate Management Extension

> Keep your duplicate record sets accurate after every rule change, remember which records are not duplicates, and give users one clear place to review and merge.

{% hint style="info" %}
The Duplicate Management Extension is free. It runs on standard Salesforce and the free Flow Tool Kit base package, with no paid components required. If you do use paid or third-party screen components, you can add them to your own version of the review flow.
{% endhint %}

## Why install it

Salesforce duplicate management gives you matching rules, duplicate rules, duplicate record sets and a Potential Duplicates card on record pages. Anyone who has run it for a while has hit the same five problems. This extension solves each of them.

### 1. Changing a rule leaves your duplicate record sets out of date

Duplicate rules run when a record is saved. When you create a matching rule, tighten one, or activate a new duplicate rule, Salesforce does not go back and check the records you already have. Your existing duplicate record sets keep describing the old rules: pairs the new rule would find are missing, and pairs it no longer finds stay flagged.

Salesforce's own answer is **Duplicate Jobs**, which re-check existing records. Duplicate Jobs are available only in **Performance and Unlimited Editions**, and only for business accounts, person accounts, contacts and leads. Most nonprofit orgs, including NPSP orgs on the Power of Us program, run Enterprise Edition and do not have them.

**With this extension**, you change your rules, run **Rebuild Duplicate Record Sets**, and every active duplicate rule for that object is re-run against every existing record, in any edition, on any object that has a duplicate rule. Sets are created for new matches, confirmed for matches that still hold, and removed when the rules no longer find them. See [Rebuilding Duplicate Record Sets](rebuilding-duplicate-sets.md).

### 2. There is no way to say "these are not duplicates"

Two records can share a name, an address and a phone number and still be different people: a parent and an adult child living together, two branches of the same organization. Standard duplicate management has no way to record that decision. You can delete the duplicate record set, but the next time either record is saved Salesforce creates it again, and when it finds a new match it adds records back into the existing set.

**With this extension**, a reviewer marks the pair **Not a Match** once, and it stays decided:

* Rebuilds skip the pair.
* When Salesforce creates a set that puts the pair together again, the extension splits it.
* When Salesforce adds new records to a set someone marked Not a Match, the extension removes them, so the decision always covers exactly the records that were reviewed.

See [Reviewing and Merging](reviewing-and-merging.md#not-a-match).

### 3. The standard Potential Duplicates card ignores your decisions

The standard card runs your matching rules live every time a record page opens. It does not read duplicate record sets, so it knows nothing about a pair you marked as different people or a set you cleaned up. If the matching rule says two records match, users see the warning on that record forever, which is exactly the confusion you were trying to remove.

**With this extension**, you replace the standard card with the **Duplicate Matches** banner. It reads the duplicate record sets, so a Not a Match decision disappears from the page for every user, and the banner only appears when there is something left to review. See [Setup](setup.md#add-the-duplicate-matches-banner).

### 4. You cannot report on potential duplicates

Because the standard card is calculated on page load, there is nothing to filter a list view on, nothing to put on a dashboard, and nothing to trigger a task for the person who should clean up.

**With this extension**, every Account, Contact, Lead and Individual, and any custom object you opt in, carries a **Potential Duplicates** number: how many other records still share an open duplicate record set with it. It is a real field, kept current automatically, so list views, reports, dashboards and record-triggered flows all work with it. A flow can assign a review task to a data steward the moment the number goes above zero. See [Reporting and Tasks](reporting-and-tasks.md).

### 5. Merging should follow your process, not a fixed screen

When the banner shows duplicates, **Review** opens a packaged screen flow, and it is overridable. Out of the box it lists the potential duplicates, lets the reviewer mark them Not a Match or compare and merge them field by field with Flow Tool Kit's merge component, and handles households properly: when contacts belong to different household accounts, it merges the households first so no household is left behind without members, then merges the contacts.

Because the review is a Flow, you can add your own steps before or after the merge. For example, you might list the merged contact's affiliations and let the reviewer remove or combine them, or update a related record. You do not need Apex or Visualforce for any of it. See [Customizing the Review](customizing-the-review.md).

## What is included

| Component | What it does |
| --- | --- |
| **Rebuild Duplicate Record Sets** screen flow | Re-runs the duplicate rules of one object against every existing record, then removes sets the rules no longer find |
| **Reprocess Duplicate Rules** Flow action | The same rebuild, for your own flows, such as a nightly schedule-triggered flow |
| **Duplicate Matches** banner | Lightning record page component that replaces the standard Potential Duplicates card |
| **Review Possible Duplicates** screen flow | Overridable review: Not a Match, compare and merge, household-first merge |
| **Potential Duplicates** field | On Account, Contact, Lead and Individual, and any custom object you add it to; kept current automatically |
| **Match Status** and **Last Matched Date** | On Duplicate Record Set (and Last Matched Date on Duplicate Record Item): the Not a Match decision and when a rebuild last confirmed the match |
| Two permission sets | **Duplicate Management Admin** (rebuilds) and **Duplicate Management Reviewer** (banner and review) |

Each piece is described in [Components](components.md), and [How It Works](how-it-works.md) walks through what happens behind the scenes.

## Things to know

* **Matching is as complete as Salesforce's matching engine.** Salesforce keeps up to 100 candidates per duplicate search. When many records share the start of a name, such as a common surname in a large org, some real pairs can fall outside those 100 and are not found by Salesforce's rules or by a rebuild. An exact-match rule on a strong identifier such as email closes that gap. See [Setup](setup.md#recommended-duplicate-rules).
* **Rebuilds run in the background.** Allow about 10 minutes per 100,000 records.
* **The standard save-time alert still ignores Not a Match.** If a duplicate rule is set to Alert, Salesforce shows its own warning when a record is saved, whatever you decided. Set your duplicate rules to report rather than alert. See [Setup](setup.md#recommended-duplicate-rules).
* **The packaged review merges Accounts, Contacts, Leads and Individuals.** Rebuilds, Not a Match, the count and the banner work on any object with a duplicate rule; see [Components](components.md#custom-objects).

## Requirements

| Requirement | Why |
| --- | --- |
| Flow Tool Kit 4.37 or later | The review uses the base package's merge component and Merge Records action |
| At least one active duplicate rule | Rebuilds and the review work from your duplicate rules; the extension ships none of its own |
| Admins who run rebuilds need View All Data | A rebuild only sees records the running user can see, and it skips the cleanup without View All |

Continue to [Installation](installation.md).
