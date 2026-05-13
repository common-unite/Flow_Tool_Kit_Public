# Prefill Flow

The **Prefill Flow** lets you run an autolaunched Flow when a Form Template first loads, populating fields and seeding repeater/table sections with logic you control — no Apex required. The Flow runs server-side, queries any records the running user can see, and returns a Form Submission that becomes the form's starting state.

This replaces the older pattern of wrapping `formTemplate` in a Screen Flow just to run a Get Records before render. Drop `formTemplate` directly on an Experience Cloud or Lightning page, point its Form Template at a Prefill Flow, and the form prefills itself.

## When the Prefill Flow runs

The Flow runs exactly once, on the **initial load of a fresh Form Submission** (no Id yet). On resumed drafts (an existing Form Submission re-loaded by Id), the Flow does **not** run — the draft's persisted values are the source of truth on that path.

## Configuring a Form Template

1. Open the Form Template record.
2. In the **Default Form Values** section, set the **Prefill Flow** picklist to the API name of the autolaunched Flow you want to run. The base package ships with `(Form) Prefill | Template` (the starter) and `Bypass` (the default — no prefill flow runs).
3. Save.

Every page or component bound to this Form Template inherits the prefill behavior. You don't configure it per-placement.

![Prefill Flow picklist on the Form Template edit modal](https://raw.githubusercontent.com/common-unite/Flow_Tool_Kit_Public/release_2gp_production/documents/screenshots/123-prefill-flow-demo.gif)

## The Flow contract

Your prefill Flow must accept one input variable and return at least one output variable. Two optional outputs let you seed related records or stop form load entirely.

| Variable | Direction | Type | Required | Purpose |
| --- | --- | --- | --- | --- |
| `record` | Input | SObject `Form_Submission__c` | Yes | The Form Submission after defaults + URL-param prefill, so your Flow can read existing values and decide whether to keep, overwrite, or fall back. |
| `prefillRecord` | Output | SObject `Form_Submission__c` | Optional | Fields set here overwrite the local Form Submission. Missing or null is a silent bypass — the form renders with whatever was already prefilled. |
| `prefillRelatedRecords` | Output | Collection of SObject `Form_Submission__c` | Optional | Seeds repeater or table sections. Each entry's `Internal_SectionId__c` tells the form which section it belongs to (see [Section Tag routing](#section-tag-routing) below). |
| `hasError` | Output | Boolean | Optional (default false) | When `true`, the form stops loading and the error illustration shows instead. Use this to gate form load on conditions only your Flow knows about. |
| `errorMessage` | Output | String (rich text supported) | Optional | When `hasError = true`, this string renders as the illustration subtitle. Supports HTML formatting and Flow merge fields. |

## Recommended pattern: surgical mapping via Transform

The starter `(Form) Prefill | Template` uses **Transform elements** for field mapping. Each `transformValueActions` entry maps one output field, so the Transform's result includes only the fields your Flow owns. This avoids the most common mistake: bulk-copying every field of `record` onto `prefillRecord`, which would wipe out the Form Template's prefill values and any URL parameters the running user passed in.

The starter Flow:

1. Looks up the running user's Contact (matches by `$User.ContactId`, the Form Submission's `Contact_1__c`, or the Form Submission's `Account__c` via OR logic).
2. Looks up the Contact's Account.
3. A **Switch** decision guards downstream work — only proceeds when both Contact and Account exist (so anonymous guests with no Contact safely no-op).
4. The **Pre-fill Mappings** Transform builds `prefillRecord` with `Contact1_First_Name__c`, `Contact1_Last_Name__c`, `Contact1_Phone__c`, `Contact1_Email__c`, plus Account fields (`Company__c`, `Company_Phone__c`, `Website__c`, `Description__c`).
5. A second **Alternate Contacts** Transform builds a collection of related Form Submissions for every other Contact on the Account, with `Internal_SectionId__c = "Contacts"` so they route to the section tagged `Contacts`.
6. Assignment writes `prefillRecord` to the output and `Add`s the alternate contacts collection to `prefillRelatedRecords`.

![Starter Flow canvas in Flow Builder](https://raw.githubusercontent.com/common-unite/Flow_Tool_Kit_Public/release_2gp_production/documents/screenshots/123-prefill-flow-builder-canvas.png)

## Section Tag routing

`prefillRelatedRecords` needs to know which repeater or table section each record belongs to. Sections have a runtime `Form_Template_Page_Section__c.Id` that changes every time the template is copied or migrated — a bad value to hard-code in a Flow.

**Use Section Tags instead.** Each Form Page Section has a new **Section Tag** picklist field. Pick a stable identifier like `Contacts`, `Tasks`, `Cases`, or `Opportunities` (or add your own value to the `Data_Conversion_Tag_s` global value set).

On each entry in `prefillRelatedRecords`, set `Internal_SectionId__c` to the tag value (e.g. `"Contacts"`). The form normalizes at runtime:

- Matches a section's `Form_Template_Page_Section__c.Id` → kept as-is
- Matches a section's `Section_Tag__c` → swapped for the runtime Id
- No match → field cleared, record dropped from render, console warning logged

A trigger enforces Section Tag uniqueness within a Form Template, so you can't accidentally tag two sections the same way.

## Preventing form load (the `Already_Submitted` pattern)

When your Flow detects a condition that should block the user from filling out the form, set `hasError = true` and `errorMessage`. The starter Flow ships this pattern active for the duplicate-submission case:

1. After Contact + Account lookups, the Flow queries `Previous_Form_Submission` — Form Submissions matching this Contact, this Form Template, and submitted status.
2. The Switch decision adds an `Already_Submitted` rule: when `Previous_Form_Submission IsNull = false`, route to an Assignment that sets `hasError = true` and `errorMessage` to a rich-text template referencing `{!Contact.FirstName}`, `{!Previous_Form_Submission.Form_Template__r.Name}`, and `{!Previous_Form_Submission.Submission_Date__c}`.
3. The form replaces itself with the error illustration showing the personalized message.

Extend this pattern for any condition: license checks, eligibility windows, application-status gates. Each new rule routes to its own Assignment element that sets `hasError + errorMessage` before terminating.

## Cloning the starter to customize

The starter Flow is shipped as a **Template flow** (`isTemplate=true`) — you'll see a Clone affordance in Setup → Flows. To customize:

1. Open the starter Flow in Flow Builder.
2. Click **Save As** → **A New Flow** to clone into your namespace.
3. Edit your clone (Contact lookup, Transforms, error gating — all yours).
4. Activate the clone.
5. Add your clone's API name to the `Form_Template__c.Prefill_Flow_Api_Name__c` picklist values via Setup → Object Manager → Form Template → Fields & Relationships → Prefill Flow → New Picklist Value.
6. Point your Form Template at the clone.

## Surgical assignment vs. bulk copy

**Do not** drop a Transform that maps every field of `record` onto `prefillRecord`. This is the most common admin mistake. Any field present on `prefillRecord` overwrites the corresponding field on the live Form Submission — including the ones the Form Template's own prefill record and URL parameter mappings already set. Bulk copying wipes those out.

Instead: each Transform element should map only the fields your Flow is responsible for computing. Leave every other field untouched on `prefillRecord` so the existing prefill values flow through unchanged.

If you want a field set conditionally — *"use the Contact's email if we have one, otherwise keep whatever was already prefilled"* — use a formula resource with `BLANKVALUE`:

```
BLANKVALUE({!Contact.Email}, {!record.Contact1_Email__c})
```

Map the formula to the Transform's output instead of the raw `{!Contact.Email}` reference.

## URL parameter security

URL parameters on a guest community page are public and tamperable. Don't carry sensitive identifiers (Salesforce record Ids, email addresses, etc.) in the URL where someone can guess or modify them.

**Recommended pattern when you must carry an identifier in a URL:** add a custom Text field on the source object (e.g. `Contact.Prefill_Token__c`, length 22, External Id, Case-sensitive, Unique). Populate it via a record-triggered Flow on insert. Merge the field into your email templates (`{!Contact.Prefill_Token__c}`). Your prefill Flow's Get Records filter matches by the token field instead of by Id.

A 22-character base-62 random token has ~131 bits of entropy — non-enumerable and non-guessable for any practical attacker. No encryption, no HMAC, no shared secret to manage, no expiration logic.

What this pattern doesn't protect: leaked URLs (forwarded emails, screenshots). Rotate the token field on the affected record to invalidate the old link.

## Guest users and the upsert override

When a guest user fills out a form on a guest community, they can INSERT a new Form Submission (Salesforce allows that), but they cannot UPDATE one in user mode (Salesforce sharing blocks it). The **`Form_Submission_Upsert`** Flow exists as the documented escape hatch — but **the package ships it in user mode**.

**FlowToolKit is a managed package and cannot ship any Flow or Apex that elevates sharing.** Every Flow in the package, including this one, runs in user mode by default. The Flow defines the *interface*; if you need actual elevation, you override.

To enable guest-user updates:

1. Clone `Form_Submission_Upsert` into your own namespace.
2. Set your clone's Run In Mode to `System Mode Without Sharing` (or a more constrained scope you can defend).
3. Wire your override through the standard FlowToolKit override mechanism so the `formTemplate` LWC invokes your clone instead.
4. Document the security review: keep `without sharing` to the smallest scope, validate the inbound `record` shape and ownership before persisting, log anything unexpected.

Salesforce and the Flow Tool Kit managed package are NOT responsible for data exposure or destructive DML introduced by a subscriber override. The override mechanism gives you full control over the DML — the security review is on you.

## Troubleshooting

### "I added a Prefill Flow and now my URL parameters stopped working"

Your Flow is bulk-copying `record` onto `prefillRecord`, which overwrites every field — including the ones URL parameters set. **Fix:** open your Transform elements and remove every `transformValueActions` entry except the fields your Flow is responsible for computing.

### "My prefilled rows in the repeater are wiped out when the user edits"

Your `prefillRelatedRecords` entries don't have a stable identifier the repeater can track. **Fix:** stamp `ExternalId__c` on each entry with a non-empty value (the source Contact Id is a natural choice). The form derives `_Id` from `ExternalId__c` so the repeater can match across re-renders.

### "Prefill Flow Error: flow could not be loaded"

The picklist value points to a Flow that doesn't exist or isn't active. **Fix:** in Setup → Flows, confirm your cloned Flow is named exactly as the picklist value and shows status Active. If you renamed it, update the picklist value to match.

### "Prefill Flow Error: returned an error"

Your Flow's body threw an error during execution. **Fix:** open the browser console while the form loads — the LWC logs `event.detail` from the Flow runtime, which includes the error and the failing element. Cross-check against Setup → Process Automation → Paused and Failed Flow Interviews if needed.

### "Flow finishes but no prefill happens"

`prefillRecord` is missing from the Flow's outputs, OR your Switch/Decision logic isn't reaching the Transform that sets it. This is treated as a silent bypass (not an error) — the form renders normally with current values. **Fix:** confirm at least one path through your Flow reaches an Assignment that writes to `prefillRecord`, and that the output variable name is exactly `prefillRecord` (case-sensitive).

### "Guest user can't save the form"

The Form Submission already has an Id and Salesforce sharing blocks the guest UPDATE. The default upsert override Flow runs in user mode and won't bypass this. **Fix:** clone the override Flow into your namespace with elevated sharing as described above, and wire it through the override mechanism.

## Security disclaimer

Salesforce and the Flow Tool Kit managed package are NOT responsible for data exposed through misconfigured or intentionally relaxed prefill Flows. The client org is responsible for reviewing every Flow it authors against the data exposure model of the surrounding page — authenticated user, guest user, internal user — and applying appropriate sharing posture (user mode by default, elevation only with deliberate review).
