# Form Template FAQ

> Common questions specific to the Form Template Framework — multi-page forms, submissions, and conversion.

## Getting Started

### What's the difference between a form component and a Form Template?

A **form component** is a single-page layout for one Salesforce object, built in Form Builder and rendered by the Flow Form screen component. A **Form Template** is a multi-page container that organizes multiple form components across pages and sections, with built-in navigation, save-and-resume, and submission tracking.

Use form components for simple data entry. Use Form Templates when you need multi-step workflows, progress saving, or submission review processes.

### Do I still need Form Builder for Form Templates?

Yes. Form Templates reference form components built in Form Builder. Each section within a template page points to a form component by its QualifiedApiName. You build the individual form components first, then assemble them into a template.

### Can I use Form Templates outside of Flows?

Yes. The Form Template component targets Flow Screens, App Pages, Record Pages, Home Pages, and Experience Cloud pages. Outside of Flows, it renders inline with page-level navigation but without save-and-resume (which requires Flow logic to handle DML).

## Save & Resume

### Can guest users save and resume forms?

No. Save-and-resume requires an authenticated user identity to match users with their draft submissions. Guest users in Experience Cloud cannot resume saved forms because there's no persistent identity to link them to a `Form_Submission__c` record.

### How is form progress stored?

Form field values are serialized as JSON and stored in the `Form_Submission__c` record. The Form Template component handles serialization and deserialization transparently — your Flow just needs to pass the submission record in and save it when `saveProgress` is true.

### What happens if a user abandons a form?

The submission stays in Draft status. Consider creating a scheduled Flow or batch process to clean up abandoned submissions — for example, deleting Draft submissions older than 30 days.

## Submissions & Conversion

### What is submission conversion?

Conversion transforms a completed `Form_Submission__c` record into actual Salesforce records (Account, Contact, Lead, Case, or custom objects). Conversion rules define which fields map to which objects and when conversion happens (manual or automatic on submit).

### Can I convert a submission to multiple objects?

Yes. You can define conversion rules for multiple target objects. For example, a grant application submission might create a Contact, an Account, and a custom Grant_Application__c record.

### Can I undo a conversion?

No. Conversion is one-way. Once a submission is converted to records, there's no automatic reversal. You can manually delete the created records, but the conversion log remains for audit purposes.

### Can I customize the conversion logic?

Yes. Use [Overridable Conversion Flows](../how-to/overridable-conversion-flows.md) to replace the default conversion with your own Flow logic. This lets you add custom field mapping, multi-object creation, validation, and error handling.

## Pages & Navigation

### Can I conditionally skip pages?

Yes. Page-level conditional logic lets you show or hide entire pages based on field values from previous pages. Note: conditions can only reference fields from earlier pages, not the current or future pages.

### Is there a limit on the number of pages?

There's no hard limit imposed by Flow Tool Kit. However, very long templates (20+ pages) may impact the user experience. Consider whether your workflow truly needs that many pages or if some can be consolidated.

### Can users navigate backward?

Yes. The Form Template component includes built-in forward and backward navigation. Users can return to previous pages to review or edit their responses.

## Related Pages

- [Form Templates Reference](../form-templates.md) — component properties and architecture
- [Form Submissions Reference](../form-submissions.md) — submission object and lifecycle
- [Troubleshooting](troubleshooting.md) — solutions to common template issues
