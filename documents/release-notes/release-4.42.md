# Release 4.42

The Stacked section header and Highlight text, template and page merge fields, a reworked free-version allowance, and the fix for guest form loads when a subscriber field shares its name with a packaged one.

## Section headers and text

- **Stacked header style** (#720). A display header for the top of a form, page or step: an eyebrow with the section icon, a pretitle, a large title, a body paragraph, tags drawn as pills, and a footer, one under the other. Choose **Stacked** as the Header Style on a component section or a page section; it works with any frame. Every part is rich text and accepts merge fields, and the inputs show as a single line until you click into one. Lines sit an even distance apart, only the title and body sit closer, and the header adds no space of its own above or below it. New fields on both section objects: `Header_Kicker__c` (Pretitle), `Header_Lead__c` (Body), `Header_Tags__c`, `Header_Tags_Position__c`, `Header_Footer__c` and `Header_Bottom_Margin__c`. See [Section Frame and Header](../how-to-guides/section-frame-and-header.md).
- **Highlight message variant** (#719). A rule in your brand color down the left edge of a rich text passage, with no card, fill or icon, for a policy or deadline the reader should not skip. Available on component section text, on a page section's Display Text, and on the text shown with a page section's header. See [Use Rich Text Message Cards](../how-to-guides/use-rich-text-message-cards.md).
- **The section Flow Action button shows without rich text** (#721). A section with a flow action enabled and a flow selected now shows its button even when the section has no rich text.
- **The Customize window's settings keep off the navigation.** The outlined settings groups now sit the same distance from the left navigation as from the right edge.

## Form Templates

- **Template, page and section merge fields** (#724). Page section text can merge fields from the Form Template, the current page and the section itself: `{{$Template.Name}}`, `{{$Page.FlowToolKit__Page_Label__c}}`, `{{$Section.FlowToolKit__Title__c}}`, with the date and number formatters. `{{$Page.Number}}` and `{{$Page.Count}}` count only the pages the respondent can see now, so a page hidden by conditional logic drops out and the numbers recount. See [Template, Page and Section Merge Fields](../form-template-framework/template-page-section-merge-fields.md).
- **Guest form loads with a subscriber field twin** (#699, #714). Guests got "Form Load Error" on a form whose configuration referenced a subscriber field that shares its local API name with a packaged Flow Tool Kit field, for example a local `cUnite_Volunteer_Group__c` next to the packaged `FlowToolKit__cUnite_Volunteer_Group__c`. 4.41 did not fix it. The cause: a user-mode query that selects one of the form's field reference columns fails inside the package for a user who cannot read the packaged twin.
  - The field reference columns are never queried now. They come from the custom metadata accessor, for form fields, conditions and the Form Template Source mapping (#714).
  - Where a form references a local field that a Flow Tool Kit field shadows, the form uses the packaged field of the same name, and field-level security decides who sees it: grant read on the packaged field to the users who need it. The log names the shadowed field at WARN level so you can repoint the form field.
  - A field the user cannot read is left out of the form, exactly as before.
  - The field dictionary is built per request and never shared, and builds in about 85 ms instead of about 1.1 s.
- **Source email template reads the source record in user mode.** The action that finds a source record's email template no longer bypasses the running user's access.

## Forms and components

- **Select All shows its label** (#718). The Select All checkbox on a Multiselect Checkbox field rendered without its label.
- **Lookups a user cannot create show the record's name** (#717). On a record form, a lookup the user can read but not create rendered blank. It now shows as a read-only name.
- **Merge Records accepts Individual** (#722). The Merge Records action now merges Individual records as well as Account, Contact, Lead, and Case (Case only with Case Merge turned on in Setup).

## Free version

- **A reworked Form Submission allowance** (#727). Free orgs get 25 Form Submissions each calendar month (was 50). Common-Unite can instead grant an annual allowance, which counts against the org's fiscal year. Windows follow the org's time zone, pre-fill templates and table or repeater rows never count, and Developer Edition orgs are now exempt like sandboxes. The limit message names the allowance and window. See [Free Version](../getting-started/free-version.md).

## Installing and upgrading

- **Missing picklist values are added on upgrade** (#696). The MetaDeploy install and upgrade plans now add any packaged picklist value an upgraded org is missing, for custom fields, record types and global value sets. Values are only ever added, never removed or reordered.
- **Package tests survive Winter '27** (#656). Test users are built from the Minimum Access profile and permission sets, because Winter '27 gives profiles with View Setup a new View Setup Audit Trail permission that a new test user's license can reject.

## After upgrading

Reset the form cache once, then open each public form page, including any affected by #699, as a guest.
