# Setup

> Put the banner on your record pages, set your duplicate rules to report, and add a strong exact-match rule.

## Add the Duplicate Matches banner

Do this for each record page where users should see potential duplicates: Account, Contact, Lead, Individual, and any custom object you have opted in (see [Components](components.md#custom-objects)).

1. Open a record, click the gear icon, and choose **Edit Page**.
2. Remove the standard **Potential Duplicates** component. Leaving it on the page brings back the warnings your reviewers have already dismissed, because it searches live and ignores Not a Match decisions.
3. Drag **Duplicate Matches** from the Custom - Managed list to the top of the main column.
4. With the banner selected, click **Add Filter** under **Set Component Visibility**, choose **Record Field**, pick **Potential Duplicates**, and set the filter to **Greater than 0**.
5. **Save** and activate the page.

The banner reads the record's Potential Duplicates number and hides itself at zero, so the visibility filter is not required for it to work. The filter keeps the page tidy: without it, Lightning still reserves a small gap for the hidden component. The banner removes that gap itself, but the filter is the platform's own way to leave a component out of the page entirely, so use it where you can. It also updates without a page reload when the number changes.

{% hint style="info" %}
The banner shows "We found N potential duplicates of this Contact" and a **Review** button. After a merge it refreshes itself, and when the record the user was on has been merged away it opens the surviving record.
{% endhint %}

## Recommended duplicate rules

### Report, do not alert

For each duplicate rule, open it in Setup and set **Action On Create** and **Action On Edit** to **Allow**, with **Report** checked and **Alert** unchecked.

* **Report** makes Salesforce create duplicate record sets the moment a record is saved, so new duplicates reach the banner between rebuilds.
* **Alert** shows Salesforce's own save-time warning. That warning runs your matching rules live and ignores Not a Match decisions, so users would be warned about pairs your reviewers already cleared. The banner replaces it.

### Bypass sharing rules when the public creates records

Each duplicate rule has a **Record-Level Security** setting. With **Enforce sharing rules**, Salesforce only compares a new record with records the saving user can see. Guest users on a public site, and most portal users, cannot see your other records, so their saves find no duplicates and no duplicate record set is created.

If records arrive from public forms, sites or portals, set **Record-Level Security** to **Bypass sharing rules** on your duplicate rules. The comparison then covers every record, while the saving user still sees nothing they could not see before. In testing, a guest who submitted a contact matching an existing one produced a duplicate record set within seconds with Bypass, and none at all with Enforce. A [rebuild](rebuilding-duplicate-sets.md) run by an admin also finds these pairs whichever setting you choose.

### Add an exact-match rule on a strong identifier

Salesforce keeps up to 100 candidates per duplicate search. The standard matching rules start their search from the name, so in a large org where many records share a surname, some genuine pairs never make the candidate list. In testing on 100,000 contacts where names were crowded, the standard rule missed up to a third of the pairs in the most crowded groups.

A second matching rule that matches **Email** exactly, with its own duplicate rule set to report, found every one of those pairs, with no false matches. Other strong identifiers work the same way: a constituent ID, a tax ID for organizations. Each rule gets its own duplicate record sets, and the banner counts a record once however many rules find it.

After adding or changing a rule, [rebuild](rebuilding-duplicate-sets.md) so existing records are checked against it.

## Show the number on list views and layouts

**Potential Duplicates** is read-only and kept current automatically. Add it to list views and reports so stewards can work through a queue. [Reporting and Tasks](reporting-and-tasks.md) has examples. You can also add it to page layouts, but the banner already says the same thing more clearly.

## Households

The review merges household accounts before contacts when the contacts belong to different households. It recognizes households by the Account record type developer name **HH_Account**, which is the NPSP household record type. If your households use a different record type, see [Customizing the Review](customizing-the-review.md#household-record-type). Orgs without that record type skip the household step.
