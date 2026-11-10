# Export and Import Form Components

> Copy a record Form Component from one org to another, for example from a sandbox to production, with the Export action and the Import Form Component button.

Export and Import work like Form Template export and import, one component at a time. The token carries the whole component: its sections, fields, conditional logic and conditions.

## Export a component

1. Open the record Form Component (the **Form Components** tab, then the component).
2. Open the actions menu and click **Export**.
3. Copy the whole token from the box.

The token leaves out values that belong to this org: record Ids, the owner, dates, the record type and the **Form Managers** list.

Only record components can be exported. A metadata component moves with a metadata deployment.

## Import a component

1. In the org you are moving it to, open the **Form Components** tab.
2. Click **Import Form Component**.
3. Paste the token and click **Import Component**. You land on the component.

When that org already has a component with the same API name, it is **updated in place**: the same record and Id, with its sections, fields and logic replaced to match the token. A design setting the token leaves out (alignment, carousel button labels) goes back to its default. Templates that use the component keep working, because its Id and API name do not change.

The import stops, changes nothing and says why when:

- a field in the token is not on the object in this org (create the field first, or remove it from the component in the source org and export again),
- the object does not exist in this org,
- a section, field or rule name in the token already belongs to a different component,
- the API name belongs to a metadata component.

A theme the target org does not have falls back to the default theme.

## Who can use them

| Permission set | Export and import | Update an existing component on import |
| -------------- | ----------------- | -------------------------------------- |
| Form Builder (Administrator) | Yes | Any component |
| Form Builder (Manager) | Yes | Only a component whose **Form Managers** list them |

## Upgrading orgs

Page layouts and list view buttons do not change on a package upgrade. In an org that upgraded:

1. Add the **Export** action to the Form Component page layout (Setup, Object Manager, Form Component, Page Layouts, Mobile & Lightning Actions).
2. Add the **Import Form Component** button to the Form Component list view (Object Manager, Form Component, Search Layouts for Salesforce Classic, List View).

The import can also be automated from developer tooling by calling the `FlowToolKit.FormComponentImport` global class.
