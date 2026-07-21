# Release 4.2

> The conversion pipeline, rebuilt around one action. Every step of submission conversion — start, convert, log, hand back — now runs through a single mode-driven **Conversion Event** action with a guided property editor, so customizing conversion means editing readable flows instead of decoding platform-event plumbing. Clean logs, no silent failures, and Campaign Members that chain themselves.

## 🆕 Conversion, simplified (#288)

- **One action, four modes**: `Form Template | Conversion Event` replaces the old spread of record-creates, derivation formulas, and a retired logging subflow. Every conversion flow — packaged or your own override — calls the same action in **Start**, **Convert to Record**, **Log**, or **Return to Controller** mode. The 77 per-flow derivation formulas are gone; the event carries its own field names.
- **A guided property editor**: pick the mode and the editor shows exactly what that mode needs — a grouped conversion-flow picker (template formulas, picklist overrides, metadata defaults, active flows), status and lookup field pickers, and automatic binding of the standard `FormSubmission`/`FormTemplate` variables with a manual fallback.
- **Readable conversion logs (#299)**: dispatch steps are silent now. A conversion reads the way you'd tell it: **Start once → each outcome (Created / Matched / Updated, or the error) → Finish.** Related-record rows log against both the row and the parent submission.
- **Campaign Members chain themselves (#300)**: membership conversion moved out of the controller and into the Contact and Lead upserts — the moment a person converts, their Campaign Member follows, for main submissions and related rows alike. Two controller passes gone.
- **Exact-match rule gates**: controller rules now test the template's Conversion Rules with true multiselect matching (`INCLUDES` flow formulas) instead of substring checks, so a custom picklist value can never false-positive another rule. Sub-action options (addresses, campaign membership) no longer masquerade as conversion triggers — enable the base rule, and sub-actions refine it.
- **Related records honor your overrides (#287)**: every captured repeater/table row dispatches through the section's resolved conversion flow — the packaged default *or* the section's Conversion Map Flow override, which the old sweep ignored. The section override picker now also appears on the page-section Customize modal's Conversion tab.

## 🛠️ No conversion failure is silent anymore

- **Blank dispatches log (#283)**: an event with no flow name used to vanish; now it writes an Error to the Conversion Log and marks the submission.
- **Queueable failures log (#284)**: a conversion flow that dies mid-dispatch used to disappear into a debug statement; now the submission goes to Error with the exception in its log.
- **Unresolvable modes refuse loudly**: a Convert step that can't resolve a flow logs an Error instead of publishing an event the dispatcher would discard.
- **Related rows finish (#289)**: converted rows are stamped Complete, so the controller stops re-sweeping them.
- **Runaway protection (#295)**: a per-run dispatch counter refuses a misconfigured flow after five identical dispatches — with a log entry explaining which flow looped and why. Fails open: the guard can never be the reason a conversion stops.
- **Chain stalls fixed**: the Account update path now returns to the controller like its siblings, and the related-records sweep resolves each row's flow from the loop's own section.

## 🧰 Also in this release

- **Preview sections render full width again (#298)**: record-page previews stopped stretching tables to infinity and shrink-wrapping narrow sections.
- **Conversion test coverage (#294)**: a consolidated Apex suite drives the dispatcher and every packaged step flow — insert, update, error, and log paths.
- **Conversion test data**: fresh dev orgs seed an all-rules "Conversion Test" template with a fully-populated draft submission and three related-record rows, ready to fire by hand.
- **Legacy cleanup (#286, #285)**: the orphaned Log Event flow is retired (the action is a full superset), and Order conversion stays as mapping-only config by decision — no Order lookup ships, keeping the package free of an Orders dependency.

## Upgrade

Existing subscriber flows keep working: Log mode is the default on every legacy call site, the retired flow remains callable in orgs that already have it, and frozen clones resolve field names from the event. **One check for orgs with customized Upsert Contact/Lead clones**: Campaign Member conversion for main submissions now lives in those flows — refresh clones from the new packaged versions (or add the Add-to-Campaign gate) to keep memberships flowing.
