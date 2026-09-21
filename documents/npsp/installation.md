# Installation

> Install the NPSP Extension with the guided installer, then switch on the one piece of matching that only an admin can switch on.

The installer does almost everything: it installs the base package, NPSP's dependencies and the extension, and then applies the configuration on the next page for you. Two things it cannot do are yours: confirming the org's NPSP settings, and activating a duplicate rule so that returning people are matched instead of duplicated.

## Before you start

Confirm all four of these. The install will not correct any of them for you.

1. **NPSP is installed.** Check by opening the App Launcher and searching for **Affiliations**. If `npe5__Affiliation__c` is not in the org, the installer stops and tells you to install NPSP first.
2. **The org is on the Household Account model.** In **NPSP Settings → People → Account Model**, the Account Model reads **Household Account**. This is the NPSP default, and it is what makes NPSP build a Household for every new Contact.
3. **NPSP's trigger handlers are running.** In **NPSP Settings → Bulk Data Processes → Trigger Configuration**, confirm `ACCT_IndividualAccounts_TDTM` and `AFFL_Affiliations_TDTM` are active and that your username is not excluded from them. The first one builds every Household; the second maintains affiliations.
4. **Enhanced Email and Lightning Web Security are on.** The base package requires Enhanced Email, and forms with large datasets degrade badly without LWS. The installer checks both and refuses to run if either is off.

## Install with the guided installer

Open the installer plan, **Install Flow Tool Kit for NPSP**, in the org you are installing into, and work through it. It runs seven steps:

| Step | What it does |
| --- | --- |
| 1. Install dependencies | Installs the Flow Tool Kit base package and the NPSP packages the extension depends on. Most orgs already have these, in which case nothing is deployed. |
| 2. Install the NPSP Extension | Installs the extension itself. It shares the `FlowToolKit` namespace with the base package. |
| 3. Update the admin profile | Grants the System Administrator profile access to the Flow Tool Kit objects, fields, Apex classes and pages. The package ships with permissions closed. Safe to re-run. |
| 4. Map Conversion Rules to their Conversion Types | Makes the `Account` rule and the two `Add to Account` rules selectable on Contact(s) templates. |
| 5. Add the Household and Organization Account record types | Adds `HH_Account` (labelled Household) and `Organization` to the Form Template's Account (Record Type) options. |
| 6. Add the NPSP Contact matching rule value | Adds `NPSP_Contact_Personal_Email_Match` to the Contact Matching Rules options on the Form Template and the Page Section. |
| 7. Apply Conversion Mapping Defaults | Points the Controller, Primary Contact and Alternate Contact records at the NPSP conversion flows. This is the connection that makes conversions run the NPSP logic. |

Steps 4 to 7 are the configuration described on the next page, applied for you. [Configuration](configuration.md) explains what each of them did, and how to do it by hand if you prefer.

{% hint style="info" %}
**Steps 4 to 7 run on a first installation only.** On an upgrade they are skipped, so any changes you have made to the Conversion Rules dependency matrix, the record type values or the mapping records are preserved.
{% endhint %}

## Switch on a duplicate rule

The conversion engine finds returning people through Salesforce duplicate detection, restricted to the matching rules your template names. A matching rule on its own finds nothing: it only produces matches through an **active duplicate rule that uses it**, and duplicate rules are org configuration that no package can create for you.

1. **Setup → Duplicate Rules**
2. Create or activate a Contact duplicate rule that uses the matching rule you intend to put on your templates.
3. Leave its action on **Allow**. The conversion engine reads the matches the rule produces and decides for itself whether to update the person it found; a blocking rule would stop conversions rather than inform them.

Two matching rules are worth knowing about:

| Rule | Ships | Matches on |
| --- | --- | --- |
| `Standard_Contact_Match_Rule_v1_1` | Active, with Salesforce | Name plus a confirming field |
| `NPSP_Contact_Personal_Email_Match` | Active, with NPSP | First Name, Last Name and Personal Email |

{% hint style="warning" %}
`NPSP_Contact_Personal_Email_Match` matches on **Personal Email** (`npe01__HomeEmail__c`), and NPSP does not copy the standard Email field into it. It will only find people whose Personal Email is populated. If your forms capture a personal email address, map it there through the Email Type field described in [Configuration](configuration.md#step-5-configure-a-form-template); if they capture a work address, match on the standard Contact rule instead.
{% endhint %}

## Installing with CumulusCI

If you work with this project's CumulusCI configuration, the whole install is one command, including the configuration steps on the next page:

```bash
cci flow run npsp_conversion_install --org <your-org>
```

That flow installs the dependencies, installs the extension's released version, and runs every post-install configuration step. It does not create a duplicate rule, because no API can activate matching for you.

Two other flows exist for development work:

- `npsp_conversion_post_install` runs the configuration steps alone, against an org where the packages are already installed.
- `npsp_conversion_dev_org` builds a complete NPSP development org from nothing: the NPSP stack, the base package, this package's source, the permission sets, NPSP demo data, and two fixture Form Templates named **NPSP Household Intake** and **NPSP Organization Intake**.

## Verifying the install

Before moving on, confirm each of these:

- Setup → **Installed Packages** lists both **Flow Tool Kit: Form and Table Builder** and **Flow Tool Kit: NPSP | Form Template Extension**.
- Setup → **Flows**, searched for `(NPSP) Convert` and `(NPSP) Utility`, shows five flows, all **Active**.
- Setup → **Custom Metadata Types → Form Template Conversion Mapping Default → Manage Records** shows Controller, Primary Contact and Alternate Contact naming the NPSP flows. [Configuration step 4](configuration.md#step-4-repoint-the-three-conversion-mapping-records) lists the exact values.
- Setup → **Duplicate Rules** shows an active Contact duplicate rule using the matching rule you plan to select on templates.
