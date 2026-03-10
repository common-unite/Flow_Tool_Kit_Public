# Flow Tool Kit v3.211: Conditional Pages, Carousel Finish Button, and File Upload Controls

We're excited to release Flow Tool Kit v3.211! This release brings powerful new conditional logic for multi-page forms, a long-requested finish button for carousel forms, and fine-grained file upload controls.

## Highlights

This release introduces **Page Conditional Logic** for Form Templates — you can now show or hide entire pages based on the user's answers, making your multi-step forms smarter and more personalized. We've also added a **configurable finish button** to carousel forms, and two new **file upload toggles** that give admins more control over uploaded documents.

## New Features

### Conditional Page Visibility (#68)

Form Template pages can now be conditionally shown or hidden based on field values on the Form Submission record. This lets you build dynamic multi-step forms where the path adapts to the user's inputs — skip irrelevant pages, show additional pages when needed, all without building separate flows.

Rules are configured directly on the Form Template Page record page using a visual condition builder. Each page can have its own set of conditions with **Show When** or **Hide When** modes and support for **AND**, **OR**, and **CUSTOM** logic.

When a page is hidden, its field values automatically reset to prefill defaults. When the page reappears, values are restored. Stage indicators, navigation buttons, and page counts all adjust in real time.

![Page Conditional Logic](https://raw.githubusercontent.com/common-unite/Flow_Tool_Kit_Public/main/documents/screenshots/68-page-conditional-logic.png)

**Use case:** A benefits enrollment form has 8 pages, but only 4 are relevant based on the employee's coverage tier. With conditional page logic, the form automatically presents only the relevant pages — no branching flows required.

### Carousel Finish Button (#45)

Carousel forms now include a configurable finish button on the final section. This was one of our most requested features — previously, the last carousel section only showed a Back button, and admins had to add a separate Custom Buttons component for the submit action.

The finish button is fully configurable in Form Builder:

- **Label** — customize the button text (default: "Submit")
- **Variant** — brand, neutral, success, or destructive
- **Icon** — optional SLDS icon
- **Action** — NEXT, FINISH, TRIGGER (message channel), or SAVE (record edit form)
- **Confirmation modal** — optional dialog before executing the action

The finish button validates **all carousel sections** before proceeding — not just the visible one. If any section has errors, the carousel navigates to the first invalid section so the user can fix it.

Back button labels are also now configurable per carousel.

![Carousel Finish Button Demo](https://raw.githubusercontent.com/common-unite/Flow_Tool_Kit_Public/main/documents/screenshots/45-carousel-finish-button-demo.gif)

## Enhancements

### File Upload: Prevent Deletion and Disable Preview Link (#64)

Two new toggles are available when configuring file upload fields in Form Builder:

| Toggle | What it does |
|--------|-------------|
| **Prevent File Deletion** | Locks uploaded files — users can upload but cannot remove them |
| **Disable Preview Link** | Removes the clickable file name link that opens the file preview |

These are useful for compliance workflows where uploaded documents must be retained, or when the preview experience isn't appropriate for the file type.

![File Upload Toggles Builder UI](https://raw.githubusercontent.com/common-unite/Flow_Tool_Kit_Public/main/documents/screenshots/64-file-upload-toggles-builder-ui.png)

![File Upload Toggles Demo](https://raw.githubusercontent.com/common-unite/Flow_Tool_Kit_Public/main/documents/screenshots/64-file-upload-toggles-demo.gif)

## Bug Fixes

- **Address fields in review mode (#62)** — Address sections now correctly display their values on the review page. Previously, address fields appeared blank when viewing a completed form in review mode.
- **Section header padding (#55)** — Fixed a layout issue where toggling a section header on and off changed the bottom padding, causing the section divider to shift out of alignment.

## What's Next

We're working on a **Form Template Task Plan** — an SLDS Setup Assistant-style interface that lets admins define a set of tasks (form pages, links, consent toggles) that users can complete in any order. Think of it as a guided checklist that sits in front of your multi-page form, letting users navigate non-linearly. Stay tuned!

---

*Flow Tool Kit v3.211 is available now on the AppExchange.*
