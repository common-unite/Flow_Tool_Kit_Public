# LWC Section Type
> Embed custom Lightning Web Components inside forms for advanced use cases that go beyond standard field inputs.

## Overview

An LWC section lets you embed any custom Lightning Web Component inside a form. The form passes the current record to your component and keeps it up to date on every field change, and your component writes values back through events.

This is useful when:
- You need a UI that standard form fields cannot provide (a map picker, signature pad, custom calculator)
- You want to display computed or external data alongside form inputs
- You need to integrate a third-party widget into a form flow
- You need to manage a set of related child records with your own interface

### Two surfaces

A custom LWC can be embedded in two different places. They share the same core contract, but only one of them can manage related records.

| | **Form Component section** | **Form Template page section** |
|---|---|---|
| Configured in | Form Builder | Page section configurator |
| Setting | Section Type = **Lightning Web Component** | Component Type = **LWC** |
| Runs in | `flowForm` (Flow screens, Experience Cloud) | Form Template runtime |
| Record object | whatever object the form targets | `FlowToolKit__Form_Submission__c` |
| Related records | not available | **available** |

Related records only exist on the page section surface. A Form Component renders an arbitrary object with no parent/child submission model, so the concept does not apply there.

## Prerequisites

**Lightning Web Security (LWS) must be enabled** in the org. This is required for dynamic component loading.

To enable: **Setup > Session Settings > Use Lightning Web Security for Lightning web components**

## The contract

Your component talks to the form through plain `@api` properties and plain `CustomEvent`s. There is nothing to import from the managed package, no base class to extend, and no coupling to a package version.

### Inputs

Never assign to these. They are set for you, and they arrive wrapped in the LWC reactive membrane, so treat them as read-only and spread rather than mutate in place.

| Property | Type | Surface | Description |
|---|---|---|---|
| `record` | Object | both | The current record, keyed by field API name. Updated on load and on every field change. |
| `objectApiName` | String | both | The SObject API name the form is operating on. |
| `review` | Boolean | both | `true` when the form is in review mode. |
| `disableAll` | Boolean | both | `true` when the form is read-only. |
| `relatedRecords` | Array | page sections | This section's related Form Submission rows. Already filtered to your section, with rows marked for deletion removed. |
| `recordTemplate` | Object | page sections | A blank related record, pre-stamped with everything a new row needs. Never build one by hand. |
| `section` | Object | page sections | The section's own `Form_Template_Page_Section__c` record, keyed by field API name, exactly as the admin configured it: `FlowToolKit__FormQualifiedApiName__c`, `FlowToolKit__Section_Tag__c`, the divider fields, and the rest. Passed down rather than looked up, so a guest user needs no read access on the section object and your component waits on no query before its first render. |

On the Form Component surface the page-section properties keep their defaults: `relatedRecords` is `[]`, `recordTemplate` is `{}` and `section` is `{}`. Declaring all seven is therefore safe, and lets you write one component that works in both places.

### Outputs

| Event | Detail | Surface |
|---|---|---|
| `formfieldchange` | `{ fieldApiName, value }` | both |
| `relatedrecordchange` | `{ action, record }` | page sections |

Both must be dispatched with `bubbles: true` **and** `composed: true`. Your component renders inside a wrapper with its own shadow root, so without `composed: true` the event stops at the first shadow boundary and the form never sees it. Nothing throws and nothing logs, so this is the most common reason a working-looking component appears to do nothing.

### Optional method

| Method | Returns |
|---|---|
| `@api validate()` | `{ isValid: Boolean, errorMessage: String }` |

## Building the component

Minimal example that works on both surfaces:

```javascript
import { LightningElement, api } from 'lwc';

export default class MyCustomWidget extends LightningElement {
    @api record;
    @api objectApiName;
    @api review = false;
    @api disableAll = false;
    @api relatedRecords = [];
    @api recordTemplate = {};
    @api section = {};

    get isReadOnly() {
        return this.review === true || this.disableAll === true;
    }
}
```

## Adding the section

### In Form Builder (Form Component section)

1. Open your form in **Form Builder**
2. Click the **Insert Section** menu on any existing section
3. Select **Lightning Web Component**
4. In the new section's configuration, expand **LWC Component**
5. Enter the fully qualified component name

The component renders live in the Form Builder preview.

### In the page section configurator (Form Template page section)

1. Open the **Form Template Page Section** and go to the **Component** tab
2. Set **Component Type** to **LWC**
3. Enter the fully qualified name in **LWC Component Name**

### Component name format

| Source | Format |
|---|---|
| Unmanaged components in your org | `c:componentName` |
| Managed package components | `FlowToolKit:componentName` |
| Other namespaces | `namespace:componentName` |

The name must be fully qualified. `myComponent` on its own will not resolve.

## Writing field values back

Dispatch one event per field:

```javascript
handleSave() {
    this.dispatchEvent(new CustomEvent('formfieldchange', {
        detail: {
            fieldApiName: 'FlowToolKit__Text_Question_1__c',
            value: '555-0100'
        },
        bubbles: true,
        composed: true
    }));
}
```

The form handles this exactly like a standard field change. Validation, formula recalculation, page conditional logic, autosave, and record output all fire automatically.

## Rendering the admin's form component

The recommended pattern for a page section is not to hand-write inputs at all. Every `lightning-input` you write throws away the labels, help text, widths, ordering, picklist rendering, conditional logic, theme, translations and validation the admin already configured, and it moves the field list into JavaScript where only a deploy can change it.

Instead, read the form component the admin attached to the section from `section`, render it with the package's own form engine, and let your component own only its behaviour: a calculation, an eligibility rule, a lookup against an external service, a signature pad.

```html
<template>
    <FlowToolKit-flow-form
            is-extension
            data-section-form
            form-qualified-api-name={formQualifiedApiName}
            object={objectApiName}
            record={record}
            transformation-record={derivedValues}
            review={review}
            disable-all={disableAll}
            onrecordchange={handleRecordChange}>
    </FlowToolKit-flow-form>
</template>
```

```javascript
import { LightningElement, api } from 'lwc';

const HOUSEHOLD_SIZE_FIELD = 'FlowToolKit__Number_Question_1__c';
const ANNUAL_INCOME_FIELD = 'FlowToolKit__Currency_Question_1__c';
const MEMBERSHIP_TIER_FIELD = 'FlowToolKit__Text_Question_1__c';

export default class HouseholdMembershipSection extends LightningElement {
    @api record;
    @api objectApiName;
    @api review = false;
    @api disableAll = false;
    @api relatedRecords = [];
    @api recordTemplate = {};
    @api section = {};

    derivedValues = {};

    get formQualifiedApiName() {
        return (this.section || {}).FlowToolKit__FormQualifiedApiName__c || '';
    }

    handleRecordChange(event) {
        const changed = event.detail || {};
        const previous = this.record || {};
        Object.keys(changed)
            .filter(fieldApiName => changed[fieldApiName] !== previous[fieldApiName])
            .forEach(fieldApiName => this.dispatchFieldChange(fieldApiName, changed[fieldApiName]));
        this.derivedValues = { [MEMBERSHIP_TIER_FIELD]: this.tierFor(changed[HOUSEHOLD_SIZE_FIELD], changed[ANNUAL_INCOME_FIELD]) };
    }

    dispatchFieldChange(fieldApiName, value) {
        this.dispatchEvent(new CustomEvent('formfieldchange', {
            detail: { fieldApiName, value },
            bubbles: true,
            composed: true
        }));
    }

    tierFor(householdSize, annualIncome) {
        // the part that is genuinely code
    }

    @api validate() {
        const form = this.template.querySelector('[data-section-form]');
        return form ? form.validate() : { isValid: true };
    }
}
```

How the pieces fit:

- `FlowToolKit-flow-form` is the namespaced tag for the package's `flowForm`, which is exposed for subscriber composition. `form-qualified-api-name` selects the admin's form component; `object` and `record` give it the submission to edit.
- `is-extension` makes the form report edits through a plain `recordchange` event carrying the whole record, instead of the Flow attribute event it uses on a Flow screen. Forward each changed field to the host form as a `formfieldchange`, and the host handles it exactly like a standard field change.
- `transformation-record` is the write-back channel for values your code derives. Pass an object keyed by field API name; the form applies it and ignores a value that already matches, so there is no feedback loop.
- `validate()` on the form runs the builder-configured required-field checks, so validation stays with the admin and your component only delegates.

The section type therefore stops meaning "draw your own UI" and starts meaning "render the admin's form and add behaviour to it". The field list stays in Form Builder, where an admin can change it without a deploy.

## Managing related records

*Page sections only.*

A related record is a child `FlowToolKit__Form_Submission__c` belonging to your section, the same storage the Repeater and Table section types use. Your component reads them from `relatedRecords` and changes them with a single event.

You never build a row, generate a key, or edit the collection. You describe what you want done and the framework handles the rest: cloning the collection, matching the row, stamping the section, parent and page keys, generating the upsert key, and marking deletions so the server processes them.

### Reading

```javascript
get rows() {
    return (this.relatedRecords || []).map((row, index) => ({
        key: row._Id || row.Id,
        label: row.FlowToolKit__Text_Question_1__c || '',
        position: index + 1
    }));
}
```

`_Id` is the stable client-side key assigned by the framework. Use it to identify a row across renders. Rows that have been saved also carry a real `Id`.

### Adding

Supply only your own fields. `recordTemplate` is applied underneath, and the keys are generated for you.

```javascript
this.dispatchEvent(new CustomEvent('relatedrecordchange', {
    detail: {
        action: 'add',
        record: { FlowToolKit__Text_Question_1__c: 'Jane' }
    },
    bubbles: true,
    composed: true
}));
```

Passing an existing row to `add` produces a **clone**, because identity is always stripped from a new row.

### Updating

Spread the existing row so the fields you are not changing survive. The row is matched on `_Id`, then `UniqueId__c`, then `Id`.

```javascript
this.dispatchEvent(new CustomEvent('relatedrecordchange', {
    detail: {
        action: 'update',
        record: { ...row, FlowToolKit__Text_Question_2__c: 'Vegetarian' }
    },
    bubbles: true,
    composed: true
}));
```

### Removing

Hand back the row. Nothing else is required.

```javascript
this.dispatchEvent(new CustomEvent('relatedrecordchange', {
    detail: { action: 'remove', record: row },
    bubbles: true,
    composed: true
}));
```

A row that was never saved simply disappears. A row that has already been saved is marked for deletion and removed from `relatedRecords` immediately, so it vanishes from your UI, while the framework retains it internally so the server can delete the real record.

> **When the delete reaches the database.** Related-record deletions are applied when the submission's conversion runs. If you remove a saved row from a submission that has **already** completed conversion, the row disappears from the form and is marked correctly, but the child record is removed only once conversion runs again. This is how all related records behave, including Repeater and Table sections, not something specific to LWC sections.

### Scope

`relatedRecords` contains only the rows belonging to your own section, and your changes only ever affect your own section. Rows collected by another section on the same page are not visible to you.

## Validation

Expose a `validate()` method and the form calls it during navigation:

```javascript
@api validate() {
    if ((this.relatedRecords || []).some(row => !row.FlowToolKit__Text_Question_1__c)) {
        return { isValid: false, errorMessage: 'Every row needs a label' };
    }
    return { isValid: true };
}
```

Returning `{ isValid: false }` blocks navigation and shows the message in a toast. If your component does not implement `validate()`, the section is always treated as valid.

## Review and read-only modes

Your component receives `review` and `disableAll` on both surfaces. Honour both, so it behaves correctly wherever it is used:

```html
<template lwc:if={isReadOnly}>
    <!-- Read-only display -->
</template>
<template lwc:else>
    <!-- Editable UI -->
</template>
```

## Error handling

- **No component name configured**: the section shows a setup illustration reading "LWC Component Name is not configured for this section"
- **Invalid component name**: the section shows "Component 'name' could not be loaded"
- **Component loads but throws**: standard LWC error boundaries apply

The form itself keeps working in all three cases.

## Configuration options

LWC sections support the same options as other section types:

- **Rich Text** header content above the component
- **Conditional Logic** to show or hide the section based on field values
- **Section Themes** for styling
- **Padding and Margin** controls
- **Accordion** mode
- **Responsive Width** (small/medium/large breakpoints)

## Permissions

| Permission Set | Access |
|---|---|
| Form Builder Admin | Read/Edit `lwcComponentName__c` |
| Form Builder Manager | Read/Edit `lwcComponentName__c` |
| Form Flow User | Read `lwcComponentName__c` |

Permissioning your own component is your responsibility.

## Limitations

- The target LWC must be deployed to the same org
- Lightning Web Security is required; orgs on Lightning Locker Service cannot use this feature
- The component name must be fully qualified
- Dynamic imports cost a network roundtrip on first load; the framework does not prefetch
- One `formfieldchange` per field. Batching multiple field updates into a single event is not supported
- Related records are page sections only, and are always scoped to the section that owns them
- `section` is page sections only. A Form Component section has no section record, so the property stays `{}` there

## Reference implementation

`demoLwcSection` implements the whole contract end to end, including related-record add, update and remove, and is the fastest way to see a working component. It lives in the `force-app-demo` source directory of the Flow Tool Kit repository. It is sample code rather than part of the managed package, so it will not be present in your org until you deploy it yourself.

## Related

- [Pages and Sections](../form-template-framework/pages-and-sections.md)
- [Lightning Out](lightning-out.md)
