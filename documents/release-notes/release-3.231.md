# Flow Tool Kit v3.231 Release Notes

## New Features

### Stages Mode on Form Templates

Long forms with optional sections, multi-contributor workflows, or multi-session respondents have always struggled with the linear Next/Back rhythm. **Stages Mode** replaces that with a non-linear stepper — respondents land on a stage overview, see every page at a glance, jump in any order, and the form persists their progress through real records.

**What you can do.**

- Render any Form Template as a stage overview instead of page-by-page navigation.
- Show respondents description text, time estimates, and Optional badges per page.
- Let multiple users collaborate on the same submission, each owning different stages — sharing is controlled-by-parent through master-detail.
- Persist stage status (`Todo`, `Current`, `Done`, `Optional`) through real `Form_Submission_Stage__c` records, automatically created when the submission is inserted.
- Use `Mark Page Complete` to flip a stage to Done with `Completed_Date__c` and `Completed_By__c` stamped, or `Return to Stages` to leave a stage in progress.

**Configuring.** Open a Form Template record. Check the new **Stages Mode** field. Save. (Optional) For each Form Template Page, set **Description**, **Estimated Time**, **Is Optional**, and **Button Label** to shape the stage card. The action button on a Todo stage now reads its label from the page's existing **Button Label** picklist (so `Start Step`, `Add Documents`, `Apply Now`, etc. are all admin-controlled and translation-friendly via the Salesforce Translation Workbench). When a new Stages-Mode template is created, the auto-generated first page defaults to `Start Step` instead of `Continue`.

**Data model.** A new custom object — `Form_Submission_Stage__c` — is master-detail to `Form_Submission__c`. One record per page is auto-created on submission insert via the existing `Form_Submission` trigger. Status flips happen through `Form_Controller.updateStageStatus(...)` from the runtime. Sharing is automatic; no rules required.

**Permissions.** All three shipped permission sets — `Form_Builder_Admin`, `Form_Builder_Manager`, `Form_Flow_User` — already include the new object and field permissions. Re-assign your users after upgrading if you want them to see stages.

**Documentation.** See [Stages Mode](../form-template-framework/stages-mode.md) for the full admin guide, security model, troubleshooting catalog, and the **Customization & Translation** section that lists every new Custom Label (21 new labels: `Stages_Review_Answers`, `Stages_Fix_Errors`, `Stages_Resume`, `Stages_Mark_Complete`, badges, progress card, meta pills, accessibility) so admins can override wording or translate via the Translation Workbench without code changes.

### Save & Resume via Email

Pairs naturally with Stages Mode: when **Allow Save Progress** is enabled, the stages header now includes a **"Draft saved N minutes ago"** indicator alongside an **Email me a resume link** button. Clicking the button persists the current submission and dispatches an email to the respondent containing a single-use URL that returns them to their exact saved state — including their last-edited stage, auto-expanded on the overview. The standard pattern for long, multi-session forms like grants, applications, and intake.

**Security model.** Tokens are 32-character hex strings (128 bits of true randomness from `Crypto.generateAesKey`, Salesforce's documented CSPRNG). The token is NOT derived from the Submission Id, datetime, or any other visible field — so even a user who has read access to the submission cannot compute or guess a valid token. Single-use — the token is cleared the moment the resume link is consumed. Re-requesting the link generates a fresh random token, invalidating the previous email. The `Internal_Unique_Token__c` field is internal metadata and should not be exposed on any record page layout.

**Recipient resolution.** The shipped `Form_Submission_Send_Resume_Link` autolaunched flow sends to `BLANKVALUE($User.Email, BLANKVALUE($Record.Contact1_Email__c, $Record.Email__c))` — the logged-in user's email wins, then `Contact1_Email__c`, then `Email__c`. The Submission Id stays off the URL — the random token is the secret, scoped by Form_Template.

**Admin-controlled email content via Form Template fields.** Two new fields on `Form_Template__c` let admins specify EmailTemplate DeveloperNames per template: `Email_Template_Name_Resume_Form__c` (used by the resume-link flow) and `Email_Template_Name_Start_Form__c` (used by the new start-link flow). When populated, the package looks up the EmailTemplate by DeveloperName and sends via it; when blank, the resume flow falls back to a minimal inline body and the start flow no-ops.

**Required setup before resume links actually work.** The package ships the token plumbing and flow trigger, but **the email's resume URL is org-specific and you must configure one of two paths** before the resume button is functional end-to-end: (1) create an EmailTemplate with the resume URL pointing at your Experience Cloud or Lightning domain and set `Email_Template_Name_Resume_Form__c` to its DeveloperName, OR (2) clone `(Form) Form Submission Send Resume Link | Overridable` and replace the `YOUR-DOMAIN` placeholder in its `EmailBody` text template with your actual domain. Without either, the resume email will arrive containing a literal `https://YOUR-DOMAIN/...` URL. See [Save & Resume via Email — Required setup](../form-template-framework/stages-mode.md#required-setup-—-must-be-done-before-the-feature-works-in-your-org) for step-by-step instructions.

**Admin-initiated invitations.** New record-triggered flow `Form_Submission_Send_Start_Link` fires after-insert on Form_Submission__c when `Internal_Unique_Token__c` is populated AND the linked Form Template has `Email_Template_Name_Start_Form__c` configured. Admins build their own outbound flow (scheduled, screen, or triggered) that pre-creates Form Submissions with generated tokens for known contacts/accounts; the shipped start-link flow handles email send via the configured template. Recipient resolution: Owner.Email if Owner is a portal user (`CspLitePortal`, `CustomerSuccess`, `PowerCustomerSuccess`, `PowerPartner`), otherwise `BLANKVALUE(Contact1_Email__c, Email__c)`.

**Token lifecycle.** A token is cleared on any of: consumption (single-use, via the prefill flow), re-request (regenerate-always), form submission (the `Form_Submission` trigger nulls both fields when `Submission_Date__c` is set), or scheduled expiration after 7 days (default — overridable by cloning `Form_Submission_Expire_Resume_Tokens`). The **Email me a resume link** button is automatically hidden once the form has been submitted.

**Button visibility.** The **Email me a resume link** button is gated on a viable recipient being resolvable. It shows when Stages Mode + Allow Save Progress are enabled AND the submission has been saved AND at least one of: (a) the running user is logged in (not a guest) — internal or Experience Cloud portal users always have a viable `User.Email`; or (b) `Contact1_Email__c`, `Email__c`, or `Contact_1__c` is populated on the submission. For guests without any contact fields populated, the button is hidden to avoid sending a resume email to the Site Guest User's noreply address.

**Logged-in only by default.** The shipped `Form_Submission_Prefill` flow runs in user mode per the Salesforce Security Review rule that prevents the package from elevating sharing. Logged-in users can resume their own submissions out of the box. **Guest user support requires the subscriber to clone the prefill flow and switch its `runInMode` to `SystemModeWithoutSharing`**, accepting that any guest with a valid token can read/update the matched submission. See the [Guest user support requires flow override](../form-template-framework/stages-mode.md#guest-user-support-requires-flow-override) section for the full security implications.

**New fields.** `Form_Submission__c.Internal_Send_Resume_Link__c` (DateTime) — stamped by the LWC when the user clicks. `Form_Submission__c.Internal_Unique_Token__c` (Text 32) — generated by the Form_Submission trigger when the datetime is stamped. Both included in all three shipped permission sets.

**New Custom Labels.** `Stages_Email_Me_Resume_Link`, `Stages_Draft_Saved`, `Stages_Resume_Link_Sent`, `Stages_Resume_Link_Error` — overridable for branding or Translation Workbench localization.

### Prefill flow hosted in a modal + new screen-flow starter

The formTemplate LWC now hosts the configured prefill flow inside a `lightning/modal` (via the new `formTemplateFlowModal` LWC) instead of an inline hidden render. The modal stays behind a spinner until the flow's first status event, then reveals — autolaunched flows finish before any UI is shown; screen flows render their screens for the user. The modal cannot be dismissed by the user (no X, no ESC, no click-outside); only the flow finishing or returning a final output closes it.

Two starter prefill flows now ship with the same underlying logic. Admins pick which API name to put in `Form_Template__c.Prefill_Flow_Api_Name__c`:

- **`Form_Submission_Prefill`** — autolaunched (existing). No UI; runs server-side and returns outputs. Use when no validation/intro screens are needed.
- **`Form_Prefill_w_Screen_Template`** *(new)* — screen flow with sample screens demonstrating user-validation inputs and custom error display. Admins clone and customize the screens. If the user bypasses or clicks through to finish, the form loads normally; screens only block the form load when an admin's clone sets `hasError=true`.

Both are shipped as Template flows and granted via the three FlowToolKit permission sets.

### Scroll Into View on Flow Form

Long multi-screen flows have a chronic UX gap: when a user clicks Next, the next screen renders but the page stays scrolled wherever they left off. On a screen with a tall Flow Form, users often start mid-page and miss the header.

**The fix.** Flow Form has a new opt-in property — **Scroll Into View** — that smoothly scrolls the form into view on every render. Off by default. Existing flows are unaffected; opt-in per screen via a toggle in the property editor.

**Where it lives.** Open the Flow Form property editor, expand **Form Properties (Optional)**, and the new section appears between Show Header and Form Record Type Options. The toggle in the header sets a literal; the variable picker below it accepts any Boolean variable, formula, or upstream component output for reactive control.

**Reactive behavior.** The property is rising-edge triggered. A reactive input that flips it from `false` → `true` re-fires the scroll after initial render. A `true` → `false` → `true` sequence fires twice (once per rising edge). Same-value sets and internal re-renders (typing, validation, picklist loads, conditional logic) do NOT re-trigger the scroll.

**When it's suppressed.** Form Builder preview pane, Form Builder editor, repeater rows, sub-form rendering inside a parent form, and table-edit mode — all skipped by design.

**Documentation.** See [Flow Form → Scroll Into View on Render](../screen-components/flow-form.md#scroll-into-view-on-render) for the full behavior matrix, configuration walkthrough, and example patterns.

## Fixes & Improvements

### Mobile docked buttons

On small screens the docked footer buttons were reworked so the primary action is never lost. The overflow-menu caret now matches the height of the grouped button, full-width buttons use the native `stretch` attribute (replacing a global `!important` width override), and **Save Progress moves into the overflow menu so Next / Submit always stays visible** rather than being pushed off-screen. (#139, #140, #141)

### Stage indicator completion no longer reverts

Completed stages previously reverted to incomplete when a respondent navigated back and saved an earlier page. Stage completion is now driven by each stage's actual `Done` status, so completed work stays completed across navigation. (#142)

### Stages Mode polish

- Back / Save Progress / Send Resume Link buttons use the brand-outline variant. (#138)
- Fixed multiple stages getting stuck **In Progress** after navigating between them. (#137)
- Improved guest / iframe save reliability — the submission and its stage now persist together on the first save / return / complete. (#136)
- The stages overview now surfaces the Form Template **Subtitle** below the title. (#135)
- Fixed duplicate Form Submissions for non-guest users on Return / Save Progress / Mark Complete. (#134)
- The stages overview scrolls the relevant stage into view on Return / Mark Complete. (#133)

### Other fixes

- Calendar **Label / Title** and **Override Start Date** now accept variables, not just static text. (#132)
- Flow Form auto-scrolls to the top of each new flow screen. (#131)
- Fixed narrow date inputs where the format hint overlay blocked clicks. (#130)
- Fixed a radio (picklist) keyboard focus trap — radio groups now follow the WAI-ARIA roving-tabindex pattern, so Tab enters the group on the selected option, arrow keys move between options, and Tab again advances to the next field. (#129)

## Known Limitations

- Toggling Stages Mode ON for a template that already has live submissions does not backfill stage records on those existing submissions. The overview renders using a position-derived fallback, but Mark Page Complete is a no-op for those legacy submissions. New submissions auto-create stages correctly.
- Substep rendering (per-section status within a page) is parked for a future release.
- No built-in reports or dashboards on stage progress — 2GP managed packages cannot ship report types reliably. Build custom reports in the subscriber org on the `Form_Submission_Stage__c` object.
- The shipped resume-link feature is logged-in-user-only. Guest portal support requires the subscriber to clone `Form_Submission_Prefill`, switch its `runInMode` to `SystemModeWithoutSharing`, and replace the shipped flow. The package will not ship the elevated-mode version per Security Review constraints.
