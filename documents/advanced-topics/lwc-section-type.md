# LWC Section Type
> Embed custom Lightning Web Components inside form sections for advanced use cases that go beyond standard field inputs.

## Overview

The LWC Section Type lets you embed any custom Lightning Web Component (LWC) inside a form section. The form passes the current record data to your component on every field change, and your component can write values back to the form via events.

This is useful when:
- You need a custom UI that standard form fields cannot provide (e.g., a map picker, signature pad, custom calculator)
- You want to display computed or external data alongside form inputs
- You need to integrate a third-party widget into a form flow

## Prerequisites

**Lightning Web Security (LWS) must be enabled** in the org. This is required for dynamic component loading.

To enable: **Setup > Session Settings > Use Lightning Web Security for Lightning web components**

## Creating an LWC Section

### Step 1: Build Your Custom LWC

Your component must accept the following `@api` properties:

| Property | Type | Description |
|----------|------|-------------|
| `record` | Object | The current form record. Updated on every field change. |
| `objectApiName` | String | The SObject API name the form is operating on. |
| `review` | Boolean | `true` when the form is in review mode. Use this to disable editing. |

Minimal example:

```javascript
import { LightningElement, api } from 'lwc';

export default class MyCustomWidget extends LightningElement {
    @api record;
    @api objectApiName;
    @api review = false;
}
```

### Step 2: Add the Section in Form Builder

1. Open your form in **Form Builder**
2. Click the **Insert Section** menu on any existing section
3. Select **Lightning Web Component**
4. In the new section's configuration, expand **LWC Component**
5. Enter the fully qualified component name:
   - **Managed package components**: `FlowToolKit:componentName`
   - **Unmanaged components**: `c:componentName`
   - **Other namespaces**: `namespace:componentName`

The component renders live in the Form Builder preview.

### Step 3: Deploy and Test

Run the form in a Flow. The LWC section renders your component with the current record data.

## Writing Values Back to the Form

Your LWC can update form field values by dispatching a `formfieldchange` event:

```javascript
handleSave() {
    this.dispatchEvent(new CustomEvent('formfieldchange', {
        detail: {
            fieldApiName: 'Phone',
            value: '555-0100'
        },
        bubbles: true,
        composed: true
    }));
}
```

**Important**: Set `bubbles: true` and `composed: true` so the event crosses shadow DOM boundaries and reaches the form.

The form handles the event exactly like a standard field change — validation rules, formula recalculation, and record output updates all fire automatically.

## Validation

Your component can optionally expose a `validate()` method. The form calls it during flow navigation (Next/Finish):

```javascript
@api validate() {
    if (!this.isValid) {
        return {
            isValid: false,
            errorMessage: 'Please complete all required fields'
        };
    }
    return { isValid: true };
}
```

If `validate()` returns `{ isValid: false }`, the form blocks navigation and displays the error message in a toast.

## Error Handling

- **No component name configured**: The section displays a setup illustration with "LWC Component Name is not configured for this section"
- **Invalid component name**: The section displays a setup illustration with "Component 'name' could not be loaded"
- **Component loads but throws**: Standard LWC error boundaries apply

## Configuration Options

LWC sections support the same configuration options as other section types:

- **Rich Text** header content above the component
- **Conditional Logic** to show/hide the section based on field values
- **Section Themes** for styling
- **Padding and Margin** controls
- **Accordion** mode
- **Responsive Width** (small/medium/large breakpoints)

## Review Mode

When the form is in review mode, your component receives `review = true`. Use this to conditionally disable editing:

```html
<template if:false={review}>
    <!-- Editable UI -->
</template>
<template if:true={review}>
    <!-- Read-only display -->
</template>
```

## Permissions

| Permission Set | Access |
|---|---|
| Form Builder Admin | Read/Edit `lwcComponentName__c` |
| Form Builder Manager | Read/Edit `lwcComponentName__c` |
| Form Flow User | Read `lwcComponentName__c` |

## Limitations

- The target LWC must be deployed to the same org
- Lightning Web Security (LWS) is required — orgs using Lightning Locker Service cannot use this feature
- The component name must be fully qualified (e.g., `c:myComponent`, not just `myComponent`)
- Dynamic imports require a network roundtrip on first load — the framework does not prefetch the component
