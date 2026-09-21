# Configuration

> The setup that switches the extension on: picklist values, record types, the three records that select the NPSP flows, and how a Form Template is filled in.

Installing the package puts the flows in the org, but the conversion pipeline still points at the standard flows and your Form Templates cannot yet say "this form builds a family". This page is the configuration that makes the extension live. Work through the steps in order; step 4 is the one that actually switches the pipeline over.

{% hint style="info" %}
Steps 1 to 4 are exactly what steps 4 to 7 of the guided installer do, and they are also automated on their own: `cci flow run npsp_conversion_post_install --org <your-org>`. If you installed with the installer, read them to know what changed, then start at step 5.
{% endhint %}

{% hint style="info" %}
**There is no new Conversion Rules value to add.** In Nonprofit Cloud the pipeline needs an `Account is Household` rule, because a Nonprofit Cloud org has no household record type. Every NPSP org on the Household Account model has one, so here the record type is the switch: a template whose Account record type is `HH_Account` is in Household mode, and nothing else turns it on.
{% endhint %}

## Step 1: Make the rules selectable under the right Conversion Type

**This step is not optional, and skipping it is the most common setup mistake.** Conversion Rules is a *dependent* picklist controlled by **Conversion Type**. A value that is not mapped to at least one Conversion Type is invisible in the interface and rejected if something tries to save it.

Go to **Setup → Object Manager → Form Template → Fields & Relationships → Conversion Rules**, find **Controlling Field: Conversion Type** and click **Change**. In the dependency matrix, make these three existing values available under **Contact(s)**:

| Value | Why a people-first NPSP template needs it |
| --- | --- |
| `Account` | A household intake has a Conversion Type of Contact(s), because the form is about people, but it still needs the Account rule to write the mapped Account fields onto the Household that NPSP built. An organisation intake needs it to create the Organization. |
| `Contact1 👉 Add to Account` | Puts Contact 1 in the Household, or affiliates them with the Organization. |
| `Contact2 👉 Add to Account` | The same for Contact 2 and for every repeater or table row that converts through the Contact 2 fields. |

Out of the box those three values are not offered under Contact(s), so an NPSP template cannot be configured until you add them here.

## Step 2: Add the Account record type values

**Account (Record Type)** on the Form Template tells the engine which record type the Account carries, and for NPSP it is also the Household switch. Go to **Setup → Object Manager → Form Template → Fields & Relationships → Account (Record Type)** and add two values with **New**:

| Value | Label | Used for |
| --- | --- | --- |
| `HH_Account` | Household | Household conversions. Choosing it turns Household mode on: the people on the form convert into one NPSP Household. |
| `Organization` | Organization | Organisation conversions. The form creates or updates an Organization, and people are linked to it by affiliation. |

The stored value is the record type's developer name, which is how the flows resolve it, and the label is what an admin reads. NPSP creates both record types itself, so there is nothing to build first.

## Step 3: Add the NPSP matching rule to the picker

So that admins can select NPSP's Contact matching rule on a template, add it to the **Contact Matching Rules** picklist. Do this on **two** objects, because a page section can override the template:

- **Setup → Object Manager → Form Template → Fields & Relationships → Contact Matching Rules**
- **Setup → Object Manager → Form Template Page Section → Fields & Relationships → Contact Matching Rules**

Add the value `NPSP_Contact_Personal_Email_Match` to each.

{% hint style="danger" %}
**Type the value without a namespace prefix.** Salesforce's duplicate check reports this rule as `NPSP_Contact_Personal_Email_Match`, and the engine keeps a match only when the picklist value equals the name it was given. A value typed as `npsp__NPSP_Contact_Personal_Email_Match` silently filters out every match, so every returning person is created again as a duplicate.
{% endhint %}

The rule only produces matches through an active duplicate rule that uses it. See [Installation](installation.md#switch-on-a-duplicate-rule).

## Step 4: Repoint the three conversion mapping records

This is the step that switches the pipeline over to the NPSP flows.

The base package ships a custom metadata type, **Form Template Conversion Mapping Default**, whose records name the flow used for each part of a conversion. The `Flow API Name` field on those records is designed to be edited by the subscriber, and repointing three of them is how the extension takes over.

Go to **Setup → Custom Metadata Types → Form Template Conversion Mapping Default → Manage Records**. Open each of these three records, click **Edit**, and set **Flow API Name** to the value in the right-hand column:

| Record | Set Flow API Name to |
| --- | --- |
| Controller | `FlowToolKit__NPSP_Form_Submission_Convert_Process_Form_Submission_Overridable` |
| Primary Contact | `FlowToolKit__NPSP_Form_Submission_Convert_Process_Contact_Primary_Overridable` |
| Alternate Contact | `FlowToolKit__NPSP_Form_Submission_Convert_Process_Contact_Alternate_Overridable` |

Leave every other record alone, the **Account** record included. NPSP organisations are ordinary Accounts, so the packaged Account step converts them unchanged, and in Household mode that same step updates the Household that NPSP built. Leads, Cases, Opportunities, Orders, Campaign Members and file uploads also keep working exactly as before.

{% hint style="danger" %}
**Edit the existing records. Never create new ones.** These records already exist, installed by the base package, and their names are prefixed `FlowToolKit__`. If you click **New** and create a record called `Controller`, the org ends up with two records whose developer name is `Controller`, and Salesforce cannot read a custom metadata type that contains a duplicate developer name: every conversion in the org then fails with `System.ListException: Row with duplicate DeveloperName`. If this happens, delete the record you created and the pipeline recovers immediately.
{% endhint %}

To undo the extension later, set these three records back to their original values, which are the packaged flow names without the `NPSP_` portion.

## Step 5: Configure a Form Template

With the setup above in place, a household intake template is configured like this:

| Field | Value | Why |
| --- | --- | --- |
| Conversion Type | `Contact(s)` | The form is about people, and this controls which rules are offered. |
| Account (Record Type) | `Household` | The switch. This template converts people into one NPSP Household. |
| Contact Matching Rules | `NPSP_Contact_Personal_Email_Match` | Returning people are matched and updated rather than duplicated. |
| Conversion Rules | See below | What the submission should build. |

A full household intake selects these Conversion Rules:

```
Account
Contact1
Contact1 👉 Add to Account
Contact2
Contact2 👉 Add to Account
```

An organisation intake is the same list with **Account (Record Type)** set to `Organization`. The Account rule creates or updates the Organization, and the two Add to Account rules affiliate each person with it.

Smaller combinations are valid and useful:

- **People only**: `Contact1`, `Contact2`, with no Account record type. Each person gets their own NPSP Household and nothing is stamped on the submission.
- **A family with no Account mapping**: the `Household` record type, `Contact1`, `Contact2` and the two Add to Account rules, but no `Account` rule. Everyone lands in one Household and the submission points at it; no form answers are written onto the Household itself.
- **Contact 1's family only**: the `Household` record type and the two Contact rules with no Add to Account rules. Contact 1's Household is stamped on the submission, and Contact 2 keeps a Household of their own.

{% hint style="warning" %}
**Joining the Household is Add to Account's job, not Household mode's.** Household mode decides that Contact 1's Household is found and stamped; a person is put into that Household only when their own Add to Account rule, or the capturing section's **Add to Account** setting, asks for it. A household template without those rules converts a family into separate Households, which is almost never what was wanted.
{% endhint %}

### Repeater and table sections

A repeater or table section captures its rows through the Contact 2 fields, so it follows the `Contact2` conversion rule. Set **Conversion Rule** to `Contact2` on the section and tick its **Add to Account** box, and every row joins the family's Household or gains an affiliation with the Organization, whatever the template-level rules say. This is how one form can hold a family repeater and a staff repeater that behave differently.

### Fields that carry NPSP behaviour

These Form Submission fields drive the NPSP-specific parts of a conversion. Map them on your form like any other field.

| Field | Effect on the Contact |
| --- | --- |
| Email Type | Puts the email in Personal, Work or Alternate Email and sets **Preferred Email** to match. `Other` maps to Alternate, because that is what NPSP stores. |
| Phone Type | Puts the phone in Home, Mobile or Work Phone and sets **Preferred Phone** to match. |
| Do Not Call | When checked, sets NPSP's **Do Not Contact**. An unchecked box never clears a value that is already there. |
| Primary Contact (`Contact1_Primary_Contact__c`, `Contact2_Primary_Contact__c`) | Makes that person the Account's Primary Contact: the Organization when the submission has one, otherwise their Household. |

A blank Email Type or Phone Type writes nothing beyond the standard Email and Phone fields.

## Step 6: Check your NPSP settings

The extension relies on NPSP doing its own work, so a setting that has been turned off shows up as a conversion that quietly does the wrong thing. Confirm these once per org:

| Setting | Where | Expected |
| --- | --- | --- |
| Account Model | NPSP Settings → People → Account Model | **Household Account**. On any other model, an inserted Contact does not get a Household. |
| `ACCT_IndividualAccounts_TDTM` | NPSP Settings → Bulk Data Processes → Trigger Configuration | Active, with your integration user not excluded. This handler is what builds every Household. |
| `AFFL_Affiliations_TDTM` | Same page | Active. This handler maintains affiliations and a Contact's Primary Affiliation. |
| Automatic Affiliation Creation | NPSP Settings → People → Affiliations | Note which way it is set. The extension's affiliation logic is the same either way, but with it on NPSP also creates an affiliation of its own when an Organization's Primary Contact is set. |

## Step 7: Check your Account matching before you convert organisations

The packaged Account step matches an existing Organization through the Account matching rules the template names, and the standard Account matching rule needs more than a name: a billing address, a phone number or a website. A form that captures only the organisation's name will therefore create a second Organization rather than matching the one you have. Decide before go-live whether your form captures enough to match on, or whether an admin is expected to merge.

Addresses on people are opt-in in the same spirit: the address blocks map only when the template's address sub-rules are on, so a blank form answer never wipes a curated address.

## Verifying the configuration

A quick way to prove the whole chain works is to submit a household intake form with two people and one repeater row, then check:

1. Three Contacts exist and all three share one Account, whose record type is `HH_Account`.
2. The submission's **Account** field points at that Household, its Account status reads `Updated`, and the Contact statuses read `Created`.
3. Resubmitting the same two people matches them, reuses the same Household, and creates no second family.

Then submit an organisation intake and check:

1. The Organization exists with the `Organization` record type and names Contact 1 as its **Primary Contact**.
2. Each person has one affiliation to it, Status **Current**, with their Title as the **Role**.
3. Each person is still in a Household of their own. A Household is never an affiliation, and an Organization is never written onto a Contact's Account.

If a step did not happen, the submission's **Conversion Logs** related list names the flow and the reason. See [Conversion Flows](conversion-flows.md#logging-and-reprocessing) for how to read the log and rerun a failed conversion.
