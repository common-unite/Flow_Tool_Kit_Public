# Release 4.16

4.16 is a focused bug-fix release for the **Form Template** runtime. There are no new features. Every issue in it is one a respondent or an administrator would actually notice, and one of them, #517, has been quietly losing data for a long time.

If you read only two things, read **[Saves were silently discarded](#-saves-were-being-silently-discarded-after-the-first-one-517)** and **[What you need to do after upgrading](#-what-you-need-to-do-after-upgrading)**.


---

## 🚑 Saves were being silently discarded after the first one (#517)

**This is the reason to upgrade.** If anyone has ever told you a form "saved the first time and then stopped", or that progress went missing without any error, this was almost certainly why.

**What happened:** the first save of a page load worked. Every save after it was thrown away. No error, no failed-save message, and the success message simply did not appear. Refreshing the page reset it, so the next save worked and then the pattern repeated. That is what made it look random rather than reproducible.

It affected **Save Progress, Complete, Return and Submit equally**, on any page including the review page, because all of them go through the same save path.

**Why it was so hard to spot:** the very act of saving successfully is what broke the next save. The component keeps a copy of the record as it was last loaded, in order to work out what changed. Saving caused Salesforce to re-deliver the record, and the component then replaced that reference copy with one that was missing the record's identifier. Without an identifier there was nothing to update, so the save was abandoned before it ever reached the database.

**The tell, if you ever see this class of problem again:** the "Saved Successfully" message never appeared. That message is only ever shown *after* the database call returns, so its absence means the save was abandoned beforehand, rather than attempted and rejected. That single observation rules out permissions, validation rules and record locking in one step.

Saves are now also more efficient. The component can once again work out which fields actually changed, so it writes only those, rather than rewriting every field on the record each time.

---

## 🐛 Submit could appear to do nothing at all (#516)

Three separate paths could end a submit with no visible result and no message:

- **A form with no confirmation message** saved correctly, then tried to send the respondent to the underlying Form Submission record. On an Experience Cloud site, or anywhere the respondent cannot open that record, that silently does nothing. The submission was safely saved, but the respondent saw no acknowledgement at all and reasonably assumed it had failed.
- **A validation failure** stopped the submit without saying why. The message explaining what was wrong was being worked out and then discarded.
- **A second, separate validity check** did the same thing.

All three now explain themselves. A form with no confirmation message shows a default confirmation instead of navigating anywhere, and a blocked submit tells the respondent to correct their answers.

If **Skip Confirmation Page** is enabled, submitting now shows the success message and then reloads the page, rather than sending the respondent to a record they may not be able to open.

---

## ⚠️ Form Flow User cannot update submissions on its own (#515)

**This one needs action from you.** See [What you need to do after upgrading](#-what-you-need-to-do-after-upgrading).

**Form Flow User** grants Create and Read on **Form Submission** and **Form Submission Stage**, but **not Update**. That is deliberate and cannot be changed in the packaged permission set: it must stay assignable to the Experience Cloud **Guest User**, and Salesforce does not allow a guest user to hold the Edit permission on an object.

The consequence is that anyone whose only Flow Tool Kit permission set is Form Flow User cannot update an existing submission. Save Progress fails, and the confirmation page never appears after Submit.

**This is not limited to community users.** It affects internal Salesforce users who are not administrators and have not been given Form Builder Manager, exactly as much as it affects Partner and Customer Community users. It is simply noticed most often on Experience Cloud, because community users are rarely given a builder permission set.

Previously this surfaced as a raw platform message, or as nothing at all. The form now names the object you lack access to.

---

## 🐛 A closed campaign hid every submission it had ever collected (#519)

When a Form Template is driven from a **source record**, such as a Campaign, that record's active flag and start and end dates **replace** the template's own. That is by design.

What was not by design is that the resulting "not available" screen also replaced **existing submissions**. So the moment a campaign closed, every response it had ever gathered became unviewable, including for an administrator opening the Form Submission record directly.

An expiry window governs **collection**, not retention. New respondents are still turned away once the window closes, but a submission that already exists is always viewable.

---

## ⏳ Submitting now shows a spinner (#518)

Previously the form stayed fully visible and editable for the whole time a submit was in flight, which on a slower connection could be several seconds. Respondents could keep typing, or press Submit again, while the first submit was still running.

A spinner now covers the form from the moment Submit is pressed until the confirmation page appears or an error is returned. Where the form is configured to reload after submitting, the spinner stays up until the page actually changes, rather than briefly showing the form again.

Save Progress, Complete and Return are unchanged and still give you the quick toast, so moving between stages does not feel slower.

---

## ✅ What you need to do after upgrading

**If any of your users fill out forms without also holding Form Builder Admin or Form Builder Manager**, they need Update access, which the packaged permission set cannot give them:

1. Create a permission set in your own org.
2. Grant **Edit** on `FlowToolKit__Form_Submission__c` and `FlowToolKit__Form_Submission_Stage__c`. Field-level access is already covered by Form Flow User, so the object permissions are all you need to add.
3. Assign it **in addition to** Form Flow User to everyone who fills out forms.
4. **Do not assign it to the Guest User.** Salesforce blocks that assignment, and guests do not need it, because guest submissions are saved through the Form Submission Upsert flow instead.

Also worth checking: **Form Submission** uses a **Private** external sharing model. Update permission is enough only while a user owns the submission they are editing. If one person resumes a submission that someone else created, that needs a sharing rule as well.

Full detail is in [Permission Sets](../getting-started/permission-sets.md) and [Troubleshooting](../faq-troubleshooting/troubleshooting.md).

---

## ⚠️ What will look different after upgrading

| Change | What to expect |
| --- | --- |
| **Saves after the first now work** (#517) | The obvious one. Also, saves now write only the fields that changed rather than every field on the record. If you have automation, validation rules or field history keyed off fields being rewritten on every save, they will now fire less often. |
| **No confirmation message no longer navigates** (#516) | A template with no confirmation message now shows a default confirmation, "Your response has been submitted." Previously it tried to open the Form Submission record. If you were relying on that navigation, set a confirmation message or enable Skip Confirmation Page. |
| **Skip Confirmation Page reloads** (#516) | Submitting with this enabled now shows the success message and reloads the page, instead of navigating to the record. |
| **Closed source records show their submissions** (#519) | Submissions collected against a closed campaign are visible again. Note that a respondent who saved a draft before the deadline can now also continue editing it after the deadline. Whether that should be allowed is being tracked separately as #520. |
| **A spinner during submit** (#518) | The form is no longer editable while a submit is in flight, and Submit cannot be pressed twice. |
| **Access errors now name the object** (#515) | Where a save previously failed with a generic platform message, or with nothing at all, it now says which object the user lacks edit access to. |

---

## Known follow-ups

- **#520** Whether a submission should still be writable after the close date. #519 relaxed a check that was doing two jobs, gating visibility and, incidentally, gating writes. The visibility half was wrong and is fixed. The writes half is a deliberate open question.
- **#521** Review mode does not yet indicate **which** section holds a validation error, or scroll to it. On a long review page a single missing required answer anywhere in the form blocks Submit, and the respondent has to hunt for it.
