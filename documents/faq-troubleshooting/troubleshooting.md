# Troubleshooting

> Symptoms, causes, and solutions for common Flow Tool Kit issues.

{% hint style="info" %}
**Can't find your issue?** Check the [FAQ](../form-template-framework/faq/faq.md) for quick answers to common questions, or reach out via the [AppExchange listing](https://appexchange.salesforce.com/appxListingDetail?listingId=a0N4V00000HC4zCUAT).
{% endhint %}

## Form Builder Won't Load

**Symptom**: You click the Form Builder tab and see a blank screen, spinner that never stops, or an error message.

**Causes & Solutions**:

1. **Missing permission set**: Assign the **Form Builder Admin** or **Form Builder Manager** permission set to your user. Form Builder requires specific class and object access.
2. **Browser cache**: Hard refresh your browser (Cmd+Shift+R on Mac, Ctrl+Shift+R on Windows).
3. **Lightning Web Security**: If you're on an older org, check if Lightning Web Security is enabled. Go to **Setup → Session Settings** and look for "Use Lightning Web Security for Lightning web components."

## Form Not Rendering on Flow Screen

**Symptom**: The Flow Form component appears blank or shows an error when you run/debug the flow.

**Causes & Solutions**:

1. **No form selected**: Verify the `formQualifiedApiName` property is set to a valid form name.
2. **Object mismatch**: The `object` property on Flow Form must match the object you selected when creating the form in Form Builder.
3. **Missing record variable**: Flow Form needs a record variable of the matching object type assigned to the `record` property.
4. **Permission set missing**: The running user (or debug user) must have the **Form Flow User** permission set at minimum.

## Fields Missing from the Form

**Symptom**: Some fields you added in Form Builder don't appear at runtime.

**Causes & Solutions**:

1. **Field-Level Security**: The running user may not have access to the field via their profile or permission set. Check **Setup → Profiles/Permission Sets → Field-Level Security** for the object.
2. **Conditional visibility**: The field may have a conditional visibility rule that's evaluating to "hidden". Check the field's conditional logic in Form Builder.
3. **Record type**: If the field is only on certain page layouts tied to specific record types, and the form's record has a different record type.

## Conditional Logic Not Working

**Symptom**: A field that should be shown/hidden based on another field's value is always visible or always hidden.

**Causes & Solutions**:

1. **Wrong field API name**: Conditional rules reference the API name. Double-check spelling and namespace prefix if applicable.
2. **Case sensitivity**: Picklist values in conditions are case-sensitive. "High" ≠ "high".
3. **AND vs OR**: If using multiple conditions with AND, all must be true. Switch to OR if you want any-one-true behavior.
4. **Controlling field not on form**: The field referenced in the condition must exist on the same form.
5. **Stale cache**: If you recently changed conditional logic, the form cache may be stale. See [Cache Reset](troubleshooting.md#form-cache-is-stale) below.

## Experience Cloud Form Is Slow

**Symptom**: Forms on Experience Cloud pages take 5-10+ seconds to load, or the browser freezes with large record sets.

**Causes & Solutions**:

{% hint style="danger" %}
**Check Lightning Web Security first.** This is the #1 cause of slow Experience Cloud forms. Lightning Locker Service (LWS disabled) wraps every object in heavyweight proxies; a form with 500+ records can freeze the browser for 8+ seconds. With LWS enabled, the same data renders instantly.
{% endhint %}

1. **Enable Lightning Web Security**: Go to **Setup → Session Settings** and enable "Use Lightning Web Security for Lightning web components." Test all components (especially Aura and third-party packages) for compatibility before enabling in production.
2. **Reduce record count**: If displaying large collections in Data Table, paginate or filter server-side.
3. **Check CSP Trusted Sites**: Missing Content Security Policy entries can cause resources to load slowly or fail silently.

## Form Cache Is Stale

**Symptom**: Changes you made in Form Builder aren't reflected at runtime. Old field order, removed fields still showing, or old conditional logic.

**Causes & Solutions**:

1. **Wait 5 minutes**: Form metadata is cached for performance. Changes may take a few minutes to propagate.
2. **Clear the cache manually**: open **Form Builder** and click **Reset Form Cache**. The button requires the **Form Component Admin** custom permission, and the reset runs as a background job - track it in Setup → **Apex Jobs**. See [Cache Reset](../advanced-topics/cache-reset.md).
3. **Hard refresh the browser**: Sometimes the browser caches old component JavaScript (Cmd+Shift+R / Ctrl+Shift+R).

{% hint style="warning" %}
Visiting `/apex/FlowToolKit__CacheFlow` does **not** reset the cache, despite what earlier versions of these docs said. That page is the internal render surface used by the flow warming job.
{% endhint %}

## Forms Are Correct but Slow on the First Load Each Day

**Symptom**: The form shows the right content, but the first person to open it each morning waits 20 seconds or more. Everyone after that gets it instantly, until the next morning.

This is not a cache staleness problem and resetting the form cache will not help. Salesforce recompiles each screen flow on its first run of the day, and after any metadata deploy in your org.

**Solution**: schedule the daily warmer so a background job pays that cost before your users arrive. See [Schedule Flow Cache Warming](../how-to-guides/schedule-flow-cache-warming.md).

## Deployment Fails for Form Metadata

**Symptom**: Change set or SFDX deployment fails with errors referencing Form\_\_mdt or related CMDT records.

**Causes & Solutions**:

1. **Missing dependencies**: Form Sections reference Forms, and Form Fields reference Sections. Deploy in dependency order, or include all related records.
2. **Missing package**: Flow Tool Kit must be installed in the target org before deploying form metadata. The CMDT types (`FlowToolKit__Form__mdt`) are part of the managed package.
3. **API name conflicts**: If the CMDT record already exists in the target org with the same qualified API name, the deployment may fail. Check for existing records.

## Permission Errors

**Symptom**: "Insufficient access" or "No access" errors when using Form Builder or filling out forms.

**Causes & Solutions**:

1. **Wrong permission set**: See the [Permission Sets](../getting-started/permission-sets.md) page to confirm the right assignment for the user's role.
2. **Object-level access**: The user needs at least Read access to the form's target object and its fields.
3. **Class access**: Invocable Actions and form rendering require Apex class access, which is included in the permission sets.

## Guest User Can't Access Forms on Experience Cloud

**Symptom**: Public (unauthenticated) users see errors or blank forms on an Experience Cloud site.

**Causes & Solutions**:

1. **Guest user profile**: The guest user profile must have Read access to the form's object and fields.
2. **Apex class access**: Grant the guest user profile access to the Flow Tool Kit Apex classes needed for rendering.
3. **Sharing rules**: Ensure sharing rules allow guest user access to the relevant records.
4. **CSP Trusted Sites**: Add necessary domains to Content Security Policy Trusted Sites in Setup.

See [Experience Cloud](../experience-cloud/experience-cloud-components.md) for full guest user setup guidance.

## Save Progress Fails or the Confirmation Page Never Appears

**Symptom**: a user clicks **Save Progress** and sees "An error occurred while trying to update the record. Please try again." Clicking **Submit** saves nothing and the confirmation page never appears. The same form works for administrators, and for guest users on a public site.

**Who it affects**: any user whose only Flow Tool Kit permission set is **Form Flow User**. That includes internal Salesforce users who are not administrators and have not been given Form Builder Manager, as well as Partner Community and Customer Community users. It is reported most often on Experience Cloud, because community users are rarely assigned a builder permission set.

**Cause**: **Form Flow User** grants Create and Read but not Update on **Form Submission** and **Form Submission Stage**. It has to, because it must remain assignable to the Guest User, and Salesforce does not allow a guest user to hold the Edit object permission. Guest saves avoid the problem because they run through a server-side upsert flow. Everyone else is saved with a direct record update, which requires Update permission.

**Solution**:

1. Create a permission set in your org granting **Edit** on `FlowToolKit__Form_Submission__c` and `FlowToolKit__Form_Submission_Stage__c`. Field-level access is already covered by Form Flow User.
2. Assign it **in addition to** Form Flow User to every user who fills out forms.
3. Do not assign it to the Guest User. Salesforce blocks that assignment and guests do not need it.

**Also check**: Form Submission uses a **Private** external sharing model. The user must own the submission or have it shared with them. This matters when one person resumes a submission that someone else created.

See [Permission Sets](../getting-started/permission-sets.md) for the full explanation.

## Related Pages

* [FAQ](../form-template-framework/faq/faq.md): quick answers to common questions
* [Permission Sets](../getting-started/permission-sets.md): who gets what
* [Deployment Overview](https://github.com/common-unite/cUnite_FormBuilder/blob/master/documents/deployment/deployment-overview.md): deploying form metadata
