# Flow Tool Kit 4.4: Twice as Fast in Public, and a Review Mode for the People Behind the Forms

**TL;DR: 4.4 cuts public-site form loading roughly in half and makes step navigation feel instant, adds a Review Mode that shows internal users a whole submission on one screen, lets blank answers deliberately clear Salesforce data during conversion, and unlocks free page-jumping on linear templates. Nine fixes ride along, including one every org with guest-facing likert surveys should take today. Upgrading is one click: Setup, Installed Packages, Upgrade to Recommended Version.**

## Your public forms just got twice as fast

We spent a night with a stopwatch against a seven-page grant application on a public Experience Cloud site, and then we spent the morning making the numbers embarrassing: returning-visitor page loads dropped from about 5.6 seconds to 3.2, and opening a step fell from as much as 8.5 seconds to about 1.5. The engine now caches its expensive metadata lookups org-wide instead of rebuilding them for every visitor, starts its main server call the moment the page knows what to load, and quietly pre-warms every form on the template while your respondent is still reading the overview - so clicking into a never-visited step usually needs no server round trip at all. None of it requires configuration, and every optimization shipped with equivalence tests proving the engine emits byte-for-byte identical forms.

Two habits worth adopting alongside the upgrade: make sure your org allocates Platform Cache capacity to the `FlowToolKit.FormComponents` partition (Setup > Platform Cache) - that partition is where all of this speed lives - and load your public form page once right after any upgrade, so the one-time component compile happens to you instead of your first real visitor.

## See the whole submission at a glance

Form Submissions collect answers across pages, sections, and related records, and until now reviewing one meant clicking through the same pages your respondent did. **Review Mode** is a checkbox on the form template component for Lightning record pages and screen flows: turn it on and the component opens straight to a single consolidated review of every answer - no stage indicators, no navigation, just the submission. Pair it with Read Only for a sealed audit view, or leave it editable and internal users can correct any section through the familiar edit modal - which now validates before it commits, keeps itself open when something's missing, and rolls every change back if you cancel. It's the internal reviewer's view we always wanted the form runtime to have, built from the same review machinery your respondents already use.

## Blank answers can finally mean something

Conversion mapping has always protected your records: blank form answers are stripped before updates so they can't overwrite good data. But sometimes blank IS the answer - the contact who cleared their dietary restrictions, the organization that no longer has a fiscal sponsor. **Nullable Fields** on the Form Template lets an admin name the fields where a blank answer should clear the target during conversion. Pick them in a dedicated selector on the template record (scoped per object, or a universal list that applies anywhere), or build the list in Flow with a simple formula. Misconfigurations fail loudly by design: a typo'd or non-updateable field name stops the conversion with a clear error instead of silently skipping.

## Linear templates, free navigation

Stages Mode has always let respondents roam. The new **Non-Linear Navigation** checkbox brings that freedom to classic linear templates with a vertical stage indicator: click any page in the rail and jump straight to it, with required fields still enforced at submit. It's opt-in per template and hides automatically wherever it doesn't apply.

## Multiselects that understand "none of the above"

Decline phrases like *None*, *Prefer not to say*, and *None of the above* are now exclusive in every multiselect display - checkboxes, comboboxes, and visual pickers alike - so choosing one clears the rest, and choosing anything else clears it. *Prefer not to say* also joined both Race & Ethnicity value sets out of the box.

## The fixes

The one to take seriously: **likert matrices were read-only for guest visitors** - Salesforce never grants guests record update permission, and the matrix was checking exactly that even though guests create their submissions rather than update them. If your public site runs a survey, this alone is worth the upgrade. Also in 4.4: form template themes now reach every button and indicator (including hover and pressed states), long-text fields no longer flash a required error the instant you click into them, guest save failures explain the actual fix instead of quoting a raw DML fault, and the visual picker aligns with its neighbors with properly brand-colored selected icons.

## What's next

The performance work opened a to-do list we like: in-app warnings when Platform Cache isn't allocated, pre-warming record defaults on step entry, and a hard look at LWR sites for the last of the framework overhead. Review Mode's lookup display and a smarter mobile button layout are also queued.

## Upgrade in one click

4.4.0.1 is the recommended version: open **Setup > Installed Packages** and click **Upgrade to Recommended Version**. Full notes live on the [release page](https://github.com/common-unite/Flow_Tool_Kit_Public/releases/tag/release%2F4.4.0.1).

Questions or feedback? Reach us at support@common-unite.com.
