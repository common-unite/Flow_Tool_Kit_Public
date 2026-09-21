# Customizing

> Change field mappings, replace a flow with your own, or reuse the affiliation utility in automation that has nothing to do with forms.

There are three levels of customization, and picking the lowest one that solves your problem keeps upgrades painless.

| Level | Change | Effort |
| --- | --- | --- |
| **1. Configure the template** | What gets built, which record type, which matching rules, which addresses | No flows, no deployment |
| **2. Clone a step flow** | Which form answers land in which fields | One cloned flow, one setting |
| **3. Override the engine** | How people are matched, saved or linked | A cloned engine, and a maintenance commitment |

## Level 1: configure the template

Most requirements are template settings rather than flow changes. Before cloning anything, check whether the behaviour you want is one of these:

- **Whether this form builds a family** is the Account record type: `HH_Account` is Household mode, `Organization` is not.
- **Who joins the Household, and who is affiliated** is the `Add to Account` rules, per person, plus the **Add to Account** box on a page section.
- **What else gets built** is the rest of the Conversion Rules selection.
- **How people are matched** is the Contact Matching Rules selection, plus the most-confident-match setting for what happens when several people match.
- **Whether addresses map** is the address sub-rules, per person and per address block.
- **Whether blank answers clear fields** is the Nullable Fields setting.
- **Per-section overrides**: a page section can carry its own conversion rule, matching rules and Add to Account setting, which lets a family repeater and a staff repeater on one form behave differently.

## Level 2: clone a step flow

This is the right level for "we need different fields to map", which is the most common request.

The two Contact step flows exist precisely to be cloned. Each is a thin wrapper around one Transform element, and that Transform is the field mapping. Cloning one gives you complete control of the mapping while leaving matching, saving, logging, Households and affiliations untouched.

1. **Clone the flow.** In Setup, open `(NPSP) Convert | Process | Contact Primary | Overridable` or `(NPSP) Convert | Process | Contact Alternate | Overridable` and **Save As** a new flow in your own namespace.
2. **Edit the Transform.** Add, remove or repoint mappings.
3. **Leave the Contact's Account alone.** The map must never set `AccountId`. In NPSP that link is the Household and the engine owns it: a new Contact 1 has to be inserted with a blank Account so NPSP builds the Household, and everyone else joins the Household already on the submission.
4. **Activate** the clone.
5. **Point the pipeline at it**, either for one template or for the whole org:
   - **For one template**: set `FlowApiName_Contact1__c` or `FlowApiName_Contact2__c` on the template to your clone's API name.
   - **For the whole org**: edit the matching Form Template Conversion Mapping Default record, exactly as in [Configuration step 4](configuration.md#step-4-repoint-the-three-conversion-mapping-records), and put your clone's API name there instead.

### What a clone must keep

A cloned step flow is dispatched by the same trigger as the packaged one, so it has to honour the same contract:

- **One input variable of type `Form_Submission_Convert__e`.** The name does not matter; its presence does. The dispatcher looks for it, and refuses to launch a flow that does not have one.
- **The flow must be an active autolaunched flow.**
- **Call the Setup subflow first.** It loads the submission, template and section, resolves matching settings, and performs the start-of-conversion reset that makes Reprocess work.
- **Hand the record to the engine**, or if you are replacing the engine too, log the outcome and return control to the controller yourself.

{% hint style="warning" %}
A rule that never stamps its status never finishes, so the controller dispatches it again. The pipeline's loop protection is the backstop, not the design: if a submission stops with a message naming your flow, your custom flow is not logging its outcome.
{% endhint %}

## Level 3: override the engine

Change the engine only when the change is genuinely about *behaviour*: different matching, a different save strategy, an extra follow-up. Anything about *which fields go where* belongs in a step flow.

Clone the engine, make the change, and point the step flows at your clone. Bear in mind what you are taking on: the engine is the piece that keeps the pipeline honest. If you clone it, preserve these or the conversion stops being safe to rerun:

- **The insert with no Account.** Contact 1 must reach NPSP without an `AccountId` so NPSP builds the Household. An engine that assigns an Account first produces a family with no NPSP Household at all.
- **The read-back after the save.** A save returns only the fields that were written, and NPSP writes the Household during the save. The stamp, the log and every follow-up need the Contact as it now stands.
- **The record type guard on the stamp.** Only an Account whose record type is `HH_Account` may be stamped on the submission. Stamping an employer makes the Account rule rewrite that organisation with household values.
- **The status and lookup stamping.** The engine passes the sentinel `--From Platform Event--` for the status and lookup field names, which lets the Log action read them from the event. That indirection is what lets one engine serve the Contact 1 and Contact 2 slots.
- **The error convention.** An error log leaves the slot's status non-terminal so Reprocess can rerun it. Log a static message naming the step that failed, and the flow's exact label. Do not stamp a terminal status on failure.
- **One return to the controller.** Every success path must reach the return element exactly once. A success path that dead-ends stalls the entire conversion with no error at all.

## Reuse the affiliation utility in your own automation

`(NPSP) Utility | Upsert | Affiliation` was built to be useful outside the form pipeline. It takes plain values, returns plain values, never writes a conversion log, and needs no Form Submission, Form Template or platform event. Call it from a record-triggered flow, a screen flow, a scheduled flow or Apex.

| Direction | Name | Notes |
| --- | --- | --- |
| In | `ContactId` | Required. The person to affiliate. |
| In | `AccountId` | Required. Must be an Organization; a Household is refused. |
| In | `Role` | Optional, usually the person's job title. Blank leaves an existing affiliation's Role as it is. |
| Out | `AffiliationId` | The affiliation that now exists, created or updated. |
| Out | `ConversionStatus` | `Created` or `Updated`, so a caller that is logging can speak the framework's vocabulary. |
| Out | `HasError`, `ErrorMessage` | True with one sentence of explanation when a step failed or the Account is not an Organization. |

*Use it anywhere a person needs linking to an organisation: a data load, an employment change screen, a nightly tidy-up.*

What it guarantees, so your caller does not have to:

- **It never duplicates.** The person's Current affiliation to that Organization is updated instead, newest Start Date first.
- **It never closes out an employer.** Primary is claimed only when the person has no primary affiliation, or when their primary is already this Organization. NPSP retires the previous primary whenever a new one is marked Primary, and this rule is what stops that happening by accident.
- **It never touches a Household.** A Household Account comes straight back as an error with a message, because a person belongs to a Household through their Contact's Account, not through an affiliation.
- **It preserves what it does not map.** Start Date is kept, and anything else on an existing affiliation, including End Date and your custom fields, is left alone.

{% hint style="info" %}
The utility writes with a single element set to upsert on Id: a blank Id inserts, a real Id updates. That is what makes it safe to call repeatedly, from a form conversion or from anywhere else.
{% endhint %}

## Upgrading safely

- **Never edit the packaged flows in place.** Clone them. A packaged flow is replaced on upgrade, and edits are lost.
- **Keep your customization in the layer that owns it.** Mapping changes in a cloned step flow survive engine upgrades untouched.
- **Record what you repointed.** The three Conversion Mapping Default records are the switchboard for the whole pipeline, and they are the first place to look when a conversion suddenly runs the wrong flow.
- **Test with Reprocess.** The fastest way to test a customization is a submission you have already converted: fix, click Reprocess, and watch the Conversion Log.
