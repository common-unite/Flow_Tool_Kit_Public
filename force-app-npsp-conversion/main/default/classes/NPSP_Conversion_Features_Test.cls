/**End-to-end tests for the Form Template features the NPSP conversion flows share with the packaged conversion: the Conversion Setup action, Form Template Mapping on a Contact section, and anonymous submissions. A respondent (Minimum Access, Form Flow User only) submits the form, as on a live site; the platform-event chain then converts it, as the Automated Process user does in production.**/
@IsTest
private class NPSP_Conversion_Features_Test {

    private static final String RESPONDENT_USERNAME = 'npsp.respondent@example.com.flowtoolkit.testing';
    private static final String HOUSEHOLD_RULES = 'Account;Contact1;Contact1 👉 Add to Account;Contact2;Contact2 👉 Add to Account';
    /**A custom (JSON) Contact section that maps the submission's Company onto the Contact's Department for Contact 1, a field the NPSP field map never sets**/
    private static final String CONTACT_SECTION_JSON = '{"Label":"Volunteer Details","*__ObjectApiName__c":"Contact","*__Submission_Field_Map__c":"{\\"lookupField\\":\\"FlowToolKit__Contact_1__c\\",\\"fields\\":{\\"FlowToolKit__Company__c\\":\\"Department\\"}}","*__sections__r":[]}';
    /**A second Contact section mapped to Contact 2 only, onto a different field, so the test tells which step flow and which lookup filled what**/
    private static final String CONTACT2_SECTION_JSON = '{"Label":"Partner Details","*__ObjectApiName__c":"Contact","*__Submission_Field_Map__c":"{\\"lookupField\\":\\"FlowToolKit__Contact_2__c\\",\\"fields\\":{\\"FlowToolKit__Company__c\\":\\"AssistantName\\"}}","*__sections__r":[]}';

    @TestSetup
    static void setup() {
        npe01__Contacts_and_Orgs_Settings__c orgSettings = npe01__Contacts_and_Orgs_Settings__c.getOrgDefaults();
        orgSettings.npe01__Account_Processor__c = 'Household Account';
        upsert orgSettings;
        npo02__Households_Settings__c householdSettings = npo02__Households_Settings__c.getOrgDefaults();
        householdSettings.npo02__Household_Rules__c = 'No Contacts';
        upsert householdSettings;

        User respondent = new User(FirstName = 'Respondent', LastName = 'User', Email = 'npsp.respondent@example.com', Username = RESPONDENT_USERNAME, Alias = 'npsprsp',
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'Minimum Access - Salesforce' LIMIT 1].Id,
            TimeZoneSidKey = 'America/Los_Angeles', LocaleSidKey = 'en_US', EmailEncodingKey = 'UTF-8', LanguageLocaleKey = 'en_US');
        System.runAs(new User(Id = UserInfo.getUserId())) { /**setup objects in their own context, after the custom settings, or a synchronous run fails with MIXED_DML_OPERATION**/
            insert respondent;
            insert new PermissionSetAssignment(AssigneeId = respondent.Id, PermissionSetId = [SELECT Id FROM PermissionSet WHERE Name = 'Form_Flow_User' AND NamespacePrefix = 'FlowToolKit' LIMIT 1].Id);
        }

        Form_Template__c mapped = new Form_Template__c(Name = 'NPSP Mapped Household', Conversion_Type__c = 'Contact(s)', Account_Record_Type__c = 'HH_Account', Conversion_Rules__c = HOUSEHOLD_RULES, IsActive__c = true);
        Form_Template__c survey = new Form_Template__c(Name = 'NPSP Family Survey', Conversion_Type__c = 'Contact(s)', Account_Record_Type__c = 'HH_Account', Conversion_Rules__c = HOUSEHOLD_RULES, IsActive__c = true);
        insert new List<Form_Template__c>{mapped, survey};
        Form_Template_Page__c page = new Form_Template_Page__c(Form_Template__c = mapped.Id, Page_Label__c = 'Volunteer', Position__c = 1, Visibility__c = 'Both');
        insert page;
        insert new List<Form_Template_Page_Section__c>{
            new Form_Template_Page_Section__c(Form_Template_Page__c = page.Id, Title__c = 'Volunteer Details', Position__c = 1, Component_Type__c = 'Field Set',
                FormConfigJSON__c = JSON.serialize(new Map<String, Object>{'formSelectionMode' => 'json', 'object' => 'Contact', 'formJsonConfig' => CONTACT_SECTION_JSON})),
            new Form_Template_Page_Section__c(Form_Template_Page__c = page.Id, Title__c = 'Partner Details', Position__c = 2, Component_Type__c = 'Field Set',
                FormConfigJSON__c = JSON.serialize(new Map<String, Object>{'formSelectionMode' => 'json', 'object' => 'Contact', 'formJsonConfig' => CONTACT2_SECTION_JSON}))};
    }

    /**Form Template Mapping: the NPSP Contact engine runs Apply Source Object Mappings, so a Contact section's mapping reaches the converted Contact, through the Primary step for a Contact 1 section and the Alternate step for a Contact 2 section. Without that step Department and Assistant Name stay blank.**/
    @IsTest
    static void contactSectionMapping_fillsTheContactFieldTheNpspMapLeavesEmpty() {
        Id submissionId;
        System.runAs(respondent()) {
            submissionId = submit('NPSP Mapped Household', 'Amara', 'Okafor', 'Riverside Food Bank', false);
        }

        Test.startTest();
        runConversion();
        Test.stopTest();

        Form_Submission__c submission = reload(submissionId);
        assertStatusWithLogs('Complete', submission.Conversion_Status__c, submissionId, 'contactSectionMapping');
        Contact amara = [SELECT Department, AssistantName, AccountId, Account.RecordType.DeveloperName FROM Contact WHERE Id = :submission.Contact_1__c];
        System.assertEquals('Riverside Food Bank', amara.Department, 'The Contact section mapping fills Department from the submission Company');
        System.assertEquals(null, amara.AssistantName, 'The Contact 2 section mapping does not apply to Contact 1');
        System.assertEquals('HH_Account', amara.Account.RecordType.DeveloperName, 'The mapping leaves the NPSP Household as the Contact Account');
        System.assertEquals(amara.AccountId, submission.Account__c, 'The Household Contact 1 brought is stamped on the submission');
        Contact partner = [SELECT Department, AssistantName, AccountId FROM Contact WHERE Id = :submission.Contact_2__c];
        System.assertEquals('Riverside Food Bank', partner.AssistantName, 'The Contact 2 section mapping reaches the Alternate step and fills Assistant Name');
        System.assertEquals(null, partner.Department, 'The Contact 1 section mapping does not apply to Contact 2');
        System.assertEquals(submission.Account__c, partner.AccountId, 'Contact 2 joins the same Household');
    }

    /**Anonymous surveys: the packaged before-save flow clears an anonymous submission's names, and the NPSP controller then skips the Account, Contact 1 and Contact 2 rules, so the conversion completes with no person and no Household. Without the anonymous guard Contact 1 runs on a blank last name and the conversion ends in Error.**/
    @IsTest
    static void anonymousSubmission_convertsNoContactOrHousehold() {
        Id submissionId;
        System.runAs(respondent()) {
            submissionId = submit('NPSP Family Survey', 'Jonah', 'Whitfield', null, true);
        }

        Test.startTest();
        runConversion();
        Test.stopTest();

        Form_Submission__c submission = reload(submissionId);
        assertStatusWithLogs('Complete', submission.Conversion_Status__c, submissionId, 'anonymousSubmission');
        System.assertEquals(null, submission.Contact_1__c, 'An anonymous submission links no Contact 1');
        System.assertEquals(null, submission.Account__c, 'An anonymous submission links no Household');
        System.assertEquals(0, [SELECT COUNT() FROM Contact WHERE LastName = 'Whitfield'], 'No Contact is created for an anonymous respondent');
    }

    /**The Conversion Setup action feeds the NPSP controller and the Contact step flows: a named submission converts end to end into one Household with the Contact 1 and Contact 2 rules finished.**/
    @IsTest
    static void namedSubmission_convertsThroughTheConversionSetupAction() {
        Id submissionId;
        System.runAs(respondent()) {
            submissionId = submit('NPSP Family Survey', 'Rosa', 'Delgado', null, false);
        }

        Test.startTest();
        runConversion();
        Test.stopTest();

        Form_Submission__c submission = reload(submissionId);
        assertStatusWithLogs('Complete', submission.Conversion_Status__c, submissionId, 'namedSubmission');
        System.assertEquals('Created', submission.Conversion_Status_Contact_1__c, 'Contact 1 is new');
        System.assertEquals('Created', submission.Conversion_Status_Contact_2__c, 'Contact 2 is new');
        System.assertEquals(2, [SELECT COUNT() FROM Contact WHERE LastName = 'Delgado' AND AccountId = :submission.Account__c], 'Both people are in the one Household on the submission');
    }

    private static User respondent() {
        return [SELECT Id FROM User WHERE Username = :RESPONDENT_USERNAME LIMIT 1];
    }

    /**Contact 1 and a Contact 2 of the same family on one submission, submitted the way the form saves it**/
    private static Id submit(String templateName, String firstName, String lastName, String company, Boolean anonymous) {
        Form_Template__c template = [SELECT Id FROM Form_Template__c WHERE Name = :templateName];
        Form_Submission__c submission = new Form_Submission__c(Form_Template__c = template.Id, Status__c = 'Draft', Submission_Date__c = System.now(), Company__c = company, Anonymous__c = anonymous,
            Contact1_First_Name__c = firstName, Contact1_Last_Name__c = lastName, Contact1_Email__c = firstName.toLowerCase() + '.' + lastName.toLowerCase() + '.npsp.test@example.com',
            Contact2_First_Name__c = 'Sam', Contact2_Last_Name__c = lastName, Contact2_Email__c = 'sam.' + lastName.toLowerCase() + '.npsp.test@example.com');
        insert submission;
        submission.Status__c = 'Submitted';
        update submission;
        return submission.Id;
    }

    private static void runConversion() {
        for (Integer hop = 0; hop < 40; hop++) Test.getEventBus().deliver();
    }

    private static Form_Submission__c reload(Id submissionId) {
        return [SELECT Id, Conversion_Status__c, Conversion_Status_Contact_1__c, Conversion_Status_Contact_2__c, Contact_1__c, Contact_2__c, Account__c FROM Form_Submission__c WHERE Id = :submissionId];
    }

    private static void assertStatusWithLogs(String expected, String actual, Id submissionId, String message) {
        if (expected == actual) return;
        List<String> lines = new List<String>();
        for (Form_Submission_Conversion_Log__c log : [SELECT Status__c, Log_Message__c FROM Form_Submission_Conversion_Log__c WHERE Form_Submission__c = :submissionId ORDER BY CreatedDate]) lines.add(log.Status__c + ': ' + String.valueOf(log.Log_Message__c).replace('\n', ' ^ '));
        System.assert(false, message + ' | expected ' + expected + ' got ' + actual + ' | LOGS >> ' + String.join(lines, ' /// '));
    }
}
