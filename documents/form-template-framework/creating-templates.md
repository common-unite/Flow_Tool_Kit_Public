# Creating Templates

> Step-by-step guide to creating a Form Template record structure with pages, sections, and form component references.

## Prerequisites

- Form Builder Admin or Form Builder Manager permission set assigned
- At least one form component built in Form Builder for each section you plan to include

## Step 1: Create Form Components

Before building a template, create the individual form components that each section will display:

1. Open **Form Builder** from the App Launcher
2. Create a form component for each logical section of your multi-page form (e.g., "Personal Info", "Employment", "Education")
3. Each form component is tied to a single object — cross-object templates use different form components per section

## Step 2: Create the Template Record

1. Navigate to the **Form Templates** tab (or create a `Form_Template__c` record directly)
2. Set the template **Name** (e.g., "Grant Application")
3. Configure template-level settings:
   - **Active** — whether the template is available for use
   - **Save and Resume** — enable progress saving
   - **Form Availability** — date range and condition controls

## Step 3: Add Pages

Create `Form_Template_Page__c` records linked to your template:

1. Set the **Position** field to control page order (e.g., 10, 20, 30 — gaps are fine)
2. Set the **Label** to the page title displayed in navigation (e.g., "Personal Information")
3. Optionally configure page-level conditional logic to show/hide pages based on field values from previous pages

## Step 4: Add Sections to Pages

Create `Form_Template_Page_Section__c` records linked to each page:

1. Set the **Position** field for section ordering within the page
2. Set the **Form** field to the QualifiedApiName of the form component this section should render
3. Each section renders one form component — a page can have multiple sections for multi-form layouts

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

## Tips

- **Use descriptive form component names** — form components are referenced by QualifiedApiName in template sections, so clear naming helps during setup
- **Page numbering with gaps** — use 10, 20, 30 instead of 1, 2, 3, so you can insert pages later without renumbering
- **Start simple** — build with 2-3 pages first, test the flow, then add more pages

## Related Pages

- [Form Templates Reference](form-templates.md) — component properties
- [Build Multi-Page Form](how-to/build-multi-page-form.md) — detailed walkthrough
- [Pages and Sections](pages-and-sections.md) — page configuration details
