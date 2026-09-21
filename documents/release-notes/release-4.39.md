# Release 4.39

A hotfix for 4.38. Nothing else changes.

## Fix

- **Payment Settings opens again in Form Template Settings** (#691): in 4.38 the Payment Settings panel showed "Component 'c/formTemplatePaymentConditions' could not be loaded" in orgs with Flow Tool Kit installed. The panel loads its component by name at run time, and a name written with `c/` is not converted to the package's namespace the way a normal import is. It now names `FlowToolKit/formTemplatePaymentConditions`. Payment rules and saved templates are unchanged.

## After upgrading

Open each public form page once after the upgrade, so the first-load compile happens for you rather than a visitor.
