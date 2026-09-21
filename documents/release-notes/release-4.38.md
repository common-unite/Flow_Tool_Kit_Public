# Release 4.38

A redesigned Form Builder, a new Outlined section header, payment that can depend on the answers, and a set of layout fixes. Existing forms, templates, flows and settings keep working as before.

## New: Outlined section header (#690)

Sections have a new **Header Style** setting next to Divider Style. **Classic** is the header you already have. **Outlined** draws a border all the way round the section in the theme's border color, width and radius, and puts the section title on the top line, the way a labelled box looks on a paper form. The subtitle and help text sit inside the box, and the title lines up with the first field.

- Section editor → **Content** → Section Header **Header** → **Header Style: Outlined**.
- Blank means Classic, so existing sections are unchanged.
- Outlined sections show no icon.
- The border width comes from the theme's **Border Size**, with 1px when it is blank or 0.

## New: Conditional payment for Form Templates

A Form Template can now require payment only when a response matches conditions, for example when Amount is above zero and Fee Waived is not checked. Set it up in **Form Template Settings → Payment Settings → Require payment when…**. Templates without conditions behave as before: Payment Required means payment is always required. Matching responses save as **Pending Payment** and continue to the payment step; other responses submit normally. Invalid or unreadable rules block submission rather than waiving payment. Collecting payment still needs a configured Stripe Connector Accelerator.

Custom runtime or guest permission sets need read access to **Payment Conditions** and to each field a rule uses.

## Form Builder redesign (#677)

The authoring panel is flatter and works from the preview:

- A **section tree** lists sections and fields with their types; add, move, edit, clone and delete from the row.
- **Live editing in the preview**: hover a field or section to outline it and get its actions (Required, Read Only, Edit, Move, Remove or Delete), drag its right edge to set its width for the preview size shown, copy a field's API name or merge field, and use **Add fields** under a section.
- The field editor is grouped into **Field**, **Layout** and **Labels** tabs; the section editor keeps its own tabs.
- Header, Divider, Accordion and Hide are one choice for each section.
- Full keyboard support in the tree and the insert menu.
- Builder text moved to custom labels for translation (#684).

## Fixes

- **Error text no longer pushes fields down** (#689): fields in a row now align to the top, so a required-field message, or the builder's hover caption, only moves what is below it.
- **Hover keeps working after deleting a section in the builder** (#689).
- **An address section alone on a row fills the full width** in the builder preview (#680).
- **Strikethrough removed from rich text options** (#681).
- **Divider sections no longer sit inset from headers** when Padding Horizontal is blank (#682).
- **No extra gap between stacked sections without a visible header** (#683).

## After upgrading

Open each public form page once after the upgrade: the first load after an install compiles the form components, and it is better that you wait for it than a visitor.
