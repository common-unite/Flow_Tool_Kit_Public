# Release 4.36

Four bug fixes and four improvements, most of them from client reports on multi-page forms and the conversion pipeline. Nothing changes shape: existing forms, templates, flows and settings keep working as before.

## 🛠 Flow sections that return related records now convert (#672)

A Flow section that hands rows back through its `relatedRecords` output serializes numbers as numbers, and the conversion step that turns saved rows into records expected text. A row carrying a Currency, Percent or Number value failed with `Invalid conversion from runtime type Integer to String` and the submission stopped converting.

The deserializer now accepts numbers, dates, times and multi-select values in their native form. Two related gaps closed with it: a Datetime carrying a time zone was silently read as the converting user's local time and shifted by their offset, and a Time value could never be saved at all. When a value still cannot be converted, the conversion log names the field, its type and the value instead of a bare cast error.

Rows returned by a Flow section also carried only their section id. They now receive the same related-record keys a Repeater row gets, so they are picked up by the related-records conversion pass, appear under their parent instead of as separate submissions, and each row has its own upsert key.

If a submission is stuck with this error in its conversion log, reprocess it after upgrading. The stored rows convert as they are; nothing needs to be re-entered.

## 🛠 Page rules on User Profile or User Role no longer crash the form (#671)

A Form Template page whose conditional logic referenced `User.Profile` or `User.Role` failed to render with `getFieldValue is not defined`. The import was missing; the rule now evaluates.

## 🛠 Headers sit flush again (#665)

Since 4.34 every header carried a default bottom margin, so a header's bottom rule floated a few pixels above the accordion or first field row. The margin is gone. Sections with no theme space their own content under the header, and an explicit bottom margin on a header still applies.

## 🆕 Review screen points at the sections that blocked a submit (#521)

A failed submit from the review screen outlines each section holding an invalid field with "Review this section for errors." and jumps to the first one. Edit clears the outline. Previously the toast said something was invalid and nothing on the page said where.

## 🆕 Confirmation page only on the first submit (#669)

An internal user reopening a submitted form and saving again no longer sees the confirmation page. They get a success toast and the form reloads. The first submit of a draft still shows the confirmation page, and guests, embeds and external users are unchanged.

## 🆕 Save Changes on every page for reviewers (#670)

An internal user opening a submitted multi-page form gets a Save Changes button on every page, whether or not Save Progress is enabled on the template. It validates and saves the current page so a reviewer can change one thing and leave without walking to the last page. On the last page and the review screen the Update button reads Save Changes. External users and guests still see Update.

## 🆕 Record form Save stays enabled on an invalid form (#664)

The Record Form component disabled Save whenever the form was invalid, with no message saying why, which was worst on required fields with a hidden label. Save now disables only while a save is running; clicking it on an invalid form toasts the required field by name and highlights it.

## 🛠 File Name Format resolves record merge fields (#663)

A file upload's File Name Format only understood `{{label}}` and `{{filename}}`. It now also merges fields from the current record, so `Receipt | {{Disbursement_Number__c}} | {{filename}}` produces `Receipt | FD-0042 | invoice.pdf`. A merge field missing from the record resolves to blank.

## After upgrading

Load each of your public form pages once. The first page load after any package upgrade pays a one-off server-side compile of several seconds, and it is better absorbed by you than by a visitor.
