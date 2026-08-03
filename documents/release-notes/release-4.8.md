# Release 4.8

## 🆕 Override New and Edit with a Form Component (#348)

You can now replace the standard **New** and **Edit** actions on an object with a Form Component. Nominate the form per object using the **Default Override Form** setting, and Salesforce will open your form instead of the standard record page layout wherever those actions appear.

The Default Override control is a stateful button, so at a glance you can see which object currently has an override in place. See the admin guide in the documentation for setup.

## 🆕 Design Blocks repeat an item per multiselect value (#349)

A Design Block item bound to a multiselect picklist merge field now renders **one copy per selected value** instead of a single item containing a comma-joined string. Selecting three values produces three items.

## 🛠 Style Sheet selector no longer runs out of heap (#339)

Opening the Style Sheet selector could fail outright with "Apex heap size too large". Every zip static resource in the org was being loaded into heap at once just to work out which ones were stylesheets. The selector now offers `text/css` static resources only, and inspects them without pulling every zip into memory.

## 🛠 Style Sheet selector reads only our own bundle (#350)

The selector was matching packaged resources by name, which meant it could pick up, or trip over, static resources belonging to other packages. It now scopes by namespace, so it reads the Flow Tool Kit bundle and leaves everyone else's resources alone. The packaged `formOverrideStyles.css` is no longer offered as a selectable stylesheet, since it is the framework's own override layer rather than something you choose.

## 🛠 A failing override flow no longer retries to the loop-guard cap (#347)

If an overridable conversion flow threw, the dispatcher's `flowInterview.start()` call was unguarded, so the failure turned into a retry storm that ran all the way to the loop-guard cap before stopping. The call is now guarded: a failing override flow logs once and stops.

## 🛠 A blank Mode no longer silently discards your log row (#346)

On the Convert and Log Event actions, leaving **Mode** blank nulled the Apex default rather than falling back to it. The result was a Log action that wrote no log row at all and published a spurious controller event on the way out. A blank Mode now resolves to the intended default.

This is a specific case of a wider Flow behaviour: an `@InvocableVariable` initializer only survives when Flow omits the parameter entirely, not when it passes it as blank.

## 🛠 Source Mapping editor fixes (#340, #343, #345)

Three fixes to the Source Mapping modal:

- The edit row's **target picker was empty**, and confirming an edit wrote a malformed source path
- Read-only fields on the **Values** tab rendered their value flush against the field border, and displayed a required asterisk they could never satisfy
- Hover flicker and sizing were corrected, mappings became editable in place, and a **Values** tab was added for editing source records directly

## 🎨 Design Block visual fixes (#341, #342, #344)

- Background layer order corrected, and overlap now behaves consistently across block types
- Hero image swap and edge-aligned headings
- Card cover images no longer overlap the eyebrow text, and cards line up with one another again
- In the editor, **Footer Note** no longer sits between the two media fields, so toggling **Icon Source** stops making the panel jump

Edge alignment now genuinely reaches the edge, and a joined grid has no internal rounding.
