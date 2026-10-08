# Record Card - upcoming release

This feature is prepared for the next release; it is not assigned a package version yet.

## Show a record as a designed card

A Record Card lays one record out as a finished card: a photo, a badge, a title, detail rows, tags and buttons. Every line takes typed text, a `{{Field}}` merge field, or both, and a line left empty is left off the card.

Nine card types ship: Media Top, Photo Overlay, Date Tile, Progress, Header Band, Icon Lead, Centered Profile, Field List and Value Spotlight. Switching type keeps the lines the new type also uses.

## Available on Experience Cloud and in forms

- **Form (Design Block):** a new **Record Card** type. It reads the page's record and reuses the block's Buttons, Card Style, Background, Border, Spacing, Motion and Visibility settings.
- **Form Builder:** a new **Record Card** section type under Formatting. It reads the form's own record and updates as the respondent types, in a form, a Flow screen, a repeater row and a Form Template.

Both are drawn by the same card, so a card configured in one looks the same in the other.

## Built like any other section in the Form Builder

- **Field lists.** An input that takes a record value is one list: pick a field, or type a value where the input accepts one. Each list shows only the fields the input can use, grouped by data type, with formula fields in their own group.
- **Image from an Asset File.** The card's image is chosen the way an Image section's is, with an optional field that overrides it for each record.
- **Detail rows are fields.** A row is a field of the section, so the form loads it and Salesforce tracks the dependency. The row shows the field's label and value unless you change them; write `{{value}}` to style the value or put text round it.
- **Insert Field.** Every rich text input has an Insert Field button that places a merge field at the cursor, with the right format for currency, number and date fields.
- **Examples.** Choosing a card type loads that type's example until you change the content.

## Buttons that open a Flow or a Record Form

A button on a Record Card, and on any other Form (Design Block) type, can now open a screen flow or a record in a Form Component, in a window over the page, as well as a link. A Record Form opens to edit or to read.

- **Record** chooses the Id the button passes: this record's, or the Id a lookup field holds. In the Form Builder that choice also decides which forms are listed, so there is no object to pick.
- A button with no Id to pass is left off, so a reader never opens an empty window.
- An edit window closes once Save succeeds.
- The buttons work in the Form Builder's preview.

## What changes on existing pages and forms

Nothing. Existing block types and section types render and are edited as before.

See [Record Cards](../form-configuration/record-cards.md).
