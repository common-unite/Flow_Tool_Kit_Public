# Stages Mode

> Render a Form Template as a non-linear stepper. Respondents see all pages at once, pick their path, work in any order, and the form remembers what's done.

![Stages overview showing pages with Complete, In progress, and Todo status badges, time estimates, and per-stage action buttons](https://raw.githubusercontent.com/common-unite/Flow_Tool_Kit_Public/main/documents/screenshots/125-stages-overview.png)

## Why Stages Mode

The default linear flow (page-by-page Next/Back) is great for short forms or scripted intake. It struggles when:

- The form has 5+ pages and respondents want to skip around
- Multiple contributors fill different sections (e.g. program staff filling Project Details while finance fills Budget)
- Respondents come back across multiple sessions and need a visual progress overview
- Some pages are optional and should be visually de-emphasized

Stages Mode replaces the linear runtime with a **stage overview** as the home screen. Each page becomes a "stage" card showing title, description, time estimate, optional/required badge, and current status. Respondents click into a stage, fill it out, then **Mark Page Complete** or **Return to Stages**.

## Enabling Stages Mode

1. Open the Form Template record.
2. Check **Stages Mode**. Save.
3. (Optional) For each page, fill in the new fields described below.

That's it. No code or flow changes — the `formTemplate` LWC detects the flag and switches rendering.

## Page-Level Configuration

Three new fields on `Form_Template_Page__c` shape how each stage card renders.

| Field | Type | Purpose |
| --- | --- | --- |
| **Description** | Long Text Area (500) | Subtitle text shown under the page title on the stage card. One or two sentences. |
| **Estimated Time (Minutes)** | Number(3,0) | Time estimate in minutes (e.g. enter `4` to display "4 min"). Used to compute the total time remaining at the top of the stages overview. Leave blank to omit the time chip. |
| **Is Optional** | Checkbox | When checked, the card shows an **Optional** badge and the page is excluded from required-step completion totals. |
| **Button Label** | Picklist (existing field) | Drives the **start-step button label** on the stage card when the stage is in `Todo` state. Pick any picklist value (`Start Step`, `Add Documents`, `Apply Now`, etc.). Falls back to `Start Step` if blank. The value is admin-controlled and translation-friendly via Salesforce Translation Workbench. |

All four fields are optional. Leave them blank and the stage card falls back to just the page label with `Start Step` on the action button.

![Form Template edit modal showing per-page Button Label configuration and the Prefill Flow selector](https://raw.githubusercontent.com/common-unite/Flow_Tool_Kit_Public/main/documents/screenshots/125-stages-template-config.png)

> **Trigger default:** when a new Form Template is inserted with **Stages Mode** enabled, the `Form_Template` trigger sets the auto-created first page's `Button_Label__c` to `Start Step` (instead of the field default `Continue`). Subsequent pages added by the admin keep the standard `Continue` default so they can be overridden per-page.

## Runtime — What Respondents See

When a respondent opens a stages-mode template they land on the **stages overview**, not page 1.

![Walkthrough: opening a stage, filling the form with the vertical stage indicator on the left, and the Return / Save Progress / Mark Complete footer buttons](https://raw.githubusercontent.com/common-unite/Flow_Tool_Kit_Public/main/documents/screenshots/125-stages-walkthrough.gif)

- One card per page, in `Position__c` order
- Each card shows: number, title, description (if set), time chip (if set), Optional badge (if set), status badge, and an action button
- Status badges: **Todo** (default), **In progress** (the page they've started), **Complete**, **Optional**, **Locked**, **Needs attention** (validation error)

Click a stage to open that page. Two buttons at the bottom replace the standard NEXT/BACK:

- **Mark Page Complete** — validates the page, saves, marks the stage as `Done`, returns to the overview
- **Return to Stages** — saves any progress and returns to the overview without marking the stage complete (if the stage was `Todo`, it flips to `Current` to show the respondent has started it)

## Data Model

Stages mode adds one runtime object: `Form_Submission_Stage__c`.

| Field | Type | Notes |
| --- | --- | --- |
| **Form Submission** | Master-Detail | Parent submission. Sharing is controlled-by-parent. |
| **Form Template Page** | Lookup | Which page this stage represents. |
| **Status** | Picklist (restricted) | `Todo`, `Current`, `Done`, `Error`, `Locked`, `Optional`. Default `Todo` (or `Optional` if the page is marked Is Optional). |
| **Assigned User** | Lookup(User) | Optional — assign a specific user to own this stage. |
| **Completed Date** | DateTime | Stamped when status flips to `Done`. |
| **Completed By** | Lookup(User) | Set when status flips to `Done`. |
| **Sort Order** | Formula(Number) | Mirrors `Form_Template_Page__r.Position__c`. Used for stage ordering in the overview. No trigger needed when admins reorder pages. |

Stage records are **auto-created** by the `Form_Submission` trigger immediately after a new submission is inserted, one per page, with status `Todo` (or `Optional`). No admin action needed.

## Security Model

Because `Form_Submission_Stage__c` is master-detail to `Form_Submission__c`:

- **Anyone with edit access to a submission can edit any stage** on it. There is no per-stage owner gate. This is intentional — multi-user collaboration was the whole reason for the feature.
- Sharing is automatic; no sharing rules required.
- Guest users assigned `Form_Flow_User` can create stages (the auto-creation trigger inserts as the running user) and update Status on stages they can see via parent-record visibility.

The three FlowToolKit permission sets ship with full CRUD/FLS:
- `Form_Builder_Admin` — full access
- `Form_Builder_Manager` — full access
- `Form_Flow_User` — create + read + edit (no delete)

## Save & Resume via Email

A respondent partway through a long form can click **Email me a resume link** in the stages overview header and receive a single-use URL that returns them to their exact saved state. Combined with Stages Mode, this is the answer for multi-session forms: nonprofits leaving applications open for weeks, finance teams pausing on the budget page until they have figures, contributors handing off between staff and program leads.

![Stages overview header showing the "Draft saved" indicator and the "Email me a resume link" button, with completed stages below](https://raw.githubusercontent.com/common-unite/Flow_Tool_Kit_Public/main/documents/screenshots/127-draft-saved-resume-button.png)

> ### Required setup — must be done before the feature works in your org
>
> The package ships the token plumbing, the trigger, the prefill match, the LWC button, and a starter send-resume-link flow. **Two things you have to do yourself** before the resume email is usable end-to-end:
>
> 1. **Create an EmailTemplate** (Classic or Lightning, Object Type = `FlowToolKit__Form_Submission__c`) and reference its `DeveloperName` from `Form_Template__c.Email_Template_Name_Resume_Form__c` on every Form Template that should use a branded email. The template body builds the resume URL using `{!FlowToolKit__Form_Submission__c.FlowToolKit__Internal_Unique_Token__c}` as the `pv9` URL parameter, pointing at your Experience Cloud / Lightning record page domain. **Without this, the resume email falls back to a minimal inline body whose URL is a `https://YOUR-DOMAIN/...` placeholder — non-functional outside Salesforce.**
> 2. **OR override the shipped flow** — clone `(Form) Form Submission Send Resume Link | Overridable`, open its `EmailBody` text template, and replace the `YOUR-DOMAIN` placeholder in the inline `<a href="...">` with your actual Experience Cloud or Lightning Experience domain. Activate the clone, deactivate the shipped flow. This is the fallback path when an admin would rather embed the URL in the flow than via an EmailTemplate.
>
> Pick option 1 for branding flexibility and Translation Workbench support; option 2 if the inline body is good enough but you need the URL fixed. **Without one or the other, the resume link button will send an email containing a literal `YOUR-DOMAIN` placeholder URL that won't work.**

### How it works

1. Respondent clicks **Email me a resume link** in the form header (visibility rules below).
2. The LWC runs the standard save-progress logic, then stamps `Form_Submission__c.Internal_Send_Resume_Link__c` with the current datetime.
3. The `Form_Submission` Apex trigger watches that field. When it transitions to a non-blank value (or changes to a different non-blank value), the trigger generates a cryptographically random 32-character hex token (128 bits, via Salesforce's `Crypto.generateAesKey` CSPRNG) and writes it to `Internal_Unique_Token__c`. The token is **not** derived from any record field — it cannot be computed by anyone who has read access to the submission.
4. The `Form_Submission_Send_Resume_Link` autolaunched flow fires record-triggered on the token write. It resolves the recipient via the formula:
   ```
   BLANKVALUE($User.Email, BLANKVALUE($Record.Contact1_Email__c, $Record.Email__c))
   ```
   — the logged-in user's email wins, then `Contact1_Email__c`, then `Email__c`. If all three are blank the flow no-ops gracefully.
5. The email goes out with merge fields for the submission Id (`{!$Record.Id}`) and token (`{!$Record.Internal_Unique_Token__c}`). The shipped body is intentionally minimal — admins clone the flow to brand the email and construct the full resume URL.
6. The recipient clicks the link, which carries URL parameter `pv9` (Token) into the Form Template record page.
7. The Form Template's existing URL parameter mapping (`pv9 → Internal_Unique_Token__c`) feeds the token into the `Form_Submission_Prefill` flow's `record` input.
8. The prefill flow's new resume path looks up the submission by **Token + Form_Template**. The token is a unique 128-bit random secret — adding the Submission Id to the match would be theater (any attacker with the URL also has the Id), so we keep the URL short and the Submission Id off the wire. The flow clears both `Internal_Unique_Token__c` and `Internal_Send_Resume_Link__c` (making the link single-use), and returns the saved submission plus all child `Form_Submission_Stage__c` records to the LWC.
9. The LWC detects the resumed record by its Id, hydrates the stages overview from the returned stages, and auto-expands the last-edited stage (`Internal_LastSavedPageId__c`).

### When the "Email me a resume link" button is visible

The button is **shown** when **ALL** of these baseline conditions are met:

1. The Form Template has `Stages_Mode__c = true`
2. The Form Template has `Allow_Save_Progress__c = true`
3. The Form Submission has been persisted (has an `Id` — i.e. the form is past its first save)

**AND** at least one of these recipient conditions is true:

- The running user is **not a guest** (logged-in users — internal Salesforce or Experience Cloud portal — have a valid `User.Email` the flow can send to), **OR**
- `Form_Submission__c.Contact1_Email__c` is populated, **OR**
- `Form_Submission__c.Email__c` is populated, **OR**
- `Form_Submission__c.Contact_1__c` (Contact lookup) is populated

The button is **hidden** when:

- The form is not in Stages Mode, or Allow Save Progress is off, or the submission hasn't been saved yet
- The user is a guest AND none of the three contact/email fields are populated (no viable recipient — the email would go to the Site Guest User noreply address)
- The form has already been submitted (`Submission_Date__c` is set) — the `allowSaveProgress` getter returns false post-submission, so the button hides automatically

**Why these rules?** The button triggers an email send. If the package can't resolve a viable recipient at button-press time, clicking it would silently fail or send to a dead address. The visibility gate prevents that confusing UX. For internal users without contact fields, the button still shows because `$User.Email` is always viable.

### Token security model

- **32-character hex = 128 bits of true randomness** from Salesforce's CSPRNG (`Crypto.generateAesKey(128)`). Collision-proof at any realistic scale, not guessable, and **not derivable from any visible record field**. An attacker who can read the Submission Id and `Internal_Send_Resume_Link__c` cannot compute the token.
- **`Internal_Unique_Token__c` is indexed (External ID + Unique)** so the prefill lookup is O(1) regardless of submission volume.
- **Single-use** — token cleared on consumption by the prefill flow. The same link cannot be used twice.
- **Regenerate-always** — every click on **Email me a resume link** generates a fresh token and invalidates the previous email link. Re-requesting the link deliberately kills any earlier copy.
- **Internal field** — `Internal_Unique_Token__c` is treated as system metadata. It should never appear on a record page layout exposed to end users.

### Token lifecycle — when tokens are cleared

A token is cleared (and the resume link rendered dead) in any of four situations:

1. **Consumption** — the prefill flow clears the token the moment the resume URL is opened and matched. Single-use.
2. **Re-request** — clicking **Email me a resume link** again regenerates a fresh token; the previous one no longer matches.
3. **Form submission** — when the respondent finally submits the form (`Submission_Date__c` set), the `Form_Submission` trigger clears both `Internal_Send_Resume_Link__c` and `Internal_Unique_Token__c` automatically. No reason to keep a resume link for a completed submission.
4. **Expiration via scheduled flow** — `Form_Submission_Expire_Resume_Tokens` runs daily and clears tokens older than **7 days** (default). Subscribers clone this flow to change the window — for instance, a 30-day window for a long-form grant application or a 24-hour window for a short intake form.

Combined, these mean an active token lives at most 7 days, and any leaked / forwarded / cached resume URL stops working at the earliest of: consumption, re-request, submission, or 7-day expiration.

The **Email me a resume link** button itself is automatically hidden from the stages overview once the form has been submitted (the LWC's `allowSaveProgress` getter returns false when `Submission_Date__c` is set).

### Guest user support requires flow override

By default the package ships **`Form_Submission_Prefill`** in `DefaultMode` (user mode). This is a deliberate choice: Salesforce Security Review prohibits packaged code that elevates sharing. **The packaged feature works out of the box for logged-in users only.**

For a guest-portal scenario (Experience Cloud public form, respondent has no Salesforce login), the resume link will not work as shipped because the Site Guest User cannot see `Form_Submission__c` records they didn't create. Subscribers who need guest support must:

1. Clone `Form_Submission_Prefill` to their own namespace (e.g. `MyOrg__Form_Submission_Resume_Guest`).
2. Edit the clone and change `<runInMode>DefaultMode</runInMode>` to `<runInMode>SystemModeWithoutSharing</runInMode>`.
3. Activate the clone, deactivate the shipped flow, and point `Form_Template__c.Prefill_Flow_Api_Name__c` at the clone.

**Security implications the subscriber accepts when doing this:**

- Any guest who possesses a valid token can read and update the matched Form Submission. The token IS the access boundary in that model.
- The token is single-use and 128 bits, so an attacker cannot brute-force or replay. But if an email is forwarded to a third party, that third party CAN consume the link.
- The clone should still match on **all three keys** (Id + Token + Form_Template) — never weaken the match condition.
- Subscribers running this in guest mode should also audit the Form Template record page exposure: anything the prefill flow returns is now visible to anyone with a valid token, regardless of which guest originally filled out the form.

This is exactly the kind of "subscribers extend in their own namespace" pattern FlowToolKit is designed around. The package never elevates sharing on the subscriber's behalf.

### Path 1 (preferred) — Customize via Form Template's Email Template Name field

The shipped `Form_Submission_Send_Resume_Link` flow looks at the linked Form Template's **Email Template Name (Resume Form)** field. If that field is populated, the flow finds the EmailTemplate by DeveloperName and sends via it — the admin's full branding, copy, and merge fields take over. **If the field is blank, the flow falls back to the inline body which contains a `YOUR-DOMAIN` placeholder URL that will not work in real email clients — you MUST either populate this field or override the flow (Path 2).**

**To configure a branded resume email per Form Template:**

1. **Build an EmailTemplate** (Classic or Lightning) — Setup → Email Templates → New. Give it a meaningful DeveloperName like `Resume_Grant_Application`. The Object Type should be `FlowToolKit__Form_Submission__c` so merge fields like `{!FlowToolKit__Form_Submission__c.FlowToolKit__Internal_Unique_Token__c}` are available.
2. **Construct the resume URL inside the template body** — substitute your real Experience Cloud or Lightning record page domain for `<your-site-domain>`:
   ```
   https://<your-site-domain>/path/to/form-template-page?pv9={!FlowToolKit__Form_Submission__c.FlowToolKit__Internal_Unique_Token__c}
   ```
3. **Open the Form Template record** and set **Email Template Name (Resume Form)** to the EmailTemplate's DeveloperName (e.g. `Resume_Grant_Application`). Save.
4. **Test** — click "Email me a resume link" on a form submission for that template. Your branded email arrives instead of the package default.

### Path 2 — Override the shipped flow's inline EmailBody with your domain

If you don't want to manage an EmailTemplate record but still need the resume link to actually work, **override the shipped flow's inline body** so the URL in its `EmailBody` text template uses your real domain instead of the `YOUR-DOMAIN` placeholder.

1. **Clone** `(Form) Form Submission Send Resume Link | Overridable` — Setup → Flows → click the flow → Save As. Give the clone a meaningful API name in your namespace.
2. **Edit the clone's `EmailBody` text template** and replace `https://YOUR-DOMAIN/{!$Record.Form_Template__c}?pv9=...` with your actual resume URL (Experience Cloud site URL, Lightning record page URL, or wherever your form template renders). Both the button `<a href>` and the fallback "paste this URL" footer use the placeholder — replace both.
3. **Activate the clone, deactivate the shipped flow.** The trigger condition (`ISCHANGED(Internal_Unique_Token__c) AND NOT(ISBLANK(Internal_Unique_Token__c))`) means both would otherwise fire and the recipient gets two emails — only one should be Active at a time.

This same clone is also the right place to add anything else the inline body can't express — send through SendGrid / Mailgun, attach a PDF, switch templates by submission state, etc.

### Either path is required

**Without one of these two paths, the resume link email will literally read `https://YOUR-DOMAIN/...` in the recipient's inbox** — the click won't go anywhere useful. The package ships the wiring (token generation, single-use clearing, flow trigger, LWC button, prefill match) but the URL domain is org-specific and the package cannot construct it. Path 1 is the lightest-weight option (no flow override needed); Path 2 is the right choice if you want the URL fixed in the flow itself.

### Admin-initiated form invitations

The same `Internal_Unique_Token__c` mechanism that powers respondent-initiated resume links can be used **in reverse** — admins building outbound flows that pre-create Form Submissions for known contacts/accounts and invite them via email to start the form. The token gives the recipient a clean one-time URL into a pre-populated draft, without giving them broad Salesforce access.

**The package ships the send-the-email half** via `Form_Submission_Send_Start_Link` — a record-triggered after-insert flow that fires when a new Form Submission is inserted with `Internal_Unique_Token__c` populated AND the linked Form Template has `Email_Template_Name_Start_Form__c` configured. The flow looks up the named EmailTemplate by DeveloperName, resolves the recipient, and sends.

**The admin builds the create-the-record half** — a custom flow (scheduled, record-triggered on a source object, or screen) that queries the records they want to invite, generates tokens, and inserts the Form Submissions.

**Example use cases:**
- A grants program officer pre-creates draft applications for every nonprofit in their database and emails each one a personalized "start your application" link
- An annual renewal flow that builds a Form Submission for every active grantee on Jan 1, pre-filled with last year's data, with a link to update and resubmit
- A registration flow that pre-creates a draft submission for every Lead a marketing campaign generates, with a "complete your registration" link

**Implementation pattern (admin's custom flow):**

1. **Query the source records** — Contacts, Accounts, Leads, Opportunities, last year's submissions, etc. (scheduled, record-triggered, or screen flow — admin's choice).
2. **Generate a random token** — 32+ random characters. Several options:
   - **Formula or expression** in the flow combining `LPAD(...)` of multiple `RAND()` calls — easy but not cryptographically strong. Acceptable for low-stakes invitations.
   - **A small Apex invocable** in the admin's namespace that wraps `EncodingUtil.convertToHex(Crypto.generateAesKey(128))` — the same CSPRNG the package uses. Recommended for sensitive workflows.
   - **`UUID` formula** via `LEFT(LOWER(REPLACE(CASESAFEID(GETRECORDIDS(...)), '0', '')), 32)` style tricks — not random, just record-bound. Don't use for security-sensitive cases.
3. **Build the Form Submission record** — assign the relevant `Form_Template__c`, prefill the contact / account / amount / whatever fields the source record knows. Set `Internal_Unique_Token__c` to the generated token. Leave `Submission_Date__c` blank (it's a draft).
4. **Insert the record.** The shipped `Form_Submission` trigger does NOT regenerate the token on insert — it only watches the `Internal_Send_Resume_Link__c` field on update. Admin-set insert tokens are preserved as-is.
5. **Send the email.** Two options:
   - **Use the shipped flow (preferred for most admins)** — configure `Email_Template_Name_Start_Form__c` on the Form Template with the DeveloperName of an EmailTemplate. The shipped `Form_Submission_Send_Start_Link` flow fires automatically on every insert that has a token + a configured template, resolving the recipient to the Owner's email if the Owner is a portal user (`CspLitePortal`, `CustomerSuccess`, `PowerCustomerSuccess`, `PowerPartner`), otherwise to `BLANKVALUE(Contact1_Email__c, Email__c)`. Zero custom flow steps required for the send.
   - **Send your own** — leave `Email_Template_Name_Start_Form__c` blank on the Form Template and the package's send-flow no-ops. The admin's outbound flow handles email send through any action of their choosing (custom Apex action, third-party send service, SendGrid invocable, etc.).

**URL the admin's email links to:**

```
https://<your-site-domain>/path/to/form-template-page?pv9={!Form_Submission__c.Internal_Unique_Token__c}
```

Same `pv9` parameter the resume-link flow uses. The Form Template's URL mapping translates it into the prefill flow's `record.Internal_Unique_Token__c` input, the prefill flow matches the submission by `Token + Form_Template`, clears the token on consumption, and returns the prefilled draft to the respondent — exactly as if the respondent had clicked their own resume link.

**Lifecycle parity:**

- ✅ The token is **single-use** (cleared by the prefill flow on first click).
- ✅ The token is **scheduled for expiration** after 7 days by `Form_Submission_Expire_Resume_Tokens`. Admins running annual or longer-lead invitation programs should clone that flow and extend the window, or refresh tokens periodically.
- ✅ The shipped Form_Submission trigger clears the token on form submission, so a completed invitation submission won't keep the link alive.
- ✅ Token quality matters — the prefill flow doesn't care HOW the token was generated, just that it's unique. If the admin uses weak randomness, attackers could guess valid tokens and access drafts. Use CSPRNG-quality randomness for any token that protects sensitive data.

**Security considerations specific to outbound invitations:**

- **Forwarding risk** — anyone the email is forwarded to can consume the link. Single-use mitigates the abuse window (one consumption kills it for everyone), but the first opener wins. For sensitive workflows, pair the invitation with an additional auth step inside the form (e.g., a confirm-your-email field that must match `Contact1_Email__c`).
- **Sharing of the inserted record** — the admin's flow runs in user/system mode per the admin's choice. Whatever Owner / sharing the inserted Form Submission gets determines who can edit it after consumption. The token doesn't change Salesforce's standard sharing — it's an *entry* gate, not an *access* gate.
- **Bulk invitation auditing** — if the admin's flow generates thousands of invitations, log them. A misbehaving flow that emails the wrong list of contacts is hard to roll back; recommend admins gate large invitation runs behind a test record set first.

> **Blog post candidate.** This pattern — using FlowToolKit's resume-link token infrastructure for outbound admin-initiated form invitations — is one of the most powerful workflows the package enables, and most admins won't discover it on their own. Worth a standalone blog post with screenshots and a complete sample flow.

### Custom Labels involved

| Label | Default value | What it controls |
| --- | --- | --- |
| `Stages_Email_Me_Resume_Link` | "Email me a resume link" | The button label in the stages header |
| `Stages_Draft_Saved` | "Draft saved" | Prefix before the relative "N minutes ago" time |
| `Stages_Resume_Link_Sent` | "Resume link email sent" | Success toast after clicking the button |
| `Stages_Resume_Link_Error` | "Could not send resume link — please try again." | Error toast if the stamping/save fails |

Override the wording via Setup → Custom Labels; translate via Translation Workbench. Same pattern as the broader Stages-mode label inventory above.

### Field reference

| Field | Type | Purpose |
| --- | --- | --- |
| `Form_Submission__c.Internal_Send_Resume_Link__c` | DateTime | LWC writes this when the user clicks the button; trigger watches it. |
| `Form_Submission__c.Internal_Unique_Token__c` | Text(32) | Trigger generates a SHA-256 hex; prefill flow consumes and clears. |
| `Form_Submission__c.Last_Saved_Date__c` | DateTime | Powers the "Draft saved N min ago" indicator in the header. Updated by every save-progress. |
| `Form_Submission__c.Internal_LastSavedPageId__c` | Text | Used to auto-expand the last-edited stage on resume. |

All four are in the shipped permission sets (`Form_Builder_Admin`, `Form_Builder_Manager`, `Form_Flow_User`).

## Known Limitations

| Limitation | Workaround |
| --- | --- |
| **Toggling Stages Mode ON for a template with existing live submissions** doesn't backfill stage records on those existing submissions. The overview will render using a position-derived fallback status, but Mark Page Complete will be a no-op (no stage record to update). | New submissions auto-create stages correctly. For backfill on a specific submission, manually insert `Form_Submission_Stage__c` records, or wait for a future `backfillStages` helper. |
| **Substeps within a page** (per-section status) are not rendered. The component path exists but isn't wired to runtime data. | Roadmap. |
| **No built-in reports / dashboards** on stage progress. 2GP managed packages can't ship report types reliably. | Build custom reports in the subscriber org on `Form_Submission_Stage__c`. |

## Troubleshooting

### Stages don't render — runtime still shows linear pages

1. Confirm **Stages Mode** is checked on the Form Template record (not just on a clone or draft).
2. Confirm the template has at least one Form Template Page.
3. Hard-refresh the browser. The LWC reads `Stages_Mode__c` via `getRecord`, which may be cached.
4. Confirm the running user has FLS read on `Form_Template__c.Stages_Mode__c` via the assigned permission set.

### Stages render, but they're empty / show no rows

1. Open the parent Form Submission record. If it was created before Stages Mode was enabled on the template, no stage records exist. (See "Known Limitations" above.)
2. Inserting a fresh submission should auto-create stages. If it doesn't, check the `Form_Submission` trigger ran by querying `SELECT Id, Status__c FROM Form_Submission_Stage__c WHERE Form_Submission__c = '...'` in the Developer Console.
3. Confirm the user has read access to `Form_Submission_Stage__c` and its FLS-protected fields.

### "Mark Page Complete" doesn't flip the badge

1. Confirm the user has **edit** on `Form_Submission_Stage__c.Status__c`. The default `Form_Flow_User` perm set grants this; double-check on custom perm sets.
2. Check browser console for `updateStageStatus failed` — if present, the DML failed (most often FLS).
3. Confirm the stage record actually exists for the current page (run the query above). If not, the submission predates Stages Mode being toggled on.

### Stage order wrong

`Sort_Order__c` is a formula on `Form_Template_Page__r.Position__c`. If the order looks wrong:

1. Open each Form Template Page and confirm Position values are unique and in the intended order. Reorder via the Form Builder UI if needed.
2. If positions are correct but order is still wrong, the LWC may be reading stale cached data — refresh.

### "Optional" badge missing on a page marked optional

1. Confirm **Is Optional** is checked on the Form Template Page record (not the section).
2. Confirm FLS read on `Form_Template_Page__c.Is_Optional__c` for the running user.
3. Note that the stage record's `Status__c` is set to `Optional` only when the stage is auto-created. Toggling Is Optional after auto-creation doesn't retroactively update existing stage records.

### "Return to Stages" doesn't change the badge from Todo to In progress

The flip happens only when the running user has edit on `Status__c`. Same diagnostic as Mark Page Complete above.

## Customization & Translation — Custom Labels

Every user-facing string in the Stages overview is sourced from a Custom Label, so subscriber admins can override the wording or translate it via the Translation Workbench without touching code.

### Action button labels (formTemplate)

| Custom Label | Default value | Used when |
| --- | --- | --- |
| `Stages_Review_Answers` | "Review answers" | Stage status = Done |
| `Stages_Fix_Errors` | "Fix errors" | Stage status = Requires Correction |
| `Stages_Resume` | "Resume" | Stage is In Progress or has been started |
| `Stages_Start_Step_Fallback` | "Start Step" | Page's **Button Label** is blank — fallback for Todo / Optional unstarted stages. (The normal Todo/Optional label comes from `Form_Template_Page__c.Button_Label__c` itself, which is a translatable picklist.) |
| `Stages_Mark_Complete` | "Mark Complete" | Stages-mode NEXT button on a stage page — flips status to Done |
| `Return` *(reused — existing label)* | "Return" | Stages-mode BACK button label on a stage page |

### Progress card (formTemplateStages)

| Custom Label | Default value | Surface |
| --- | --- | --- |
| `Stages_Required_Steps_Complete` | "required steps complete" | After the "X of Y" counter |
| `Stages_Complete_Suffix` | "complete" | After the percentage ("XX% complete") |
| `Stages_Remaining` | "remaining" | After the minutes estimate ("~Nm remaining") |
| `Stages_Needs_Attention_Suffix` | "needs attention" | After the error count |

### Stage row badges (formTemplateStageRow)

| Custom Label | Default value | State |
| --- | --- | --- |
| `Stages_In_Progress` | "In progress" | Current stage |
| `Stages_Needs_Attention` | "Needs attention" | Stage with validation errors |
| `Stages_Optional` | "Optional" | Page marked Is_Optional |
| `Stages_Locked` | "Locked" | Stage locked by upstream logic |
| `Stages_Complete` | "Complete" | Stage marked Done |
| `Stages_Conditional` | "Conditional" | Page rendered by Conditional Logic |

### Meta pills, pluralization, accessibility

| Custom Label | Default value | Where |
| --- | --- | --- |
| `Stages_Section_Singular` | "section" | Substep meta ("1 section") |
| `Stages_Sections_Plural` | "sections" | Substep meta ("N sections") |
| `Stages_Error_Singular` | "error" | Error meta ("1 error") |
| `Stages_Errors_Plural` | "errors" | Error meta ("N errors") |
| `Stages_Fields` | "fields" | Fields meta ("X/Y fields") |
| `Stages_Expand` | "Expand" | Accessibility alt-text on the expand chevron |

### Overriding & translating

- **Override wording** for English only: Setup → Custom Labels → search "Stages_" → edit Value.
- **Translate** to another language: Setup → Translation Workbench → Translate → pick "Custom Label" → choose label → enter translation. The runtime picks up the user's locale automatically; no code or formula change.
- **Why this matters:** the previous hardcoded strings were not overridable or translatable. After v3.231 every Stages-mode surface is admin-controlled.

## Related

- [Pages and Sections](pages-and-sections.md) — how `Form_Template_Page__c` ordering and Position work.
- [Form Submissions](form-submissions.md) — the parent record stages hang from.
- [Permissions](../platform/permissions.md) — perm set assignment details.
