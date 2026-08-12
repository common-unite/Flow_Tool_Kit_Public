# Custom Labels Dictionary

> Every text string Flow Tool Kit displays that you can override or translate, what it says out of the box, and exactly where each one appears.

## Overview

Flow Tool Kit renders its own interface text through Salesforce **Custom Labels**. Because they are Custom Labels rather than hardcoded strings, you can do two things without any code:

- **Reword** a message to match your organisation's voice
- **Translate** it into any language your org supports

Every label listed here ships unprotected, which is what makes it overridable in a subscriber org.

> This page is generated from the package source by `scripts/generate-label-dictionary.js`. Do not edit it by hand; regenerate it instead.

## How to translate a label

Translations use the standard Salesforce Translation Workbench. Flow Tool Kit needs no special setup beyond it.

1. **Enable the language.** Setup, then *Translation Workbench*, then *Translation Settings*. Click **Enable**, then **Add** the languages you need and mark them Active.
2. **Assign a translator.** Still under *Translation Settings*, add at least one user as a translator for each language. A user can translate only the languages they are assigned to.
3. **Open the translation editor.** Setup, then *Translation Workbench*, then **Translate**.
4. **Filter to the labels.** Set *Setup Component* to **Custom Label**, then choose your target language. Set *Package* to **Flow Tool Kit** to see only this package's labels.
5. **Enter the translation.** Double-click the *Label Translation* column for a row, type the translated text, and save. Untranslated rows fall back to the English value in the table below.
6. **Verify in the form.** Set your user's *Language* to the target language and reload the form. The label should render translated.

### Which language does a respondent see?

| Surface | Language used |
|---|---|
| Form in an internal Lightning page or Flow | The running user's **Language** setting |
| Form on an Experience Cloud site, logged in | The logged-in user's **Language** setting |
| Form on a public site, guest access | The **site guest user's** Language, which follows the site default |
| Generated PDF | The running user's Language at the moment the PDF is produced |

For a guest-accessible public form, set the language on the site's guest user, since respondents have no user record of their own.

### Rewording without translating

To change the English wording, edit the label's **Value** rather than adding a translation. Setup, then *Custom Labels*, find the label, click **Edit**, and change the Value. This survives package upgrades because these labels are unprotected.

## Reading the dictionary

**Used By** lists the components where each label appears. Two things are worth knowing:

- Some components reach a label through the shared `flowFormBase` base class rather than importing it themselves. Those are marked *(via base)*. The label still displays in that component; it is only the wiring that differs.
- A label showing **not currently referenced** is defined but unused. It is safe to ignore, and translating it has no effect.


## Flow Form

| Label API Name | Display Value | Used By | Purpose |
|---|---|---|---|
| `Confirm` | Confirm | buttonsCustom, flowDataTable | Used within Datatable modals |
| `Save` | Save | flowDataTable *(via base)* | Used within Datatable modals |
| `Save_Form` | Save Form | *not currently referenced* | Save Form |

## Form Builder Template

| Label API Name | Display Value | Used By | Purpose |
|---|---|---|---|
| `Cancel` | Cancel | buttonsCustom, flowDataTable | Cancel |
| `Confirmation_Default` | Your response has been submitted. | formTemplate | Confirmation page body used when a Form Template has no confirmation message of its own |
| `Cancel_Refresh` | Cancel/Refresh | *not currently referenced* | Cancel/Refresh |
| `Next_Page` | Next Page | buttonsCustom | Next Page |
| `Previous_Page` | Previous Page | buttonsCustom | Previous Page |
| `Save_Progress` | Save Progress | formTemplate | Save Progress |
| `Something_Went_Wrong` | Something Went Wrong | *not currently referenced* | Something Went Wrong |
| `Submit` | Submit | buttonsCustom | Submit |
| `Update` | Update | formTemplate | Update |

## Form Builder, Errors

| Label API Name | Display Value | Used By | Purpose |
|---|---|---|---|
| `Error_Additional_Errors` | There are ({0}) additional errors | flowForm *(via base)* | Suffix noting further errors beyond those listed. {0} is the count. |
| `Error_Campaign_Member_Status` | Campaign Member Status Error! | flowForm *(via base)* | Toast title when Campaign Member Status options cannot be resolved |
| `Error_Fix_Before_Submit` | Please correct the highlighted fields before continuing. | formTemplate | Toast body when a page or review screen cannot be submitted because fields are still invalid |
| `Error_Save_Record_Not_Identified` | We could not save your changes. Please refresh the page and try again. | formTemplate | Toast body when a save is abandoned because the record to update could not be identified. Pairs with the `Error_Save_Failed` title. |
| `Error_Component_Loading` | Component is still loading: Please try again | flowForm *(via base)* | Shown when the respondent advances before the form has finished loading |
| `Error_Form_Load` | Form Load Error | flowForm *(via base)*, flowFormRepeat *(via base)* | Toast title when the form metadata fails to load |
| `Error_Formula_Recalculation` | Formula Recalculation Error | flowForm *(via base)* | Toast title when live formula recalculation fails |
| `Error_Hierarchy_Assignment` | Hierarchy Assignment Error | flowForm *(via base)* | Toast title when a hierarchy field assignment fails |
| `Error_Hierarchy_Validation` | Hierarchy Assignment Validation Errors | flowForm *(via base)* | Toast title when hierarchy assignment returns validation errors |
| `Error_No_Edit_Access` | You do not have edit access to {0}. Your administrator must grant Edit permission on this object before your progress can be saved. | formTemplate | Toast body when the running user cannot update the records a save requires. {0} is the object label, or a comma separated list of them. See [Permission Sets](../getting-started/permission-sets.md) |
| `Error_Object_Access` | Object Access Error! | flowDataTable *(via base)*, flowForm *(via base)*, flowFormLookup *(via base)*, flowFormRepeat *(via base)*, formTemplate | Toast title when the running user cannot access the form's object |
| `Error_Prefill_Flow` | Prefill Flow Error | formTemplate *(via base)* | Toast title when the prefill flow fails |
| `Error_Record_Load` | Record Load Error | flowForm *(via base)* | Toast title when the parent record fails to load |
| `Error_Resolve_Validation` | Resolve Validation Errors | flowForm *(via base)*, flowFormRepeat *(via base)* | Toast title listing outstanding field validation errors |
| `Error_Retrieve_Edit_Form` | Retrieve Edit Form Error | flowFormRepeat *(via base)* | Toast title when a repeater's edit form cannot be retrieved |
| `Error_Save_Failed` | Save Failed | formTemplate *(via base)* | Toast title when the submission fails to save |
| `Error_Save_Flow_Flagged` | The save flow flagged an error and stopped. | formTemplate *(via base)* | Shown when the upsert override flow reports hasError without a message |
| `Error_Save_Flow_Returned` | The save flow returned an error. Contact your administrator. | formTemplate *(via base)* | Shown when the upsert override flow errors outright |
| `Error_Select_Date_Time` | You must select at least one date and time | flowDateTimePicker | Validation message when no date and time has been chosen |
| `Error_Selection_Required` | Selection is required! | flowDateTimePicker | Short validation message when a selection is mandatory |
| `Error_Unexpected` | Oops! Something went wrong. | flowForm *(via base)*, formTemplate *(via base)* | Generic toast title for an unclassified failure |
| `Field_Not_Accessible` | Field is not accessible! Review FLS Permissions | flowFormField *(via base)* | Placeholder shown in place of a field the running user cannot see |
| `Field_Not_Accessible_User` | Field is not accessible for current User: Contact your System Administrator for more details | flowFormField *(via base)* | Tooltip on an inaccessible field |
| `Field_Not_Readable_User` | Field is not readable for current User: Contact System Administrator for more details | flowFormFieldAddress | Tooltip on an unreadable address field |

## Form Builder, Likert

| Label API Name | Display Value | Used By | Purpose |
|---|---|---|---|
| `Likert_Answered_Suffix` | answered | flowFormLikertMatrix | Likert Matrix total row count suffix - renders after "X of Y" |
| `Likert_Partial` | Partial | flowFormLikertMatrix | Likert Matrix total row pill while not all rows are answered |
| `Likert_Row_Error` | Please select an answer to continue. | flowFormLikertMatrix | Likert Matrix inline error under an unanswered required row |
| `Likert_Total_Score` | Total Score | flowFormLikertMatrix | Likert Matrix total row default label when Total_Score_Label__c is blank |

## Form Builder, Stages

| Label API Name | Display Value | Used By | Purpose |
|---|---|---|---|
| `Stages_Complete` | Complete | formTemplateStageRow | Stage row badge - done state |
| `Stages_Complete_Suffix` | complete | formTemplateStages | Progress card - text after the percent number ("XX% complete") |
| `Stages_Conditional` | Conditional | formTemplateStageRow | Stage row badge - page rendered by conditional logic |
| `Stages_Continue_To_Review` | Continue to Review | formTemplate | Open-review button fallback when Review_Page_Button_Label__c is blank |
| `Stages_Draft_Saved` | Draft saved | formTemplateStages | Stages header - "Draft saved" prefix before the relative time |
| `Stages_Email_Me_Resume_Link` | Email me a resume link | formTemplateStages | Stages header - "Email me a resume link" button label |
| `Stages_Error_Singular` | error | formTemplateStageRow | Stage row meta - singular ("1 error") |
| `Stages_Errors_Plural` | errors | formTemplateStageRow | Stage row meta - plural ("N errors") |
| `Stages_Expand` | Expand | formTemplateStageRow | Stage row - accessible alternative text for the expand chevron |
| `Stages_Fields` | fields | formTemplateStageRow | Stage row meta - fields suffix ("X/Y fields") |
| `Stages_Fix_Errors` | Fix errors | formTemplate | Stages action button - requires-correction state |
| `Stages_In_Progress` | In progress | formTemplateStageRow | Stage row badge - in-progress state |
| `Stages_Locked` | Locked | formTemplateStageRow | Stage row badge - locked state |
| `Stages_Mark_Complete` | Mark Complete | formTemplate | Stages-mode NEXT button label - flips the current stage to Done |
| `Stages_Needs_Attention` | Needs attention | formTemplateStageRow | Stage row badge - requires-correction state |
| `Stages_Needs_Attention_Suffix` | needs attention | formTemplateStages | Progress card - text after the error count ("N needs attention") |
| `Stages_Optional` | Optional | formTemplateStageRow | Stage row badge - optional page |
| `Stages_Remaining` | remaining | formTemplateStages | Progress card - text after the minutes-remaining estimate ("~Nm remaining") |
| `Stages_Required_Steps_Complete` | required steps complete | formTemplateStages | Progress card - text after "X of Y" count |
| `Stages_Resume` | Resume | formTemplate | Stages action button - in-progress or has-started state |
| `Stages_Resume_Link_Error` | Could not send resume link - please try again. | formTemplate | Toast message when the resume-link request fails |
| `Stages_Resume_Link_Sent` | Resume link email sent | formTemplate | Toast message after the user requests a resume link |
| `Stages_Review_Answers` | Review answers | formTemplate | Stages action button - done state |
| `Stages_Section_Singular` | section | formTemplateStageRow | Stage row meta - singular ("1 section") |
| `Stages_Sections_Plural` | sections | formTemplateStageRow | Stage row meta - plural ("N sections") |
| `Stages_Start_Step_Fallback` | Start Step | formTemplate | Stages action button - fallback when Page.Button_Label__c is blank |

## Form Builder, Validation

| Label API Name | Display Value | Used By | Purpose |
|---|---|---|---|
| `Complete_This_Field` | Complete this field. | flowFormCheckbox, flowFormNumberInput, flowFormPathPicklist, flowFormRadioCheckbox, flowFormVisualPicker, flowFormField *(via base)* | Inline validation message on a required field left empty |

## Form Builder

| Label API Name | Display Value | Used By | Purpose |
|---|---|---|---|
| `Active` | Active | flowFormCheckbox | Boolean Picklist Override |
| `Disabled` | Disabled | flowFormCheckbox | Boolean Picklist Override |
| `Enabled` | Enabled | flowFormCheckbox | Boolean Picklist Override |
| `False` | False | flowFormCheckbox | Boolean Picklist Override |
| `Inactive` | Inactive | flowFormCheckbox | Boolean Picklist Override |
| `Invalid` | Invalid | flowFormCheckbox | Boolean Picklist Override |
| `No` | No | flowFormCheckbox | Boolean Picklist Override |
| `Off` | Off | flowFormCheckbox | Boolean Picklist Override |
| `On` | On | flowFormCheckbox | Boolean Picklist Override |
| `True` | True | flowFormCheckbox | Boolean Picklist Override |
| `Valid` | Valid | flowFormCheckbox | Boolean Picklist Override |
| `Yes` | Yes | flowFormCheckbox | Boolean Picklist Override |

## Form Buttons

| Label API Name | Display Value | Used By | Purpose |
|---|---|---|---|
| `View_Details` | View Details | flowFormRepeat *(via base)* | View Details (Repeater Button) |

## Form Conditions Editor

| Label API Name | Display Value | Used By | Purpose |
|---|---|---|---|
| `conditionType` | Condition Type | *not currently referenced* | conditionType |
| `customLogic` | Custom Logic | *not currently referenced* | customLogic |

## Form Editor

| Label API Name | Display Value | Used By | Purpose |
|---|---|---|---|
| `backgroundColor` | Background Color | *not currently referenced* | backgroundColor |
| `displayConditionalRule` | Display Conditional Rule | *not currently referenced* | displayConditionalRule |
| `displayType` | Display Type | *not currently referenced* | displayType |
| `fontColor` | Font Color | *not currently referenced* | fontColor |
| `FormSections` | Form Sections | *not currently referenced* | Form Sections |
| `helpText` | Help Text | *not currently referenced* | helpText |
| `iconColor` | Icon Color | *not currently referenced* | iconColor |
| `iconName` | Icon Name | *not currently referenced* | iconName |
| `InsertNewSection` | New Section | formBuilderSection *(via base)* | Insert New Section Button |
| `label` | Label | *not currently referenced* | label |
| `NewSection` | New Section | *not currently referenced* | New Section |
| `readOnly` | Read Only | *not currently referenced* | readOnly |
| `required` | Required | flowFormFieldLabel, flowFormLikertMatrix | required |
| `sectionWidthLarge` | Section Width Large | *not currently referenced* | sectionWidthLarge |
| `subtitle` | Subtitle | *not currently referenced* | subtitle |
| `title` | Title | *not currently referenced* | title |
| `WidthLarge` | Desktop Width | *not currently referenced* | WidthLarge |
| `WidthMedium` | Tablet Width | *not currently referenced* | WidthMedium |
| `WidthSmall` | Mobile Width | *not currently referenced* | WidthSmall |

## Form Field Editor

| Label API Name | Display Value | Used By | Purpose |
|---|---|---|---|
| `fieldFormat` | Field Format | *not currently referenced* | fieldFormat |
| `fieldFormatAlert` | Format Alert Message | *not currently referenced* | fieldFormatAlert |
| `labelPosition` | Label Position | *not currently referenced* | labelPosition |

## Form Section Editor

| Label API Name | Display Value | Used By | Purpose |
|---|---|---|---|
| `hideSectionHeader` | Hide Header | formBuilderSection *(via base)* | hideSectionHeader |
| `SectionHeader` | Section Header | formBuilderSection *(via base)* | SectionHeader |
| `sectionHelpText` | Section Help Text | *not currently referenced* | sectionHelpText |
| `sectionSubtitle` | Section Subtitle | *not currently referenced* | sectionSubtitle |
| `sectionTheme` | Section Theme Overrides | formBuilderSection *(via base)* | sectionTheme |
| `sectionTitle` | Section Title | *not currently referenced* | sectionTitle |
| `sectionWidthMedium` | Section Width Medium | *not currently referenced* | sectionWidthMedium |
| `sectionWidthSmall` | Section Width Small | *not currently referenced* | sectionWidthSmall |
| `selectFields_Assigned` | Assigned | formBuilderSection *(via base)* | selectFields_Assigned |
| `selectFields_Available` | Available | formBuilderSection *(via base)* | selectFields_Available |
| `selectFields_FieldLevelHelp` | Use picklist to assign and order fields within this section | formBuilderSection *(via base)* | selectFields_FieldLevelHelp |
| `selectFields_Label` | Select Fields | *not currently referenced* | selectFields_Label |
| `showSectionHeader` | Show Header | formBuilderSection *(via base)* | showSectionHeader |

## Form Table

| Label API Name | Display Value | Used By | Purpose |
|---|---|---|---|
| `Filter_Records` | filter records | flowDataTable *(via base)* | Filter Records |
| `Filtered_Totals` | Filtered Totals | flowDataTable *(via base)* | Filtered Totals |
| `Grand_Totals` | Grand Totals | flowDataTable *(via base)* | Grand Totals |
| `Selected_Totals` | Selected Totals | flowDataTable *(via base)* | Selected Totals |
| `Total_Selected` | Total Selected | flowDataTable *(via base)* | Total Selected |

## Form Upload Image

| Label API Name | Display Value | Used By | Purpose |
|---|---|---|---|
| `Image_Size_Error` | Image Size Error | imgUpload *(via base)* | Image Size Error |
| `Image_Size_Error_Message` | Max image size 1 mb | imgUpload *(via base)* | Max image size 1 mb |
| `Invalid_File_Type` | Invalid File Type | imgUpload *(via base)* | Invalid File Type |
| `Invalid_File_Type_Message` | Image type must be either png or jpg | imgUpload *(via base)* | Image type must be either png or jpg |
| `Remove_Image` | Remove Image | imgUpload *(via base)* | Remove Image |

## Form

| Label API Name | Display Value | Used By | Purpose |
|---|---|---|---|
| `Available` | Available | flowFormField | Multiselect Picklist Column Header |
| `Chosen` | Chosen | flowFormField | Multiselect Picklist Column Header |
| `Return` | Return | formTemplate, imgUpload *(via base)* | Return |
| `Select` | Select | flowFormField, flowFormRepeaterButton | Used in repeater and table components |
| `Select_an_Option` | Select an Option | comboBox, flowFormField | Select an Option |
| `Selected` | Selected | flowFormRepeaterButton | Used in repeater and table components |
| `Unselect` | Unselect | flowFormRepeaterButton | Used in repeater and table components |

## Header

| Label API Name | Display Value | Used By | Purpose |
|---|---|---|---|
| `Header` | Header | *not currently referenced* | Header |
| `showHeader` | Show Header | *not currently referenced* | showHeader |

## Site Design Block, Errors

| Label API Name | Display Value | Used By | Purpose |
|---|---|---|---|
| `Free_Version_Block_Subtitle` | Site Design Blocks work on Account, Contact, Case, Lead and Form Template records in the free version. Upgrade to use them on other objects. | siteDesignBlock | Illustration subtitle listing the objects free supports |
| `Free_Version_Block_Title` | Not available in free version | siteDesignBlock | Illustration title when a block sits on an object free excludes |

## Table Builder, Errors

| Label API Name | Display Value | Used By | Purpose |
|---|---|---|---|
| `Error_Retrieve_Table_Form` | Retrieve Table Form Error | flowDataTable *(via base)* | Toast title when a table's row form cannot be retrieved |
| `Error_Retrieve_Table_Form_Bulk` | Retrieve Table Form (Bulk) Error | flowDataTable *(via base)* | Toast title when a table's bulk-edit form cannot be retrieved |
| `Error_Table_Minimum_Selection` | You must select at least ({0}) record(s) | flowDataTable *(via base)* | Toast body for the minimum row selection rule. {0} is the required count. |
| `Error_Table_Selection_Required` | Table Selection is Required! | flowDataTable *(via base)* | Toast title when a table requires a row selection |

## Summary

- **138** custom labels ship with Flow Tool Kit
- **105** are referenced by at least one component
- **33** are defined but not currently referenced
- All are **unprotected**, so every one can be reworded or translated in a subscriber org
