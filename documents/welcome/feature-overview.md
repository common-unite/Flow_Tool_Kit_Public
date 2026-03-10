# Feature Overview

> A complete list of everything Flow Tool Kit can do. Click any item to jump to its documentation page.

## Video Introduction

{% embed url="https://vimeo.com/732573675" %}

## Form Builder

The visual, drag-and-drop editor for creating form metadata — no code required.

- [Drag-and-drop form editor](../screen-components/form-builder.md) with real-time preview
- 15+ field types — text, picklist, checkbox, lookup, date/time, file upload, signature, rich text, address, phone, email, currency, number, URL, and more
- Section-based layout with configurable columns
- [Conditional show/hide logic](../form-configuration/conditional-logic.md) — field-based and user-based rules
- Field validation — min/max, required, regex patterns, phone masking
- Inline help text and prompt messages
- [Theme and label customization](../form-configuration/themes-labels-styling.md)
- JSON export/import for form portability between orgs
- Formula field recalculation

## Table Builder

The visual editor for configuring data tables — define columns, actions, and formatting without code.

- Drag-and-drop column editor
- Inline editing support
- Pagination and sorting
- Row-level actions
- Column formatting options

## Flow Screen Components

Components you drag onto Flow Screens in Flow Builder.

| Component | Description |
|-----------|-------------|
| [Flow Form](../screen-components/flow-form.md) | Runtime form rendering — renders your Form Builder metadata as a live, interactive form |
| [Flow Data Table](../screen-components/data-table.md) | Runtime table rendering — displays and edits record collections with your Table Builder configuration |
| [Lookup / Search](../screen-components/lookup.md) | Lookup field with filtering, display columns, and multi-select |
| [Form Template](../screen-components/form-builder.md) | Multi-page form component — pages, sections, save & resume, navigation |
| [Header](../screen-components/header.md) | Configurable header — title, subtitle, icon |
| [Custom Buttons](../screen-components/custom-buttons.md) | Custom button bar — actions, styling, conditional visibility |
| [Illustrations](../screen-components/illustrations.md) | SLDS illustration display for empty states and messaging |
| Signature Pad | Signature capture field for forms |
| Date/Time Picker | Enhanced date and time picker for flows |
| Repeating Sections | Table repeater for line items and repeating data entry |

## Form Template Framework

Multi-page forms with submissions, conversion, and lifecycle management.

- **Multi-page forms** — Template → Pages → Sections → Forms architecture
- [Page-level conditional logic](../form-template-framework/form-templates.md) — show/hide entire pages based on field values or user attributes
- **Save and resume** — users can save progress and return later
- **Pre-fill from existing records** — populate fields from existing Salesforce records
- **Default value templates** — set starting values for new submissions
- [Form submissions](../form-template-framework/form-submissions.md) with review mode — users can review before submitting
- **Submission-to-record conversion** — convert submissions into Account, Contact, Lead, Case, Opportunity, or Campaign Member records
- **Customizable conversion flows** — override the default conversion process with your own Flow
- **Data conversion rules** — field mapping and transformation logic
- **Email notifications** — automated emails triggered by form submissions
- **PDF generation** — create PDFs from submissions and templates
- **Campaign integration** — link templates to campaigns, auto-create campaign members
- **Form availability controls** — date ranges, user criteria, active/inactive toggles

## Invocable Flow Actions

Utility actions available in any Flow — drag them from the Action element in Flow Builder.

### Record Operations
- [Upsert Bypass Duplicates](../invocable-actions/record-operations.md) — insert or update records while bypassing duplicate rules
- [Future DML](../invocable-actions/record-operations.md) — async record operations for governor limit management
- [Record Merge](../invocable-actions/record-operations.md) — merge duplicate records
- [Lead Conversion](../invocable-actions/record-operations.md) — convert leads to accounts/contacts/opportunities
- [Duplicate Check](../invocable-actions/record-operations.md) — check for existing duplicates before creating records

### Collection Utilities
- [Collection Subset](../invocable-actions/collection-data-utilities.md) — extract a portion of a record collection
- [Remove Nulls](../invocable-actions/collection-data-utilities.md) — strip null records from collections
- [Strip Null Values](../invocable-actions/collection-data-utilities.md) — remove null field values from records

### Date/Time Utilities
- [DateTime ↔ Epoch Conversion](../invocable-actions/datetime-utility-actions.md) — convert between DateTime and Unix epoch
- [DateTime Formatting](../invocable-actions/datetime-utility-actions.md) — format dates and times with custom patterns

### File & Data Operations
- [JSON Serialize / Deserialize](../invocable-actions/json-serialization.md) — convert between Salesforce records and JSON
- [File Upload Serialize / Deserialize](../invocable-actions/file-upload-actions.md) — handle file upload data
- [Content Document to Zip](../invocable-actions/file-upload-actions.md) — package content documents into a zip file
- PDF Generation — create PDFs from templates and data
- Get SObject Type — determine the object type of a record at runtime
- Get Record Types — retrieve available record types for an object
- Custom Exception — throw custom exceptions in flows for error handling

## Experience Cloud

Deploy Flow Tool Kit forms on public-facing Experience Cloud sites.

- [Form wrapper component](../experience-cloud/experience-cloud-components.md) for Experience Cloud pages
- [Custom Flow display component](../experience-cloud/dynamic-flow-display.md) with modal support
- Property editor configuration UI for admins
- Modal display mode for overlay forms
- Guest user support with appropriate permissions
- reCAPTCHA integration for public-facing forms

## Platform & Administration

Cross-cutting features for org management.

- **Lightning Out** — embed Flow Tool Kit forms in external sites
- **Form/flow caching** — performance optimization with configurable cache
- **Cache reset utilities** — clear stale form and flow cache
- [3 permission sets](../getting-started/permission-sets.md) — Form Builder Admin, Form Builder Manager, Form Flow User
- [12 Custom Metadata Types](../form-configuration/custom-metadata-types.md) for configuration
- 5 Lightning Message Channels for inter-component communication
