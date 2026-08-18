# Release 4.23

A focused fix for embedded forms opened directly by URL.

- **Guest behavior now applies when the embed page is opened top-level** (#580): opening `FlowToolKit__EmbedForm` directly as a link (rather than framed inside another website) skipped every guest-specific safeguard, because the platform reports guest users as non-guests under Lightning Out and the iframe check found no frame. The most visible symptom: a guest submitting a form saw a save error even though the submission saved perfectly. All guest safeguards - the successful-create workaround, save-button hiding, confirmation display, autosave suppression, guest file-upload tokens, and IsGuest conditional logic - now also engage whenever the form is served from the embed page itself, framed or not. Embedded-in-a-website behavior is unchanged.

Admins: load your public form pages - including embedded form URLs - once after upgrading; the first visit pays the component compile so a real visitor doesn't.
