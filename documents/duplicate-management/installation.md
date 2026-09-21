# Installation

> Install the extension, assign its two permission sets, and run your first rebuild.

## Before you start

1. **Flow Tool Kit 4.37 or later is installed.** The extension is built on the base package's merge component and Merge Records action.
2. **At least one duplicate rule is active** on each object you want to manage. Check in Setup, **Duplicate Rules**. The extension works from your rules and ships none of its own.
3. **You know who will run rebuilds.** A rebuild searches only the records its user can see, so it is run by an admin with **View All Data**.

## Step 1: Install the package

Install the **Flow Tool Kit: Duplicate Management** package from the install link published in the release notes for the current version. Open the link while logged in to the target org, and use a sandbox first.

Choose **Install for Admins Only**. Access for everyone else comes from the permission sets in step 2.

When the install finishes, open Setup, **Flows**, and confirm two active flows with the `FlowToolKit` namespace:

* **(Duplicate) Rebuild Duplicate Record Sets**
* **(Duplicate) Review Possible Duplicates | Overridable**

## Step 2: Assign the permission sets

| Permission set | Assign to | Grants |
| --- | --- | --- |
| **Flow Tool Kit: Duplicate Management Admin** | Admins and data stewards who run rebuilds | The rebuild flow and action, and edit access to Match Status, Last Matched Date and the match details on duplicate record items |
| **Flow Tool Kit: Duplicate Management Reviewer** | Everyone who reviews and merges duplicates from record pages | The banner and the review flow, and permission to mark sets Not a Match |

Reviewers also need their normal permission to edit and delete the records they merge. Merging is a standard Salesforce merge and follows the user's own access.

## Step 3: Run your first rebuild

Your existing duplicate record sets were created under whatever rules were active when each record was saved. Rebuild once per object so every set reflects your current rules and every record gets its Potential Duplicates number:

1. In Setup, open **Flows**, then **(Duplicate) Rebuild Duplicate Record Sets**, and click **Run**.
2. Choose the object, leave the rule boxes unchecked to rebuild every active rule, and click **Next**.

The rebuild runs in the background. Details are in [Rebuilding Duplicate Record Sets](rebuilding-duplicate-sets.md).

Continue to [Setup](setup.md) to put the banner on your record pages.
