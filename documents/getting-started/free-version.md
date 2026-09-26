# Free Version

> What the free version of Flow Tool Kit includes, and how its Form Submission allowance works.

## Who Runs the Free Version

The free version is set per org by Common-Unite. Sandboxes, scratch orgs and Developer Edition orgs always run without limits, so you can build and demo everything before going live.

## What It Includes

Forms and form components work on these objects:

| Object | |
| --- | --- |
| Account, Contact, Lead, Case | Standard objects |
| Campaign, Campaign Member | Standard objects |
| Form Submission, Form Template, Form Page, Form Page Section, Survey Response | Flow Tool Kit objects |

A form built on any other object shows "Object Is Not Available Within the Free Version". Site Design Blocks work on Account, Contact, Case, Lead and Form Template records, and show a "Not available in free version" notice on other records.

## Form Submission Allowance

A free org can create a set number of Form Submissions in each window.

| | Allowance | Window |
| --- | --- | --- |
| **Default** | 25 Form Submissions | Each calendar month, from 12:00 AM on the 1st to midnight at the end of the last day |
| **Annual allowance** (granted on request) | The number granted, often 100 | The org's fiscal year, from 12:00 AM on its first day to midnight at the end of its last day |

When an annual allowance is granted, it replaces the monthly one. Contact Common-Unite support to ask for one. Both windows follow the org's time zone and its fiscal year settings, standard or custom.

### What counts

- **A submission counts when it is created**, whether or not it is ever submitted. Autosave and Save Progress count once, when they first create the record; resuming or submitting later does not count again.
- **Pre-fill templates never count.**
- **Rows from tables, repeaters and section flows never count.** These are the related records a form creates under its main submission.
- **Deleting submissions does not give the allowance back.** The count is kept separately from the records.

### When the allowance is used up

Creating another Form Submission fails with a message that names the limit, for example "Flow Tool Kit limit: the free version allows 25 Form Submissions per month. Contact support to increase your limit." The count starts again at zero when the next window begins, or when an annual allowance is granted or removed.

{% hint style="info" %}
The count updates a few seconds after each submission is saved. Two submissions saved at the same moment can both be accepted when only one remains in the allowance.
{% endhint %}

## Related

* [Installation](installation.md)
* [Permission Sets](permission-sets.md)
