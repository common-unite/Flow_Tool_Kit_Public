# Flow Tool Kit 4.0: Forms People Finish

**TL;DR: Flow Tool Kit 4.0 is the milestone release, forty-six releases of capability in one upgrade. Long applications become stage overviews families complete together. Work saves itself and comes back through emailed resume links. Surveys score themselves into real Salesforce fields. Donation forms grow preset amounts, steppers, and sliders. Any form embeds on any website. And when your requirements get unusual, your admins extend it all with Flow, not code. It is live now as the recommended version: one click in Setup.**

The fastest way to understand 4.0 is to use it. This is a real public affordable-housing application running on Flow Tool Kit right now: **[open the live demo](https://common-unite.my.site.com/s/form-template/a0fRQ000003mUy9/affordable-housing-land-trust-application?language=en_US)**, click through the stages, save your progress, mark a page complete. No login, no setup, ninety seconds.

## Applications people actually finish

Picture the longest thing you ask anyone to complete: the housing application, the grant proposal, the annual re-certification. The reason those get abandoned is not the questions, it is the march: page after page with no sense of where the end is. **Stages Mode** replaces the march with a stage overview: every step listed with what it is, how long it takes, and what is already done. A parent starts Household Information on a lunch break, a spouse attaches documents that evening from a phone, and the overview keeps everyone honest about what is left.

![Full Stages Mode walkthrough: landing on the stage overview, opening a stage, saving progress, and marking stages complete](https://raw.githubusercontent.com/common-unite/Flow_Tool_Kit_Public/main/documents/.gitbook/assets/125-stages-public-walkthrough-demo.gif)

The quiet win is on your side of the form. Progress lives in real Salesforce records, so your staff get a list view of applicants stuck on Documents, a dashboard of completion rates by stage, and a record-triggered flow that nudges anyone idle for a week. There is no portal project here: Stages Mode is a checkbox on the Form Template, and the operations behind the experience come from the same checkbox.

## Life interrupts. Your forms are fine with that.

A half-finished form is not a respondent failure, it is a Tuesday. In 4.0, work saves itself as people type, a quiet "Draft saved" note keeps them confident, and one click emails a private, single-use link that reopens the form exactly where they left it, days later, on any device. It works for logged-in users, for guests, and for forms embedded on your website.

![Autosave in action](https://raw.githubusercontent.com/common-unite/Flow_Tool_Kit_Public/main/documents/.gitbook/assets/216-autosave-demo.gif)

It also unlocks a pattern you could not build before: launching a form *to* people instead of waiting for them. A record-triggered flow can send start links to a whole list, so two hundred members receive their renewal already tied to their record, open it without logging in, and finish it across as many sittings as they need.

## Ask like a survey. Store like Salesforce.

Survey tools usually mean another vendor, another export, another "we'll sync it later." The Survey Suite makes the survey a form: **Likert Matrix sections** render a battery of same-scale questions as one clean grid, **Survey Buttons** turn picklists into tap-friendly cards that never collapse into a dropdown on a phone, and **Visual Picker** makes choices you can see instead of read.

![A scored Likert matrix updating its total live](https://raw.githubusercontent.com/common-unite/Flow_Tool_Kit_Public/main/documents/.gitbook/assets/144-likert-number-demo.gif)

There is no sync, ever. Every tap lands in a real field on a real record the moment it happens. Scored mode totals live as the respondent clicks and stamps the result into a number field, which means a triage flow can route a high-risk intake to a case manager before the confirmation page has finished loading.

![Visual picker cards with brand-color selection](https://raw.githubusercontent.com/common-unite/Flow_Tool_Kit_Public/main/documents/.gitbook/assets/247-visual-picker-demo.gif)

## A number is a decision, not a data entry task

A donation amount, a ticket quantity, a percent allocation: these are moments where someone decides, and a bare text box does nothing to help them. Now any number, currency, or percent field can render as **preset amount chips** (the giving-page pattern, with an Other chip for the generous), a **stepper** with real minus and plus buttons, or a **slider**. Currency symbols and percent signs stay true in every mode, so the form reads like money instead of math.

![Stepper, slider, and preset amount chips](https://raw.githubusercontent.com/common-unite/Flow_Tool_Kit_Public/main/documents/.gitbook/assets/254-number-overrides-demo.gif)

Because these are display overrides on the fields you already have, delivery is a dropdown, not a migration: no schema changes, no parallel fields, and every report and rollup keeps working untouched.

## Your website just became a Salesforce form

Open the **Embed Code Generator**, pick a Flow, Form Template, or Record Form, copy one snippet, and paste it into WordPress, Squarespace, or hand-rolled HTML. Visitors see a form that simply belongs to the page: it sizes itself, keeps bots out with reCAPTCHA, and every submission is a Salesforce record the instant the button is clicked. No middleware, no CSV imports, no "we'll pull the leads in on Friday."

![The Embed Code Generator](https://raw.githubusercontent.com/common-unite/Flow_Tool_Kit_Public/main/documents/.gitbook/assets/100-embed-code-generator.png)

## The one that makes it yours: extend with Flow, not code

Every organization eventually asks its forms to do something no product anticipated: "only returning volunteers should see this," "pull their household from last year," "if they already applied, stop them politely." In most form tools, that sentence starts a development project. In Flow Tool Kit, it starts a flow.

Every Form Template can name a **Prefill Flow**, an autolaunched or screen flow built entirely in Flow Builder that runs before the form renders. Prefill from the running user's records, seed repeating sections with related data, gate the form with your own eligibility rules and a branded message, or hand an in-progress draft off to a resume-link email. Because it is ordinary Flow, it scales like Flow: shared flows, per-template flows, reusable subflows. This is the reason Flow-first orgs choose Flow Tool Kit: when the requirements get weird, your admins keep going instead of opening a ticket. Don't sleep on this feature.

## One form, every occasion

Two more spotlights round out the release. **Form Template Sources** let one template serve your whole program calendar: each campaign, event, or cohort record carries its own dates, branding, prefill values, and confirmation messaging, and program staff manage it themselves from the record page with a live preview.

![The Template Source Editor on a source record](https://raw.githubusercontent.com/common-unite/Flow_Tool_Kit_Public/main/documents/.gitbook/assets/form-template-source-editor-demo.gif)

And **Per-Template Style Sheets** give each template its own scoped CSS, so a gala invitation and a corporate intake form can live in the same org without ever bleeding into each other. The form your donors see can finally match the brand your designers built.

![Choosing a per-template style sheet](https://raw.githubusercontent.com/common-unite/Flow_Tool_Kit_Public/main/documents/.gitbook/assets/221-style-sheet-selector-demo.gif)

## Try it, then upgrade

Ninety seconds in the **[live demo](https://common-unite.my.site.com/s/form-template/a0fRQ000003mUy9/affordable-housing-land-trust-application?language=en_US)** will tell you more than anything written here. The full story, every feature, improvement, and fix since 3.196, is in the [4.0 release notes](https://github.com/common-unite/Flow_Tool_Kit_Public/releases/tag/release%2F4.0.0.1).

4.0.0.1 is flagged as the package's recommended version: open **Setup > Installed Packages** and click **Upgrade to Recommended Version**, and everything above arrives in one click.

Questions or feedback? Reach us at support@common-unite.com.
