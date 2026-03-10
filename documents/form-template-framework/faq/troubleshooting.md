# Form Template Troubleshooting

> Step-by-step solutions for common Form Template Framework issues.

## Template Not Rendering

**Symptom**: The Form Template component shows a blank screen or spinner that never loads.

**Check**:
1. Verify the `recordId` input points to a valid `Form_Template__c` record
2. Confirm the template has at least one Page (`Form_Template_Page__c`) with at least one Section (`Form_Template_Page_Section__c`)
3. Check that each section references a valid form component QualifiedApiName
4. Ensure the running user has the **Form Flow User** permission set (minimum)
5. If in a Flow, verify `isFlow` is set to `true`

## Save Progress Not Working

**Symptom**: User clicks "Save Progress" but nothing happens when they return.

**Check**:
1. Verify your Flow checks the `saveProgress` output after the Form Template screen
2. Confirm the Flow creates or updates the `Form_Submission__c` record when `saveProgress` is true
3. When resuming, ensure the same `Form_Submission__c` record is passed back to the `formSubmission` input
4. Check that the submission's `Form_Template__c` lookup matches the template being displayed

## Pages Display in Wrong Order

**Symptom**: Template pages appear in an unexpected sequence.

**Check**:
1. Open the `Form_Template_Page__c` records and verify the Position field values
2. Pages are sorted numerically by position — gaps are fine (10, 20, 30) but duplicates cause unpredictable order
3. If using page-level conditional logic, hidden pages may shift the apparent order

## Conditional Page Logic Not Working

**Symptom**: A page that should be hidden still appears, or a page that should appear is skipped.

**Check**:
1. Page conditions can only reference fields from **previous** pages — not the current page or future pages
2. Verify the field API name in the condition matches exactly (case-sensitive for picklist values)
3. Check whether the condition uses AND or OR logic — AND requires all conditions true, OR requires any one

## Submission Conversion Fails

**Symptom**: Converting a submission to records throws an error or creates incomplete records.

**Check**:
1. Review the `Form_Submission_Conversion_Log__c` records for error messages
2. Verify the target object and field mappings in the conversion rules
3. Check required fields on the target object — if any mapped fields are blank in the submission, the insert may fail
4. For custom conversion flows, check the Flow's fault path for error details
5. Ensure the running user has Create permission on the target objects

## Experience Cloud Template Issues

**Symptom**: Form Template works in Lightning but fails or displays incorrectly in Experience Cloud.

**Check**:
1. Confirm the Experience Cloud site has the correct CSP Trusted Sites configured
2. Verify the guest user profile (if applicable) has access to `Form_Template__c`, `Form_Template_Page__c`, `Form_Template_Page_Section__c`, and `Form_Submission__c`
3. Check that [Lightning Web Security is enabled](../../faq-troubleshooting/troubleshooting.md) for performance
4. Set `serverURL` appropriately when embedding in Experience Cloud Flows

## Related Pages

- [Form Template FAQ](faq.md) — common questions
- [General Troubleshooting](../../faq-troubleshooting/troubleshooting.md) — non-template-specific issues
- [Known Limitations](../../faq-troubleshooting/known-limitations.md) — platform constraints
