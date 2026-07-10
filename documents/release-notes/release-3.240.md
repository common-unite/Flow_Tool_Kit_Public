# Release 3.240

Three headline additions this release, built as a family: **Likert Matrix sections** bring survey-style question grids with live scoring to Form Builder, the new **Survey Buttons** picklist display type gives any picklist the modern option-card look on desktop and mobile alike, and **Visual Picker** renders picklist and multiselect options as icon or image cards.

![A Likert Matrix being configured and answered live in the Form Builder preview](../.gitbook/assets/144-likert-picklist-demo.gif)

## New

### Likert Matrix Sections (#144)

Form Builder has a new section type for the most common survey pattern there is: a set of related questions that share one answer scale. Rows are your fields, columns are the scale, and every click stores a real field value on the submission, so reports, conversion mappings, and automation see normal data.

Add one from the new-section menu (Input Fields, then **Likert Matrix**) and pick a mode in Likert Matrix Settings:

* **Picklist mode** builds the columns from the first assigned picklist field's options. Column subsetting and per-form option labels (from 3.239's Picklist Option Labels) work on the whole matrix, and edits sync across every row automatically.
* **Number mode** is for scored surveys: define your own answer columns in the **Edit Answer Scale** editor (label, stored number, optional column help text, drag-free reordering) and assign number fields as rows.

![A scored Number mode matrix answering live while the total updates](../.gitbook/assets/144-likert-number-demo.gif)

Number mode can also score itself. **Show Total Score** adds a live total row beneath the matrix with an answered count and a Partial flag while incomplete, and the optional **Total Score Result Field** stamps the running total into any updateable number field as answers change, so formulas, conditional rules, and record-triggered automation can react to the score with zero custom logic. An untouched matrix stamps an empty value rather than 0, keeping "not started" distinguishable from a real all-zeros score.

Each row keeps the full field toolkit: required and read-only flags, custom labels and help text, formula recalculation triggers, and per-row display conditions. Required rows validate inline, the review screen renders each row as a standard field entry, and on phones (or in columns narrower than 480 pixels) the grid collapses to stacked survey-button cards per question. Full guide: [Likert Matrix Sections](../form-configuration/likert-matrix-sections.md).

### Survey Buttons Picklist Display Type (#246)

Any picklist can now render as **vertical, full-width option cards**: large tap-friendly targets with a radio indicator, the selected card outlined and tinted in your org's brand color, matching what respondents expect from modern survey tools.

![Switching a picklist to Survey Buttons and selecting options in the preview](../.gitbook/assets/246-survey-buttons-demo.gif)

Pick **Survey Buttons** under Picklist Display Type in Picklist Override Settings. It renders on every form factor (no phone fallback to a dropdown, unlike the Radio display type), plays nicely with option subsetting, custom option labels, help text, and conditional rules, and stores the standard picklist API value. Likert Matrix sections reuse the same rendering for their mobile layout, so survey forms stay visually consistent end to end. Details: [Field Type Settings](../form-configuration/field-type-settings.md#survey-buttons).

### Visual Picker Picklist Display Type (#247)

Picklists and multiselect picklists can now render as a grid of **visual cards**: each option shows an SLDS icon or one of your org's public image assets, hovering fades the media into the option label (phones show a caption instead), and selected cards outline and tint in your org's brand color. Multiselect fields get checkbox behavior so several cards stay selected.

![Visual picker cards on a picklist and a multiselect, with hover revealing the labels](../.gitbook/assets/247-visual-picker-demo.gif)

Choose **Visual Picker** as the Picklist Display Type and the Override Option Labels button becomes **Customize Visual Picker**: one editor maps each option's media (Icon with the standard/custom/doctype icon picker, or Image Asset from your public assets) alongside the same Custom Label input you already know, with merge fields and API-safe stored values intact. Column(s) Size shapes the grid exactly as it does for radio options, option subsetting applies, and icons paint in the brand color across internal, Aura, and LWR contexts.

![Mapping icons, image assets, and custom labels per option](../.gitbook/assets/247-visual-picker-modal-demo.gif)

Details: [Field Type Settings](../form-configuration/field-type-settings.md#visual-picker).
