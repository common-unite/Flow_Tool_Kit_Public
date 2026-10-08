# Form Styles - upcoming release

This feature is prepared for the next release; it is not assigned a package version yet.

## Shared styles and template refinements

Set the look of every form in **Form Builder → Global Styles**, then make one template different in the **Style Editor** tab on its Form Template record. The saved org defaults also apply to Form (Component), Form (Repeater), Form (Table), Form (Header), Form (Illustration) and Form (Calendar/Scheduler) placed directly on a Flow screen.

Start with **Basics** for shared sizes, text size and font, spacing, colors and borders. **Advanced** refines individual controls without replacing Basics: button text size, input placeholders, heading padding and other common details. New Advanced sizes use rem; units already saved are kept.

Stacked headers have optional text-size and spacing refinements. Section frames use shared border, corner, spacing and shadow controls, with an additional frame background setting. Record Picker lookups join the existing input styling paths.

In Global Styles, **Save org defaults**, **Cancel** and **Reset org defaults** sit in the bar at the bottom of Form Builder. On a template there is no Save: the Style Editor saves about two seconds after your last change, and **Reset to org defaults** clears the template's styles. Clearing one setting makes it inherit again. Explicit Classic Theme properties retain priority; unrelated properties continue following the style editor. The packaged Form Default theme is the exception: a saved style wins over it, so Brand, Field labels and the section frame controls work on templates that were never themed. Components inside a template inherit that template's overrides, and builder components follow the live preview.

## Move defaults between organizations

Saved styles are data, so a change set or package deployment does not carry them. **Export**, in both editors, copies the saved styles as JSON to the clipboard. **Import** accepts pasted JSON and replaces what that editor holds: Global Styles previews it until you select Save org defaults or Cancel, and a template saves it by itself. Units and inheritance are preserved. Invalid settings are rejected, and if the clipboard is blocked the JSON is shown for you to copy.

## Existing CSS and developer tools

Custom-metadata stylesheet mappings and template-assigned Static Resources remain supported. A generated reference and downloadable CSV/JSON describe all 156 public CSS tokens, and show where each one sits in the style editor. See [Form Styles](../form-configuration/form-styles.md), the [token reference](../form-configuration/style-token-reference.md) and [stylesheet setup](../form-configuration/custom-styling-overview.md).

## What changes on existing forms

A form with no Form Styles saved renders as it did before, with these exceptions:

- **A Classic Theme's brand color reaches further.** It used to color buttons. It now also colors icon buttons (repeater add and delete, date and number steppers, the attestation add button), checked checkboxes, focus rings and slider thumbs, which were Salesforce blue. Set **Brand** in Global Styles or on a template to choose a different color for these.
- **Button-style picklists adapt to narrow columns.** An optional button group is drawn by Flow Tool Kit so its selection can be cleared, and any button group switches to separate buttons when its options no longer fit on one row. It looks the same as before when the options fit.
- **Selected survey and visual choices use a solid tint.** The selected fill used to be translucent, so a colored section background showed through it.
- **Field error messages sit under the field.** "Complete this field." used to be 8px text inside the field's lower right corner, hidden while the field had focus. It is now a 12px line under the field that stays visible while you type, so it can follow Input size and Text size. A field in error is about 20px taller than before. Toasts and the red border and icon are unchanged.

## Rollout and current limits

- **Who can save the org defaults:** an administrator with the **Form Style Defaults Manager** permission set and the **Customize Application** permission. The permission set shows the Global Styles tab; Customize Application is what allows the save, the same permission Form Builder needs to save a form.
- **Who can style a template:** anyone who can edit the template and its **Style Overrides** field, which **Form Builder (Administrator)** and **Form Builder (Manager)** include.
- Check a few typical templates and Flow screens before you save org defaults. A Classic Theme you created, or a stylesheet, can take priority on purpose.
- Custom-metadata sheets remain page-level CSS and need explicit selector scoping. Declare tokens under `:root` there; they reach every Flow Tool Kit component on the page. Template-assigned stylesheet selectors are scoped automatically.
- **Error color** now colors field error borders, icons and messages and the required mark, not only the attestation card.
- Some native Salesforce controls need activation classes generated by saved editor tokens. CSS-only declarations do not create these classes; the token reference identifies affected tokens and alternatives.
- The editor does not parse developer CSS or display its computed values. Unsaved previews stay within the current page; reload other open pages after saving.
- PDF rendering and native Salesforce dialogs/toolbars are not a promise of pixel-identical browser styling. Verify any specialized host separately.
- On an LWR site, **Joined button corners** and **Rich text corners** keep the site's 4px corners. The LWR site stylesheet fixes those two values, so no style setting reaches them. Font, Error color, Brand and every other setting apply there as on other hosts.
- A Flow on an LWR page needs the **FlowToolKit LWR Support** component in the site footer or on the same page, or its Calendar, Repeater and Table components do not load.

Template stylesheet assignment and Classic Theme configuration remain available.
