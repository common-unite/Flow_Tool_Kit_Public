# Deploying to Production

> Production deployment checklist — what to include, verify, and test.

{% hint style="danger" %}
**Always deploy to a sandbox first.** Test your form configurations in a sandbox or scratch org before deploying to production.
{% endhint %}

## Pre-Deployment Checklist

### 1. Verify Package Version
- Confirm Flow Tool Kit is installed in production and is the same version (or newer) as your sandbox.
- If you're upgrading the package and deploying forms in the same release, upgrade the package first, then deploy your metadata.

### 2. Inventory What to Deploy

List all CMDT records that need to move:

- [ ] `Form__mdt` records
- [ ] `Form_Section__mdt` records
- [ ] `Form_Field__mdt` records
- [ ] `Form_Conditional_Logic__mdt` records (if used)
- [ ] `Form_Conditional_Logic_Condition__mdt` records (if used)
- [ ] `Form_Style_Sheet__mdt` records (if customized)
- [ ] `Form_Labels__mdt` records (if used)
- [ ] `Form_Template__c` records (if using templates)
- [ ] `Form_Template_Page__c` records (if using templates)
- [ ] `Form_Template_Page_Section__c` records (if using templates)

### 3. Check Field Dependencies

Ensure all fields referenced by your forms exist in production:
- Custom fields must be deployed or already exist
- If your form references a field that doesn't exist in production, the form will error at runtime

### 4. Verify Permission Sets

- [ ] **Form Builder Admin** assigned to administrators
- [ ] **Form Builder Manager** assigned to form builders
- [ ] **Form Flow User** assigned to end users who fill out forms
- [ ] Object and field-level security allows access to form-related objects

## Deployment Steps

1. **Deploy CMDT records** using your preferred method (see [Deploying Metadata](deploying-metadata.md)).
2. **Deploy any related metadata** — Flows, custom fields, or permission changes that depend on or use the forms.
3. **Clear the form cache** — navigate to `your-org/apex/FlowToolKit__CacheFlow` to ensure production picks up the new metadata.

## Post-Deployment Verification

1. **Open Form Builder** — verify all deployed forms appear and look correct.
2. **Test each form in a Flow** — run a screen flow with the deployed form and verify:
   - All fields render
   - Conditional logic works
   - Themes display correctly
   - Record creation/update succeeds
3. **Test as end user** — log in as a user with only the **Form Flow User** permission set and verify forms work.
4. **Test Experience Cloud** (if applicable) — verify forms render on EC pages for both authenticated and guest users.

## Rollback Plan

If something goes wrong:

- **CMDT records can be deactivated** — most forms have an "Active" setting. Deactivate the form rather than deleting it.
- **Redeploy the previous version** — if you saved the previous CMDT values, deploy them back.
- **Form Builder can edit in production** — as a last resort, fix the form directly in production Form Builder (then back-port the fix to your sandbox).

## Related Pages

- [Deployment Overview](deployment-overview.md) — what metadata needs to be deployed
- [Deploying Metadata](deploying-metadata.md) — step-by-step methods
- [Upgrading Versions](upgrading-versions.md) — upgrading the managed package
