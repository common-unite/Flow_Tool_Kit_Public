# Overriding Packaged Flows

Flow Tool Kit ships its automation as flows marked **overridable**: the save flow `(Form) Upsert | Overridable`, the prefill and resume flows, the scheduled flow that expires resume links ([how to override it](../form-template-framework/save-progress-email.md#the-expire-resume-tokens-scheduled-flow)), and every conversion engine and step flow. Overridable means you can replace one with a flow of your own, and the package keeps calling the replacement. This page covers the two ways to do that, what each one changes, and the three things that trip people up when the override serves guests or travels through a deployment.

## Two routes

Walkthrough: creating a flow override of a packaged conversion flow with Save As New Flow.

{% embed url="https://vimeo.com/1241879216" %}

**A flow override.** Open the packaged flow in Flow Builder and choose **Save As**. Because the packaged flow is overridable, Flow Builder opens **Save as flow override** instead of a plain copy; give the new flow a label and API name, make your changes, and **Activate** it. From then on everything that names the packaged flow runs yours: the form's save, the prefill and resume calls, subflow calls, and the conversion dispatcher. Nothing else needs pointing at it. In metadata the override is an ordinary flow whose `overriddenFlow` names the packaged flow.

**A plain clone.** Save a copy without the override link and point the package at it explicitly: a Form Template's Flow API Name fields for one template, or the Form Template Conversion Mapping Default records for the whole org. The NPSP and Nonprofit Cloud Customizing pages describe this route for the conversion step flows. A clone only runs where something names it.

{% hint style="info" %}
**The packaged name is what you will keep seeing.** The Conversion Map picklists, the mapping default records, a template's Flow API Name fields, the dispatch counters and the conversion log all carry the name the call was made with, which is the packaged flow's. None of them can tell you that an override ran. To know, open the packaged flow in Setup and look for its override, or search your retrieved metadata for `overriddenFlow`.
{% endhint %}

## Overrides that serve guests run in system context

Guests save through `(Form) Upsert | Overridable`, and a guest can insert a Form Submission but never update one or stamp it with a record they cannot read. Since 5.3 the form starts the save flow from Apex, where a flow on the default setting runs in system context; the packaged save flow ships on the default setting (see [How the form starts the save flow](../form-template-framework/prefill-flow.md#how-the-form-starts-the-save-flow)); the override that serves your guest site is yours, and it has to run as **System Context Without Sharing**: open your override's properties, **Show Advanced**, and set **How to Run the Flow**. Then grant it: Form Flow User only grants the packaged flows, so add your override under **Flow Access** in a permission set of your own and assign it to the guest user. Without that grant the save fails with "You do not have permission to run this form's save process".

**Since 5.3 the packaged save flow, and any override still on the default setting, runs in system context.** To keep each respondent's own access, override it (or open your override), save it as API version 68.0 or later, and set **How to Run the Flow** to **User Context, Enforces User Permissions**; choose System Context only when it serves guests who must update their saved submissions.

Keep the override to saving the submission it receives, and review it like any other code that runs for the public. The [Guest Forms Quickstart](../how-to-guides/guest-forms-quickstart.md#6-set-up-the-save-override-for-guests) walks through the clicks; [Guest users and the upsert override](../form-template-framework/prefill-flow.md#guest-users-and-the-upsert-override) covers the security review and the fault wiring a clone made before 4.46 keeps.

## Guest save override

A guest save needs an override of `(Form) Upsert | Overridable` that runs in System Context Without Sharing, is activated, and is granted to the guest user: add it under **Flow Access** in a permission set you assign to the guest user (the profile works too). It is ordinary Salesforce access, nothing Flow Tool Kit ships. The [Guest Forms Quickstart](../how-to-guides/guest-forms-quickstart.md#6-set-up-the-save-override-for-guests) has the clicks, and the test to run as a guest in a new private window.

## Deploying an override with metadata

- **It may arrive inactive.** Unless the target org has **Deploy processes and flows as active** turned on (Setup, Process Automation Settings), a deployed flow version lands as **Draft**. Activate it after the deploy, or the packaged flow keeps running.
- **Mind the API version.** A flow that uses a local action, such as the toast action, needs the deploying project on API version **63.0 or later**. On API 60 the deployment is refused.
- **A clone made before 4.46** of `(Form) Upsert | Overridable` keeps the fault wiring of its time, under which a refused save ended as "Submitted successfully". See [Guest users and the upsert override](../form-template-framework/prefill-flow.md#guest-users-and-the-upsert-override) for the one connector to move.

## Related pages

- [Prefill Flow](../form-template-framework/prefill-flow.md)
- [Save Progress Email: the Expire Resume Tokens scheduled flow](../form-template-framework/save-progress-email.md#the-expire-resume-tokens-scheduled-flow)
- [Guest Forms Quickstart](../how-to-guides/guest-forms-quickstart.md)
- [NPSP Customizing](../npsp/customizing.md) and [Nonprofit Cloud Customizing](../nonprofit-cloud/customizing.md)
