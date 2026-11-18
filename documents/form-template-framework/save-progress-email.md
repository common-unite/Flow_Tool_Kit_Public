# Save Progress Email

> When a respondent saves their progress on an ordinary (non-stages) form, the package emails them a link back to their draft. At most one email an hour, for site guests too, with no flow to build.

## Overview

The video shows an admin turning the email on, a visitor saving, the email that goes out, and the link reopening the draft.

{% embed url="https://vimeo.com/1245008625/1886347942" %}


Turn on **Send Save Progress Email** on the Form Template. After that, a respondent who saves gets an email with a **Continue your form** link. The link reopens their saved answers on any device.

* **First save:** the first save that has a recipient email sends one email.
* **Autosave and repeated clicks:** nothing more for an hour after the last email.
* **After an hour:** the next save sends another email with a new link. Each email carries a new link, so only the latest one works.
* **After using the link:** the link works once. The first save after reopening it sends a fresh link.
* **Submit:** sends nothing, and the link stops working.
* **Stages mode:** never sends this email. Stages mode keeps its **Email me a resume link** button, which works as before (see [Stages Mode](stages-mode.md#save--resume-via-email)).

## What the Form Template needs

Check each line on the Form Template before expecting an email.

- [ ] **Allow Save Progress** is on (Form Setup tab, **Save & Form Submission Settings**).
- [ ] **Send Save Progress Email** is on. It sits directly below **Allow Save Progress** and only shows while that is on.
- [ ] The template is **not in stages mode**. Stages mode uses its own **Email me a resume link** button instead.
- [ ] A web form address: the template's own (**Open Web Form** or **Change Web Form Address**) or the org's **Default Web Form URL** in Flow Tool Kit Settings. With neither, no email is sent and a Conversion Log row says so.
- [ ] A recipient email on the submission: Contact 1's email, then **Contact 1 Email**, then **Email**, the first that has a value (see Who gets the email below).
- [ ] Optional: **Email Template Name (Saved)** for your own email. Without it the built-in email is sent.
- [ ] Nothing else: no URL Parameter Mapping and no Prefill Flow choice.

## Setup

| Step | Where | What to set |
|---|---|---|
| 1. Turn it on | Form Template, Form Setup tab, **Save & Form Submission Settings**: **Send Save Progress Email**, directly below **Allow Save Progress** | On. The toggle shows only while **Allow Save Progress** is on. Stages Mode must be off. |
| 2. Where the link points | Form Template, **Open Web Form** or **Change Web Form Address** | Pick the Experience Cloud site or type a custom https address, for this template (**Web Form Site URL**) or as the org default (**Default Web Form URL** in Flow Tool Kit Settings). The template's own address wins; the template's **Web Form URL** adds its Id. With neither, no email is sent: the save is kept and a Conversion Log row says "Save Progress email didn't send: this Form Template has no web form URL, and no default domain is assigned. Set one with Open Web Form on the template, or set the org's Default Web Form URL." |
| 3. Optional: your own email | Form Template, **Email Template Name (Saved)** | The developer name of an email template. The flow always tries it first, rendered against the submission's **Contact 1** with the submission as the related record; merge `{!FlowToolKit__Form_Submission__c.FlowToolKit__Internal_Resume_Link__c}` (Save Progress Resume Link) for the link. If that send fails for any reason (no Contact 1, no template by that name, anything else), the built-in email is sent instead. |

The built-in email has the form's name as its heading, the line "Your progress is saved", a short note that the link works once, and the link.

Resuming needs no setup: no URL Parameter Mapping and no Prefill Flow choice. For site guests, read [Guest User Considerations](#guest-user-considerations).

## Who gets the email

The first of these that has a value:

1. Contact 1's email, unless it has bounced
2. **Contact 1 Email** on the submission
3. **Email** on the submission

A save with none of them sends nothing. The first later save that has one sends the first email.

## Token, step by step

1. A save asks for an email (Save Progress or autosave, when the setting is on and there is a recipient).
2. The Form Submission trigger accepts at most one request an hour, by Salesforce server time, and mints a new 128-bit token for it.
3. The flow emails a link that ends in `resume=<token>`.
4. Opening the link: the form reads `resume` (or an old `pv9` that holds a token), and the prefill finds the draft by token and template.
5. The prefill clears the token and the request, so the link works once.
6. The next save after opening sends a fresh link at once, even inside the hour.
7. Tokens also clear on submit and after 7 days.
8. A save from the form can never clear the token or the request, so the hour cannot be dodged.

## How it works

| Step | What happens |
|---|---|
| The form decides | On every save (Save Progress, autosave), the form asks for an email by setting **Send Resume Link** (`Internal_Send_Resume_Link__c`) on the submission, the same field the stages **Send Resume Email** button sets. It asks when the setting is on, stages mode is off, the form is not submitted or read only, there is a recipient, and either nothing was sent yet, the last email is more than an hour old, or this visit was opened from a resume link. The value rides the save the form already makes. |
| The trigger checks | In the same save, on any template not in stages mode, the Form Submission trigger refuses a request the form would never make: the setting off, a submitted form, inside the hour since the last email by Salesforce server time, or a save trying to clear the request. A refused request keeps the stored value, so nothing is sent. An accepted request is stamped with server time and gets a new resume token. Stages templates are left to the button, as before. |
| The flow sends | **(Form) Send Resume Link \| Overridable**, the same flow that sends the stages resume email, starts when a request and its new token are saved. It ships in default mode and reads the Form Template once. It checks nothing else up front: it **tries your template first**, sends the **built-in email** if that faults, and only if that faults too writes a log row. Stages-mode templates take the same three steps with the stages email. The flow never writes to the record. |
| When no email goes out | The template has no web form address, or both sends faulted (for example no recipient email, an unverified Default Workflow User, or the daily limit): the save is kept, and one **Conversion Log** row on the submission says "Save Progress email didn't send" and gives the reason. The submission's conversion status is not changed. A request the trigger refuses because the person saving cannot read the Form Template is logged the same way. |
| The link | The template's Web Form URL plus `resume=<token>`: its Web Form Site URL if set, otherwise the org's Default Web Form URL, then the template Id. It opens the template's public form page, never a record page. The stages resume email uses the same link. |
| Opening the link | The form template reads the `resume` parameter itself (and `pv9` when it holds a token, for links sent before this release), with no URL Parameter Mapping. It runs the template's Prefill Flow, or the packaged **(Form) Prefill \| Template** when the template is on Bypass, in default mode. The prefill finds the draft by token and template, clears the token and the request (single use), and the form opens on the saved answers. The next save sends a fresh link straight away, even inside the hour. If the prefill can't open the draft, a new form opens with: "This link can't open your saved form. It may already have been used or have expired, or this site's guest user can't read saved forms (see Guest User Considerations). A new form has opened below." |
| Expiry | Tokens clear on submit and after 7 days (the **Expire Resume Tokens** scheduled flow; see [The Expire Resume Tokens scheduled flow](#the-expire-resume-tokens-scheduled-flow), which also explains how to change the window). A save from the form can never clear the token or the request itself, so the hour cannot be dodged that way. |

### Why a new link disables the older one

**How it works.** A Form Submission holds only one token at a time. Each request for a resume link makes a new token, which replaces the old one, so the older link stops working. Opening the submission through the prefill flow clears the token, so the link works once.

**Why.** Security. A link in an email is a key to the saved record, and drafts often hold personal details. With one live token, no link sits in an inbox or an email template giving anyone access to the record for all time.

**One strategy among others.** This is one built-in strategy in a security model, not the full set of security considerations. Your org can add its own security postures to guest forms.

**You are not locked in.** The form template framework runs inside flows, so you can override them to turn off a default or change the behavior. The token itself is made in the Form Submission trigger, so the changes go in the flows around it: your own **(Form) Send Resume Link | Overridable** override can build the emailed link from a token you keep, and your own copy of **(Form) Prefill | Template** (set as the template's **Prefill Flow**) can look that token up and decide when it stops working. For example, an org could store its tokens on a related custom object and query past ones. That is possible, but not recommended: it brings back long-lived links, so review it against your own security rules. How to override: [Overriding Packaged Flows](../advanced-topics/overriding-packaged-flows.md).

## What happens when

| Situation | What the respondent sees | What the admin sees |
|---|---|---|
| Email sends with your template | Your branded email with the link | Nothing to act on |
| Your template send faults (no Contact 1, a guest who can't merge, anything else) | The built-in email, with the form's name and the link | Nothing to act on |
| Both sends fault | No email; the save is kept | One Conversion Log row (Log Only) "Save Progress email didn't send" with the reason; conversion status unchanged |
| No web form address and no default | No email; the save is kept | A Conversion Log row with the message "this Form Template has no web form URL, and no default domain is assigned" |
| A second save inside the hour | Nothing | Nothing |
| Link opened | The draft opens on their saved answers; the next save sends a new link | Nothing |
| Used or expired link, or a site guest who can't read the draft in default mode | "This link can't open your saved form. It may already have been used or have expired, or this site's guest user can't read saved forms (see Guest User Considerations). A new form has opened below." and a new form | Nothing; see Guest User Considerations to let guests resume |
| Template on Bypass | The packaged prefill still resumes the draft | Nothing |
| Stages mode | Not this email; the **Email me a resume link** button instead | Nothing |
| A child submission is saved (it has a Parent Form Submission, or Is Related Record is checked) | Nothing; only the parent submission sends the email. The request is not stamped and no token is made | Nothing |
| A save with no address: Contact 1 Email, Email and Contact 1 all blank | No email; the save is kept | Nothing: the send flow does not start, so no Conversion Log row is written (the form never asks for the email without an address) |
| Stages **Email me a resume link** click with no recipient fields | The resume email goes to the record owner, as before | Nothing |

## Things to know

* **One email an hour, per submission.** The hour runs from the last email, not the last save, so a respondent who keeps autosaving still gets a new email after an hour.
* **Custom upsert overrides.** The request travels on the submission the form saves. If your org overrides the **Form Submission Upsert** flow and builds its own record instead of saving the record it is given, the request is dropped and no email is sent. Pass the record through, or add **Send Resume Link** (`Internal_Send_Resume_Link__c`) to the fields you save.
* **Sender.** The email is sent from the org's Default Workflow User, like the stages resume email. That user's email address must be verified (Setup, Process Automation Settings); until it is, no email goes out and each attempt leaves a Conversion Log row saying so.
* **Field access.** Site guests need Edit on **Send Resume Link** (`Internal_Send_Resume_Link__c`), which **Form Flow User** already grants for the stages button. **Save Progress Resume Link** shows the token, so site guests are never given read access to it.
* **Daily email limit.** Each email counts against the org's daily single-email limit.
* **Server time, not the browser's.** The trigger stamps each accepted request with Salesforce server time and ignores the time the browser sent. A save that sets a future time or clears the request is refused. Only the package's own reset, when the link is opened, clears it.

## Guest User Considerations

**Why the package ships default mode.** Every packaged flow and class runs as the person using the form, never in system mode. The packaged prefill that opens a resume link runs as that person too. A signed-in user who can read their own submission gets their draft back with no setup.

**Site guests.** A site guest usually can't read saved submissions: guest-created records belong to the site's default owner, and the package ships no guest sharing rule. In default mode the guest's resume link can't find the draft, so a new form opens with the notice above. Nothing is shown that the guest can't already see.

**Letting guests resume is your org's choice.** To let site guests reopen drafts, save a copy of **(Form) Prefill | Template** in your org, set the copy to run in system mode, and choose it as the template's **Prefill Flow**. The copy then reads the one submission whose token is in the link. That is a security decision your org makes: anyone who holds the link can open that draft.

**What limits the risk.** The token is 128-bit random, unique and single use: opening the link clears it, a save never brings it back, and each email carries a new one. It is matched together with the Form Template, cleared on submit, and cleared after 7 days. So one link opens one draft, once.

**Sensitive data.** For forms that collect sensitive data, use authenticated users (an Experience Cloud login) instead of guest resume links. A forwarded or intercepted link opens the draft for whoever clicks it first.

## Your email template and site guests

| The submission | Email sent |
|---|---|
| Has a Contact 1, and Email Template Name (Saved) names a template | Your template, rendered against Contact 1 with the submission as the related record |
| No Contact 1 (most site guests), no template named, or the template send fails for any other reason | The built-in email, which carries the form's name and the link |

A site guest who only types an email address has no Contact 1, so the built-in email is what they get. To send your own branded email to them, override the flow (below).

## The Expire Resume Tokens scheduled flow

**Purpose.** A resume link that nobody opens would otherwise work forever. **(Form) Expire Resume Tokens | Scheduled | Overridable** (`Form_Submission_Expire_Resume_Tokens`) is the housekeeping that retires old links, so a forgotten email cannot open a draft months later. It ships active, so it runs without any setup, and you can override it if the default window does not suit you.

**How it works.**

| Part | What it does |
|---|---|
| Schedule | Runs once a day. A link that passes the cutoff stops working at the next daily run, so a link lives up to a day longer than the window. |
| Which submissions | Form Submissions that have both **Send Resume Link** (`Internal_Send_Resume_Link__c`) and **Save Progress Resume Link** (`Internal_Unique_Token__c`) filled in, that is, submissions with a link outstanding. |
| The cutoff | A formula named `Token_Expiration_Cutoff`: `{!$Flow.CurrentDateTime} - 7`, now minus 7 days. A submission is expired when its **Send Resume Link** time, the moment the last email was requested, is older than the cutoff. The window counts from the last email, not the last save. |
| What it clears | Both fields. The token is gone, so the link finds no draft and the respondent sees the "This link can't open your saved form" notice with a new form. Clearing **Send Resume Link** also means the next save can email a fresh link at once, without waiting out the hour. |

Other ways a link stops working, none of which depend on this flow: it is **opened once** (the prefill clears the token), a **newer link is requested** (a new token replaces it), or the form is **submitted** (the trigger clears both fields on the first submission date).

**Overriding it with your own logic.** The flow is overridable, so the steps are the ones on [Overriding Packaged Flows](../advanced-topics/overriding-packaged-flows.md#two-routes):

1. In Setup, open **Flows**, open **(Form) Expire Resume Tokens | Scheduled | Overridable** and choose **Save As**. Flow Builder offers **Save as flow override**; give it a label and API name.
2. Change the cutoff formula, the decision or the update, as in the examples below, and **Activate** the override. The packaged flow stays installed, and your override runs in its place.
3. Keep the two fields it clears (**Send Resume Link** and **Save Progress Resume Link**) in the update. Clearing only one leaves a half-cleared submission.

Generic examples:

* **A longer or shorter window.** Edit the formula: `{!$Flow.CurrentDateTime} - 30` keeps links for a month, `- 1` for a day. Change nothing else.
* **Expire at the form's close date.** A link should stop working once the form closes. Form Templates have a **Close Date** (`Close_Date__c`, a date and time). In the override, replace the cutoff test with a decision that clears a submission when its template's close date has passed: `{!$Record.FlowToolKit__Form_Template__r.FlowToolKit__Close_Date__c} < {!$Flow.CurrentDateTime}` (drop the namespace prefix in an unpackaged org). Combine it with the 7-day test if you want whichever comes first.
* **A different window per template.** Add a decision before the update that looks at the template, such as its name or a custom field of your own, and sends each branch through its own cutoff: 3 days for a short registration, 60 days for a long application.
* **Warn the respondent before expiry.** Add a branch for submissions whose link is 6 days old that sends an email through the **Send Email** action ("Your saved form closes tomorrow"), and keep the 7-day branch for the clear. Because the flow runs once a day, a window of a few days is enough to land the warning.

{% hint style="info" %}
**Test with a throwaway submission.** In a sandbox, create a draft with a resume link, set its **Send Resume Link** time back past your window, and run the override once from Flow Builder's debug option or let it run overnight. Confirm the token clears before you rely on the override.
{% endhint %}

## Optional: override the send flow

The packaged flow ships in default mode, and the package never ships a flow set to system mode. If your public form must send your own branded template to site guests, you can override the flow and change how it merges the template. For example, use the Send Email action's own email template option for submissions with a Contact 1, or run your override in system mode with the elements it needs.

**How.** In Setup, open **Flows**, find **(Form) Send Resume Link | Overridable**, save a copy as an override, change it, and activate it. Keep the same start conditions, the stages path, and the Log Only step for emails that do not go out.

**It is your security decision.** An override that reads or merges data the person saving cannot see shows that data to them through the email. Review it against your own security rules.

## Related

* [Stages Mode: Save & Resume via Email](stages-mode.md#save--resume-via-email)
* [Prefill Flow](prefill-flow.md)
* [Form Templates](form-templates.md)
