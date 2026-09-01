# Installation

> Install the Nonprofit Cloud Extension package and the two rules that ship alongside it.

Installing takes four steps. Steps 1 and 2 are package installs; steps 3 and 4 add the matching and duplicate rules, which are deliberately **not** in the package so that you can edit them. When the install is done, continue to [Configuration](configuration.md), which is where the extension is actually switched on.

## Before you start

Confirm all four of these. The install will not correct any of them for you.

1. **Nonprofit Cloud is set up in the org, with the Group Membership feature licensed.** Check by opening the App Launcher and searching for **Party Relationship Groups**. If the object is not there, the extension has nothing to write to.
2. **Person Accounts are enabled**, and at least one person account record type is active.
3. **An Account record type exists for households.** Any name works. Naming it `Household` means the packaged configuration will find it with no extra work.
4. **Flow Tool Kit 4.31.0.1 or later is installed.** The extension declares the base package as a dependency, so an older version stops the install with a missing-dependency error.


## Step 1: Install the Flow Tool Kit base package

If the base package is not already installed, or is older than 4.31.0.1, install or upgrade it first using the normal [deployment process](../deployment/deployment-overview.md). The extension will not install on top of an older base version.

## Step 2: Install the extension package

The current released version is **1.2.0.1** (`04tRQ000000AaevYAC`). Open the matching install URL in a browser while logged in to the target org.

**Sandbox and scratch orgs:**

```
https://test.salesforce.com/packaging/installPackage.apexp?p0=04tRQ000000AaevYAC
```

**Production and Developer Edition orgs:**

```
https://login.salesforce.com/packaging/installPackage.apexp?p0=04tRQ000000AaevYAC
```

Choose **Install for Admins Only** unless you have a reason to do otherwise. The conversion flows run in system context under the Automated Process user, so they do not depend on which profiles the package is installed for.

When the install finishes, confirm the flows arrived. In Setup, open **Flows** and filter for `NPC`. You should see nine active flows, all with the `FlowToolKit` namespace.

## Step 3: Add the Person Account matching rule

The extension's Account engine matches returning people against existing Person Accounts. It does that through a matching rule named `NPC_Person_Account_Match`, which is **not packaged**, because a packaged matching rule cannot be edited and matching is exactly the thing most orgs need to tune.

Create it in Setup under **Matching Rules → New Rule**, on the **Person Account** object:

| Setting | Value |
| --- | --- |
| Rule Name | `NPC_Person_Account_Match` |
| Label | NPC Person Account Match |
| Matching criteria | Person Email (Exact), First Name (First Name), Last Name (Exact), Mobile (Phone), Phone (Phone) |
| Logic | `1 OR (2 AND 3 AND (4 OR 5))` |
| Blank value behaviour | Do not match blank values, on every field |

In plain English, that logic reads: **the same email address, or the same name plus either the same mobile or the same phone.** Save the rule, then click **Activate**. Activation is asynchronous and takes a moment.

{% hint style="info" %}
If you deploy metadata rather than clicking through Setup, the rule is in the project at `force-app-npc/main/default/matchingRules/PersonAccount.matchingRule-meta.xml`, and the duplicate rule below sits beside it. Deploy the matching rule first and let it activate, because the duplicate rule references it.
{% endhint %}

## Step 4: Add the duplicate rule

Create a duplicate rule on Person Account named **NPC Person Account Duplicate Rule**, pointing at the matching rule from step 3:

| Setting | Value |
| --- | --- |
| Record-level security | Enforce sharing rules |
| Action on create | **Allow**, with Alert and Report |
| Action on edit | **Allow**, with Report |
| Alert text | A Person Account with this email, or this name and phone, already exists. |

The action must be **Allow**, not Block. The conversion engine reads the matches this rule produces and decides for itself whether to update the person it found; a blocking rule would stop conversions rather than inform them. Users creating Person Accounts by hand still see the alert.

## Step 5: Configure the extension

The package is now installed but not yet doing anything: the conversion pipeline still points at the standard flows. [Configuration](configuration.md) is the step that switches it over, and it is required.

## Installing with CumulusCI

If you work with this project's CumulusCI configuration, the whole install is one command, including the configuration steps on the next page:

```bash
cci flow run npc_conversion_install --org <your-org>
```

That flow installs the latest released base package, installs the pinned extension version, deploys the matching and duplicate rules in the right order, and then runs every post-install configuration step. To build a complete test org from nothing, use `npc_subscriber_install_org` instead, which creates a subscriber-style Nonprofit Cloud org first and then runs the same install on top of it.

{% hint style="warning" %}
`install_npc_conversion` pins a specific package version. After every new extension build, update the pinned `04t` id in `cumulusci.yml` or the flow will keep installing the old version.
{% endhint %}

## Verifying the install

Before moving on, confirm each of these:

- Setup → **Installed Packages** lists both **Flow Tool Kit: Form and Table Builder** (4.31.0.1 or later) and **Flow Tool Kit: AFNP | NPC Extension**.
- Setup → **Flows**, filtered for `NPC`, shows nine flows, all **Active**.
- Setup → **Matching Rules** shows `NPC_Person_Account_Match` as **Active**.
- Setup → **Duplicate Rules** shows **NPC Person Account Duplicate Rule** as **Active**.
