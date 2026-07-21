# Flow Tool Kit 4.1: Your First Form Now Needs Zero New Fields

**TL;DR: 4.1 ships 99 ready-made fields on Form Submission, taking it from 132 to 231, so a new form maps entirely to fields that already exist: generic question slots, rating-scale batteries that make a scored Likert survey a zero-setup exercise, nonprofit registration staples, and demographics. A thirteen-component grant application demo shows the whole system working together, and two fixes round it out, including one every guest-user org should take. Upgrading is one click: Setup, Installed Packages, Upgrade to Recommended Version.**

## Stop creating fields before your first form

The most common friction in any form tool is the field tax: before you can ask a question, you create somewhere to store the answer. 4.1 pays that tax for you. Ten generic text questions, five booleans, five numbers, three dates, and two URLs are simple landing spots for one-off questions; give them a custom label on the form and map the answer downstream. Contact parity fields (middle names, salutations, pronouns), a full mailing address block, business fields, attribution, contact preferences, emergency contact, volunteer and event staples, and household demographics cover the rest. Every picklist ships unrestricted with a complete value set, and every field is granted in all three permission sets from the moment you upgrade.

## Surveys that assemble themselves

The rating-scale batteries are the quiet star: ten Agreement fields, five Satisfaction, five Frequency, five star Ratings, and three 0-to-10 scales, all sharing their answer scales, which is exactly what Likert Matrix sections require. That means a ten-statement scored assessment is now a drag-and-drop exercise with zero field creation, with three Total Score fields ready to catch the running sums for automation.

## A real grant application, out of the box

The FY26 Community Impact Grant demo in the dev workflow now runs on thirteen modular components built entirely from the new fields: legal information with EIN validation, a scored capacity self-assessment, preset-tier requested amounts where picking over $50,000 conditionally reveals a references stage, and a certification page that signs on glass. Each block is interchangeable, carries its own conditional logic, and doubles as a pattern library for building your own.

## The fixes

The packaged save flow no longer re-updates the record it just created, which was showing guest users an error on perfectly successful saves and silently double-saving for everyone else. And record forms now work on objects without a tab, where Salesforce reports last-viewed fields that cannot actually be queried.

## Upgrade in one click

4.1.0.1 is the recommended version: open **Setup > Installed Packages** and click **Upgrade to Recommended Version**. Full details, plus the complete 4.0 milestone story, live on the [release page](https://github.com/common-unite/Flow_Tool_Kit_Public/releases/tag/release%2F4.1.0.1).

Questions or feedback? Reach us at support@common-unite.com.
