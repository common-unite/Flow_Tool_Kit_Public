# Flow Tool Kit 3.240: The Survey Release

**TL;DR: Version 3.240 turns Form Builder into a survey tool. Likert Matrix sections render a battery of same-scale questions as a compact grid, with an optional live score that can write itself into a field on the record. Two new picklist display types round it out: Survey Buttons gives any picklist the modern full-width option-card look, and Visual Picker renders options as selectable icon or image cards. Upgrading is one click: open Setup, go to Installed Packages, and click Upgrade to Recommended Version.**

## Likert Matrix sections: the question grid you have been building by hand

If you have ever built a satisfaction survey or a screener like the GAD-7 in a form tool, you know the pattern: five, seven, ten questions that all share the same answer scale. Until now that meant a stack of identical picklists eating half the page.

The new **Likert Matrix** section type renders the whole battery as one grid: one row per question, one column per answer, a radio selection at each intersection. Rows stripe for readability, the selected cell fills with your org's brand color, and every click stores a real field value on the submission, so your reports, conversion mappings, and record-triggered automation see completely ordinary data.

[SCREENSHOT PLACEHOLDER: 144-likert-picklist-demo.gif, assigning picklist fields as matrix rows and answering in the live preview]

There are two modes:

* **Picklist mode** builds the answer columns from your first field's picklist options. Column subsetting and the custom option labels we shipped in 3.239 apply to the whole matrix, and edits sync across every row automatically.
* **Number mode** is for scored surveys. You define the answer columns yourself in the new Edit Answer Scale editor, each with a label respondents see and a number that gets stored, then assign number fields as your rows.

Number mode is where it gets fun. Flip on **Show Total Score** and a live total row appears beneath the matrix, summing the answered rows as the respondent clicks, with an answered count and a Partial flag while the survey is incomplete. Then pick a **Total Score Result Field** and the matrix stamps the running score straight into a number field on the record. Formulas recalculate, conditional rules fire, and record-triggered flows react to the score with zero custom scoring logic. An untouched survey stamps an empty value rather than zero, so "not started" never masquerades as a legitimate all-zeros result.

[SCREENSHOT PLACEHOLDER: 144-likert-number-demo.gif, a scored matrix updating its total live]

Every row is still a full form field: required and read-only flags, custom labels with merge fields, help text, per-row display conditions, and formula recalculation triggers all work exactly as they do everywhere else. On phones, or anywhere the matrix gets squeezed below usable width, the grid collapses to stacked option cards per question, which brings us to the second feature.

## Survey Buttons: picklists that feel like a survey tool

Any picklist can now render as **vertical, full-width option cards**: big tap-friendly targets with a radio indicator, the selected card outlined and tinted in your org's brand color. It is the look respondents know from every modern survey product, and it is one dropdown away in the field's Picklist Display Type.

[SCREENSHOT PLACEHOLDER: 246-survey-buttons-demo.gif, survey button cards being selected]

Unlike the Radio display type, Survey Buttons never falls back to a dropdown on phones, which makes it a great default for mobile-first forms. Option subsetting, custom option labels, help text, and conditional rules all apply, the stored value stays the plain API value, and Likert Matrix sections reuse this exact rendering for their stacked mobile layout, so your survey forms stay visually consistent from desktop grid to phone cards.

## Visual Picker: options your respondents can see

The third member of the family goes visual. The new **Visual Picker** display type renders picklist and multiselect options as a grid of selectable cards, each showing either an SLDS icon or one of your org's public image assets. Hover a card and the media fades into the option's label; on phones the label renders as a caption instead. Selected cards outline and tint in your brand color, icons paint in your brand color in every context, and multiselect fields get checkbox behavior so several cards stay selected.

[SCREENSHOT PLACEHOLDER: 247-visual-picker-demo.gif, icon and image cards on a picklist and a multiselect]

Configuration is one editor: choose Visual Picker as the display type and the option labels button becomes **Customize Visual Picker**, where each option gets a media type (icon or image asset), the matching picker, and the same custom label input you already know, merge fields included. Column count works exactly like radio options, from one column to twelve.

[SCREENSHOT PLACEHOLDER: 247-visual-picker-modal-demo.gif, mapping icons, assets, and labels per option]

## Under the hood

* Answers from component-based sections (including the Likert Matrix) can now trigger formula recalculation, so calculated fields respond to grid answers the moment they change.
* All three features ship with full documentation, including a dedicated Likert Matrix guide with configuration walkthroughs for both modes.

Full details in the [3.240 release notes](https://github.com/common-unite/Flow_Tool_Kit_Public/releases/tag/release/3.240.0.1).

## Upgrade in one click

3.240 is flagged as the package's recommended version, so admins will find an **Upgrade to Recommended Version** link on the Installed Packages page in Setup. And if you skipped 3.239, this upgrade also picks up its critical Flow Builder fix, which every org that adds Form components to new screen flows should have.

## What's next

The survey tooling will keep growing, and we are exploring deeper theming control so the same design language can flow through every component on the page. If you build something with the new matrix, we would genuinely love to see it.

Questions or feedback? Reach us at support@common-unite.com.
