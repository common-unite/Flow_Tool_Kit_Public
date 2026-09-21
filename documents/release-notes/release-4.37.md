# Release 4.37

Two bug fixes. Nothing changes shape: existing forms, templates, flows and settings keep working as before.

## PDFs

- **View PDF works again** (#674): the PDF pages (`FormSubmissionPrint`, `FormSubmissionSimplePrint`, `FormTemplatePrint` and `FormTemplateSimplePrint`) set a download file name containing the submitted date, and the date's comma was not quoted. Chrome read the comma as a second header value and refused the whole response, so the View PDF tab showed "vf.force.com sent an invalid response" instead of the PDF. The file name is now quoted, and a missing template or submission name no longer breaks it.

## Custom LWC sections

- **No more console logging from custom LWC sections** (#673): since 4.34 every custom Lightning Web Component page section wrote "SECTION SET" and a full copy of its section record to the browser console each time it rendered. The logging and the copy are gone.
