# Flow Tool Kit v3.215: Lightning Out Fix and Address Field Improvements

We're releasing Flow Tool Kit v3.215 with a critical fix for Lightning Out (Beta) guest user forms and improvements to the address field configuration in Form Builder.

## Highlights

This release resolves a **breaking issue** where forms embedded on external sites via Lightning Out would fail to render for guest users. We also improved how address sections discover available fields, fixing gaps where standard address-like fields (e.g., `Street`, `City` on NPC objects) weren't appearing in the field pickers.

## Bug Fixes

### Lightning Out: Guest User Proxy Errors (#91) — Critical

Forms embedded on external sites via Lightning Out (Beta) were completely broken for guest users. The browser console showed `getOwnPropertyDescriptor` proxy trap errors, and form fields failed to render.

**Root cause:** When `objectInfo` is passed from parent to child components via `@api`, Salesforce's Locker Service wraps it in a double-proxy (Locker's SecureObject proxy on top of LWC's reactive membrane proxy). This violates JavaScript Proxy spec invariants — the outer proxy reports properties as non-configurable, but they don't exist on the proxy's actual target object. The engine throws a TypeError.

**Fix:** Child components now wire `getObjectInfo` directly via Lightning Data Service instead of receiving the proxied object from parents. LDS caches the result globally, so all field components sharing the same object resolve from a single cached response — zero additional network calls. All `object-info=` template bindings have been removed across the codebase.

This fix was applied to 17 LWC files across 6 child components and 11 parent templates.

**Note:** Salesforce's own `lightning-record-edit-form` has the same proxy bug internally (`recordEditUtils.js` → `filterByPicklistsInForm`). This produces a harmless console error but does not affect form rendering or functionality. We reproduced this independently using a minimal component with only standard Salesforce components — no Flow Tool Kit code involved. This is a Salesforce platform bug in Lightning Out (Beta) + Locker Service.

### Address Section Freeze (#87)

Adding an address section to custom objects (like `Form_Submission__c`) caused the Form Builder window to freeze. This was caused by stale default address field variables (`defaultStreetField`, `defaultCityField`, etc.) that weren't being reset when switching between objects or sections.

**Fix:** Default address field variables are now reset at the start of `setFieldOptions()`, preventing stale references from blocking the UI.

## Enhancements

### Address Field Name-Based Matching (#87)

Address field pickers in Form Builder previously only showed fields based on their Salesforce field type. Standard text fields that function as address components (e.g., `Street`, `City`, `PersonMailingStreet` on NPC objects) were filtered out.

Field pickers now also match by API name — if a field's API name contains `Street`, `City`, `State`, `PostalCode`, or `Country`, it appears in the corresponding address field picker regardless of its declared type. This supports both standard compound address fields and custom text-based address patterns used in Nonprofit Cloud and other industry packages.

### Form Component Editor Packaging

The `formComponentEditor` component is now marked as `isExposed=true` in its metadata, allowing it to be used in Lightning App Builder pages in subscriber orgs.

## Known Limitations

### Lightning Out + Locker Service

Salesforce's `lightning-record-edit-form` produces a console error (`getOwnPropertyDescriptor` proxy trap on `AccountNumber` or `Address`) in Lightning Out for guest users. This is a Salesforce platform bug — the error is inside their compiled code and does not affect form functionality. Enabling **Lightning Web Security** (Setup → Session Settings) eliminates this class of proxy error entirely.

## Upgrade Notes

This release modifies 17 LWC files. No Apex changes, no metadata changes, no permission set changes. The upgrade is fully backwards compatible — the `@api objectInfo` property is preserved as a getter/setter on all modified components for backwards compatibility with any custom extensions that pass it.

---

*Flow Tool Kit v3.215 — March 2026*
