# Release 4.9

## 🆕 Custom LWC sections can now manage related records (#386)

A Form Template page section set to **LWC** hands your custom Lightning Web Component the related records belonging to that section, and lets it add, update and remove them through a single event. Your component describes what it wants done and the framework handles the rest: matching the row, generating keys, stamping the section and parent, and making sure a removed record is genuinely deleted.

```javascript
this.dispatchEvent(new CustomEvent('relatedrecordchange', {
    detail: { action: 'add', record: { FlowToolKit__Text_Question_1__c: 'Jane' } },
    bubbles: true, composed: true
}));
```

`action` accepts `add`, `update` and `remove`. Your component also receives `relatedRecords` (already scoped to your section) and `recordTemplate`, a pre-stamped blank row.

The contract is deliberately import-free: plain `@api` properties and plain `CustomEvent`s, with nothing to import from the managed package and no coupling to a package version. See **LWC Section Type** in the documentation for the full guide.

## 🛠 Custom LWC sections: field changes are no longer lost (#386)

In the same section type, a field change dispatched from a custom LWC never reached the form. Two things were wrong, and together they made the feature look like it worked while quietly discarding data.

The handler was looking for the wrong property name on the event, which meant every change fell through to a fallback that **replaced the whole working record with the event payload**. That blanked every merge field in the section and destroyed the record your own component was reading. The change also never travelled up to the form, so it never reached the submission, page conditional logic, or autosave: edits were display-only and lost on save.

Both are fixed. A custom LWC section now behaves like any other section: changes persist, merge fields update, conditional logic re-evaluates, and autosave fires.

Alongside this, the section's optional `validate()` method is now actually called during navigation, and `review` and `disableAll` reach your component on both surfaces so it can render read-only when the form is.

## 🆕 Design Blocks: record-driven conditional visibility (#383)

Site Design Blocks can now show or hide themselves based on the values on a record, using the same rule builder and the same semantics as Form Template Page conditional logic. Blocks share a single conditional-logic core with the form runtime, so a rule behaves identically wherever you write it.

Blocks no longer flash before evaluating, a hidden block leaves no gap in the layout, and entrance animations are self-healing when a block becomes visible.

## 🆕 Fields Referenced widget (#353, #361, #366)

A new widget on the Form Template record page lists **every field the template references**, so you can review a template's true data footprint without opening each page and section. Each occurrence gets its own row, with linked Section and Source columns, and Source is split into the source and the component it comes from.

## 🛠 Page field map now walks all three section sources (#360)

Hiding a page cleared the fields it contained only when those fields came from metadata. Sections configured from a record or from inline JSON were skipped, so their values survived a page being hidden. The map now walks all three sources.

## 🛠 flowForm conditional logic: DOESNOTCONTAIN and numeric zero (#385)

`DOESNOTCONTAIN` threw rather than evaluating, and a numeric **zero** was treated as blank, so rules testing for zero behaved as though the field were empty. Both are corrected.

## 🛠 Device Size conditions use the measured width (#388)

Device Size conditions were reading Salesforce's `FORM_FACTOR` rather than the width the component has already measured for itself. They now use the measured width, so a condition matches what is actually on screen rather than the device category.

## 🛠 buttonClicked no longer generates invalid output on a Flow screen (#358)

Placing a Form Template on a Flow screen could fail with "generated invalid output for field", because the button output carried a property that is not part of the Button type. Apex-defined outputs deserialize strictly, so one unexpected key fails the whole assignment. The output now matches the type.

## 🛠 Two components sharing a Merge Field no longer cross-populate (#359)

When two components on a page shared the same Merge Field and the key value was still blank, typing into one could populate the other. Merge identity now accounts for the blank case, so components stay independent until the key has a value.

## 🛠 The record type picked in the New dialog reaches the form (#351)

Choosing a record type in the standard **New** dialog was discarded on the way into the overriding form, so the form always opened with the default record type. The selection now carries through.

## 🛠 Source mapping fields are reachable in the UI (#334)

`Prefill_Mapping_Field__c` was missing from the Form Template Source layout and could not be set at all, and `Source_Text_1-3` were invisible on submissions. All are now on their layouts.

## 🎨 Design Blocks: three rounds of design refinement (#362-#380)

Padding controls now do what they say, including removing the built-in section padding. Buttons and cards gained link targets, cards can be made clickable as a whole, and the stats bar aligns to the page content edge. Full-bleed blocks stretch the background without dragging the content out of alignment with contained blocks, card text no longer overflows at narrow widths, and card grids stack correctly on mobile.

## 🆕 Marketing and demo pages (#354, #355, #356, #357)

A motion library for Design Blocks with entrance, hover and loop options, honouring reduced-motion preferences. Seven marketing demo pages and a Volunteer Opportunity page built from the design canvas, plus a **Next Design** control that cycles every canvas design.
