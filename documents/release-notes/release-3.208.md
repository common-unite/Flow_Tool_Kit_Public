# Flow Tool Kit v3.208: Spacing Controls for Every Component

We're excited to release Flow Tool Kit v3.208! This release is all about giving admins fine-grained layout control across every visible Flow screen component.

## Highlights

If you've ever built a multi-step flow with several Flow Tool Kit components on a single screen, you know that getting the spacing *just right* between components can be tricky. Previously, only Form, Data Table, and Form Repeater offered Top and Bottom Margin properties. With v3.208, **every visible Flow Tool Kit component** now has consistent margin controls — so you can dial in your layout without custom CSS or workarounds.

## Enhancements

### Consistent Margin Controls Across All Components

Nine additional components now support **Top Margin** and **Bottom Margin** properties:

- **Form (Header)** — previously only had Top Margin, now includes Bottom Margin too
- **Form (Buttons)**
- **Form (Calendar/Scheduler)**
- **Form (Merge Records)**
- **Form (Image)**
- **Form (Field Set)**
- **Form (Template)**
- **Form (Stage Indicator)**
- **Form (Illustration)**

Each property offers the full range of SLDS spacing sizes — from None up to xx-large — matching the same options already available on Form, Data Table, and Form Repeater. When no margin is configured, components default to **None**, so existing flows are unaffected.

For components with Custom Property Editors (Header, Buttons, Calendar/Scheduler, Merge Records, Image), you'll see side-by-side Top and Bottom Margin dropdowns right in the configuration panel. For components without CPEs (Field Set, Template, Stage Indicator, Illustration), the margin dropdowns appear in the standard Flow Builder property panel.

<!-- Screenshot placeholder: Side-by-side margin dropdowns in a CPE -->

### Calendar/Scheduler: Data Source Help Text

New to the Calendar/Scheduler component? The **Data Source** toggle now includes inline help text explaining the two modes:

- **Record Mode** — Display dates and times from an existing record collection
- **Schedule Mode** — Generate available time slots from a configured date range and days of the week

This small addition makes it easier for admins configuring the component for the first time to understand which mode fits their use case.

<!-- Screenshot placeholder: Data Source toggle with help text tooltip -->

## What's Next

We're planning a follow-up pass to standardize the placement and grouping of margin controls within each component's property editor for an even more polished admin experience. Stay tuned!

---

*Flow Tool Kit v3.208 is available now on the AppExchange.*
