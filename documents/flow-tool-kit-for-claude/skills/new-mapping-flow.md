# new-mapping-flow

Builds the conversion flows that turn a Form Submission into real records, plus prefill flows.

Run it as `/flow-tool-kit:new-mapping-flow`, or just describe what you want and Claude picks it.

## What it's for

Builds the conversion flows that turn a submitted Form Submission into Contact, Account, Opportunity, Case, Campaign Member and your own objects, plus the prefill flows that fill a form from existing records. It follows Flow Tool Kit's platform-event conversion pattern.

The shared **mapping preference** applies: on a paid org the default is the packaged conversion flow plus Form Builder field mapping (Form Template Mapping) and the action Apply Submission Field Maps. A Transform row is hand-built only for calculated or combined values, Campaign Members and record types. An overridden flow always keeps the Apply step. On a free org it uses the current approach.

### The four rules it follows

1. **Override, or a new flow.** Use a flow override for a small tweak to a built-in standard rule (Contact, Account, Opportunity, Case, Campaign Member): one more field, a default value, a matching setting. An override runs on every template, with no wiring. Build a new flow when the conversion logic or mapping is genuinely different, or when only some templates should use it. Claude recommends one, says why, and asks you.
2. **The packaged controller, or your own.** The packaged controller is big because it is mostly an example: it runs every standard rule so any template can switch any of them on. For a focused project a project-specific controller is often simpler, so an administrator can read the whole conversion top to bottom. For example, an Outbound Funds controller that checks the Account, then the Contact, then creates or updates the Funding Request and its Review records, and nothing else. This is partly taste, so Claude recommends one with the reason and asks you.
3. **Always start from the package's templates.** Every new flow is a copy of a packaged template, so it carries the latest pattern: the controller template `Form_Submission_Convert_Process_Form_Submission_Template`, the Contact template `Form_Submission_Convert_Process_Contact_Template` and the Account template `Form_Submission_Convert_Process_Account_Template` (also the starting point for objects with no template of their own). Never a blank flow.
4. **Wire a new flow through the picklists.** A new flow runs only where a Conversion Map Flow picklist names it. Add it as a picklist value whose **value is exactly the flow's API name**, with a **friendly label** with no underscores ("Primary Contact"). Then set the defaults: which flow each Form Template uses, and, where needed, a different flow for one Repeater or Table section. A label typed in as the value saves without complaint and stops every conversion that selects it, so Claude checks the wiring with a script before anyone types it into Setup.

### The fields that wire a flow

**On Form Template** (record page, Data Conversion Settings, Advanced Data Mapping Overrides). Each picklist starts with one value, `Default`, which runs the flow named in that rule's record of the **Form Template Conversion Mapping Default** custom metadata type. The read-only FlowApiName field beside each one shows which flow will run.

| Picklist (label, API name) | Chooses the flow for | Shows the result |
|---|---|---|
| Conversion Map Flow (Controller), `Conversion_Map_Flow_Controller__c` | The controller, which runs the rules in order | `FlowApiName_Controller__c` |
| Conversion Map Flow (Contact1), `Conversion_Map_Flow_Contact1__c` | The primary Contact | `FlowApiName_Contact1__c` |
| Conversion Map Flow (Contact2), `Conversion_Map_Flow_Contact2__c` | The second Contact | `FlowApiName_Contact2__c` |
| Conversion Map Flow (Lead1), `Conversion_Map_Flow_Lead1__c` | The primary Lead | `FlowApiName_Lead1__c` |
| Conversion Map Flow (Lead2), `Conversion_Map_Flow_Lead2__c` | The second Lead | `FlowApiName_Lead2__c` |
| Conversion Map Flow (Account), `Conversion_Map_Flow_Account__c` | The Account | `FlowApiName_Account__c` |
| Conversion Map Flow (Opportunity), `Conversion_Map_Flow_Opportunity__c` | The Opportunity | `FlowApiName_Opportunity__c` |
| Conversion Map Flow (Case), `Conversion_Map_Flow_Case__c` | The Case | `FlowApiName_Case__c` |
| Conversion Map Flow (CampaignMember), `Conversion_Map_Flow_CampaignMember__c` | Campaign Members | `FlowApiName_CampaignMember__c` |
| Conversion Map Flow (File Upload), `Conversion_Map_Flow_FileUpload__c` | Uploaded files | `FlowApiName_FileUpload__c` |
| Conversion Map Flow (Order), `Conversion_Map_Flow_Order__c` | An Order (no packaged Order flow ships, so this names your own) | `FlowApiName_Order__c` |

**On a form component's section** (Form Template Page Section, the record that places a form component on a page). Only Repeater and Table sections have these, in Form Builder under the section's Conversion Rules, because only their rows convert one by one:

| Field (label, API name) | What it does |
|---|---|
| Conversion Rule, `Conversion_Rule__c` | What each row becomes: Bypass (the default), Contact1, Contact2 (each with mailing or other address variants), Lead1, Lead2 or Case |
| Conversion Map Flow, `Conversion_Map_Flow__c` | The flow for this section's rows. It depends on Conversion Rule, so a new value must also be included under its rule in Field Dependencies |
| FlowApiName (Related), `FlowApiName_Related__c` | Read-only: the flow the rows run. On Default it is the packaged default for the rule, not the template's own choice, so a repeater left on Default does not follow the template's custom Contact flow |

To add a value: Setup, Object Manager, Form Template (or Form Template Page Section), the Conversion Map Flow field, Values, New. Type the flow's API name, save, then edit the value and change only its label to the friendly name.

## When it's used

After the template is built, or directly: map this form's answers to Contacts and Opportunities, add a conversion step for our custom Program Enrollment object, convert children differently from their parent.

## What you say

- "Map this form's answers to Contacts and Opportunities."
- "Add a conversion step for our Program Enrollment object."
- "Children on this form should be saved with fewer fields than their parent."
- "Build a prefill flow that fills the form from the Contact."
- "Why did this submission save but write nothing?"
- "Every Contact should also get a Preferred Name; override the packaged Contact flow."

## Inputs

The built Form Template (or the formassembly-capture flow plan for a whole account), the org's Flow Tool Kit version and edition, and the target objects.

## Outputs

- Two decisions, each recommended with its reason and confirmed by you: override or new flow, and the packaged controller or a project controller.
- Each new flow cloned from the matching package template, built once and switched on per template or per Repeater or Table section through the Conversion Map Flow picklists, with the wiring checked (value equals the flow's API name, friendly label).
- Hand-built Transform rows only where the mapping preference allows, with logs for each outcome and fault paths named `Fault_<Operation>`.
- Prefill flows with their input and output contract.

Flow names and descriptions follow the documentation standard. A copy of a template keeps the template's name and swaps "Template" for its purpose, for example `(Form Submission) Convert | Process | Contact | Primary Contact`, API name `Form_Submission_Convert_Process_Contact_Primary_Contact`.

## How it connects

- **Calls:** [new-invocable](new-invocable.md) when a step needs Apex; [flow-access-fix](flow-access-fix.md) for guest and portal flows.
- **Called by:** [ftk-start](ftk-start.md); [build-template](build-template.md). Reads [formassembly-capture](formassembly-capture.md)'s flow plan.

## Why it's valuable

Conversion is where Flow Tool Kit projects fail quietly: a mapping that saves but writes nothing, or a picklist label typed in where the flow's API name belongs. This skill builds conversion the way the package expects, starting from its templates, wires each flow to the right templates and sections, and debugs a conversion that is not writing records.

## Where it runs

Claude Code (it deploys flows). In claude.ai chat it plans, drafts the flows and checks the wiring, then hands the deploy to Claude Code.

## Walkthrough demo

All names and data below are invented. Read the lines aloud as a video script: your words, then what Claude says and does, then the result.

**You:** The Maple Clinic registration form collects a parent or guardian and, in a repeater, their children. Build the conversion. For the children, store as little as possible.

**Claude:** The parent's mapping differs from the packaged Contact flow on this template only, and the children need a genuinely different mapping, so I recommend two new flows rather than an override, which would change every template in the org. The packaged controller already runs Contact 1 and the repeater rows, so no project controller is needed. Shall I go ahead with two new flows?

**You:** Yes.

**Claude:** I cloned both from the package's Contact template. "(Form Submission) Convert | Process | Contact | Primary Contact" maps the parent's details and insurance. "(Form Submission) Convert | Process | Contact | Child Minor" maps only name, birthdate and the household link, so no health answers are stored on a child's Contact.

**Claude:** Wiring. On Form Template I added a Conversion Map Flow (Contact1) value: value `Form_Submission_Convert_Process_Contact_Primary_Contact`, label "Primary Contact". On Form Template Page Section I added a Conversion Map Flow value: value `Form_Submission_Convert_Process_Contact_Child_Minor`, label "Child / Minor", included under the Contact1 rule in Field Dependencies. The wiring check passed: both values equal their flows' API names.

**Claude:** Then the defaults. The Registration template's Conversion Map Flow (Contact1) is Primary Contact. Its Children repeater has Conversion Rule Contact1 and Conversion Map Flow Child / Minor. Left on Default, the children would have run the packaged Contact flow instead.

**You:** Could I have typed "Child / Minor" as the value?

**Claude:** That is the mistake the check catches: the package reads the value as the flow to run, so a label there stops the conversion. The label is only what you pick from the list.

**Result.** Two flows in the org, two picklist values whose values match the flows exactly, the template and the repeater set, and a test submission that created the parent with full details and each child with only the minimum.

[Back to all skills](../README.md)
