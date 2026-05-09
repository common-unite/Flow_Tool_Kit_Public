# Flow Tool Kit v3.229 Release Notes

## Bug Fixes

### Form Template Scrolls to Top on Page Navigation

When a respondent clicks **Next**, **Back**, or a stage indicator on a multi-page form template, the form now scrolls to the top of the new page automatically. Previously the browser scroll position stayed wherever the user left it, so on long pages users would land in the middle of the next page instead of seeing it from the top.

**Root cause.** `formTemplate` swaps page content in place via `setCurrentPage()` — the DOM updates, but no scroll reset happens. All navigation paths (Next/Back buttons, stage indicator clicks, conditional-logic-forced page changes, and the Flow attribute echo path) share this method.

**Fix.** A `_scrollFormToTop()` helper queries the form's outer `.FlowToolKit-form-template` container and calls `scrollIntoView({block:'start', behavior:'smooth'})` inside `requestAnimationFrame` so the scroll happens after the new page lays out. It runs at the end of `setCurrentPage()` guarded by the `rendered` flag, so the initial page load is unaffected.

**Affected components:**
- `formTemplate` LWC — adds the `_scrollFormToTop()` helper invoked from `setCurrentPage()`

**Note for iframe embeds.** When the form is embedded via the iframe snippet, the iframe auto-sizes to its content and the *parent* page is what scrolls. A cross-origin iframe cannot scroll its parent, so this fix does not apply to iframe embeds. If you embed forms via iframe and want the parent page to scroll on page navigation, please open an issue and we'll add a `postMessage`-based handshake to the embed snippet.

### Encrypted (and Non-Custom Lookup) Fields Are Now Keyboard-Tabbable

Keyboard users can now tab into encrypted fields and start typing. Previously, tabbing to an encrypted field appeared to focus the field but typing did nothing — focus was actually trapped on a wrapper `<div>`, never reaching the underlying input. The same issue affected reference (lookup) fields when **Enable Custom Lookup** was off.

**Root cause.** The `flowFormField` template wraps its slot (containing `lightning-record-field` / `lightning-input-field` / read-only `lightning-input`) in a `<div>` with hardcoded `tabindex=0`. That wrapper was originally added so **custom lookup** fields would auto-open the search picker on focus. Release 3.227 routed encrypted fields through this same `isInputField` slot path so they'd render via `lightning-input-field` and inherit Salesforce's native masking — but the wrapper's `tabindex=0` meant the wrapper itself became the next tab stop, blocking focus from reaching the inner input.

**Fix.** The wrapper's `tabindex` is now bound to a new `inputWrapperTabindex` getter that returns `'0'` only when `displayCustomLookup` is true (preserving the auto-open-picker behavior) and `'-1'` otherwise. Encrypted fields, regular lookups, and override-picklist cases now let focus pass through to the actual underlying input.

**Affected components:**
- `flowFormField` LWC — new `inputWrapperTabindex` getter; wrapper `<div>` binds `tabindex` to it instead of hardcoding `0`
