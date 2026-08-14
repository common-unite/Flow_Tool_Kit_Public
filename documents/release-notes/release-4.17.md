# Release 4.17

4.17 is a bug-fix release. There are no new features. Three of the four issues are things an administrator hits while configuring, and the fourth is visible to respondents.

If you upgraded from a version older than record-based Form Components, read **[Edit was failing on Record Components](#-edit-was-failing-on-record-components-526)** and **[What you need to do after upgrading](#-what-you-need-to-do-after-upgrading)**. That one needs a few minutes of your time in Setup.

---

## 🚑 Edit was failing on Record Components (#526)

**This affected every org upgraded from before record-based Form Components shipped, including our own.**

Clicking **Edit** on a Record-based Form Component failed with an unhelpful `Script error.` and an error dialog. New and View were unaffected, so the component was still usable, just not editable.

**Why it only happened to upgraded orgs.** A package upgrade **never replaces a page layout that already exists in your org**. That is Salesforce behaviour, not a choice we make, and it is usually a kindness, since it protects the layout changes you have made. The side effect is that when we add a field to a packaged layout, existing subscribers do not receive it.

Record-based components added four fields to the **Form Component Layout**. Orgs installing for the first time got them. Orgs upgrading did not, and the Edit action depended on one of them being present.

Editing no longer depends on those fields. It also no longer depends on the layout at all, which is the more important change: the same class of problem cannot recur when we add a field in future.

---

## 🐛 A Form Template was being forced on every source record (#525)

A Campaign, or any record configured as a form source, can now be left **without** a Form Template.

Previously the Form Template lookup was **forced to be required** in the source settings editor, no matter how you had configured the field itself. Worse, a source record that did have a blank template showed respondents an error, as though something had broken.

Neither is right. Only some of your Campaigns host a form, and the ones that do not are not a fault.

- Requiredness now follows **your** field settings. If you want it enforced, set the field to Required in Setup, or write a validation rule. The form no longer overrules you.
- A source record with no Form Template now renders **nothing at all**, taking up no space on the page, rather than showing an error or reserving a blank block.
- The reason is written to the browser console whenever a form does not appear, naming the record and explaining that this is a valid configuration rather than a failure.

---

## 🐛 The Form Template lookup did not render properly in source settings (#527)

The Form Template lookup on a source record's settings now displays reliably.

This was most visible on **standard objects such as Campaign**, where the packaged Form Template field is not on the page layout. A managed package cannot ship a page layout for a standard object, so that field is on nobody's Campaign layout unless an administrator added it, and the lookup was relying on it being there.

---

## ✨ Rich text now renders in option labels (#528)

Picklist option labels containing formatting now display as **formatted text** rather than showing the raw markup.

This applies everywhere Flow Tool Kit draws the option itself:

- Radio buttons and checkboxes
- Separated buttons and survey buttons
- Badges
- Visual picker captions
- Combobox options

Boolean fields using the **Checkbox** display type now render their label as formatted text too. Previously that display type showed its label unrendered.

Bold, italics, colour and links all work.

**Please note:** option labels drawn by **standard Salesforce components** still show plain text. That includes the standard picklist, the dual listbox and the path display. Those components accept labels as plain data and render them as text, and no package can change that. If you need formatted option labels, choose one of the display types listed above.

---

## ✅ What you need to do after upgrading

**1. Check your Form Component Layout.** If you upgraded from before record-based Form Components, the layout is probably missing fields. In Setup, open the **Form Component** object, then **Page Layouts**, then **Form Component Layout**, and add any of these that are absent:

- **ObjectApiName**
- **FormConfigJSON**
- **Label**
- **Record Type**

The Edit error is fixed whether or not you do this, but those fields stay off your layout until you add them, and you will want them when configuring components.

**2. If you serve public Experience Cloud form pages, load each one once.** The first page load after any install or upgrade pays a one-time component compile of several seconds. Doing it yourself means a visitor does not.

---

## Upgrade notes

Nothing in 4.17 removes or renames anything, so it installs cleanly over 4.16 with no configuration changes required.
