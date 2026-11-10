# Creating Templates

> Step-by-step guide to creating a Form Template record structure with pages, sections, and form component references.

## Prerequisites

- Form Builder Admin or Form Builder Manager permission set assigned
- At least one form component built in Form Builder for each section you plan to include

## Step 1: Create Form Components

Before building a template, create the individual form components that each section will display:

1. Open **Form Builder** from the App Launcher
2. Create a form component for each logical section of your multi-page form (e.g., "Personal Info", "Employment", "Education")
3. Each form component is tied to a single object; cross-object templates use different form components per section

## Step 2: Create the Template Record

1. Navigate to the **Form Templates** tab (or create a `Form_Template__c` record directly)
2. Set the template **Name** (e.g., "Grant Application"), and optionally a **Form Template Subtitle** and **Header Tags** (short tags separated by semicolons, such as "2027 season; About 10 minutes")
3. A new template starts with the **Form Header Banner** header: a banner showing the name, subtitle, Header Tags as pills and the Banner/Header Image from the **Form Images** tab. See [The default header](../form-configuration/banner-sections.md#the-default-template-header).
4. Configure template-level settings:
   - **Active**: whether the template is available for use
   - **Save and Resume**: enable progress saving
   - **Form Availability**: date range and condition controls

## Step 3: Add Pages

Create `Form_Template_Page__c` records linked to your template:

1. Set the **Position** field to control page order (e.g., 10, 20, 30; gaps are fine)
2. Set the **Label** to the page title displayed in navigation (e.g., "Personal Information")
3. Optionally configure page-level conditional logic to show/hide pages based on field values from previous pages

## Step 4: Add Sections to Pages

Create `Form_Template_Page_Section__c` records linked to each page:

1. Set the **Position** field for section ordering within the page
2. Set the **Form** field to the QualifiedApiName of the form component this section should render
3. Each section renders one form component; a page can have multiple sections for multi-form layouts

## Step 5: Add to a Flow

1. In Flow Builder, drag the **Form (Template)** screen component onto a screen
2. Set `recordId` to the Form Template record Id
3. Set `isFlow` to `true`
4. Configure save-and-resume by passing a `Form_Submission__c` record to `formSubmission`

## Template Structure Example

```
Grant Application (Form_Template__c)
├── Page 1: Personal Information (Position: 10)
│   └── Section 1: Contact Details (→ "Contact_Basic_Info" form component)
├── Page 2: Organization (Position: 20)
│   ├── Section 1: Org Details (→ "Account_Org_Info" form component)
│   └── Section 2: Org Financials (→ "Account_Financials" form component)
├── Page 3: Grant Details (Position: 30)
│   └── Section 1: Grant Request (→ "Grant_Application_Details" form component)
└── Page 4: Review (Position: 40)
    └── Section 1: Review All (→ renders all previous sections in read-only mode)
```

## Open the live web form

**Open Web Form** on a Form Template opens the template's form on your site in a new tab, so you see it the way a respondent does.

The video shows the first-click setup, then one template moved to a different site with Change Web Form Address.

{% embed url="https://vimeo.com/1243904372" %}

**The first time**, when no address is set, Open Web Form asks where your forms live instead:

1. Pick your site from the list. Flow Tool Kit lists every active Experience Cloud site in your org with its address, and tells Aura and LWR sites apart for you. For a page outside Salesforce, pick **Custom address** and type it.
2. Choose **Default for all templates** (saved in Flow Tool Kit Settings; only users who can edit that setting, usually admins, see this choice) or **This template only** (saved in the template's **Web Form Site URL**).
3. Click the form link to test it, then **Save and Open**.

From then on, Open Web Form opens the form straight away. Every existing template uses the default the moment it is saved; nothing else needs editing.

| Site | Address saved | Open Web Form opens |
| --- | --- | --- |
| Aura site at `https://yoursite.my.site.com/forms` | `https://yoursite.my.site.com/forms/s/form-template` | `.../forms/s/form-template/<template Id>` |
| LWR site at `https://yoursite.my.site.com/apply` | `https://yoursite.my.site.com/apply/form-template` | `.../apply/form-template/<template Id>` |
| Custom address ending in `/` or `=` | as typed | the address with the Id added, no second slash |

The link only works once the site has a **Form Template** object page; see step 3 of [Put a form on your site for guests](../how-to-guides/guest-forms-quickstart.md). The read-only **Web Form URL** field on the template shows the full link, for reports, emails and flows.

- **Changing it later:** open the template's **Show more actions** menu and click **Change Web Form Address** (it appears once an address is set). It shows what opens now, the default and the template's own address; pick a new site and save it as the default, for this template only, or set the template back to the default.
- **No access to set it:** a user who can't edit the template or the setting sees "Ask your admin to set it".
- **Copied record page:** both actions are on the packaged Form Template record page and layout. If your org uses a copy of the record page, add **Open Web Form** and **Change Web Form Address** to that page's highlights panel actions yourself.
- **Different site per team:** Flow Tool Kit Settings is a hierarchy setting, so a profile or user value replaces the org default for those users, for example to point a test team at a sandbox site.
- **Pop-up blocked:** if the browser blocks the new tab, Open Web Form shows the link to click instead.

## Tips

- **Use descriptive form component names**: form components are referenced by QualifiedApiName in template sections, so clear naming helps during setup
- **Page numbering with gaps**: use 10, 20, 30 instead of 1, 2, 3, so you can insert pages later without renumbering
- **Start simple**: build with 2-3 pages first, test the flow, then add more pages

## Related Pages

- [Form Templates Reference](form-templates.md): component properties
- [Build Multi-Page Form](how-to/build-multi-page-form.md): detailed walkthrough
- [Pages and Sections](pages-and-sections.md): page configuration details

## Survey Mode

For the upcoming survey release, expand a section in the page's **Page Sections** editor and enable **Survey Section** beside **Do Not Print**. Each section can use this presentation independently. The same control appears under **Customize → Component**. See [Survey Mode](survey-mode.md#enable-it-on-a-form-template) for the setting and respondent walkthrough.

To collect reportable answers, use **Form Template Settings → Form Analytics → Enable Form Analytics**. This is separate from the section's presentation setting. See [Survey Results](survey-results.md).
