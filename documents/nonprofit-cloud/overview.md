# Nonprofit Cloud Extension

> Turn form submissions into Person Accounts, Households, memberships and relationships, using the same Form Template conversion pipeline you already know.

## What this extension is

Flow Tool Kit's base conversion pipeline creates business Accounts and Contacts: the classic Salesforce shape, where a person is a Contact attached to a company. Nonprofit Cloud uses a different shape. A person is a **Person Account**, a family is a **Household** (a Party Relationship Group record), belonging to that family is an **Account Contact Relation**, and "Maria is Tom's daughter" is a **Contact Contact Relation**.

The **Flow Tool Kit: AFNP | NPC Extension** package teaches the conversion pipeline that second shape. It is a managed extension package that installs on top of the base package and shares its namespace, so everything you already know about Form Templates, Conversion Rules, conversion logs and Reprocess works exactly the same way. What changes is which flows do the work.

{% hint style="info" %}
Nothing in the base package is replaced or modified. The extension adds new flows and points four configuration records at them. If you uninstall the extension, pointing those four records back at the packaged flows restores standard behaviour.
{% endhint %}

## What a converted submission produces

A single household intake form, filled in once, can produce all of this:

| Record | Created as | From |
| --- | --- | --- |
| **Person Account** for each person | Account with a person record type, carrying its own Contact | The Contact 1 and Contact 2 sections of your form |
| **Household** | Account with your Household record type | The Account section, when the template says the Account is a Household |
| **Party Relationship Group** | The group record that makes the Household a real Nonprofit Cloud household | Created automatically alongside the Household Account |
| **Household membership** | Account Contact Relation, one per person, with the group flags your template chooses | The "Add to Account" rule on each person |
| **Family relationships** | Contact Contact Relation, written in both directions | The related-records rows on your form, one per relationship |

## How it fits together

The base pipeline runs one conversion rule per pass, driven by platform events, and records the outcome of every pass in the conversion log. The extension keeps all of that. It supplies its own controller and its own set of step flows, and they are selected by four **Form Template Conversion Mapping Default** records that ship with the base package and are designed to be repointed.

```
Form Submission (Submitted)
    ↓
NPC controller decides which rule runs this pass
    ↓
Person Account step  →  shared Account engine  →  Person Account created or matched
    ↓
Account step         →  shared Account engine  →  Household + Party Relationship Group + memberships
    ↓
Related records                                 →  Contact Contact Relations
    ↓
Form Submission (Complete)
```

The one genuinely new idea is **ordering**. In a household conversion, people have to exist before the household can be built around them, but the household has to exist before anyone can be added to it. The controller resolves this by holding the Household back until the first person exists, then queueing that person to run a second time so they can join the household that now exists. This is explained in full under [Conversion Flows](conversion-flows.md#the-household-ordering-problem).

## What is included

| Component | Count | Notes |
| --- | --- | --- |
| Conversion flows | 9 | One controller, three step flows, one Account engine, four reusable utilities |
| Matching rule | 1 | `NPC_Person_Account_Match`, deployed separately so you can edit it |
| Duplicate rule | 1 | `NPC_Person_Account_Duplicate_Rule`, reports duplicates and never blocks |

The four utility flows are deliberately **form-agnostic**: values in, values out, with `HasError` and `ErrorMessage` outputs. They know nothing about Form Submissions or platform events, so your own automation can call them to create households, memberships and relationships with no Flow Tool Kit involvement at all. See [Customizing](customizing.md#reuse-the-utility-flows-in-your-own-automation).

## Requirements

| Requirement | Why |
| --- | --- |
| **Nonprofit Cloud** with the Group Membership feature licensed | The extension writes Party Relationship Group and Contact Contact Relation records. Without the license those objects do not exist. |
| **Person Accounts enabled** | Every person the extension creates is a Person Account. |
| **Flow Tool Kit base package 4.31.0.1 or later** | The extension declares it as a package dependency, so an older base package blocks the install. |
| An Account record type for households, and an active person account record type | The engine looks these up by name and falls back to the org default if a name does not match. |

## Where to go next

1. [Installation](installation.md) walks through installing the package and its two rules.
2. [Configuration](configuration.md) is the step-by-step manual setup: picklist values, record types, and repointing the four mapping records.
3. [Conversion Flows](conversion-flows.md) explains each flow, how it works, and the considerations that matter.
4. [Customizing](customizing.md) covers overriding the flows and reusing the utilities elsewhere.
