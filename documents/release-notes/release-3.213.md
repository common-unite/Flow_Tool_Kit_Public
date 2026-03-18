# Flow Tool Kit v3.213 Release Notes

## New Features

### LWC Section Type — Custom Lightning Web Component Sections (#83)

Admins can now embed any custom Lightning Web Component inside a form section. This opens the door to advanced use cases that go beyond standard field inputs — map pickers, signature pads, custom calculators, third-party widgets, and more.

**How it works:**
1. Add a **Lightning Web Component** section in Form Builder
2. Enter the fully qualified component name (e.g., `c:myCustomWidget`)
3. The component renders live in the builder preview and at runtime in Flows

**Data flow:**
- The form passes the current `record` object to your LWC on every field change
- Your LWC dispatches `formfieldchange` events to write values back to the form
- Validation is supported — expose a `@api validate()` method and the form calls it on navigation

**Key details:**
- Works in Form Builder preview, Flow runtime, and all display modes (default, review, tabset)
- Supports all standard section options: conditional logic, themes, padding/margin, accordion, responsive width
- Graceful error handling when the component name is invalid or missing
- Review mode passes `review=true` so the LWC can disable editing

**Prerequisite:** Lightning Web Security (LWS) must be enabled in the org. This is a one-time setting in Setup > Session Settings.

**Documentation:** [LWC Section Type Guide](../advanced-topics/lwc-section-type.md)
