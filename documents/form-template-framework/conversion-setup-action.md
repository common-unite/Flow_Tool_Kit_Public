# Conversion Setup Action

> Load everything a conversion step needs, the submission, its template, the parent and the matching rules, in one action at the top of a custom conversion flow.

## What it is for

Every conversion step starts from the same records. A step needs the Form Submission it is working on, the Form Template that holds the conversion settings, and, for a repeater or table row, the parent submission and the section that captured the row. It also needs to know which duplicate matching rules apply to the record it is about to create.

The **Form Template | Conversion Setup** action reads all of that for you. You do not add a Get Records element for each object, and you do not call a subflow. Add the action as the first element of the flow, pass it the platform event, and use its outputs everywhere after it.

Every packaged conversion flow starts this way, and so does every clonable `| Template` starter flow. A custom flow that does the same behaves like a packaged one.

## When to use it

Use it as the first element of any flow that is dispatched by the conversion pipeline:

* A custom step flow you point a Form Template at, such as the Contact 1, Account or Opportunity step
* A custom controller flow
* A clone of a packaged `| Template` flow
* A flow you run in Flow Builder to debug a conversion (see [Debug a conversion](#debug-a-conversion-in-flow-builder))

You do not need it in a flow that never reads the submission or the template.

{% hint style="info" %}
**Already have a flow that calls the Setup subflow?** The packaged **(Form Submission) Convert | Utility | Setup | Overridable** subflow is still supported, and your existing flows keep working. It now calls this action inside. For a new or edited flow, call the action directly: it is one element instead of a subflow with its own inputs and outputs, and it is what the packaged flows use.
{% endhint %}

## What it does and does not do

**It reads.** It loads the records listed under [Outputs](#outputs) and works out the matching settings for the step. It reads for a whole batch of events at once, and it keeps the Form Template and its sections for the rest of the transaction, so a chain of steps for one submission reads the template once, not once per step.

**It does not reset the conversion.** The conversion trigger sets every conversion status back to Ready, sets the overall status to In Progress, and writes the Conversion Started log before any flow runs. That is what makes Reprocess work. The action hands the event back with its **Start** flag turned off, so steps after it do not read the run as starting again. Your flow does not repeat the reset.

**It does not write anything.** Records are created and updated by the rest of your flow, and the outcome is logged with the **Form Template | Log Conversion Event** action.

## Inputs

| Input | Use it for |
| --- | --- |
| **Platform Event** | The conversion event the flow was started with: the input variable of type **Form Submission Convert**. Its Record Id names the Form Submission. A Convert event also loads the related rows. Leave it empty only in a debug run. |
| **Debug Record** | Optional, for a debug run in Flow Builder: the Form Submission to set up. It stands in for the event, so leave it empty in the running flow. |
| **Debug Event Name** | Optional, with Debug Record: the event name the step receives, such as Contact, Lead or Convert. It decides which matching settings the action returns. |
| **Debug Event Type** | Optional, with Debug Record: the submission lookup field the step fills, such as `FlowToolKit__Contact_1__c`. It decides which template matching settings apply. |

## Outputs

| Output | What you get |
| --- | --- |
| **Platform Event** | The event this step handles. Pass this one, not your input variable, to the actions that follow, for example Log Conversion Event. It is the input event with Start turned off, or in a debug run the event built from the Debug Record. |
| **Form Submission** | The submission the event names, as the conversion last wrote it. For a related row, this is the row itself. |
| **Parent Form Submission** | For a related row, its parent submission. Empty for a main submission. It is found by the lookup or, for a guest save that could not fill the lookup, by the text stamp. |
| **Form Template** | The template of the submission, or of its parent for a related row. Read once per transaction. |
| **Page Section** | For a related row, the Repeater or Table section that captured it. Its conversion settings win over the template's for that row. |
| **All Page Sections** | For a Convert event: the template's sections that carry a conversion rule, in page order. |
| **Related Records** | For a Convert event: the submission's captured rows that still need converting. Rows that are already Complete are left out, so converting related rows can be resumed. |
| **Matching Rule Names** | The duplicate rules this step matches with. For a main submission they come from the template (Contact, Lead or Account matching rules, by the event's type); for a related row, from the capturing section. Pass this to the Check for Duplicates action. |
| **Update Most Confident Match** | Whether this step updates the most confident match when there are several. It comes from the same place as Matching Rule Names. |

If the event has no Record Id, or the Record Id is not a Form Submission the running user can read, **Form Submission** comes back empty. Put a Decision after the action when your flow should stop cleanly in that case.

### Rows added during the conversion

The related rows are read the first time a submission needs them and kept for the rest of the transaction, so a row converted by an earlier step drops out of the list. When rows are created under the submission partway through, as happens when the conversion adds a guest's or an embedded form's repeater and table rows, the next call reads them again. Your flow sees the new rows without any extra step.

### Your own fields on Form Submission

Custom fields you add to Form Submission arrive on the **Form Submission** output like any other. Two kinds cannot: a field whose API name matches a packaged field without the prefix, and a custom Address or Geolocation field. Both are left out. See [Your own fields on Form Submission](submission-conversion.md#your-own-fields-on-form-submission) for what to do instead.

## Example: a custom Contact step

This is the shape of a custom step flow, the same one the packaged Contact template follows.

1. In Flow Builder, create an **Auto-Launched Flow** (or clone **(Form Submission) Convert | Process | Contact | Template**, which arrives with this wiring).
2. Add one input variable: a non-collection record variable of type **Form Submission Convert**, available for input. Any name works.
3. Add an **Action** element named `Setup`: search for **Form Template | Conversion Setup**. Set **Platform Event** to your input variable.
4. Add a **Decision** that checks `{!Setup.formSubmission}` is not empty, so the flow ends cleanly if the submission is gone.
5. Add a **Transform** that maps `{!Setup.formSubmission}` fields to your Contact variable. Read template settings from `{!Setup.formTemplate}` and, for a related row, section settings from `{!Setup.pageSection}`.
6. Save the Contact with your own logic, or hand the record to the packaged **Upsert Contact** subflow, passing `{!Setup.matchingRuleNames}`, `{!Setup.updateMostConfidentMatch}`, `{!Setup.formSubmission}`, `{!Setup.formTemplate}`, `{!Setup.pageSection}` and `{!Setup.parentFormSubmission}`.
7. Log the outcome with **Form Template | Log Conversion Event**, passing `{!Setup.platformEvent}` and the new record's Id, and turn on **Dispatch Return Event** on the success log so control goes back to the controller.
8. Save and activate the flow, then set the template's Contact 1 flow to its API name.

A flow that never logs its outcome is dispatched again and again, until the pipeline stops it and marks the submission as errored. See [Overridable Conversion Flows](how-to/overridable-conversion-flows.md) for the full contract.

## Debug a conversion in Flow Builder

To run a conversion flow without publishing an event, leave **Platform Event** empty and fill the debug inputs:

1. Set **Debug Record** to a Form Submission, for example from a Get Records element or a record variable you set in the debugger.
2. Set **Debug Event Name** to the step you are testing, such as `Contact`.
3. Set **Debug Event Type** to the lookup field that step fills, such as `FlowToolKit__Contact_1__c`.

The action builds the event from those values. Remove them, or leave them empty, in the flow you activate.

## Related pages

* [Overridable Conversion Flows](how-to/overridable-conversion-flows.md): the contract a custom flow follows
* [Submission Conversion](submission-conversion.md): the conversion lifecycle
* [Overriding Packaged Flows](../advanced-topics/overriding-packaged-flows.md): replace a packaged flow without re-pointing callers
