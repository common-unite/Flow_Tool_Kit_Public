# NPSP Extension

> Turn form submissions into NPSP Households, Organizations and affiliations, using the same Form Template conversion pipeline you already know.

## What this extension is

Flow Tool Kit's base conversion pipeline creates business Accounts and Contacts: the classic Salesforce shape, where a person is a Contact attached to a company. The Nonprofit Success Pack uses a different shape. A person is still a **Contact**, but NPSP gives every Contact a **Household Account** of its own, and it builds that Household itself, inside the same transaction as the insert. An organisation is an ordinary Account with the **Organization** record type, and "Grace works at Harbor Youth Coalition" is an **affiliation** (`npe5__Affiliation__c`), never a change to the Contact's Account.

The **Flow Tool Kit: NPSP | Form Template Extension** package teaches the conversion pipeline that second shape. It is a managed extension package that installs on top of the base package and shares its namespace, so everything you already know about Form Templates, Conversion Rules, conversion logs and Reprocess works exactly the same way. What changes is which flows do the work.

{% hint style="info" %}
Nothing in the base package is replaced or modified. The extension adds new flows and points three configuration records at them. If you uninstall the extension, pointing those three records back at the packaged flows restores standard behaviour.
{% endhint %}

## What a converted submission produces

A single household intake form, filled in once, can produce all of this:

| Record | Created as | From |
| --- | --- | --- |
| **Contact** for each person | An ordinary Contact, inserted with no Account so NPSP can act | The Contact 1 and Contact 2 sections of your form, and every repeater or table row |
| **Household Account** | Built by NPSP itself when Contact 1 is created, or brought along by a returning Contact 1 | Contact 1's conversion. The extension never creates a Household |
| **Household membership** | The Contact's own Account field, pointing at that Household | The Add to Account rule for that person, or the section's Add to Account setting |
| **Organization Account** | The packaged Account step, with the Organization record type | The Account section of an organisation intake form |
| **Affiliation** | `npe5__Affiliation__c`, Status Current, Role taken from the person's Title | The Add to Account rule, when the submission's Account is an Organization |
| **Primary Contact** | `npe01__One2OneContact__c` on the Organization, or on the Household when there is no Organization | The Primary Contact checkbox on that person's row |

## How it fits together

The base pipeline runs one conversion rule per pass, driven by platform events, and records the outcome of every pass in the conversion log. The extension keeps all of that. It supplies its own controller, its own two Contact steps and its own Contact engine, and they are selected by three **Form Template Conversion Mapping Default** records that ship with the base package and are designed to be repointed. The Account step stays the packaged one.

```
Form Submission (Submitted)
    ↓
NPSP controller decides which rule runs this pass
    ↓
Contact 1 step  →  NPSP Contact engine  →  Contact saved, NPSP builds the Household
                                        →  that Household stamped on the submission
    ↓
Account step    →  packaged Account engine  →  the Household updated, or an Organization created
    ↓
Contact 2, repeater rows, table rows  →  join the Household, or gain an affiliation
    ↓
Form Submission (Complete)
```

The one genuinely new idea is **ordering**. A Household in NPSP comes from the person, not the other way round, so people convert first. Contact 1 converts, NPSP builds the Household around them, the engine stamps that Household on the submission, and the Account rule then updates it rather than creating a second Account. This is explained in full under [Conversion Flows](conversion-flows.md#people-come-first).

## What is included

| Component | Count | Notes |
| --- | --- | --- |
| Conversion flows | 5 | One controller, two Contact steps, one Contact engine, one reusable affiliation utility |
| Matching rules | 0 | The extension ships none. NPSP's own `NPSP_Contact_Personal_Email_Match` and the standard Contact rules can match Contacts already |

The affiliation utility is deliberately **form-agnostic**: values in, values out, with `HasError` and `ErrorMessage` outputs. It knows nothing about Form Submissions or platform events, so your own automation can call it to affiliate a person with an organisation with no Flow Tool Kit involvement at all. See [Customizing](customizing.md#reuse-the-affiliation-utility-in-your-own-automation).

## Requirements

| Requirement | Why |
| --- | --- |
| **NPSP installed, on the Household Account model** | The whole design rests on NPSP building a Household for every Contact inserted without an Account. |
| **The `HH_Account` and `Organization` Account record types** | Every NPSP org on the Household Account model has them. `HH_Account` on a Form Template is what turns Household mode on. |
| **NPSP's Contact and Affiliation trigger handlers active** | `ACCT_IndividualAccounts_TDTM` builds the Household and `AFFL_Affiliations_TDTM` maintains affiliations. A subscriber who switched either off silently breaks the foundation. |
| **Flow Tool Kit base package** | The extension declares it as a package dependency, so it installs first. |

{% hint style="info" %}
Person Accounts are not used anywhere in this extension, and NPSP does not need them. Every person it creates is an ordinary Contact.
{% endhint %}

## Where to go next

1. [Installation](installation.md) walks through the guided installer and the one duplicate rule you have to switch on yourself.
2. [Configuration](configuration.md) is the step-by-step manual setup: picklist values, record types, and repointing the three mapping records.
3. [Conversion Flows](conversion-flows.md) explains each flow, how it works, and the NPSP behaviour that matters before you rely on it.
4. [Customizing](customizing.md) covers overriding the flows and reusing the affiliation utility elsewhere.
