# Installation

> Install the Nonprofit Cloud Extension package and the two rules that ship alongside it.

Installing takes four steps. Steps 1 and 2 are package installs; steps 3 and 4 activate Salesforce's standard Person Account matching and duplicate rules, which ship in every Person Accounts org but arrive switched off - and only a Setup click can switch them on. When the install is done, continue to [Configuration](configuration.md), which is where the extension is actually switched on.

## Before you start

Confirm all four of these. The install will not correct any of them for you.

1. **Nonprofit Cloud is set up in the org, with the Group Membership feature licensed.** Check by opening the App Launcher and searching for **Party Relationship Groups**. If the object is not there, the extension has nothing to write to.
2. **Person Accounts are enabled**, and at least one person account record type is active.
3. **An Account record type exists for households.** Any name works. Naming it `Household` means the packaged configuration will find it with no extra work.
4. **Flow Tool Kit 4.31.0.1 or later is installed.** The extension declares the base package as a dependency, so an older version stops the install with a missing-dependency error.


## Step 1: Install the Flow Tool Kit base package

If the base package is not already installed, or is older than 4.31.0.1, install or upgrade it first using the normal [deployment process](../deployment/deployment-overview.md). The extension will not install on top of an older base version.

## Step 2: Install the extension package

The current released version is **1.5.0.1** (`04tRQ000000AcFJYA0`). Open the matching install URL in a browser while logged in to the target org.

**Sandbox and scratch orgs:**

```
https://test.salesforce.com/packaging/installPackage.apexp?p0=04tRQ000000AcFJYA0
```

**Production and Developer Edition orgs:**

```
https://login.salesforce.com/packaging/installPackage.apexp?p0=04tRQ000000AcFJYA0
```

Choose **Install for Admins Only** unless you have a reason to do otherwise. The conversion flows run in system context under the Automated Process user, so they do not depend on which profiles the package is installed for.

When the install finishes, confirm the flows arrived. In Setup, open **Flows** and filter for `NPC`. You should see nine active flows, all with the `FlowToolKit` namespace.

## Step 3: Activate the Standard Person Account Matching Rule

The extension's Account engine matches returning people against existing Person Accounts through Salesforce's own **Standard Person Account Matching Rule** (`Standard_PersonAccount_Match_Rule_v1_0`). Every Person Accounts org already has it - but Salesforce ships it **inactive**, and no API or metadata deploy can activate a standard rule, so this is a required click even for fully metadata-driven installs:

1. **Setup → Matching Rules**
2. Find **Standard Person Account Matching Rule** and click **Activate**. Activation is asynchronous and takes a moment.

It matches on name plus a confirming field (email, phone or address), so family members who share one email address stay separate people - which is exactly what household intake needs.

## Step 4: Activate the Standard Person Account Duplicate Rule

The engine reads its matches through the matching rule's duplicate rule, which also ships inactive:

1. **Setup → Duplicate Rules**
2. Find **Standard Person Account Duplicate Rule** and click **Activate**. Salesforce requires the matching rule from step 3 to be active first.

Leave its actions on **Allow** (the shipped default). The conversion engine reads the matches this rule produces and decides for itself whether to update the person it found; a blocking rule would stop conversions rather than inform them.

{% hint style="info" %}
Orgs that installed an earlier extension version created a custom `NPC_Person_Account_Match` rule pair by hand. Those keep working unchanged - the engine names both rules and matches through whichever is active. New installs need only the standard rules above.
{% endhint %}

## Step 5: Configure the extension

The package is now installed but not yet doing anything: the conversion pipeline still points at the standard flows. [Configuration](configuration.md) is the step that switches it over, and it is required.

## Installing with CumulusCI

If you work with this project's CumulusCI configuration, the whole install is one command, including the configuration steps on the next page:

```bash
cci flow run npc_conversion_install --org <your-org>
```

That flow installs the latest released base package, installs the pinned extension version, and runs every post-install configuration step. It does not activate the standard Person Account matching and duplicate rules - no API can, so activate them in Setup (steps 3 and 4 above) before converting. To build a complete test org from nothing, use `npc_subscriber_install_org` instead, which creates a subscriber-style Nonprofit Cloud org first and then runs the same install on top of it.

{% hint style="warning" %}
`install_npc_conversion` pins a specific package version. After every new extension build, update the pinned `04t` id in `cumulusci.yml` or the flow will keep installing the old version.
{% endhint %}

## Verifying the install

Before moving on, confirm each of these:

- Setup → **Installed Packages** lists both **Flow Tool Kit: Form and Table Builder** (4.31.0.1 or later) and **Flow Tool Kit: AFNP | NPC Extension**.
- Setup → **Flows**, filtered for `NPC`, shows nine flows, all **Active**.
- Setup → **Matching Rules** shows **Standard Person Account Matching Rule** as **Active**.
- Setup → **Duplicate Rules** shows **Standard Person Account Duplicate Rule** as **Active**.
