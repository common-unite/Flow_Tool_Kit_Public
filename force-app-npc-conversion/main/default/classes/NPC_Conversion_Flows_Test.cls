/**What the NPC flows took over from base 5.4: anonymous submissions, the template's Contact (Record Type), whole-name matching rules, Form Template Mapping in the Account engine and the Account rule gate. Every test builds its data as a Minimum Access user holding only the Form Builder Admin permission set, the way the package build and a subscriber's admin run it.**/
@IsTest
private class NPC_Conversion_Flows_Test {

    private static final String TEST_USERNAME = 'npcconversionflows@example.com.flowtoolkit.testing';
    private static final String HOUSEHOLD_ONLY_RULES = 'Account;Account is Household';
    private static final String PEOPLE_RULES = 'Contact1';
    private static final String ANONYMOUS_LEAD_TEXT = 'FlowToolKit Anonymous';

    @TestSetup
    static void setup() {
        User testUser = new User(FirstName = 'Npc', LastName = 'Flows', Email = 'npcflows@example.com', Username = TEST_USERNAME, Alias = 'npcflows',
                ProfileId = [SELECT Id FROM Profile WHERE UserType = 'Standard' AND UserLicense.LicenseDefinitionKey = 'SFDC' AND PermissionsViewSetup = false AND PermissionsApiEnabled = false ORDER BY CreatedDate LIMIT 1].Id,
                TimeZoneSidKey = 'America/Los_Angeles', LocaleSidKey = 'en_US', EmailEncodingKey = 'UTF-8', LanguageLocaleKey = 'en_US');
        insert testUser;
        insert new PermissionSetAssignment(AssigneeId = testUser.Id, PermissionSetId = [SELECT Id FROM PermissionSet WHERE Name = 'Form_Builder_Admin' AND NamespacePrefix = 'FlowToolKit' LIMIT 1].Id);
    }

    private static User testUser() {
        return [SELECT Id FROM User WHERE Username = :TEST_USERNAME LIMIT 1];
    }

    /**Base 5.x: an anonymous submission never creates a Household or a person; the NPC controller used to convert it like any other.**/
    @IsTest
    static void anonymousSubmission_createsNoHouseholdAndNoPerson() {
        System.runAs(testUser()) {
            Form_Template__c template = template('NPC Anonymous', HOUSEHOLD_ONLY_RULES + ';' + PEOPLE_RULES, 'PersonAccount');
            Form_Submission__c submission = newSubmission(template.Id, 'Ana', 'Nonymous', 'ana.nonymous.test@example.com');
            submission.Anonymous__c = true;

            Test.startTest();
            insert submission;
            runConversion();
            Test.stopTest();

            Form_Submission__c reloaded = reload(submission.Id);
            System.assertEquals('Complete', reloaded.Conversion_Status__c, 'An anonymous submission still finishes its conversion');
            System.assertEquals(null, reloaded.Account__c, 'No Household for an anonymous submission');
            System.assertEquals(null, reloaded.Contact_1__c, 'No Person Account for an anonymous submission');
            System.assertEquals(0, [SELECT COUNT() FROM Account WHERE CreatedDate = TODAY AND (IsPersonAccount = true OR Name LIKE '%Household')], 'Nothing names the respondent');
        }
    }

    /**Base 5.x Link Anonymous Lead: with a campaign rule on, the anonymous response is tied to the one shared anonymous Lead instead of a person.**/
    @IsTest
    static void anonymousSubmission_withCampaignRule_linksTheSharedAnonymousLead() {
        System.runAs(testUser()) {
            Form_Template__c template = template('NPC Anonymous Campaign', 'Contact1;Contact1 👉 Create Campaign Member', 'PersonAccount');
            Form_Submission__c submission = newSubmission(template.Id, 'Ana', 'Nonymous', 'ana.campaign.test@example.com');
            submission.Anonymous__c = true;

            Test.startTest();
            insert submission;
            runConversion();
            Test.stopTest();

            Form_Submission__c reloaded = reload(submission.Id);
            System.assertEquals(null, reloaded.Contact_1__c, 'No Person Account for an anonymous submission');
            System.assertNotEquals(null, reloaded.Lead_1__c, 'The response is linked to the shared anonymous Lead');
            System.assertEquals(ANONYMOUS_LEAD_TEXT, [SELECT LeadSource FROM Lead WHERE Id = :reloaded.Lead_1__c].LeadSource, 'The linked Lead is the shared anonymous one');
        }
    }

    /**The NPC controller used to convert people only when Contact (Record Type) was exactly PersonAccount, and skipped them silently otherwise. -- Use Default -- now converts with the org's default person record type.**/
    @IsTest
    static void useDefaultContactRecordType_convertsContact1AsAPersonAccount() {
        System.runAs(testUser()) {
            Form_Template__c template = template('NPC Use Default', PEOPLE_RULES, '-- Use Default --');
            Form_Submission__c submission = newSubmission(template.Id, 'Dana', 'Default', 'dana.default.test@example.com');

            Test.startTest();
            insert submission;
            runConversion();
            Test.stopTest();

            Form_Submission__c reloaded = reload(submission.Id);
            assertStatusWithLogs('Created', reloaded.Conversion_Status_Contact_1__c, reloaded.Id, 'Use Default converts the person');
            Account person = [SELECT IsPersonAccount, RecordType.IsPersonType FROM Account WHERE PersonContactId = :reloaded.Contact_1__c];
            System.assert(person.IsPersonAccount, 'Contact 1 is a Person Account');
            System.assert(person.RecordType.IsPersonType, 'With the org default person record type');
        }
    }

    /**#662: rule names are compared whole. A custom rule whose name contains NPC_Person_Account_Match used to stop the fallback being added, so a returning person was not found and was created again.**/
    @IsTest
    static void customRuleNamedLikeTheFallback_stillFindsTheReturningPerson() {
        System.runAs(testUser()) {
            Form_Template__c first = template('NPC First Visit', PEOPLE_RULES, 'PersonAccount');
            Form_Template__c second = template('NPC Return Visit', PEOPLE_RULES, 'PersonAccount');
            second.Contact_Matching_Rules__c = 'NPC_Person_Account_Match_Custom';
            update second;
            Form_Submission__c firstVisit = newSubmission(first.Id, 'Rami', 'Returner', 'rami.returner.test@example.com');

            Test.startTest();
            insert firstVisit;
            runConversion();
            Form_Submission__c secondVisit = newSubmission(second.Id, 'Rami', 'Returner', 'rami.returner.test@example.com');
            insert secondVisit;
            runConversion();
            Test.stopTest();

            Form_Submission__c reloaded = reload(secondVisit.Id);
            assertStatusWithLogs('Matched', reloaded.Conversion_Status_Contact_1__c, reloaded.Id, 'The returning person is matched through the NPC fallback rule');
            System.assertEquals(reload(firstVisit.Id).Contact_1__c, reloaded.Contact_1__c, 'Both visits point at the same person');
            System.assertEquals(1, [SELECT COUNT() FROM Account WHERE IsPersonAccount = true AND PersonEmail = 'rami.returner.test@example.com'], 'No second Person Account');
        }
    }

    /**Form Template Mapping: the NPC Account engine applies a section mapped to the submission's Account, as the base Upsert Account does.**/
    @IsTest
    static void mappedAccountSection_fillsTheHousehold() {
        System.runAs(testUser()) {
            Form_Template__c template = template('NPC Mapped Household', HOUSEHOLD_ONLY_RULES, null);
            Form_Template_Page__c page = new Form_Template_Page__c(Form_Template__c = template.Id, Page_Label__c = 'Household', Position__c = 1, Visibility__c = 'Both');
            insert page;
            String formJson = JSON.serialize(new Map<String,Object>{'Label' => 'Household Notes', '*__ObjectApiName__c' => 'Account', '*__sections__r' => new List<Object>(),
                    '*__Submission_Field_Map__c' => '{"lookupField":"FlowToolKit__Account__c","fields":{"FlowToolKit__Description__c":"Description"}}'});
            insert new Form_Template_Page_Section__c(Form_Template_Page__c = page.Id, Title__c = 'Household Notes', Position__c = 1, Component_Type__c = 'Field Set',
                    FormConfigJSON__c = JSON.serialize(new Map<String,Object>{'formSelectionMode' => 'json', 'object' => 'Account', 'formJsonConfig' => formJson}));
            Form_Submission__c submission = newSubmission(template.Id, 'Mia', 'Mapped', 'mia.mapped.test@example.com');
            submission.Description__c = 'Two adults, one dog';

            Test.startTest();
            insert submission;
            runConversion();
            Test.stopTest();

            Form_Submission__c reloaded = reload(submission.Id);
            assertStatusWithLogs('Created', reloaded.Conversion_Status_Account__c, reloaded.Id, 'The Household is created');
            System.assertEquals('Two adults, one dog', [SELECT Description FROM Account WHERE Id = :reloaded.Account__c].Description, 'The mapped section fills the Household Description');
        }
    }

    /**The base Account rule gate: an Account event for a template with no Account rule logs a configuration Error and creates nothing.**/
    @IsTest
    static void processAccount_withoutAccountRule_logsAnErrorAndCreatesNothing() {
        System.runAs(testUser()) {
            Form_Template__c template = template('NPC No Account Rule', PEOPLE_RULES, 'PersonAccount');
            template.Conversion_Type__c = 'Bypass';
            update template;
            Form_Submission__c submission = newSubmission(template.Id, 'Gil', 'Gate', 'gil.gate.test@example.com');
            submission.Company__c = 'Gate Works';
            insert submission;
            Form_Submission_Convert__e accountEvent = new Form_Submission_Convert__e(recordId__c = submission.Id, EventName__c = 'Account', Type__c = 'FlowToolKit__Account__c', ConversionStatusFieldApiName__c = 'FlowToolKit__Conversion_Status_Account__c');

            Test.startTest();
            Flow.Interview.createInterview('FlowToolKit', 'NPC_Form_Submission_Convert_Process_Account_Overridable', new Map<String,Object>{'PlatformEvent' => accountEvent}).start();
            runConversion();
            Test.stopTest();

            System.assertEquals(0, [SELECT COUNT() FROM Account WHERE Name = 'Gate Works'], 'No Account without the Account rule');
            System.assert(hasLogContaining(submission.Id, 'Invalid Conversion Rule'), 'The configuration error is logged');
        }
    }

    // ---- helpers ----

    private static Form_Template__c template(String name, String rules, String contactRecordType) {
        Form_Template__c template = new Form_Template__c(Name = name, Conversion_Type__c = 'Contact(s)', Account_Record_Type__c = 'Organization', Conversion_Rules__c = rules, IsActive__c = true, Contact_Record_Type__c = contactRecordType);
        insert template;
        return template;
    }

    private static Form_Submission__c newSubmission(Id templateId, String firstName, String lastName, String email) {
        return new Form_Submission__c(Form_Template__c = templateId, Status__c = 'Submitted', Submission_Date__c = System.now(),
                Contact1_First_Name__c = firstName, Contact1_Last_Name__c = lastName, Contact1_Email__c = email);
    }

    /**Walks the event chain: each hop publishes the next event, which the next delivery runs.**/
    private static void runConversion() {
        for (Integer hop = 0; hop < 40; hop++) Test.getEventBus().deliver();
    }

    private static Form_Submission__c reload(Id submissionId) {
        return [SELECT Id, Conversion_Status__c, Conversion_Status_Contact_1__c, Conversion_Status_Account__c, Contact_1__c, Account__c, Lead_1__c FROM Form_Submission__c WHERE Id = :submissionId];
    }

    /**On a mismatch the whole Conversion Log rides out in the assertion message, since a build org is unreachable afterwards.**/
    private static void assertStatusWithLogs(String expected, String actual, Id submissionId, String message) {
        if (expected == actual) return;
        List<String> lines = new List<String>();
        for (Form_Submission_Conversion_Log__c log : [SELECT Status__c, Log_Message__c FROM Form_Submission_Conversion_Log__c WHERE Form_Submission__c = :submissionId ORDER BY CreatedDate]) {
            lines.add(log.Status__c + ': ' + String.valueOf(log.Log_Message__c).replace('\n', ' ^ '));
        }
        System.assert(false, message + ' | expected ' + expected + ' got ' + actual + ' | LOGS >> ' + String.join(lines, ' /// '));
    }

    private static Boolean hasLogContaining(Id submissionId, String text) {
        for (Form_Submission_Conversion_Log__c log : [SELECT Log_Message__c FROM Form_Submission_Conversion_Log__c WHERE Form_Submission__c = :submissionId]) {
            if (log.Log_Message__c != null && log.Log_Message__c.contains(text)) return true;
        }
        return false;
    }
}
