# Release 4.15

4.15 is a large release. It carries everything from 4.14 plus the fix that made 4.14 installable, and **supersedes 4.14.0.1 entirely** - see the note at the top of the fix section. The bulk of it is a single sustained pass over the **Site Design Block** property editor, driven by a long run of design review, plus a set of form runtime and Form Builder fixes.

If you read only one section, read **[What will look different after upgrading](#what-will-look-different-after-upgrading)** at the end.


---

## 🚑 Why this is 4.15 and not 4.14 (#514)

**4.14.0.1 was promoted but could not be installed** as an upgrade over 4.13.0.2:

```
LightningComponentBundle(formSectionTheme): You can't remove the following public
properties: dividerStyleName, dividerIconName, because the component is part of a
managed package.
```

Consolidating divider rendering through `c-header` (#451) dropped two `@api` properties from `formSectionTheme`. A managed package can never remove a public property, whether or not anything still reads it, because a subscriber's stored component configuration may reference it. The package builds cleanly either way; only the *install* fails, which is why it reached promotion.

Both properties are restored in 4.15. They are unread by the component and exist purely so the upgrade path stays intact.

**Verified, not assumed:** an org running 4.13.0.2 was upgraded to 4.15.0.2 successfully, which is the exact transition that failed on 4.14.0.1.

**If you are on 4.13.0.2 or earlier, upgrade straight to 4.15.0.2.** 4.14.0.1 cannot be installed and cannot be withdrawn, because a promoted managed package version is permanent.


## 🧭 Site Design Block: every control now owns exactly one thing

Roughly sixty of this release's issues share one root cause. A control in the block property editor would sit in one accordion while steering something in another, or paint far more of the block than its name suggested. Body Alignment on a Callout moved the supporting points two sections away. Text Color repainted the heading. Heading Color painted card titles and never the heading.

The editor now follows one rule throughout: **a control lives in the accordion of the thing it steers, and steers only that.**

- **The Body section only appears when a block genuinely has body content.** Six block types no longer show it at all, because for them it held nothing but controls belonging elsewhere.
- **Alignment moved to what it aligns.** Pricing tiers, tag cloud pills, callout supporting points and stats each carry their own alignment where you configure them.
- **Colour controls are named after the part they paint**, taken from that block type's own field labels. A Callout now reads *Statement Color* and *Eyebrow Color*, because that is what those fields are called. A Timeline reads *Detail Color* and *Title Color*.
- **Composite modules gained their own part colours.** Callout supporting points, steps, showcase bullets and card items each offer Title and Description colours, so you set a default once instead of colouring every item's rich text by hand.
- **Showcase has three independent modules** (its body copy, its bullets, its inline stats) and each now has its own colour pair rather than sharing one.

### Also in the block

- **Hero media selector** now hosts **Stats, Timeline and Quote** alongside Image and Facts, so a hero can lead with a highlight module instead of a picture.
- **Showcase item cards** gained real Card Style options in Cards mode.
- **Gradient opacity now means tint strength.** Dropping a gradient stop to 5% gives a pale wash of that colour rather than switching the gradient off.
- **Split layouts read as one block.** The heading, its body copy and its buttons move together, and Vertical Alignment positions the pair.
- **Buttons centre their own labels**, which is visible on any full-width button such as a pricing tier call to action.
- **Footnotes behave like footers everywhere:** full width, at the bottom, in every block type.

A build-time check now guards the class of defect behind many of these fixes, so a control that silently paints nothing fails the build rather than reaching a release.

---

## 🐛 Form runtime and Form Builder

- **Conditional logic no longer destroys a value it should keep (#438).** A field referenced by one rule and hidden by another could loop and lose its value. A field's value is now cleared only when no visible rendering of it remains anywhere on screen.
- **Related-record forms work and are documented (#439, #440).** *Use Related Field Form* had been half-built since 2023, and the documented field format was the one that could not work. It now resolves a related record more than one lookup away.
- **Guest users can load Form Templates again (#427).** The query selected every custom field on the prefill relationship, including subscriber-added ones the guest could not see.
- **Prefill is more forgiving (#424, #430).** One malformed URL parameter no longer kills all prefill, and a source record can override the template's prefill flow through the new **Prefill Flow Field**.
- **Form Builder saves no longer die in the deploy callback (#431)** when assigning a theme by name.
- **Back navigation works in Linear mode (#408).**
- **Form Builder no longer leaks internal record Ids** as hover tooltips (#464).
- **Button 1 gains `buttonLabel` (#460)**, because Flow Builder claims `label` as the component name. Existing buttons migrate automatically.

---

## 🎨 Header Display as Divider (#451)

Any section header can now render in the divider visual language, with the selected icon and a Centered Icon variant that splits the title above the rule. This works end to end across template page sections.

---

## ⚡ Performance and caching

- **Screen flow warming (#410, #405).** The warm-up batch no longer emails anyone, and the two-tier warming model is documented for subscriber-built flows.
- **Cache documentation corrected (#425).** Three pages told admins to clear the form cache by visiting `/apex/FlowToolKit__CacheFlow`, which clears nothing. The real reset is **Reset Form Cache** in the Form Builder.

---

---

## 🆕 Radio Buttons (Separated), and the first button-style display type for multi-select (#456)

**Picklist Display Type** gains **Radio Buttons (Separated)**, sitting directly beneath the existing **Radio Buttons**. Where Radio Buttons renders one connected segmented bar, the separated variant renders each option as its own button with a gap between them, wrapping onto further rows when they do not fit.

It is offered on **picklist and multi-select picklist alike**. That is worth calling out: until now the multi-select list offered checkboxes, badges, a combobox and a visual picker, but **no button-style option at all**. On a multi-select the buttons toggle, so several can be lit at once; on a single-select picking one clears the rest.

### They are SLDS buttons, deliberately

The buttons are `slds-button` and `slds-button_neutral`, switching to `slds-button_brand` when selected. Nothing about their appearance is defined locally, which has three consequences worth knowing:

- They match every other button in your form, in whichever SLDS version your org is on. On SLDS 2 they pick up SLDS 2's button radius automatically.
- Your brand colour reaches the selected state without configuration.
- If you restyle `.slds-button` in a custom stylesheet, these restyle with it. There is one place to change how they all look.

### Picklist Columns gains "Grow"

**Column(s) Size** gains a **Grow** option. Selecting it grows each button to fill the field width evenly, dividing the row by the number of options rather than by label length, so a 0-10 scale comes out as eleven equal buttons rather than a ragged row. No button ever shrinks below the width of its own label.

Grow is for a **single row**. If the options cannot fit on one line, the buttons fall back to their natural width and pack to the left rather than stretching across several rows. That decision is made by measurement and re-checked as the form resizes, so it stays correct at any width and on any device.

Grow is exempt from the mobile column collapse that forces other column settings to two columns on a phone, because adapting to the available width is the whole point of it.

### Notes

- The existing **Radio Buttons** type is unchanged. Forms already using it render exactly as before.
- Column sizing, centre alignment, required, read-only and disabled all behave as they do for the other display types.
- Not offered for checkbox/boolean fields; Yes/No display types are unchanged.
- Long option labels wrap inside their button rather than pushing the column open, so full survey statements work as options.

## 🆕 Prepend and Append now read as captions (#457)

**Prepend** and **Append** render smaller and in a lighter tone, so they read as captions beneath a field rather than competing with the field's own label.

The scale question is the case that shows why. With `0 - Not Likely` on the left and `10 - Very Likely` on the right, those two captions previously rendered at exactly the same size and colour as the question label above them, so the eye had three labels of equal weight and no hierarchy. They are now clearly subordinate.

Caption rows sitting under a button bar also gained consistent spacing, so **Radio Buttons** and **Radio Buttons (Separated)** now clear their captions by the same amount. Previously the connected variant sat flush against them.

### Notes

- **This affects every existing form that uses Prepend or Append**, not only the new display type. Nothing needs reconfiguring, but the appearance changes.
- Captions deliberately no longer follow the theme's **Label Color**. A caption that tracked the label colour was the thing being corrected, so they now stay in the neutral caption tone whatever the theme sets for labels.
- Rich text in Prepend and Append still renders.

## 🐛 Form Builder no longer shows internal Ids on hover (#464)

Hovering a settings group heading inside a field editor in the Form Builder raised a browser tooltip containing a raw Salesforce identifier such as `01IO200000Habve.00NO200000kNqYY`. Eleven layout wrappers carried a tooltip built from the field's stored identifier, and because a tooltip on a wrapper is inherited by everything inside it, the identifier surfaced over headings that had no tooltip of their own.

Those tooltips were decoration and have been removed rather than relabelled. The group headings are already visible text and every control inside carries its own label, so nothing is lost.

The **Read Only** and **Required** toggles keep their tooltips. Those controls render without a visible label, so their tooltip is what names them for screen readers and on hover.

## 🐛 Wipe Reveal no longer clips content in the corners (#465)

On a Site Design Block using the **Wipe Reveal** entrance, content sitting flush in the top-left corner of its row was clipped for the duration of the animation. It was most obvious on a vertical **Timeline**, where each milestone's circular marker sits exactly in that corner and appeared cut in half as the block revealed.

The reveal was rounding the corners of its own clipping shape at a fixed radius, which cut into anything positioned against that corner. The reveal is now square-cornered, which is invisible on cards, since a card paints its own rounded corners regardless, and leaves corner-anchored content whole.

Blocks affected were Timeline in both orientations, Facts rows and Quote rows. Cards, stats, pricing and showcase blocks look exactly as before.

---

## ⚠️ What will look different after upgrading

Most of this release is invisible until you open the editor. These are the exceptions, and they affect blocks and forms you have already built.

| Change | What to expect |
|---|---|
| **Text Color scope** (#496, #509) | Text Color no longer repaints headings. If you were relying on it to colour a heading, set **Heading Color** instead. |
| **Body sections removed** (#502) | Six block types no longer show a Body accordion. Nothing you configured is lost; the controls moved or were never doing anything. |
| **Arrangement removed from Showcase and Pricing** (#489, #498) | A stored block set to *Split* on those two types renders stacked. Showcase keeps two columns via Media Side and Column Ratio. |
| **Call to Action is being retired** (#506) | It no longer appears when choosing a block type. **Every CTA block you have already placed keeps working and rendering exactly as before.** Use Hero for new work. |
| **Prepend and Append captions** (#457) | These now render smaller and lighter on **every existing form** that uses them, so they read as captions rather than competing with the field label. |
| **Gradient opacity** (#500) | A stop below 100% now tints rather than fades out. Gradients configured at low opacity will be more visible than before. |
| **Conditional field clearing** (#438) | A hidden field's value now survives when another visible rendering of the same field is still on screen. |
