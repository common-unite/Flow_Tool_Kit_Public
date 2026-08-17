# Release 4.20

Extensibility on the Form Template, a Save button that stays out of the way, and a design-block polish pass.

## Inject your own settings into the Form Template

- **Custom settings and business process configuration** (#572): the Form Template Settings and Data Conversion Settings tabs are components we ship and replace on every upgrade, which left nowhere to put an organization's own settings. Both tabs now end with a section deliberately left empty for you, backed by an unprotected form record you are free to fill. Add a field to Form Template, drop it into `Form Template Settings (Custom)` or `Form Template Conversion Rules (Custom)` in Form Builder, and it renders on the tab alongside ours. Because the field lives on the Form Template record, record-triggered Flows, validation rules, and overridable conversion Flows can all branch on it. Flow Tool Kit never writes to those two records, so your fields survive upgrades. See [Inject Custom Settings](../form-template-framework/how-to/inject-custom-settings.md).

## Behavior changes

Two changes alter how existing forms behave after upgrading. Neither needs configuration, but both are worth knowing before you upgrade.

- **Save appears only after a change** (#571): on a form editing an existing record, the Save button now stays hidden until at least one field actually differs from what loaded, and hides again if you put a value back. Clicking Save with nothing changed was already doing nothing (it wrote no data and showed no confirmation), so this removes a button that could not act rather than removing an action. Create forms are unaffected and always show Save. This also cleans up forms that host a Form Template, where the outer Save button was never relevant.
- **Rich text inputs reveal their toolbar only while editing** (#551, #553): every rich text input across the product now shows its formatting toolbar when the field has focus rather than permanently. Forms with several rich text fields read considerably quieter at rest. The format picker also groups controls by family (Lists, Indent, Align) instead of listing every button.

## Design blocks

A polish pass driven by four rounds of review on the block library.

- **Readable text on dark and photographic backgrounds** (#560): dark sections handed the raw brand accent to eyebrows, footnotes, ghost buttons, and badges, which failed contrast against navy and photos with a mid-tone brand color. Dark sections now lift the accent while keeping its hue. Bullet cards on dark backgrounds no longer render white text on a white card, and photo backgrounds outside heroes always take a full veil so copy stays legible edge to edge.
- **One spacing rhythm for every block** (#561, #567): gaps between a block's parts were set independently, so stats sat noticeably further from the heading than buttons did. Every part-to-part gap now reads a single value, and organizations can loosen the whole rhythm from one design token. Bullets and cards were the worst offenders, sitting hard against the buttons below them and adrift from the paragraph above.
- **Images fill their space** (#562): a landscape photo beside a tall column used to letterbox, leaving empty bands. A new **Image Fit** control defaults to Fill, cropping the photo into the space, with Fit available when the whole image must stay visible. Cut-out artwork keeps the whole image automatically. Vertical Alignment now genuinely selects which part of a photo survives the crop.
- **Timeline connectors join up again** (#563, #570): the connecting rail between vertical timeline markers had broken into disconnected stubs, and milestones with no detail line collapsed to half height. Both are fixed, and timeline spacing is tighter.
- **Stat rows hold still and fill their width** (#568): a counting number is narrower mid-count than where it lands, so an animated stat row used to shift on every frame. Columns are now equal width, which also stops four short stats bunching to one side. Inline stats accept five entries instead of four.
- **Property editor tidy-up** (#564, #569): overlay image controls no longer appear when the block's media is not an image, hero media choices are trimmed to the three that render well, and Count Up moved to sit with the stats it applies to.

## Upgrade note

Admins: load your public form pages once after upgrading. The first visit pays the component compile so a real visitor does not.
