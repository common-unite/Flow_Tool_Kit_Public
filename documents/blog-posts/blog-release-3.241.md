# Flow Tool Kit 3.241: Steppers, Sliders, and Preset Amounts

**TL;DR: Version 3.241 makes number fields interactive. Any number, currency, or percent field can render as a stepper with minus/plus buttons, a slider, or a row of preset amount chips with an optional custom-value input, formatting intact in every mode. Fields named for icons, email templates, image assets, or style sheets now get real pickers, text fields can render as text areas, and a fix to the packaged save flow means form template saves work out of the box for standard and guest users. Upgrading is one click: open Setup, go to Installed Packages, and click Upgrade to Recommended Version.**

## Number inputs, grown up

A plain number box is fine for "how many chairs?" It is not fine for a donation form, a quantity picker, or a percent allocation: the places respondents actually decide a number. 3.241 gives every number, currency, and percent field three new ways to render, one dropdown away in the field's **Number Display Type**:

[SCREENSHOT PLACEHOLDER: 254-number-overrides-demo.gif, the Number Display Type dropdown, the preset editor, and all three modes live in the preview]

* **Stepper** puts minus and plus buttons on either side of the formatted input. The field's new **Step** value sets how much each click moves: set it to 1 on a currency field and the stepper counts whole dollars instead of pennies. Step is purely an increment: it never restricts what a respondent can type, so $12.50 is always welcome even when the buttons move in fives.

[SCREENSHOT PLACEHOLDER: 254-number-stepper-demo.gif, a stepper with Min, Max, and Step incrementing a quantity]

* **Slider** turns the field into a draggable range. It defaults to 0–100, the natural shape for a percent field, and honors the field's Min, Max, and Step the moment you set them.

[SCREENSHOT PLACEHOLDER: 254-number-slider-demo.gif, a percent slider bounded 0 to 100 with a step of 10]

* **Preset Amounts** is the donation-page pattern: quick-pick chips you define as label/value pairs in the new Edit Preset Amounts editor. Turn on Allow Custom Values and an **Other** chip appears, revealing a free-entry input; a prefilled value that matches no chip selects Other automatically so nothing gets orphaned. Chips light up in your org's brand color whether the amount was tapped or typed.

Currency symbols and percent signs follow the field's real formatting in every mode, the layout adapts to the actual width of the container rather than just the device, and the full field toolkit (custom labels with merge fields, help text, required, prompts, conditional rules) works exactly as it does everywhere else. Formula fields, being read-only, sensibly stay plain.

We liked the steppers enough to use them in our own settings UI the same week we built them: the Repeater's Min/Max settings in the section customize window are now a pair of cross-bound steppers, each using the other's value as its boundary.

## Semantic fields get real pickers

If a field is called `Icon_Name__c`, a text box is the wrong editor. 3.241 notices: String and Picklist fields whose API names match icon, email template, image asset, or style sheet patterns now offer the matching **selector display type**: an icon picker with the complete current SLDS set (629 icons joined the library this release), an email template picker scoped to the form's object, an image asset picker for your org's public assets, and a style sheet picker.

The chosen value saves with the form like any other answer (no direct record writes), and the standard label, help text, and sizing toolkit applies. It is a small thing that makes config-style forms feel native instead of improvised.

## Text fields as text areas

Any standard Text field can now render as a **multi-line text area** with the character counter, length validation, and height controls included: a 255-character field can collect a short paragraph without changing your schema. And setting a Maximum Height on long text or rich text now clamps the **read-only** rendering into a bordered, scrollable box, so review screens stay tidy when someone pastes their life story.

## The fix worth the upgrade

Since June, the packaged form template save flow shipped in a state subscriber orgs could not activate: its save keyed on a field that could not satisfy the platform's uniqueness requirement. Admins never noticed, because admins run the latest flow version regardless. Standard and guest users need the *active* version, and there wasn't one.

3.241 fixes the root cause with a new unique identifier field, restores the flow to its original design, and ships it **active**. Form template saves for every user profile now work out of the box, with the same replay safety that makes autosave and double-clicks resolve to a single record. If your org uses Form Templates with non-admin users, take this upgrade.

## Also in this release

* **Form Template Framework group**: the object selector now groups Form Submission, Form Template, Form Template Page, and Form Template Page Section separately from your org's custom objects.
* **Section overlap fixed**: a legacy negative margin could paint each Form Template section a few pixels over the one above it; both renderers corrected.
* **Percent Min/Max on the right scale**: the builder now captures percent constraints on the same whole-number scale the field stores. If you set percent Min/Max before 3.241, re-enter them once (a saved 0.1 becomes 10).
* **Builder crash fixes**: repeater/table forms with actions no longer crash the preview, and Form Component record pages render configs saved during the affected window without cleanup.
* **Customize window rebuilt on our own forms**: the section customize experience (Actions, Conversion Rules, Repeater/Table Settings) is now driven by flowForm configurations, the same engine your forms run on, including an extensible Client Conversion Config slot for org-specific conversion parameters.

Full details in the [3.241 release notes](https://github.com/common-unite/Flow_Tool_Kit_Public/releases/tag/release/3.241.0.1).

## Upgrade in one click

3.241 is flagged as the package's recommended version, so admins will find an **Upgrade to Recommended Version** link on the Installed Packages page in Setup.

## What's next

The display-type family keeps growing. If there is an input pattern your respondents keep asking for, tell us. And if you put the preset amount chips on a giving form, we would love to see it.

Questions or feedback? Reach us at support@common-unite.com.
