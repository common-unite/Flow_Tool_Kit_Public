# Release 4.1

> 99 ready-made Form Submission fields so clients build their first form without creating any, a grant application demo suite showing them off, and two fixes worth having.

## 🆕 New Features

- **Form Submission field expansion (#263)**: 99 packaged fields take Form Submission from 132 to 231, so admins map forms without creating fields first. Standard-object mapping gaps (contact parity, mailing address block, business fields, attribution, contact preferences), generic question shapes (ten short texts, five booleans, five numbers, three dates, two URLs), rating-scale batteries sized for instant Likert Matrix sections (Agreement ×10, Satisfaction ×5, Frequency ×5, star Rating ×5, 0-10 Scale ×3, Total Score ×3), nonprofit staples (emergency contact, volunteer and event fields, opt-ins), and demographics. Every picklist ships unrestricted with its complete value set, every field carries a purpose description, and all three permission sets grant every field. Zero new lookups, so the shared relationship pool is untouched. 📚 [Form Submission](../form-template-framework/form-submissions.md)
- **Grant application demo suite (#263)**: thirteen modular, interchange-ready components (legal information with EIN validation, scored capacity self-assessment Likert, preset-tier requested amount, attestation and signature certification, and more) wired into the FY26 Community Impact Grant stages demo. Ships unpackaged with the dev org build; the References stage appears only for requests over $50,000, driven by the preset amount chips.

## 🛠️ Fixes

- **Guest first-save error (#262)**: the packaged save flow's sequencer re-dispatched a just-inserted record into its update element, showing guests INSUFFICIENT_ACCESS on a successful save and silently double-updating for everyone else. First saves now skip the redundant update entirely.
- **Record forms on objects without MRU (#266)**: object-info reports LastReferencedDate and LastViewedDate even when an object has no tab, crashing derived queries. Both record-form components now skip MRU-only fields.

## Upgrade

4.1 is flagged as the package's recommended version: open Setup → Installed Packages → **Upgrade to Recommended Version**.

The complete 4.0 milestone notes (everything since 3.196) follow on the [release page](https://github.com/common-unite/Flow_Tool_Kit_Public/releases/tag/release%2F4.1.0.1) and in [Release 4.0](release-4.0.md).
