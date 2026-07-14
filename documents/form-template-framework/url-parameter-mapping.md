# URL Parameter Mapping

> Capture values straight from the link: map URL query parameters into Form Submission fields the moment a Form Template loads.

## Overview

Every link you share can carry context: which ad brought the respondent here, which event they're registering for, which payment just completed. **URL Parameter Mapping** captures that context automatically: when a new submission loads, mapped query parameters are read from the page URL and written into the Form Submission's fields before the respondent types a thing.

Typical uses:

* **Marketing attribution**: capture `utm_source`, `utm_medium`, `utm_campaign`, `utm_term`, and `utm_content` into fields for ROI reporting
* **Link-specific values**: pass `pv1` through `pv9` general-purpose parameters (a referral code, a location, a program name) from any link you generate
* **Payment hand-offs**: capture `payment_intent` after a Stripe redirect
* **Event routing**: capture an `eventType` to drive conditional logic inside the form

## Configuration

1. Open the **Form Template** record.
2. Run the **URL Parameter Mapping** quick action.
3. For each mapping, pick the **URL parameter** (pv1–pv9, the five UTM parameters, `payment_intent`, or `eventType`) and the **Form Submission field** it should populate. Internal/system fields are excluded from the picker.
4. Save. The mappings store as JSON on the template's `URL Parameter Mapping` field.

<!-- [CAPTURE NEEDED: URL Parameter Mapping quick action editor + a form loading with a utm_source captured] -->

## Behavior

* Mappings apply to **new submissions only**; a respondent resuming a saved draft keeps their saved values.
* Mappings apply when the template loads **outside of Flow context** (record pages, Experience Cloud, iframe embeds); inside a Flow, pass values as Flow inputs instead.
* Captured values behave like any other answer: they appear in mapped fields, participate in [conditional logic](../form-configuration/conditional-logic.md), and flow through [conversion](how-to/overridable-conversion-flows.md).

{% hint style="info" %}
The `pv1`–`pv9` parameters are the same general-purpose parameters used by [iframe embeds](../advanced-topics/iframe-embed.md), so an embedded form and a directly-linked form can share one mapping configuration.
{% endhint %}

## Related Pages

- [Form Template Sources](form-template-sources.md): per-source context for reusable templates
- [Prefill Flow](prefill-flow.md): prefill from the running user's data instead of the URL
- [Iframe Embed](../advanced-topics/iframe-embed.md): passing pv1–pv9 into embedded forms
