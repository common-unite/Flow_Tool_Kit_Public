# Flow Tool Kit v3.211 Release Notes

## New Features

### Form Template Page Conditional Logic (#68)
Admins can now conditionally show or hide entire Form Template pages based on field values on the Form Submission record. Rules are configured per page using a new SLDS Expression-style LWC on the Form Template Page record page. Supports Show When / Hide When modes with AND, OR, and CUSTOM condition types.

- Conditions evaluate on initial load and on every record change (300ms debounce)
- When a page is hidden, field values reset to prefill defaults and restore when the page reappears
- Navigation, stage indicators, and Flow outputs adjust automatically
- The current page is never hidden while the user is on it — changes are deferred until navigation

![Page Conditional Logic](https://raw.githubusercontent.com/common-unite/Flow_Tool_Kit_Public/main/documents/screenshots/68-page-conditional-logic.png)

### Carousel Finish Button (#45)
The carousel form type now displays a configurable finish button on the final section. Previously, users reaching the last carousel section had no action button — they had to rely on a separate Custom Buttons component.

- Button label, variant, icon, and action type configurable in Form Builder
- Supports NEXT, FINISH, TRIGGER (message channel), and SAVE (lightningRecordEditForm) actions
- Full-form validation runs across all carousel sections before executing the action
- On validation failure, the carousel navigates to the first invalid section
- Optional confirmation modal before action
- Back button label also configurable per carousel

![Carousel Finish Button Demo](https://raw.githubusercontent.com/common-unite/Flow_Tool_Kit_Public/main/documents/screenshots/45-carousel-finish-button-demo.gif)

## Enhancements

### File Upload: Prevent Deletion and Disable Preview Link (#64)
Two new toggles for file upload fields configured in Form Builder:

- **Prevent File Deletion** — locks uploaded files so end users cannot remove them
- **Disable Preview Link** — removes the clickable file name link that opens the preview window

Both settings are configured in the Form Builder CPE and work in Flow and Experience Cloud contexts.

![File Upload Toggles Demo](https://raw.githubusercontent.com/common-unite/Flow_Tool_Kit_Public/main/documents/screenshots/64-file-upload-toggles-demo.gif)

## Bug Fixes

- **Address component crash in review mode (#62)** — Address sections now correctly display their entered values on the review page. Previously, address fields appeared blank in review mode.
- **Section header toggle padding (#55)** — Fixed an issue where enabling and then disabling a section header changed the bottom padding, misaligning the section divider.

---

*Flow Tool Kit v3.211 is available now on the AppExchange.*
