# Release 4.30

Pre-fill mappings can now say **"today"** instead of a fixed date, and the generated embed code is readable again.

- **Use the current date in a pre-fill mapping** (#617): in **Assign Pre-fill Values**, a Date or Date/Time field now has a **Current date** / **Current date/time** toggle beside it. Turn it on and the field is filled with the date at the moment the form is opened, rather than the date you happened to pick while setting it up. An **Offset** box appears alongside for a number of days either way, so a due date thirty days out or a cut-off a week back are both a single setting. The field keeps showing what the value resolves to today, so you can see what the respondent will get.
- **This matters most for embedded forms.** Pre-fill values are written into the embed snippet that gets pasted onto your website, so a fixed date is frozen there until somebody remembers to regenerate the code. A relative one never goes stale.
- **Existing mappings are untouched.** A pre-fill value that is a specific date stays exactly that, and the toggle simply stays off.
- **Readable embed code for payment forms** (#616): the **Pre-fill** values inside a generated payment embed snippet were being written as one long, escaped line of text that could not be read or safely edited. They are now laid out like the rest of the configuration. The code the browser sends is unchanged, so existing embeds keep working exactly as before and there is nothing to regenerate unless you want the tidier version.

Admins: load your public form pages, including any embedded form URLs, once after upgrading; the first visit pays the component compile so a real visitor does not.
