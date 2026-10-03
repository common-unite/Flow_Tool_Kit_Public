# Overriding Packaged Flows

Flow Tool Kit ships its automation as flows marked **overridable**: the save flow `(Form) Upsert | Overridable`, the prefill and resume flows, and every conversion engine and step flow. Overridable means you can replace one with a flow of your own, and the package keeps calling the replacement. This page covers the two ways to do that, what each one changes, and the three things that trip people up when the override serves guests or travels through a deployment.

## Two routes

**A flow override.** Open the packaged flow in Flow Builder and choose **Save As**. Because the packaged flow is overridable, Flow Builder opens **Save as flow override** instead of a plain copy; give the new flow a label and API name, make your changes, and **Activate** it. From then on everything that names the packaged flow runs yours: the form's save, the prefill and resume calls, subflow calls, and the conversion dispatcher. Nothing else needs pointing at it. In metadata the override is an ordinary flow whose `overriddenFlow` names the packaged flow.

**A plain clone.** Save a copy without the override link and point the package at it explicitly: a Form Template's Flow API Name fields for one template, or the Form Template Conversion Mapping Default records for the whole org. The NPSP and Nonprofit Cloud Customizing pages describe this route for the conversion step flows. A clone only runs where something names it.

{% hint style="info" %}
**The packaged name is what you will keep seeing.** The Conversion Map picklists, the mapping default records, a template's Flow API Name fields, the dispatch counters and the conversion log all carry the name the call was made with, which is the packaged flow's. None of them can tell you that an override ran. To know, open the packaged flow in Setup and look for its override, or search your retrieved metadata for `overriddenFlow`.
{% endhint %}

## Overrides that serve guests run in system context

Guests save through `(Form) Upsert | Overridable`, and a guest can insert a Form Submission but never update one or stamp it with a record they cannot read. The package ships every flow in the default (user) context and never in system context; the override that serves your guest site is yours, and it has to run as **System Context Without Sharing**: open your override's properties, **Show Advanced**, and set **How to Run the Flow**. Then grant it: Form Flow User only grants the packaged flows, so add your override under **Flow Access** in a permission set of your own and assign it to the guest user. Without that grant the save fails with "You do not have permission to run this form's save process".

Keep the override to saving the submission it receives, and review it like any other code that runs for the public. The [Guest Forms Quickstart](../how-to-guides/guest-forms-quickstart.md#6-set-up-the-save-override-for-guests) walks through the clicks; [Guest users and the upsert override](../form-template-framework/prefill-flow.md#guest-users-and-the-upsert-override) covers the security review and the fault wiring a clone made before 4.46 keeps.

## The installer's guest save override

Since 4.46 the installer offers an optional step on a first install, **Install the Guest Save Override (inactive)**, checked by default on the Install, Nonprofit Cloud and NPSP plans. It deploys a copy of `(Form) Upsert | Overridable` as a flow override named **(Form) Upsert | Guest Override** (`Form_Submission_Upsert_Guest`) in System Context Without Sharing, **inactive**, together with the permission set **Form Flow (Guest User)** (`Form_Flow_Guest_User`) that grants it. Both are unmanaged metadata of your own; the package still ships nothing in system context.

What the step leaves to you, by design:

1. Review the override in Flow Builder, as you would any code that runs for the public.
2. **Activate** it. Until then the packaged flow keeps serving every save.
3. Assign **Form Flow (Guest User)** to the site's guest user alongside Form (Flow User).

The step runs on a first install only. A re-run of setup and the Upgrade plan skip it, so the permission set is never replaced: Flow Tool Kit extension installers add their own guest grants to **Form Flow (Guest User)**, and so can you. An org installed before 4.46 keeps the override it built; the copy the installer would have deployed is the same flow, so there is nothing to migrate.

{% hint style="info" %}
**Test in a new guest session.** A guest session that started before the override was activated, or before the permission set was assigned, keeps running with what it had and still fails with "You do not have permission to run this form's save process". Open the form in a fresh private window, or log out of the site at `https://<site domain>/<site path>/secur/logout.jsp` and load the form again.
{% endhint %}

## Deploying an override with metadata

- **It may arrive inactive.** Unless the target org has **Deploy processes and flows as active** turned on (Setup, Process Automation Settings), a deployed flow version lands as **Draft**. Activate it after the deploy, or the packaged flow keeps running.
- **Mind the API version.** A flow that uses a local action, such as the toast action, needs the deploying project on API version **63.0 or later**. On API 60 the deployment is refused.
- **A clone made before 4.46** of `(Form) Upsert | Overridable` keeps the fault wiring of its time, under which a refused save ended as "Submitted successfully". See [Guest users and the upsert override](../form-template-framework/prefill-flow.md#guest-users-and-the-upsert-override) for the one connector to move.

## Related pages

- [Prefill Flow](../form-template-framework/prefill-flow.md)
- [Guest Forms Quickstart](../how-to-guides/guest-forms-quickstart.md)
- [NPSP Customizing](../npsp/customizing.md) and [Nonprofit Cloud Customizing](../nonprofit-cloud/customizing.md)
