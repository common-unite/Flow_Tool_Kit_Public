# Unreleased: resumed payment step reads the real amount (#716)

Reopening a **Pending Payment** submission on its record page no longer shows "Amount is too small. The minimum amount is $0.50 US" when the record's Stripe Amount is fine.

## What changed for subscribers

- **The payment step hands the Stripe form its record again right before it reveals it.** The connector clears the record it was mounted with when it connects, and the resume path was the one place nothing pushed the record back before the amount check ran. Typing and submitting were never affected, because both push the record again.
- Works with the Stripe Connector Accelerator already installed; the connector's own fix (Stripe #37) stops the clearing at the source and ships with its next release.
- When the Stripe feature is not licensed for the org, the step still cannot boot. With the current connector that surfaces as the connector's "component is not available" error; with the next connector release the Form Template shows its Payment Unavailable illustration instead (#715).

## After upgrading

Open a Pending Payment submission's record page once to confirm the payment surface (or the Payment Unavailable illustration) appears with no amount toast.
