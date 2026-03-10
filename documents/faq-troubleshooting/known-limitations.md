# Known Limitations

> Platform limits, unsupported scenarios, and constraints to be aware of when using Flow Tool Kit.

## Salesforce Platform Limits

These are Salesforce platform constraints — not Flow Tool Kit bugs. They apply to any managed package running on the platform.

### Governor Limits in Flows

| Limit | Value | Impact |
|-------|-------|--------|
| **SOQL queries per transaction** | 100 | Form components with many lookup fields or complex conditional logic may approach this limit |
| **DML statements per transaction** | 150 | Form submissions that create records across many objects |
| **Heap size** | 6 MB (sync) / 12 MB (async) | Very large form components with hundreds of fields and complex JSON |
| **CPU time** | 10,000 ms (sync) | Complex conditional logic evaluation on large form components |

{% hint style="info" %}
**Tip**: If you hit governor limits, simplify your form component or split it into multiple screens/pages using the Form Template Framework.
{% endhint %}

### Custom Metadata Type Limits

| Limit | Value | Impact |
|-------|-------|--------|
| **CMDT records per type** | 10 MB total storage | Very large orgs with hundreds of form components may approach this |
| **Field length** | 255 characters (text) | Long conditional logic expressions may need to be split |
| **Deployment size** | 10,000 records per deployment | Bulk form component deployments may need to be batched |

### Experience Cloud Limits

| Limit | Value | Impact |
|-------|-------|--------|
| **Guest user daily API requests** | Varies by edition | High-traffic public forms may hit API limits |
| **File upload size** | 2 GB (max per file) | Org edition may impose lower limits |
| **Concurrent guest users** | Varies by edition | Check your org's Experience Cloud license limits |

## Flow Tool Kit Constraints

### Form Builder

- **One object per form component** — each form component targets a single Salesforce object. Cross-object forms require the Form Template Framework (multiple form components across pages).
- **Field types** — Form Builder supports standard Salesforce field types. Encrypted fields and some compound fields (like geolocation) may not render correctly.
- **Polymorphic lookups** — lookups that can reference multiple object types (like `WhoId` on Task) have limited support.

### Flow Form (Runtime)

- **Controlling field must be on the same form component** — conditional logic can only reference fields that are on the current form component, not fields from other screen components or Flow variables.
- **Record variable type must match** — the record variable assigned to Flow Form must be the same object type as the form component. Mismatches cause runtime errors.
- **FlowAttributeChangeEvent echo** — when Flow Form dispatches attribute changes, the Flow runtime echoes the values back wrapped in new proxies. This is a platform behavior, not a bug.

### Data Table

- **Large record sets** — while Data Table supports pagination, loading thousands of records in a single page can cause performance issues, especially with Lightning Locker Service enabled (see [Troubleshooting](troubleshooting.md#experience-cloud-form-is-slow)).
- **Inline editing field types** — not all field types support inline editing in Data Table (e.g., rich text, file upload).

### Form Template Framework

For Form Template Framework constraints (Save & Resume, conversion, page-level conditional logic), see the [Form Template Framework documentation](../form-template-framework/overview.md).

### Experience Cloud

- **Lightning Locker Service performance** — if LWS is not enabled, form components with large datasets will be significantly slower due to proxy wrapping. Always enable Lightning Web Security for best performance.
- **Guest user limitations** — guest users cannot access all Apex classes or objects. Carefully configure the guest user profile.
- **CSP restrictions** — external resources (reCAPTCHA, custom fonts, external APIs) require CSP Trusted Site entries.

### Deployment

- **CMDT records are org-specific** — form component configurations don't sync automatically between orgs. You must explicitly deploy them.
- **Namespace prefix** — in deployed CMDT records, the `FlowToolKit__` namespace prefix is required. Records created without it won't be recognized by the package.

## Unsupported Scenarios

| Scenario | Reason | Alternative |
|----------|--------|-------------|
| Offline form submission | Salesforce requires an active connection | Use Experience Cloud with service worker caching (limited) |
| Cross-object form components (single page) | Form Builder is single-object | Use Form Template Framework with multiple pages |
| Custom Apex validation in form components | Form validation uses metadata rules | Use Flow decision elements after the form screen |
| Dynamic object at runtime | Object type is set at design time | Use `dynamicFormSelectorEnabled` with multiple form components |
| Aura-only components in forms | Flow Tool Kit uses LWC | Wrap Aura components in an LWC adapter |

## Related Pages

- [Troubleshooting](troubleshooting.md) — solutions to common issues
- [FAQ](faq.md) — frequently asked questions
- [Feature Overview](../welcome/feature-overview.md) — what Flow Tool Kit can do
