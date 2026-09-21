# Payment Settings loading fix — unreleased

Fixes **Component 'c/formTemplatePaymentConditions' could not be loaded** when opening Payment Settings in a client org with Flow Tool Kit installed. The built-in section now loads its LWC using the `FlowToolKit` package namespace. Payment rules and saved template data are unchanged.

Delivery requires a managed-package update containing the corrected Form Template Settings component. Deploying source to the sprint scratch org alone does not update installed client packages.
