# Release 4.41

Faster conditional logic on Form Templates, Section Frames with four header styles, and fixes for guest form loads, Flow Transform picklists and the Stripe payment step.

## Form Templates

- **Conditional logic is fast again** (#687). One toggle on a large template used to trigger hundreds of channel messages and full rule passes across every section. Sections now announce only real value changes, the template pushes only real differences, and each form applies only what moved. Input-to-visible on the reference template dropped from 1.1 to 2.3 seconds to 0.5 to 0.85 seconds. What a form shows, keeps, clears and saves is unchanged: every scenario was captured before and after and compared field by field. Custom components listening on the `Flow_Form__c` channel still receive every real change, clear and restore; only exact repeats of an unchanged value are no longer re-broadcast on every render.
- **A hidden field inside a Repeater row comes back with its last value** when its rule shows it again. Before, it came back blank.
- **An address section without an Address-type field no longer breaks the form** (#713). Validation used to throw on it; it is now skipped.
- **Section Frames** (#693, #694, #695, #697, #698, #700, #701, #702 to #708). Section Class, Header Style and Header Display were three unrelated fields for one idea. They are now one concept, shared by component sections and page sections: a **Section Frame** (none, Box, Shadow) and a **Header Style** (Classic, Classic Spread, Card, Title on border). The Section Frame group sits first on the section editor's Content tab with a visual picker. Frames reach outward so fields inside a Box or Shadow sit on the same edge as a standard Flow input, repeaters and tables included; blank Padding Horizontal now means none. Title on border keeps the drop shadow, the icon rides the border without painting over a tinted background, a theme's section background fills only framed sections, and a plain divider on a framed page section renders as a divider. Page sections gain `Section_Frame__c` and `Header_Style__c`, both granted in every permission set. Divider Style, Header Divider Style, Header Style and Section Theme are now unrestricted picklists, so a new value we ship saves in an upgraded org even before the picklist definition catches up.

## Payment step

- **Resuming a Pending Payment submission reads the real amount** (#716). Reopening one on its record page showed "Amount is too small" although the record's Stripe Amount was fine. The Stripe Connector clears the record it was mounted with when it connects, and the resume path was the one place nothing pushed the record back before the amount check. The payment step now hands the Stripe form its record again right before revealing it. Works with the connector already installed; the connector's own fix ships with its next release.
- **Payment Unavailable illustration when the Stripe form cannot boot** (#715). When the Stripe feature is not licensed for the org or its keys are missing, the Form Template takes over the surface and shows its Payment Unavailable illustration with the reason, instead of a raw load error and a toast. Needs Stripe Connector Accelerator 0.69 or later; with an older connector the connector's own error still shows.

## Guest and Flow fixes

- **Guest form loads with a subscriber field twin** (#699). Guest visitors got "Form Load Error" when a subscriber field shared its API name with a packaged Flow Tool Kit field. The field dictionary now resolves fields by durable id with no relationship traversal, runs in user mode, and rebuilds in 85 ms instead of 1,153 ms in the reference org.
- **Flow Transform picklist values reach every record action** (#712). A Transform element hands picklist and multi-select picklist values to Apex as Flow types. Strip Null Values silently dropped multi-select values, and the other record-taking actions could corrupt or reject them. Every invocable that takes a record now converts those values before touching the record. Proven on an autolaunched flow.

## After upgrading

Open each public form page once after the upgrade, so the first-load compile happens for you rather than a visitor.
