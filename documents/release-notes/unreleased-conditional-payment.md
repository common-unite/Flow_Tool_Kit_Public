# Conditional payment for Form Templates — unreleased

Form Templates can now require payment only when a response matches configured conditions. For example, collect a membership fee when Amount is greater than zero and Fee Waived is false; let other responses submit without a payment step.

## Configure payment

Open **Form Template Settings → Payment Settings**. The section combines the Stripe setup guidance, the existing **Payment Required** attestation, and **Require payment when…** in one LWC section.

1. Enable **Payment Required**.
2. Add conditions using fields on Form Submission. Choose all conditions (AND), any condition (OR), or custom logic such as `AND(1,NOT(2))`.
3. Use the Salesforce stored values for picklist conditions. Calculated fields are supported; change-since-load conditions are not.

Existing templates without conditions retain their behavior: enabled means payment is always required. Disabling Payment Required keeps the saved rule but bypasses it for new submissions. Clearing conditions restores always-required payment while enabled.

The section uses the settings form's normal save behavior: autosave on the record page and the parent Save action in New/Edit. It has no separate Save Conditions button in this surface.

## Submission behavior

- Matching responses save as **Pending Payment**, with no Submission Date, and enter the payment step. Completion and the Screen Flow handoff wait for successful payment.
- Nonmatching responses follow the normal submission path.
- Responses already awaiting payment stay in that step even if the conditions or master setting later change.
- Submission checks use the latest in-memory edits, including an immediate Submit after changing a field. Referenced formula fields are recalculated before evaluating payment conditions.
- Invalid or inaccessible rules and failed formula recalculation block submission instead of silently waiving payment.

The amount still comes from **Stripe Amount**, calculated from **Amount** on Form Submission. A compatible, configured **Stripe Connector Accelerator** is required to collect payment. This feature does not change the Stripe charge or product-mapping implementation.

## Deployment and permissions

The release adds `Form_Template__c.Payment_Conditions__c` (long text containing the rule JSON), the payment conditions editor and evaluator, and updates the form runtime and settings configuration. Deploy the field with the associated LWC changes and permission sets.

The existing payment access in **Form Builder Admin**, **Form Builder Manager**, and **Form Flow User** is extended to Payment Conditions. Custom runtime/guest permission sets need read access to that field and each field referenced by a rule. Authors need edit access to Payment Required and Payment Conditions. No data migration is required for existing templates.

## Verification

Verified in the sprint scratch org: matching/nonmatching submissions, Pending Payment/date stamping, immediate-edit submission, saved rule rendering, attestation persistence, and clearing conditions across refresh. The automated suite covers rule validation, formula refresh failures, parent save events, and namespace handling.

The scratch org has no configured Stripe payment integration; required cases stop at Payment Unavailable. A successful card charge and the complete Stripe lifecycle were not exercised. Native New/Edit-dialog saving was not separately exercised. Production has not been deployed.

Implementation notes and detailed evidence: [conditional-payment verification](../../_plans/payment-required-form-templates/conditional-payment/VERIFICATION.md).
