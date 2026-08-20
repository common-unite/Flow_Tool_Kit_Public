# Release 4.25

Edit Message in the record-form property editor works again.

- **Edit Message opens its editor instead of an empty modal** (#591): clicking **Edit Message** (the confirmation message) in the record-form property editor, whether in Experience Builder or the Embed Code Generator, opened an empty modal and then blocked every later dialog until the page was reloaded. The rich text editor now opens normally and later dialogs such as **Assign Pre-fill Values** are unaffected. Affected 4.20 through 4.24.
