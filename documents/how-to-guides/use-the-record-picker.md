# Use the Record Picker for Lookups

> Turn any single-object lookup into a searchable picker with filters, a second line of detail under each suggestion, and an extra field to search on. It also gives portal users a working lookup when they can edit a record but not create one.

![Setting up the Record Picker on Parent Account](https://raw.githubusercontent.com/common-unite/Flow_Tool_Kit_Public/main/documents/screenshots/661-record-picker-demo.gif)

{% hint style="info" %}
**Prerequisites**: A form with a lookup field that points at **one** object (for example Parent Account on Account, or Account on Contact). See [Build a Form](build-a-form.md).
{% endhint %}

## What It Does

The Record Picker replaces the standard lookup input with Salesforce's `lightning-record-picker`. Compared with the standard lookup it can:

* **Filter the suggestions**, including by other answers on the same form. "Only show accounts of the Type chosen above" is one row: `Account Type` equals `{{Type}}`.
* **Show a second line under each suggestion**, such as the Account Number, Phone or Website, so people can tell similar names apart.
* **Search a second field**, so someone can find an account by its number or phone as well as its name.
* **Work for users who cannot create the record**, which the standard lookup cannot (see [When it turns on by itself](#when-it-turns-on-by-itself)).

## When to Use It

| Situation | Use |
| --- | --- |
| People must pick from a subset of records (active programs, this household's contacts, accounts of one type) | **Record Picker** with a filter |
| Many records share a name and people need a second detail to choose correctly | **Record Picker** with a display field |
| People know a record by a number or code, not its name | **Record Picker** with an extra search field |
| You want a full search modal with several columns, hierarchy or "New" record creation | The standard lookup with [Configure Lookup Fields](configure-lookup-fields.md) |
| The lookup can point at several objects (for example Owner, or a Task's What) | The standard lookup; the picker searches one object only |

## Set It Up

1. Open **Form Builder**, select your form, and click the lookup field in the outline.
2. On the **Field** tab, set **Lookup Field Display Type** to **Record Picker**. The option only appears for lookups that point at one object.
3. Click **Record Picker Settings**.

![Record Picker Settings with a filter and suggestion fields](https://raw.githubusercontent.com/common-unite/Flow_Tool_Kit_Public/main/documents/screenshots/661-record-picker-settings.png)

4. Add filters and choose the suggestion fields (both explained below), then click **Save**.
5. Save the form. The button now reads **Record Picker Settings (1 filter)** when a filter is set.

### Filter

Each row is **Field**, **Operator**, **Value**. Rows combine with AND unless you write **Filter logic** such as `1 AND (2 OR 3)`.

* **Merge fields** in the value follow the form's other answers: `{{Type}}`, `{{AccountId}}`, `{{Program__c}}`. The suggestions update as soon as that answer changes.
* **A row whose merged value is blank is skipped**, not treated as "equals blank". Until someone chooses a Type, the picker shows every account; once they choose one, it narrows. Filter logic is rewritten around the skipped row automatically.
* **For in, not in, includes and excludes**, separate values with commas.
* **Custom path (cross-object)** filters on a related record's field, for example `Account.Type` on a Contact picker.

![Suggestions narrowed to Prospect accounts by the Type answer](https://raw.githubusercontent.com/common-unite/Flow_Tool_Kit_Public/main/documents/screenshots/661-record-picker-filtered-results.png)

### Suggestions

| Setting | What it controls | Default |
| --- | --- | --- |
| **Show as title** | The main line of each suggestion | The record name |
| **Show below the title** | A second, smaller line | Nothing |
| **Search on** | The field the typed text is matched against | The record name |
| **Also search on** | One extra field to match | Nothing |

These lists offer text, email, phone, URL and picklist fields. They leave out the record ID (the picker returns nothing when ID is used) and long text fields, which cannot be searched. The picker allows **one** extra display field and **one** extra search field.

![Searching by website with the website shown under each name](https://raw.githubusercontent.com/common-unite/Flow_Tool_Kit_Public/main/documents/screenshots/661-record-picker-search-by-website.png)

### Placeholder

The picker shows the field's **Placeholder** if you set one on the Labels tab, otherwise "Search Accounts..." (the object's plural label), matching the standard lookup.

![A picked record in the Record Picker](https://raw.githubusercontent.com/common-unite/Flow_Tool_Kit_Public/main/documents/screenshots/661-record-picker-selected.png)

## When It Turns On By Itself

A form that runs with a record in create mode cannot show the standard lookup to someone who lacks **Create** on the object: Salesforce renders it blank. So Flow Tool Kit picks the lookup's display from the running user's access, with no setting to change:

| The running user can... | The lookup shows as |
| --- | --- |
| Create the object | The standard lookup, or the Record Picker if you chose it |
| Edit but not create | **The Record Picker, automatically**, using your Record Picker Settings if any |
| Only read | The related record's name, read-only |

The automatic picker only applies when the field's display type is **Default**. A field set to **Form Component**, **Start New Form** or **View/Edit Form Submission** keeps that display.

This is the case for most portal users. A Customer Community Plus user who can edit their household Account but not create Accounts now gets a working picker instead of a blank box.

## Guests and External Users

### Portal users (Customer Community, Customer Community Plus, Partner)

* **Suggestions follow sharing.** A portal user only sees records they can already see. If the picker looks empty, check the sharing sets or sharing rules for that object before the filter.
* **The fields you display, search or filter on need read access** (field-level security) on the user's profile or permission set.

### Guest users

* **Guests never get the automatic picker.** Salesforce does not allow Edit on most objects for guest profiles, so the "edit but not create" case cannot happen. A guest gets the Record Picker only when you choose it as the display type.
* **Guests need a guest sharing rule** on the object being searched. Without one the picker searches and finds nothing, with no error.
* **Guests need object Read** and field-level security on every field used for display, search or filters, through the guest profile or a permission set assigned to the guest user.
* **On LWR sites**, turn on **Allow guest users to access public APIs** in the site's settings, or the picker cannot load the object's details for guests.

{% hint style="warning" %}
**Guest sharing rules make records visible to anyone on the internet** who reaches the form. Share only what the picker needs, with criteria (for example `Type = Partner`), and never share records that hold personal data.
{% endhint %}

## Limitations

* **No "no matches" message.** When nothing matches the search and the filter, the suggestion list simply does not open. The picker does not report empty results, so Flow Tool Kit cannot show its own message. Use the field's help text or label to explain the filter, for example "Only accounts of the type you chose above".
* **Single-object lookups only.** The option is hidden for lookups that can point at more than one object.
* **One extra display field and one extra search field.** This is a limit of Salesforce's picker.
* **Read-only fields use the standard read-only lookup display**, not the picker.
* **A saved field the picker cannot use is cleared** the next time you open Record Picker Settings. Save the settings and the form to repair a form saved with, for example, the record ID as a display field.
* **Styling on LWR sites.** On Lightning Experience, Aura sites and embedded forms, the picker matches your other fields. On an LWR site its inside is sealed off from page styles, so a picked record may keep Salesforce's default look.

## Troubleshooting

| Symptom | Likely cause |
| --- | --- |
| The **Record Picker** option is missing | The lookup points at more than one object |
| The picker shows nothing for a guest | No guest sharing rule on the object, or no field access for the guest |
| Nothing ever matches, even with no filter | A display or search field the picker cannot use; reopen Record Picker Settings, save, then save the form |
| The filter never narrows | The merge field is blank or misspelled; the row is skipped while its value is blank |
| A portal user sees a read-only name instead of the picker | The user can read the object but not edit it |

## Related Pages

* [Configure Lookup Fields](configure-lookup-fields.md): the standard lookup with a search modal, hierarchy and new record creation
* [Open A Form From A Lookup](open-a-form-from-a-lookup.md): Form Component, Start New Form and View/Edit Form Submission
* [Deploy to Experience Cloud](deploy-to-experience-cloud.md): site setup for guests and portal users
* [Build a Form](build-a-form.md): creating forms from scratch
