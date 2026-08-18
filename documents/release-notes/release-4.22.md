# Release 4.22

Reliability fixes for guest submissions and prefill flows, plus a faster, extension-ready embed page.

- **Guest submissions no longer fail after the form is submitted** (#576): community guest users could hit a submission error caused by an internal logging path attempting to stamp an error message onto the submission record from the guest's own context. The stamp only ever applied to conversion logging, so non-conversion modes now skip it silently and guests never see an error for a state they cannot act on.
- **Prefill flow faults can never strand a visitor on the spinner** (#575): the flow runtime reports a finished status even when an autolaunched prefill flow hits an unhandled fault, so the modal now guarantees it always closes and returns control to the form. If your prefill flow can fail, keep returning `hasError = true` with a fault message from the flow itself - fault handling remains the flow author's contract, exactly as before.
- **Embedded forms show a loading indicator immediately** (#579): the embed page (`FlowToolKit__EmbedForm`) previously sat blank for the several seconds Lightning Out needs to boot on a cold visit. A lightweight spinner now paints in under half a second. Generated embed snippets also include connection warm-up hints (`preconnect`) for the hosting site's origin, trimming cold-view latency.
- **Embed page is extension-ready** (#578): the embed page and Embed Code Generator now support embed types contributed by Flow Tool Kit extension packages. The first consumer is the upcoming Stripe Connector payment embed - once that package is installed, a Payment type appears in the generator automatically, configured with the same property editor used in Experience Builder.

**Behavior change**: a hand-built embed URL with an unrecognized `componentType` value now shows "Unknown embed type" instead of silently attempting to run as a screen flow. Snippets produced by the Embed Code Generator are unaffected.

Admins: load your public form pages - including any embedded form URLs - once after upgrading; the first visit pays the component compile so a real visitor doesn't.
