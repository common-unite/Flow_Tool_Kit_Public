# Customizing

> Change field mappings, replace a flow with your own, or reuse the household utilities in automation that has nothing to do with forms.

There are three levels of customization, and picking the lowest one that solves your problem keeps upgrades painless.

| Level | Change | Effort |
| --- | --- | --- |
| **1. Configure the template** | What gets built, which record types, which matching rules, which addresses | No flows, no deployment |
| **2. Clone a step flow** | Which form answers land in which fields | One cloned flow, one setting |
| **3. Override the engine** | How records are matched, saved or linked | A cloned engine, and a maintenance commitment |

## Level 1: configure the template

Most requirements are template settings rather than flow changes. Before cloning anything, check whether the behaviour you want is one of these:

- **What gets built** is the Conversion Rules selection. Leave `Create Relationships` off and no relationships are written; leave the group-flag rules off and memberships are created with their flags false.
- **Which record types** are the Account and Contact record type fields.
- **How people are matched** is the Contact Matching Rules selection, plus the most-confident-match setting for what happens when several people match.
- **Whether addresses map** is the address sub-rules, per person and per address block.
- **Whether blank answers clear fields** is the Nullable Fields setting.
- **Per-section overrides**: a page section can carry its own conversion rule, matching rules and Add to Account setting, which lets one repeater section behave differently from the rest of the form.

## Level 2: clone a step flow

This is the right level for "we need different fields to map", which is the most common request.

The three step flows exist precisely to be cloned. Each is a thin wrapper around one Transform element, and that Transform is the field mapping. Cloning one gives you complete control of the mapping while leaving matching, saving, logging, households and relationships untouched.

1. **Clone the flow.** In Setup, open the step flow you want to change (Process Person Account Primary, Process Person Account Alternate, or Process Account) and **Save As** a new flow in your own namespace.
2. **Edit the Transform.** Add, remove or repoint mappings. Keep `Id`, `PersonContactId`, `IsPersonAccount` and `RecordTypeId` mapped as they are: the engine relies on them to know what it is saving.
3. **Activate** the clone.
4. **Point the pipeline at it**, either for one template or for the whole org:
   - **For one template**: set the template's Flow API Name override field for that rule to your clone's API name.
   - **For the whole org**: edit the matching Form Template Conversion Mapping Default record, exactly as in [Configuration step 5](configuration.md#step-5-repoint-the-four-conversion-mapping-records), and put your clone's API name there instead.

### What a clone must keep

A cloned step flow is dispatched by the same trigger as the packaged one, so it has to honour the same contract:

- **One input variable of type `Form_Submission_Convert__e`.** The name does not matter; its presence does. The dispatcher looks for it, and refuses to launch a flow that does not have one.
- **The flow must be an active autolaunched flow.**
- **Call the Setup subflow first.** It loads the submission, template and section, resolves matching settings, and performs the start-of-conversion reset that makes Reprocess work.
- **Hand the record to the engine**, or if you are replacing the engine too, log the outcome and return control to the controller yourself.

{% hint style="warning" %}
A rule that never stamps its status never finishes, so the controller will dispatch it again. The pipeline notices: after five dispatches of the same flow for the same submission it stops, marks the submission as errored, and names the flow in the Conversion Log. If you see that message, your custom flow is not logging its outcome.
{% endhint %}

## Level 3: override the engine

Change the engine only when the change is genuinely about *behaviour*: different matching, a different save strategy, an extra follow-up. Anything about *which fields go where* belongs in a step flow.

Clone the engine, make the change, and point the step flows at your clone. Bear in mind what you are taking on: the engine is the piece that keeps the pipeline honest. If you clone it, preserve these or the conversion stops being safe to rerun:

- **The status and lookup stamping.** The engine passes the sentinel `--From Platform Event--` for the status and lookup field names, which lets the Log action read them from the event. That indirection is what lets one engine serve the Account, Contact 1 and Contact 2 slots.
- **The error convention.** An error log leaves the slot's status non-terminal so Reprocess can rerun it. Log a static message naming the step that failed, and the flow's exact label. Do not stamp a terminal status on failure.
- **The read-back after save.** A save returns only the fields that were written. Everything downstream, above all a Person Account's `PersonContactId`, needs the record as it really stands.
- **One return to the controller.** Every success path must reach the return element exactly once. A success path that dead-ends stalls the entire conversion with no error at all.

## Reuse the utility flows in your own automation

The four utilities were built to be useful outside the form pipeline. They take plain values and return plain values, they never write a conversion log, and none of them requires a Form Submission, a Form Template or a platform event. Call them from a record-triggered flow, a screen flow, a scheduled flow or Apex.

All three writing utilities return `HasError` and `ErrorMessage` so the caller can decide how to report a failure, and a `ConversionStatus` of `Created` or `Updated` so a caller that *is* logging can speak the framework's vocabulary.

### Upsert Party Relationship Group

| Direction | Name | Notes |
| --- | --- | --- |
| In | `AccountId` | Required |
| In | `GroupName` | Defaults to the Account's name. An existing group is never renamed. |
| In | `GroupStatus` | Defaults to Active |
| In | `GroupType` | Defaults to Household |
| Out | `PartyRelationshipGroupId` | The group the Account now has |
| Out | `ConversionStatus`, `HasError`, `ErrorMessage` | |

*Use it whenever you need to guarantee an Account carries a household group, however that Account was created.*

### Upsert Account Contact Relation

| Direction | Name | Notes |
| --- | --- | --- |
| In | `AccountId`, `ContactId` | Both required |
| In | `IsPrimaryMember` | Head of household. Handled safely against the platform's one-per-Account rule. |
| In | `IsPrimaryGroup` | Where this person's information rolls up |
| In | `IsIncludedInGroup` | Whether they count in the group's aggregation |
| In | `ClearOtherPrimaryGroups` | Demote the person's other primary groups |
| Out | `AccountContactRelationId` | |
| Out | `ConversionStatus`, `HasError`, `ErrorMessage` | |

*Use it for any membership change: a data load, a "move this person to another household" screen, a nightly tidy-up.*

{% hint style="info" %}
When the Account has no primary member yet, the person being added takes that seat. Pass an existing member's household if you do not want a new person becoming head of household.
{% endhint %}

### Upsert Contact Contact Relation

| Direction | Name | Notes |
| --- | --- | --- |
| In | `ContactId`, `RelatedContactId` | Both required |
| In | `RelationshipName` | Everyday wording: Mother, Father, Stepparent, Legal Guardian, Foster Parent, Spouse or Partner, Child, Sibling, Grandparent, Friend |
| Out | `ContactContactRelationId` | The forward relationship |
| Out | `ConversionStatus`, `HasError`, `ErrorMessage` | |

*Use it anywhere two people need relating by role name. It writes both directions, which hand-built automation usually forgets.*

### Find Household for a Person

| Direction | Name | Notes |
| --- | --- | --- |
| In | `ContactId` | Use when you already know the person |
| In | `Email` | Used to find the Person Account when no Contact Id is known |
| Out | `HouseholdAccountId` | The Household's Account Id; blank when there is none |
| Out | `HasError`, `ErrorMessage` | |

{% hint style="info" %}
The utility deliberately returns the **Id, not the group record**. A populated Party Relationship Group crossing a subflow's output boundary crashes the packaged runtime with an internal Salesforce error, so callers take the Id and query whatever else they need. The same rule applies to your own flows on this object: pass its records between flows by Id.
{% endhint %}

*Read-only and safe to call from anywhere: deduplication checks, intake screens, reporting flows.*

## Upgrading safely

- **Never edit the packaged flows in place.** Clone them. A packaged flow is replaced on upgrade, and edits are lost.
- **Keep your customization in the layer that owns it.** Mapping changes in a cloned step flow survive engine upgrades untouched.
- **Record what you repointed.** The four Conversion Mapping Default records are the switchboard for the whole pipeline, and they are the first place to look when a conversion suddenly runs the wrong flow.
- **Test with Reprocess.** The fastest way to test a customization is a submission you have already converted: fix, click Reprocess, and watch the Conversion Log.
