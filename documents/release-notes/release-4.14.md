# Release 4.14

> **Withdrawn. Do not install 4.14.0.1.** It was promoted but cannot be installed over 4.13.0.2:
> `formSectionTheme` had two `@api` properties removed, and a managed package may never drop a public
> property (#514). A promoted 2GP version cannot be deleted, so it remains in the package's version
> list; its GitHub release pages are hidden.
>
> **Everything below shipped in [4.15](release-4.15.md)**, along with the fix. Upgrade straight to 4.15.0.2.

> This note currently covers four of the issues in 4.14. The remaining slate (#405, #410, #427, #429, #430, #431, #432-#437, #438, #439, #440, #450, #451, #460, #467) is still to be written up.

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
