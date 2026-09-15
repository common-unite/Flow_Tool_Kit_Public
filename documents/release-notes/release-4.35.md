# Release 4.35

Two fixes to the Record Form component, both from one client report about a portal. Nothing changes shape: existing forms, templates and settings keep working as before.

## Forms

- **Read-only forms no longer ask for Create permission** (#657): a Record Form set to Read Only told portal users "You do not have permission to create Account records", which was misleading twice over. The form was never going to create anything, and the real problem was usually a record id that failed to arrive. Read Only now means what it says: the form never creates, so it never needs Create permission on the object. Given no record to show, it renders the empty form with every input disabled instead of reporting a permission error.

- **A record id that cannot be used now says so** (#657): when a component property is bound to an expression that does not resolve, the unresolved text arrived as the record id and was silently discarded, which looked identical to a form deliberately placed without a record. The form then fell into create mode and blamed permissions. The component now tells the admin the record id is not valid and points at the binding, which is where the fix actually is.

- **Forms are read-only for users who cannot edit** (#657): a user who can neither create nor update the object now gets a read-only form whether or not the admin ticked Read Only. Previously the inputs looked editable while nothing could be saved.

- **A clear message when the user cannot view the object** (#657): a user with no read access to the object now sees a view-permission message rather than an empty area.

- **Show a portal user their own related record** (#658): a Record Form can now follow a lookup chain from the logged-in user. Set Lookup Field API Name to a path beginning with `User.`, leave Record Id empty, and the form resolves the record for whoever is signed in. `User.Contact.AccountId` gives a portal user their own Account; `User.Contact.npsp__Primary_Affiliation__c` does the same on NPSP. It runs entirely in the browser through Lightning Data Service, with no Apex and one request.

## Upgrading orgs, two things to know

**Read-only forms behave differently in two situations.** A read-only form with no record id now renders the empty form rather than an error, and a user who can neither create nor update now sees disabled inputs where the fields previously looked editable. Neither changes what could actually be saved; both make the form honest about it. Forms with a record id and users who can edit are unaffected.

**Portal users need record access as well as object access.** If you use the new `User.` path to let portal users edit a record, object-level Edit on the profile is not enough on its own. Account's sharing setting for external users is usually Private, which gives a portal user read-only access to their own Account, so the form loads and the save fails. Granting edit needs a Sharing Set that maps the user's Contact and Account to the record. If the form is only meant to display the record, Read Only is the correct setting and no sharing change is needed.

## After upgrading

Load each of your public form pages once. The first page load after any package upgrade pays a one-off server-side compile of several seconds, and it is better absorbed by you than by a visitor.
