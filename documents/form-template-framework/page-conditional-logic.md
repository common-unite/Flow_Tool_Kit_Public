# Page Conditional Logic

> Show or hide entire Form Template pages based on field values from previous pages.

## Overview

Page conditional logic lets you create dynamic, branching form experiences. Instead of showing all pages to every user, you can conditionally display pages based on the responses entered on earlier pages.

![Page conditional logic configuration](../screenshots/68-page-conditional-logic.png)

## How It Works

1. Define conditions on a `Form_Template_Page__c` record
2. When the user navigates to that page, the conditions are evaluated
3. If conditions are **not met**, the page is skipped and the user advances to the next qualifying page
4. Backward navigation also respects conditions — hidden pages are skipped when going back

## Condition Rules

### Supported Operators
- Equals
- Not Equals
- Is Blank
- Is Not Blank
- Contains
- Greater Than / Less Than (numeric fields)

### Logic Combinations
- **AND** — all conditions must be true to show the page
- **OR** — any one condition being true shows the page

### Field References

Conditions can **only reference fields from previous pages**. This is a fundamental constraint — the form hasn't collected data for the current or later pages yet, so those field values don't exist at evaluation time.

## Example: Conditional Intake Form

```
Page 1: Applicant Type (always shown)
  → Field: "Applicant Type" picklist (Individual / Organization)

Page 2: Individual Details (shown when Applicant Type = "Individual")
  → Condition: Page 1 > Applicant Type = "Individual"

Page 3: Organization Details (shown when Applicant Type = "Organization")
  → Condition: Page 1 > Applicant Type = "Organization"

Page 4: Financial Information (always shown)

Page 5: Spouse Information (shown when Marital Status = "Married")
  → Condition: Page 2 > Marital Status = "Married"
  → Note: This page only appears for Individuals who are married
```

## Tips

- **Test all paths** — with conditional pages, users can take different routes through the form. Test each combination to ensure navigation works correctly
- **Default values** — if a skipped page has required fields, ensure your Flow handles the absence of those values downstream
- **Page numbering** — use gaps (10, 20, 30) so you can insert conditional pages between existing ones

## Related Pages

- [Pages and Sections](pages-and-sections.md) — page structure reference
- [Conditional Logic](../form-configuration/conditional-logic.md) — field-level conditional logic (within a single form component)
