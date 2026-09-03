# Conversion Flows

> What each of the nine flows does, how a conversion actually unfolds, and the behaviour worth understanding before you rely on it.

## The shape of a conversion

The extension follows the same pattern as the base package: a conversion is not one long flow, it is a series of short passes. Each pass converts exactly one thing, records what happened, and publishes a platform event that starts the next pass. Every pass is its own transaction with its own governor limits, which is why a large household conversion does not run out of resources.

Two fields on the Form Submission track each rule: a **lookup** holding the record that was created, and a **status** saying how it went. A rule is finished when its status reads `Created`, `Matched` or `Updated`. Any other status, including `Error` and `Ready`, means "run me again", and that single convention is what makes Reprocess work and what makes the household ordering below possible.

## The nine flows

| Flow | Label | Role |
| --- | --- | --- |
| Process Form Submission | `(NPC) Convert \| Process \| Form Submission \| Overridable` | The controller. Picks the one rule that runs next. |
| Process Account | `(NPC) Convert \| Process \| Account \| Overridable` | Maps company answers onto an Account or Household. |
| Process Person Account Primary | `(NPC) Convert \| Process \| Person Account Primary \| Overridable` | Maps Contact 1's answers onto a Person Account. |
| Process Person Account Alternate | `(NPC) Convert \| Process \| Person Account Alternate \| Overridable` | The same for Contact 2 and for each repeater row. |
| Upsert Account | `(NPC) Convert \| Upsert \| Account \| Overridable` | The engine. Saves every Account and runs the follow-ups. |
| Upsert Party Relationship Group | `(NPC) Utility \| Upsert \| Party Relationship Group` | Gives a Household Account its group. |
| Upsert Account Contact Relation | `(NPC) Utility \| Upsert \| Account Contact Relation` | Puts a person in a Household with the right flags. |
| Upsert Contact Contact Relation | `(NPC) Utility \| Upsert \| Contact Contact Relation` | Relates two people, in both directions. |
| Find Household for a Person | `(NPC) Utility \| Find \| Household for a Person` | Answers "which Household is this person already in?" |

They fall into three layers, and knowing which layer to touch is most of what you need to customize safely:

- **The controller** decides *what runs when*.
- **The step flows** decide *which form answers land in which fields*. This is where field mapping lives, and it is the layer most customizations belong in.
- **The engine and utilities** decide *how records are matched, saved and linked*. Behaviour lives here, not mapping.

## The controller

The controller runs once per pass. It calls the packaged Setup subflow to load the submission, its template and (for repeater rows) the capturing section, then walks the conversion rules in a fixed priority order and dispatches the first one whose work is not finished:

1. Account or Household
2. Person Account for Contact 1, then Lead 1
3. Person Account for Contact 2, then Lead 2
4. Opportunity, then Case
5. Additional data, then related records, then files
6. Confirmation email
7. Finish

When no rule matches, the conversion is marked Complete and anything untouched is stamped Bypassed.

This is the same state machine as the packaged controller. Conversion statuses, the Conversion Log, Reprocess and the per-template flow override fields all behave exactly as they do in a standard Flow Tool Kit conversion.

### The household ordering problem

The one genuinely NPC-specific piece of the controller is the order in which a household is built, and it exists to solve a real chicken-and-egg problem.

A household cannot be built until you know who is in it. But a person cannot join a household until the household exists. Worse, a *returning* family already has a household, and creating a second one would be exactly wrong.

The controller resolves this by holding the Account rule back. In household mode, the Account rule waits until Contact 1 has been converted. What then happens is:

1. **Contact 1 converts first.** The engine saves the Person Account, then asks the Find Household utility whether this person already belongs to a household.
2. **If a household is found**, its Account is written straight onto the submission. The Account rule still runs, and it updates that existing household rather than creating a new one. A returning family keeps the household they have.
3. **If no household is found**, Contact 1's status is set back to `Ready`. Because `Ready` is not a terminal status, the controller will run Contact 1 again later.
4. **The Account rule now runs** and creates the household, and the engine gives it a Party Relationship Group.
5. **Contact 1 comes through a second time**, and this time the submission has an Account, so the person joins the household that now exists.

The whole mechanism is built out of the ordinary status convention. Nothing special is hidden in Apex, and you can watch each of these passes in the submission's Conversion Log.

Household mode is on when the template's Conversion Rules include `Account is Household`, or when its Account record type name contains `Household`.

## The step flows

The three step flows do one job: turn form answers into a record, then hand it to the engine. Each one calls Setup, prepares a couple of lookups, runs a **Transform** element that maps the fields, and calls the engine.

**Process Account** maps the company answers: name, phone, website, and the billing and shipping addresses (only when the template's address sub-rules are on, so blank answers never wipe curated addresses). In household mode the Name is special: it uses the company name if the form captured one, and otherwise builds `<Contact 1's last name> Household`. That is how a family's household gets named. If the template names an Account record type, it is looked up and stamped on.

**Process Person Account Primary** and **Alternate** are the same flow reading different columns: the Primary flow reads the `Contact1_*` fields, the Alternate flow reads the `Contact2_*` fields, which are also the fields each repeater row uses. Both map names, salutation, email, mobile, phone, birthdate and title, plus the mailing and other address blocks when those sub-rules are on. Both look up the org's active person account record type and any Person Account the submission already points at, so a re-run updates a person rather than duplicating them.

The Transform element in each of these is the thing to clone when you want different field mapping. See [Customizing](customizing.md).

## The engine

One engine saves every Account the extension produces, whether it is a person, an organisation or a household. It follows the packaged Upsert Account engine step for step, so it will read familiarly.

**The save path:**

1. **Strip blanks.** An empty form answer never erases data on an existing record. The template's Nullable Fields setting is the opt-out where blank genuinely means "clear this".
2. **Update or match.** If the record arrived with an Id, it is updated directly. Otherwise the duplicate checker runs with the matching rules the step passed in.
3. **Resolve the match.** One match is updated. Several matches stop the conversion with a `Multiple Matches` status so a human can resolve it, unless the template allows updating the most confident match. No match inserts a new record.
4. **Read the record back.** A save returns only the fields that were written, so the engine re-queries the Account. This matters most for a Person Account, whose `PersonContactId` is the Contact Id the submission needs, and which does not exist until the insert has happened.
5. **Log the outcome**, stamping the submission's status and lookup fields for this rule, which is how the controller knows the rule is finished.

{% hint style="info" %}
**People are always matched with the Person Account rule.** A standard Contact matching rule can never match a Person Account, so the engine adds `NPC_Person_Account_Match` to whatever the template configured whenever it is saving a person. Organisations match on exactly what the template configured, unchanged.
{% endhint %}

**The follow-up router.** After a successful save, one decision decides what else this pass should do. Every follow-up returns to that decision when it finishes, each one fires at most once per pass, and when nothing is left the flow returns control to the controller. The follow-ups, in order:

| Follow-up | When it fires |
| --- | --- |
| Give the Household its group | The saved Account is not a person, and the template is in household mode |
| Find the family's Household | The saved Account is Contact 1, the submission has no Account yet, and household mode is on |
| Add the person to the Account | The Add to Account rule is on for this person, or the capturing section asks for it |
| Relate Contact 2 to Contact 1 | The Create Relationships rule is on and the row named a relationship |
| Chain a Campaign Member | The Create Campaign Member rule is on for this person |

## The four utilities

The utilities are deliberately **form-agnostic**. They take plain values, return plain values, and know nothing about Form Submissions, platform events or conversion logs. They never write a log entry: they return `HasError` and `ErrorMessage`, and the caller decides how to report a failure. That is what makes them equally usable from your own automation ([Customizing](customizing.md#reuse-the-utility-flows-in-your-own-automation)).

All of them are safe to run repeatedly. Each looks for the record that may already exist, maps its Id into a transform, and saves with a single element set to upsert on Id: a blank Id inserts, a real Id updates.

### Upsert Party Relationship Group

Guarantees that an Account has a Party Relationship Group, which is Nonprofit Cloud's way of saying "this Account is a Household". It never creates a second group. An existing group is reactivated (status set to Active, end date cleared) but **never renamed**, so a group an admin renamed by hand keeps its name.

### Upsert Account Contact Relation

Puts a Contact in an Account with the membership flags you ask for. Salesforce allows only one Account Contact Relation per Contact and Account pair, so running it twice can never duplicate.

Its careful handling of the two "primary" flags is worth understanding, because the platform treats them very differently:

- **`IsPrimaryMember`** is group-centric: who is the household's principal person. **Salesforce enforces one per Account.** If the seat is free, the person being added takes it. If someone else holds it and you have asked for this person, the current holder is demoted first and then this person is promoted, so your request is honoured without ever tripping the platform's rule.
- **`IsPrimaryGroup`** is person-centric: which household this person's information rolls up to. **Salesforce does not enforce one per person**, so nothing stops a person from having two primary groups, which reporting will not expect. Pass `ClearOtherPrimaryGroups` alongside `IsPrimaryGroup` and the flow demotes every other membership that person has.

### Upsert Contact Contact Relation

Records how two people are related, **in both directions**. Salesforce does not create the inverse relationship automatically for records written by automation, so this flow writes both sides itself: Layla is Omar's spouse, and Omar is Layla's spouse.

It translates everyday words into Party Role Relation names first. Every kind of parent (Mother, Father, Stepparent, Legal Guardian, Foster Parent) becomes `Parent`; a partner becomes `Spouse`; anything else passes through unchanged. The reverse role comes from the role's own Related Inverse, so `Parent` flips to `Child`, while a symmetric role such as Spouse, Sibling or Friend is its own inverse.

{% hint style="warning" %}
**Party Role Relations are org data you manage in Setup, not something this package ships.** If the org has no Party Role Relation for the role a form asked for, the flow stops and returns a message naming the role to add. It never guesses, because a guessed relationship is worse than a missing one. Add the role in Setup and use Reprocess.
{% endhint %}

### Find Household for a Person

Read-only, and answers one question: which household does this person already belong to? Give it a Contact Id, an email address, or both.

It reads the person's active **indirect** memberships, because a Person Account's direct relation points at itself rather than at a household. It then asks in a single query which of those Accounts carries an active Household group, oldest first, so a person who somehow belongs to two households is answered with the one they joined first. Finding nothing is an answer, not an error: it simply means the person is new or is in no household.

It returns the Household's **Account Id**, deliberately not the group record itself: a populated Party Relationship Group crossing a subflow's output boundary crashes the packaged runtime, so the record never leaves the flow and callers query what more they need.

## Logging and reprocessing

Every pass writes to the submission's **Conversion Logs** related list. A successful pass records what was created, matched or updated. A failure records a short, fixed message naming the step that failed, along with the flow it happened in.

Failures are deliberately non-terminal. When a pass fails, the rule's status is set to `Error`, which is not one of the finished statuses, so the rule is eligible to run again. Fix the underlying problem, click **Reprocess** on the submission, and the conversion resumes: everything already finished is skipped, and only the unfinished rules run. Because every write is an upsert and every utility looks before it writes, rerunning cannot duplicate what already exists.

## Things worth knowing

**A conversion runs as the Automated Process user, in system context.** It does not depend on the permissions of whoever submitted the form.

**Related rows use the parent's context.** When a repeater row converts, it borrows the parent submission's Account and Contact 1, and control returns to the parent, because the rule sequence lives there.

**Blank answers never erase data by default.** If you need a blank answer to clear a field, list that field in the template's Nullable Fields setting.

**Multiple matches stop rather than guess.** If matching finds several candidate people, the pass stops with a `Multiple Matches` status and waits for a human. Turn on the template's most-confident-match setting only if you would rather it chose.

**Some operations run through small Apex actions on purpose.** Package validation cannot compile a native flow element that reads Party Relationship Groups or creates group and relationship records, so those specific operations run through typed Apex actions inside the extension. Each affected element's description says so, and a clone of a utility in your own org can use the plain native element instead, because your org holds the Group Membership licence that the packaging environment cannot.

**Addresses are opt-in.** Address blocks map only when the matching address sub-rule is on, so a household's curated address is not overwritten by a form that did not ask for one. If your org uses State and Country/Territory picklists, see [Configuration, step 8](configuration.md#step-8-check-your-address-fields).
