# Release 4.40

A fix for Payment Required Form Templates. Nothing else changes.

## Fix

- **The payment step charges the right amount** (#692): on some Payment Required templates the Stripe payment step stopped with "Amount is too small" although the submission showed a valid amount. The payment step reads Stripe Amount, a formula, from the form's copy of the submission. That copy could be out of date, because the form keeps a cached copy that a page refresh does not clear, and the formula was only recalculated when the template had payment conditions. Before the payment step opens, the form now reloads the saved submission and recalculates its formula fields, so Stripe always receives the current amount.

## After upgrading

Open each public form page once after the upgrade, so the first-load compile happens for you rather than a visitor.
