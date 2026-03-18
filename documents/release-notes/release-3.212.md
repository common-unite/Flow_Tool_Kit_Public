# Flow Tool Kit v3.212 Release Notes

## Bug Fixes

### File Upload Fields Now Support Conditional Logic (#77)
File upload fields can now use conditional logic and the "required when condition" setting. Previously, the Form Builder hid these options for file upload fields. Unsupported builder parameters (e.g., formula recalculation, compare record) are now properly hidden for file upload fields.

### Conditional Rules Not Working with Assigned Custom Permission (#78)
Fixed an issue where conditional logic rules that used the "assigned custom permission" condition type were not evaluating correctly. The custom permission check now works as expected in both Flow and Experience Cloud contexts.

### File Upload Field Mapping Bug (#79)
Fixed a critical bug where the second file upload field on a form was incorrectly mapped to `File_Upload_1__c` instead of `File_Upload_2__c`. This caused the second file upload to overwrite the first file's data.

### Missing Fault Handler on File Upload Flow (#80)
Added a fault handler to the `Update_ContentDocuments` element in the file upload flow. Previously, if the content document update failed (e.g., due to permissions or storage limits), the flow would crash without a meaningful error message.
