# Configuration

> The manual setup that switches the extension on: picklist values, record types, and the four configuration records that select the Nonprofit Cloud flows.

Installing the package puts the flows in the org, but the conversion pipeline still points at the standard flows and your Form Templates cannot yet express a household. This page is the configuration that makes the extension live. Work through the steps in order; step 5 is the one that actually switches the pipeline over.

{% hint style="info" %}
Every step here can be done in Setup by an administrator. All of these are also automated: `cci flow run npc_conversion_post_install --org <your-org>` performs steps 1 to 5 in one command.
{% endhint %}

## Step 1: Add the Conversion Rules picklist values

**Conversion Rules** on the Form Template is the multi-select picklist that says what a submission should build. The extension needs six new values.

Go to **Setup → Object Manager → Form Template → Fields & Relationships → Conversion Rules**, scroll to the values list, and use **New** to add each of these. Use the exact spelling, including the emoji, because the flows match on the literal value:

| Value | What it does |
| --- | --- |
| `Account is Household` | Turns household mode on. The Account this submission builds is treated as a Household: a Party Relationship Group is created for it and people are added as members. |
| `Create Relationships` | Turns on family relationships. The related-records rows on the form become Contact Contact Relations, written in both directions. |
| `Contact1 👉 Is Primary Group` | Marks this household as the person's primary group when Contact 1 joins it. |
| `Contact1 👉 Included In Group` | Includes Contact 1 in the household's rollups when they join. |
| `Contact2 👉 Is Primary Group` | The same for the second person on the form. |
| `Contact2 👉 Included In Group` | The same for the second person on the form. |

{% hint style="info" %}
The 👉 character is part of the value. Copy the values from this table rather than retyping them. This matches the convention the base package already uses for its own sub-rules such as `Contact1 👉 Add to Account`.
{% endhint %}

## Step 2: Make the rules selectable under the right Conversion Type

**This step is not optional, and skipping it is the most common setup mistake.** Conversion Rules is a *dependent* picklist controlled by **Conversion Type**. A value that is not mapped to at least one Conversion Type is invisible in the interface and rejected if something tries to save it, so the six values from step 1 do nothing until they are mapped here.

On the same Conversion Rules field page, find **Controlling Field: Conversion Type** and click **Change**. In the dependency matrix, make these selections available:

| Value | Available under Conversion Type |
| --- | --- |
| `Account is Household` | Contact(s), Account, Other |
| `Create Relationships` | Contact(s), Account, Other |
| `Contact1 👉 Is Primary Group` | Contact(s), Account, Other |
| `Contact1 👉 Included In Group` | Contact(s), Account, Other |
| `Contact2 👉 Is Primary Group` | Contact(s), Account, Other |
| `Contact2 👉 Included In Group` | Contact(s), Account, Other |
| `Account` *(existing value)* | **Add Contact(s)** |
| `Contact1 👉 Add to Account` *(existing value)* | **Add Contact(s)** |
| `Contact2 👉 Add to Account` *(existing value)* | **Add Contact(s)** |

The last three rows matter as much as the new values. A household intake form has a Conversion Type of **Contact(s)**, because the form is fundamentally about people, but it still needs the `Account` rule to build the Household and the `Add to Account` rules to put people in it. Out of the box those three values are not offered under Contact(s), so a household template cannot be configured until you add them here.

## Step 3: Add the Account record type values

**Account (Record Type)** on the Form Template tells the engine which record type to give the Account it creates. Go to **Setup → Object Manager → Form Template → Fields & Relationships → Account (Record Type)** and add two values with **New**:

| Value | Used for |
| --- | --- |
| `Household` | Household conversions. The engine looks for an Account record type with this name and uses it for the Household. |
| `Organization` | Business or organisation conversions, for forms that create an organisation rather than a family. |

These are names the engine looks up at run time, not record type ids. If no record type in the org matches the name, the engine falls back to the org's default rather than failing, so a typo shows up as an Account with the wrong record type rather than as a conversion error.

## Step 4: Add the PersonAccount contact record type value

**Contact (Record Type)** uses a shared value set rather than a field-level list, because the same values serve both the Form Template and its Page Sections.

Go to **Setup → Picklist Value Sets → Contact Record Type**, and add one value with **New**:

| Value |
| --- |
| `PersonAccount` |

At run time the engine resolves this name to the org's active person account record type.

{% hint style="warning" %}
You must select `PersonAccount` on each Form Template that creates people. Marking the value as the value set's default has no effect, because the packaged field carries a formula default of `-- Use Default --` that cannot be changed after installation, and `-- Use Default --` means "let the org decide", which produces a business Account rather than a Person Account.
{% endhint %}

## Step 5: Repoint the four conversion mapping records

This is the step that switches the pipeline over to the Nonprofit Cloud flows.

The base package ships a custom metadata type, **Form Template Conversion Mapping Default**, whose records name the flow used for each part of a conversion. The `Flow API Name` field on those records is designed to be edited by the subscriber, and repointing four of them is how the extension takes over.

Go to **Setup → Custom Metadata Types → Form Template Conversion Mapping Default → Manage Records**. Open each of these four records, click **Edit**, and set **Flow API Name** to the value in the right-hand column:

| Record | Set Flow API Name to |
| --- | --- |
| Controller | `FlowToolKit__NPC_Form_Submission_Convert_Process_Form_Submission_Overridable` |
| Account | `FlowToolKit__NPC_Form_Submission_Convert_Process_Account_Overridable` |
| Primary Contact | `FlowToolKit__NPC_Form_Submission_Convert_Process_Person_Account_Primary_Overridable` |
| Alternate Contact | `FlowToolKit__NPC_Form_Submission_Convert_Process_Person_Account_Alternate_Overridable` |

Leave every other record alone. Leads, Cases, Opportunities, Orders, Campaign Members and file uploads keep working exactly as before.

{% hint style="danger" %}
**Edit the existing records. Never create new ones.** These four records already exist, installed by the base package, and their names are prefixed `FlowToolKit__`. If you click **New** and create a record called `Account`, the org ends up with two records whose developer name is `Account`, and Salesforce cannot read a custom metadata type that contains a duplicate developer name: every conversion in the org then fails with `System.ListException: Row with duplicate DeveloperName`. If this happens, delete the record you created and the pipeline recovers immediately.
{% endhint %}

To undo the extension later, set these four records back to their original values, which are the same flow names without the `NPC_` portion.

## Step 6: Add the matching rule to the picker

So that admins can select the Person Account matching rule on a template, add it to the **Contact Matching Rules** picklist. Do this on **two** objects, because a page section can override the template:

- **Setup → Object Manager → Form Template → Fields & Relationships → Contact Matching Rules**
- **Setup → Object Manager → Form Template Page Section → Fields & Relationships → Contact Matching Rules**

Add the value `NPC_Person_Account_Match` to each. The value is the matching rule's API name, which is how the conversion engine passes it to the duplicate-matching action.

## Step 7: Configure a Form Template

With the setup above in place, a household intake template is configured like this:

| Field | Value | Why |
| --- | --- | --- |
| Conversion Type | `Contact(s)` | The form is about people, and this controls which rules are offered. |
| Contact (Record Type) | `PersonAccount` | Everyone the form creates is a Person Account. |
| Account (Record Type) | `Household` | The Account this form builds is a Household. |
| Contact Matching Rules | `NPC_Person_Account_Match` | Returning people are matched and updated rather than duplicated. |
| Conversion Rules | See below | What the submission should build. |

A full household intake selects these Conversion Rules:

```
Account
Account is Household
Contact1
Contact1 👉 Add to Account
Contact2
Contact2 👉 Add to Account
Create Relationships
Contact1 👉 Is Primary Group
Contact1 👉 Included In Group
Contact2 👉 Is Primary Group
Contact2 👉 Included In Group
```

Smaller combinations are valid and useful:

- **People only, no household**: `Contact1`, `Contact2`. Person Accounts are created, nothing else.
- **A household with no members yet**: `Account`, `Account is Household`. Useful for organisation-style intake where members are added later.
- **A household without group flags**: leave the four Is Primary Group and Included In Group rules unselected. Memberships are still created; their flags stay false.

## Step 8: Check your address fields

If your org uses **State and Country/Territory Picklists**, the state and country fields on Account and Contact are picklists that only accept valid codes, while the packaged fields on Form Submission (`State_Province__c`, `Country__c`, `Mailing_State_Province__c`, `Mailing_Country__c`) are plain text. Free text typed into a form will not save into a picklist state or country field.

To collect addresses that convert cleanly:

1. Enable and configure State and Country/Territory picklists first, from **Setup → State and Country/Territory Picklists**.
2. Enable **Custom Addresses** and add an address field to the **Form Submission** object, so the form can present real state and country picklists rather than text boxes.
3. Update your form's field mappings to use the new address field, and update the conversion mapping so the address lands on the target object's address fields.

{% hint style="info" %}
Budget the field allocation before you start: each custom address field counts as **nine** custom fields on the object.
{% endhint %}

## Verifying the configuration

A quick way to prove the whole chain works is to submit a household intake form with two people and one relationship, then check:

1. Two Person Accounts exist, each with a Contact behind it.
2. A Household Account exists with your Household record type, and a Party Relationship Group is linked to it.
3. Each person has an Account Contact Relation to the Household, with the group flags your template selected.
4. A Contact Contact Relation exists between the two people, in both directions.
5. The submission's **Conversion Logs** related list tells the story of each pass, and the submission's status is Complete.

If a step did not happen, the conversion log names the flow and the reason. See [Conversion Flows](conversion-flows.md#logging-and-reprocessing) for how to read the log and rerun a failed conversion.

## Sources

- [Configure State and Country/Territory Picklists](https://help.salesforce.com/s/articleView?id=sf.admin_state_country_picklists_configure.htm&language=en_US&type=5)
- [Considerations for Custom Address Fields](https://help.salesforce.com/s/articleView?id=platform.fields_caf_requirements.htm&language=en_US&type=5)
