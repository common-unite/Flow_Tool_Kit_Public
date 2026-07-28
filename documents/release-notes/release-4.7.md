# Release 4.7

## 🛠 Guest form submissions save again (#338)

A visitor filling in a public form saw the confirmation message, but the Form Submission was never created and nothing appeared against the Form Template. This affected **every guest submission since 4.2**, and it failed silently: no error reached the visitor and none reached the admin.

The submission was being created, then destroyed. When a conversion pipeline starts, the Start step was writing the conversion statuses back onto the submission inside the visitor's own transaction. A guest has no access to the record they have just created, so that write failed, and the failure rolled back the whole transaction, taking the new submission with it.

Start now does only what it was designed to do: publish the event. The status reset happens in the pipeline's own transaction, which is exactly what the event exists to hand off to. Signed-in submissions were never affected and are unchanged.

## 🛠 Conversion logs name the record they created (#338)

Conversion Log rows now take **Object Name** and **Event Name** from the record each step produced, rather than from the event that triggered it. Start and Finish still read as Start and Finish. A row that created a Contact now says Contact, where before it could show the event's name or nothing at all.

## 🛠 Required radio-button questions are now validated (#337)

A required Yes/No question displayed as **radio buttons** could be left unanswered and the form would still submit. That display was the only one missing from the validation sweep. Selecting the "no" option was, and remains, a valid answer to a required question when it is shown as a picklist, radio, or radio buttons: required means "choose one", not "must say yes".
