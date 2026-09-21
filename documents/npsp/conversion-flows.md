# Conversion Flows

> What each of the five flows does, how an NPSP conversion actually unfolds, and the behaviour worth understanding before you rely on it.

## The shape of a conversion

The extension follows the same pattern as the base package: a conversion is not one long flow, it is a series of short passes. Each pass converts exactly one thing, records what happened, and publishes a platform event that starts the next pass. Every pass is its own transaction with its own governor limits, which is why a large family conversion does not run out of resources.

Two fields on the Form Submission track each rule: a **lookup** holding the record that was created, and a **status** saying how it went. A rule is finished when its status reads `Created`, `Matched` or `Updated`. Any other status, including `Error` and `Ready`, means "run me again", and that single convention is what makes Reprocess work and what makes the ordering below possible.

## The five flows

| Flow | Label | Role |
| --- | --- | --- |
| Process Form Submission | `(NPSP) Convert \| Process \| Form Submission \| Overridable` | The controller. Picks the one rule that runs next. |
| Process Contact Primary | `(NPSP) Convert \| Process \| Contact Primary \| Overridable` | Maps Contact 1's answers onto a Contact. |
| Process Contact Alternate | `(NPSP) Convert \| Process \| Contact Alternate \| Overridable` | The same for Contact 2 and for each repeater or table row. |
| Upsert Contact | `(NPSP) Convert \| Upsert \| Contact \| Overridable` | The engine. Saves every person and runs the follow-ups. |
| Upsert Affiliation | `(NPSP) Utility \| Upsert \| Affiliation` | Affiliates a person with an Organization. |

Accounts are converted by the **packaged** Account step and engine, unchanged. An NPSP Organization is an ordinary Account, and in Household mode the Account rule updates a Household that already exists, so neither needed an NPSP version.

The flows fall into three layers, and knowing which layer to touch is most of what you need to customize safely:

- **The controller** decides *what runs when*.
- **The step flows** decide *which form answers land in which fields*. This is where field mapping lives, and it is the layer most customizations belong in.
- **The engine and the utility** decide *how records are matched, saved and linked*. Behaviour lives here, not mapping.

## The controller

The controller runs once per pass. It calls the packaged Setup subflow to load the submission, its template and (for repeater rows) the capturing section, then walks the conversion rules in a fixed priority order and dispatches the first one whose work is not finished:

1. Account or Household
2. Contact 1, then Lead 1
3. Contact 2, then Lead 2
4. Opportunity, then Case
5. Additional data, then related records, then files
6. Confirmation email
7. Finish

When no rule matches, the conversion is marked Complete and anything untouched is stamped Bypassed.

This is the same state machine as the packaged controller. Conversion statuses, the Conversion Log, Reprocess and the per-template flow override fields all behave exactly as they do in a standard Flow Tool Kit conversion.

### People come first

The one genuinely NPSP-specific piece of the controller is the order in which a family is built, and it exists because in NPSP a Household comes *from* a person.

Insert a Contact with no Account and NPSP builds them a Household Account in the same transaction. Nothing else can produce a correct NPSP Household, so the extension never creates one. That single fact sets the order:

1. **The Account rule waits for Contact 1.** In Household mode the controller holds it back until Contact 1 has converted.
2. **Contact 1 converts.** A new person is inserted with no Account and NPSP builds the Household around them. A returning person is matched and brings the Household they already have.
3. **The engine stamps that Household on the submission**, as a record update and an informational log row with no status of its own.
4. **The Account rule now runs**, and because the submission already has an Account, it *updates* that Household with the mapped Account fields instead of creating a second one.
5. **Contact 2 and the repeater rows follow**, waiting until the Household is on the submission so they can join the one Contact 1 established.

Household mode is on when the template's **Account record type is `HH_Account`**, and nothing else turns it on. Without Household mode, the packaged order stands: the Account rule runs first and creates the Organization.

{% hint style="warning" %}
**A person whose Account is not a Household is never stamped.** If the matched Contact 1 already belongs to an Organization, stamping it would make the Account rule rewrite that employer with household values. The engine skips the stamp and writes an error log saying so, which leaves the slot rerunnable: fix the person's Account, or split the form, and use Reprocess.
{% endhint %}

## The step flows

The two step flows do one job: turn form answers into a Contact, then hand it to the engine. Each calls Setup, runs a **Transform** element that maps the fields, and calls the engine. The Primary flow reads the `Contact1_*` fields; the Alternate flow reads the `Contact2_*` fields, which are also the fields each repeater and table row uses.

Both map names, salutation, email, phone, birthdate and title, plus the mailing and other address blocks when those sub-rules are on. Three mappings are NPSP's own:

- **Email Type** puts the email in Personal, Work or Alternate Email and sets **Preferred Email** to match. `Other` becomes Alternate, because Alternate is what NPSP stores.
- **Phone Type** puts the phone in Home, Mobile or Work Phone and sets **Preferred Phone** to match.
- **Do Not Call**, when checked, sets NPSP's **Do Not Contact**. Unchecked, it writes nothing at all, so a form can never clear a flag somebody set deliberately.

**Neither step ever maps the Contact's Account.** In NPSP that link is the Household, and the engine owns it. The Transform element in each of these flows is the thing to clone when you want different field mapping. See [Customizing](customizing.md).

## The engine

One engine saves every person the extension produces: Contact 1, Contact 2, and every repeater or table row. It follows the packaged Contact engine step for step, so it will read familiarly.

**The save path:**

1. **Strip blanks.** An empty form answer never erases data on an existing Contact. The template's Nullable Fields setting is the opt-out where blank genuinely means "clear this".
2. **Join the Household, if asked.** The submission's Account is read, or the parent submission's for a repeater row. When that Account is an `HH_Account` **and** the Add to Account rule for this person, or the section's Add to Account box, is on, the Household is set on the Contact before the save. A new person is created inside it; a matched person is moved into it. On Contact 1's first pass there is no Account yet, so nothing happens and NPSP builds the Household.
3. **Update or match.** A Contact that arrived with an Id is updated directly. Otherwise the duplicate checker runs with the matching rules the template or section configured. One match, or the most confident match when the template allows it, is updated; several matches stop the conversion with a `Multiple Matches` status so a human can resolve it; no match inserts a new Contact through the bypass-duplicates action, so subscriber Block rules and alerts cannot interrupt an unattended conversion.
4. **Read the Contact back.** A save returns only the fields that were written, and NPSP fills in the Household during the save, so the engine re-queries the Contact. Everything after this point needs the record as it now stands.
5. **Log the outcome**, stamping the submission's status and lookup fields for this rule, which is how the controller knows the rule is finished.

{% hint style="danger" %}
**Only a Household is ever written onto a Contact's Account.** An organisation link in NPSP is an affiliation. Moving a Contact between Accounts is something NPSP handles badly: the Account they leave is never deleted, and their mailing address is rewritten from the new Account's default address.
{% endhint %}

**The follow-up router.** After a successful save, one decision decides what else this pass should do. Every follow-up returns to that decision when it finishes, each one fires at most once per pass, and when nothing is left the flow returns control to the controller. The follow-ups, in order:

| Follow-up | When it fires |
| --- | --- |
| Stamp the family's Household on the submission | Household mode, this is Contact 1, the submission has no Account yet, and the Contact's Account is a Household |
| Name the person the Account's Primary Contact | Their Primary Contact box is checked. The Organization when the submission has one, otherwise their Household |
| Fill a blank Organization Primary Contact | This is Contact 1, Contact 1's Add to Account rule is on, and the Organization has no Primary Contact yet |
| Affiliate the person with the Organization | The submission's Account is not a Household, and the Add to Account rule for this person or the section asks for it |
| Chain a Campaign Member | The Create Campaign Member rule is on for this person |

## The affiliation utility

`(NPSP) Utility | Upsert | Affiliation` is deliberately **form-agnostic**. It takes plain values, returns plain values, and knows nothing about Form Submissions, platform events or conversion logs. It never writes a log entry: it returns `HasError` and `ErrorMessage`, and the caller decides how to report a failure. That is what makes it equally usable from your own automation ([Customizing](customizing.md#reuse-the-affiliation-utility-in-your-own-automation)).

Give it a Contact, an Account and optionally a Role, and it:

1. **Reads the Account and refuses anything that is not an Organization.** A Household is never an affiliation, and neither is a bucket or one-to-one individual account. The refusal comes back as a clear message rather than a wrong record.
2. **Looks for the person's Current affiliation to that Organization**, newest Start Date first. If there is one, the save becomes an update of that row, which is why running it twice never duplicates. `Current` is the key NPSP orgs' own duplicate guards use, and a `Former` affiliation is history that stays where it is.
3. **Writes the affiliation**: the Contact, the Organization, Status `Current`, the Start Date kept from the existing row or today for a new one, and the Role you passed in, falling back to the Role already there.
4. **Decides Primary carefully.** The affiliation is marked Primary only when the person has no primary affiliation yet, or when the primary they have is already this Organization.

{% hint style="warning" %}
**Primary is restrained on purpose.** NPSP retires a person's previous primary affiliation, setting it to Former with today's End Date, whenever a new one is marked Primary. If a form always claimed Primary, a volunteer signing up with a second organisation would silently close out their current employer. The same restraint protects a portal user, whose primary affiliation controls the account they sign in with.
{% endhint %}

Only the fields listed above are written, so an End Date or a custom field on an existing affiliation keeps its value.

## Logging and reprocessing

Every pass writes to the submission's **Conversion Logs** related list. A successful pass records what was created, matched or updated. A failure records a short, fixed message naming the step that failed, along with the flow it happened in.

Failures are deliberately non-terminal. When a pass fails, the rule's status is set to `Error`, which is not one of the finished statuses, so the rule is eligible to run again. Fix the underlying problem, click **Reprocess** on the submission, and the conversion resumes: everything already finished is skipped, and only the unfinished rules run. Because every write is an upsert and the affiliation utility looks before it writes, rerunning cannot duplicate what already exists.

## Things worth knowing

**A conversion runs as the Automated Process user, in system context.** It does not depend on the permissions of whoever submitted the form.

**Related rows use the parent's context.** When a repeater row converts, it borrows the parent submission's Account, and control returns to the parent, because the rule sequence lives there.

**Never assert on a Household's name.** NPSP names the Household from its own settings, and with asynchronous household naming on, the final name arrives after the transaction. The extension stamps the Household's Id and nothing else, so naming cannot affect a conversion, but reports and tests that key on the name will be disappointed.

**Empty Households linger.** If a matched person is moved into the family's Household, the Household they left behind stays in the org with no members. NPSP has no setting that deletes it. Moving people between Accounts is worth avoiding for this reason alone.

**Setting an Organization's Primary Contact creates an affiliation.** NPSP does that itself when automatic affiliation creation is on. The engine names the Primary Contact before it affiliates, so the utility finds NPSP's row and updates it: one affiliation, correct flags, logged as Updated rather than Created.

**Multiple matches stop rather than guess.** If matching finds several candidate people, the pass stops with a `Multiple Matches` status and waits for a human. Turn on the template's most-confident-match setting only if you would rather it chose.

**Blank answers never erase data by default.** If you need a blank answer to clear a field, list that field in the template's Nullable Fields setting. Do Not Contact is the deliberate exception: it is only ever set, never cleared.
