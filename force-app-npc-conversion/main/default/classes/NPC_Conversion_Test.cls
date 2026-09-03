/**End-to-end tests for the NPC PersonAccount conversion (#74): one family per test, the whole platform-event chain walked with Test.getEventBus().deliver(). Two template shapes cover both controller orders: people first (Household mode with Contact1 Add to Account) and Account first.**/
@IsTest
private class NPC_Conversion_Test {

    /**People first: the NPC controller runs Contact 1 ahead of the Account rule when Household mode, a PersonAccount record type and Contact1 Add to Account meet.**/
    private static final String HOUSEHOLD_RULES = 'Account;Account is Household;Contact1;Contact1 👉 Add to Account;Contact2;Contact2 👉 Add to Account;Create Relationships;Contact1 👉 Is Primary Group;Contact1 👉 Included In Group;Contact2 👉 Is Primary Group;Contact2 👉 Included In Group';
    /**Account first: without Contact1 Add to Account the packaged order stands, so the Household exists before any person converts.**/
    private static final String HOUSEHOLD_RULES_PLAIN = 'Account;Account is Household;Contact1;Contact1 👉 Add to Account;Contact2;Contact2 👉 Add to Account;Create Relationships';

    /**Every template names an Account record type, as a configured template in the wild does. It also
       dodges a packaging build-org platform gack: business Account inserts relying on DEFAULT record type
       resolution die there with an internal Salesforce error (IDs 1812735920-*, 1053856087-1582681), while
       the same insert with an explicit RecordTypeId succeeds. In orgs without an Organization record type
       the engine degrades to the default by design, so this stays harmless everywhere else.**/
    @TestSetup
    static void setup() {
        PartyRoleRelation spouse = new PartyRoleRelation(Name = 'Spouse-Spouse-CCR', RoleName = 'Spouse', RelatedRoleName = 'Spouse', RelationshipObjectName = 'Contact_Contact_Relationship', ShouldCreaInversRoleAuto = false);
        PartyRoleRelation parent = new PartyRoleRelation(Name = 'Parent-Child-CCR', RoleName = 'Parent', RelatedRoleName = 'Child', RelationshipObjectName = 'Contact_Contact_Relationship', ShouldCreaInversRoleAuto = false);
        PartyRoleRelation child = new PartyRoleRelation(Name = 'Child-Parent-CCR', RoleName = 'Child', RelatedRoleName = 'Parent', RelationshipObjectName = 'Contact_Contact_Relationship', ShouldCreaInversRoleAuto = false);
        insert new List<PartyRoleRelation>{spouse, parent, child};
        parent.RelatedInverseRecordId = child.Id;
        child.RelatedInverseRecordId = parent.Id;
        update new List<PartyRoleRelation>{parent, child};

        Form_Template__c template = new Form_Template__c(Name = 'NPC Household Intake', Conversion_Type__c = 'Contact(s)', Contact_Record_Type__c = 'PersonAccount', Account_Record_Type__c = 'Organization', Conversion_Rules__c = HOUSEHOLD_RULES, IsActive__c = true);
        Form_Template__c plain = new Form_Template__c(Name = 'NPC Household Intake Plain', Conversion_Type__c = 'Contact(s)', Contact_Record_Type__c = 'PersonAccount', Account_Record_Type__c = 'Organization', Conversion_Rules__c = HOUSEHOLD_RULES_PLAIN, IsActive__c = true);
        Form_Template__c accountOnly = new Form_Template__c(Name = 'NPC Household Only', Conversion_Type__c = 'Contact(s)', Account_Record_Type__c = 'Organization', Conversion_Rules__c = 'Account;Account is Household', IsActive__c = true);
        insert new List<Form_Template__c>{template, plain, accountOnly};
        Form_Template_Page__c page = new Form_Template_Page__c(Form_Template__c = template.Id, Page_Label__c = 'Family', Position__c = 1, Visibility__c = 'Both');
        Form_Template_Page__c plainPage = new Form_Template_Page__c(Form_Template__c = plain.Id, Page_Label__c = 'Family', Position__c = 1, Visibility__c = 'Both');
        insert new List<Form_Template_Page__c>{page, plainPage};
        insert new List<Form_Template_Page_Section__c>{
            new Form_Template_Page_Section__c(Form_Template_Page__c = page.Id, Component_Type__c = 'Repeater', Conversion_Rule__c = 'Contact2', Add_to_Account__c = true),
            new Form_Template_Page_Section__c(Form_Template_Page__c = plainPage.Id, Component_Type__c = 'Repeater', Conversion_Rule__c = 'Contact2', Add_to_Account__c = true)};
    }

    // ---- scenarios ----

    @IsTest
    static void household_headPlusWifeSonDaughter_createsHouseholdMembershipsAndRelationships() {
        Id parentId = submitFamily('Haddad', 'omar', new List<Relative>{
            new Relative('Layla', 'Haddad', 'layla', 'Spouse or Partner'),
            new Relative('Sami', 'Haddad', 'sami', 'Child'),
            new Relative('Nour', 'Haddad', 'nour', 'Child')});

        Test.startTest();
        runConversion();
        Test.stopTest();

        Form_Submission__c parent = reload(parentId);
        assertStatusWithLogs('Complete', parent.Conversion_Status__c, parent.Id, 'The main submission must finish');
        System.assertEquals('Updated', parent.Conversion_Status_Contact_1__c, 'The head converts before the Household exists, is queued, and the pass that adds the membership is an update; Updated is the honest final state');
        System.assertEquals('Created', parent.Conversion_Status_Account__c, 'A new Household must be created by the Account rule for a new head');
        System.assert(String.valueOf(parent.Contact_1__c).startsWith('003'), 'Contact 1 must hold the person Contact Id, never the Account Id');

        List<Account> people = [SELECT Id, PersonContactId, LastName FROM Account WHERE IsPersonAccount = true AND PersonEmail LIKE '%haddad.test@example.com'];
        System.assertEquals(4, people.size(), 'Head, wife, son and daughter must each be a Person Account');

        Account household = [SELECT Id, Name FROM Account WHERE IsPersonAccount = false AND Name = 'Haddad Household'];
        System.assertEquals(household.Id, parent.Account__c, 'The submission must point at the Household');
        System.assertEquals(1, [SELECT COUNT() FROM PartyRelationshipGroup WHERE AccountId = :household.Id AND Type = 'Household'], 'The Household needs exactly one Household group');

        List<AccountContactRelation> members = [SELECT ContactId, IsPrimaryMember, IsPrimaryGroup, IsIncludedInGroup, Contact.FirstName FROM AccountContactRelation WHERE AccountId = :household.Id];
        System.assertEquals(4, members.size(), 'All four people must be members of the Household');
        Integer heads = 0;
        for (AccountContactRelation member : members) {
            if (member.IsPrimaryMember) { heads++; System.assertEquals('Omar', member.Contact.FirstName, 'The head of household is the primary member'); }
            System.assert(member.IsPrimaryGroup, member.Contact.FirstName + ': the template says this Household is the primary group for both slots');
            System.assert(member.IsIncludedInGroup, member.Contact.FirstName + ': the template says both slots are included in the group');
        }
        System.assertEquals(1, heads, 'Exactly one primary member');

        for (Form_Submission__c row : [SELECT Conversion_Status__c, Conversion_Status_Contact_2__c, Contact_2__c FROM Form_Submission__c WHERE Parent_Form_Submission__c = :parentId]) {
            System.assertEquals('Complete', row.Conversion_Status__c, 'Every related row must finish');
            System.assertEquals('Created', row.Conversion_Status_Contact_2__c, 'Every relative must be created as Contact 2');
        }

        Map<String, Integer> pairs = relationPairs();
        System.assertEquals(6, [SELECT COUNT() FROM ContactContactRelation WHERE Contact.LastName = 'Haddad'], 'Three relationships, both directions each');
        System.assertEquals(1, pairs.get('Layla>Omar:Spouse'), 'Wife to head: Spouse');
        System.assertEquals(1, pairs.get('Omar>Layla:Spouse'), 'Head to wife: Spouse');
        System.assertEquals(1, pairs.get('Sami>Omar:Child'), 'Son to head: Child');
        System.assertEquals(1, pairs.get('Omar>Sami:Parent'), 'Head to son: Parent');
        System.assertEquals(1, pairs.get('Nour>Omar:Child'), 'Daughter to head: Child');
        System.assertEquals(1, pairs.get('Omar>Nour:Parent'), 'Head to daughter: Parent');
        System.assert(!hasLogWithStatus(parentId, 'Error'), 'A clean run writes no Error log');
    }

    @IsTest
    static void reprocess_sameFamily_createsNothingNew() {
        Id parentId = submitFamily('Haddad', 'omar', new List<Relative>{
            new Relative('Layla', 'Haddad', 'layla', 'Spouse or Partner'),
            new Relative('Sami', 'Haddad', 'sami', 'Child')});

        Test.startTest();
        runConversion();
        Integer peopleBefore = [SELECT COUNT() FROM Account WHERE IsPersonAccount = true];
        Integer householdsBefore = [SELECT COUNT() FROM PartyRelationshipGroup];
        Integer membersBefore = [SELECT COUNT() FROM AccountContactRelation WHERE Account.Name = 'Haddad Household'];
        Integer relationsBefore = [SELECT COUNT() FROM ContactContactRelation];
        startAgain(parentId);
        runConversion();
        Test.stopTest();

        Form_Submission__c parent = reload(parentId);
        assertStatusWithLogs('Complete', parent.Conversion_Status__c, parent.Id, 'The reprocessed submission must finish again');
        System.assertEquals('Updated', parent.Conversion_Status_Contact_1__c, 'The head is found through Contact 1 and updated, not created');
        System.assertEquals('Updated', parent.Conversion_Status_Account__c, 'The Household already on the submission is updated in place, never created again');
        System.assertEquals(peopleBefore, [SELECT COUNT() FROM Account WHERE IsPersonAccount = true], 'No new Person Account on reprocess');
        System.assertEquals(householdsBefore, [SELECT COUNT() FROM PartyRelationshipGroup], 'No new Household on reprocess');
        System.assertEquals(membersBefore, [SELECT COUNT() FROM AccountContactRelation WHERE Account.Name = 'Haddad Household'], 'No new membership on reprocess');
        System.assertEquals(relationsBefore, [SELECT COUNT() FROM ContactContactRelation], 'No new relationship on reprocess');
    }

    @IsTest
    static void returningHead_aloneWithAccountIsHousehold_joinsExistingHousehold() {
        Id firstId = submitFamily('Haddad', 'omar', new List<Relative>{ new Relative('Layla', 'Haddad', 'layla', 'Spouse or Partner') });
        Form_Template__c joinTemplate = new Form_Template__c(Name = 'NPC Household Join', Conversion_Type__c = 'Contact(s)', Contact_Record_Type__c = 'PersonAccount', Account_Record_Type__c = 'Organization', Conversion_Rules__c = 'Account;Account is Household;Contact1;Contact1 👉 Add to Account', IsActive__c = true);
        insert joinTemplate;

        Test.startTest();
        runConversion();
        Id householdId = reload(firstId).Account__c;
        Form_Submission__c again = newSubmission(joinTemplate.Id, 'Omar', 'Haddad', 'omar.haddad.test@example.com', 'Submitted');
        insert again;
        runConversion();
        Test.stopTest();

        Form_Submission__c reloaded = reload(again.Id);
        assertStatusWithLogs('Complete', reloaded.Conversion_Status__c, reloaded.Id, 'returningHead');
        System.assertEquals('Matched', reloaded.Conversion_Status_Contact_1__c, 'The returning head must match the existing Person Account by email');
        System.assertEquals('Updated', reloaded.Conversion_Status_Account__c, 'The Account rule ran first and recognised the family through the head\'s email, so the existing Household was updated');
        System.assertEquals(householdId, reloaded.Account__c, 'The same Household, found through the head\'s email and membership');
        System.assertEquals(1, [SELECT COUNT() FROM Account WHERE IsPersonAccount = false AND Name = 'Haddad Household'], 'No second Household');
        System.assertEquals(2, [SELECT COUNT() FROM AccountContactRelation WHERE AccountId = :householdId], 'No duplicate membership for the head');
    }

    // ---- failures ----

    @IsTest
    static void missingRole_errorsTheRelatedRowAndHaltsTheConversion() {
        Id parentId = submitFamily('Haddad', 'omar', new List<Relative>{ new Relative('Rami', 'Haddad', 'rami', 'Sibling') });

        Test.startTest();
        runConversion();
        Test.stopTest();

        Form_Submission__c row = [SELECT Conversion_Status__c, Conversion_Status_Contact_2__c, Contact_2__c FROM Form_Submission__c WHERE Parent_Form_Submission__c = :parentId LIMIT 1];
        assertStatusWithLogs('Error', row.Conversion_Status_Contact_2__c, row.Id, 'The slot goes back to Error by design, so Reprocess runs the person and their relationship again');
        System.assertNotEquals(null, row.Contact_2__c, 'The person record itself was still created and stamped');
        System.assertEquals('Error', row.Conversion_Status__c, 'A relationship value with no Party Role Relation errors the row');
        System.assert(hasLogContaining(row.Id, 'Upsert Relationships'), 'The Error log must point at the relationship step (messages are static by design; the missing role is found in Setup)');
        System.assertNotEquals('Complete', reload(parentId).Conversion_Status__c, 'The conversion halts so Reprocess can retry once the role exists');
        System.assertEquals(0, [SELECT COUNT() FROM ContactContactRelation WHERE Contact.LastName = 'Haddad'], 'No relationship is written without a role');
    }

    @IsTest
    static void blankLastName_errorsThePersonAndWritesNoHousehold() {
        Id templateId = [SELECT Id FROM Form_Template__c WHERE Name = 'NPC Household Intake Plain'].Id;
        Form_Submission__c parent = newSubmission(templateId, 'Nameless', '', 'nameless.haddad.test@example.com', 'Submitted');

        Test.startTest();
        insert parent;
        runConversion();
        Test.stopTest();

        Form_Submission__c reloaded = reload(parent.Id);
        System.assertEquals('Error', reloaded.Conversion_Status_Contact_1__c, 'People first: a Person Account needs a last name, and the insert failure lands on Contact 1');
        System.assert(hasLogWithStatus(parent.Id, 'Error'), 'The failure must be logged');
        System.assertEquals(null, reloaded.Account__c, 'No Household is written');
        System.assertNotEquals('Complete', reloaded.Conversion_Status__c, 'The conversion halts so Reprocess can retry once the form carries a name');
        System.assertEquals(0, [SELECT COUNT() FROM Account WHERE Name = ' Household' OR Name = 'Household'], 'No unnamed Household is created');
    }

    @IsTest
    static void blankRelationshipValue_isLoggedAndSkipped_notAnError() {
        Id parentId = submitFamily('Haddad', 'omar', new List<Relative>{ new Relative('Layla', 'Haddad', 'layla', null) });

        Test.startTest();
        runConversion();
        Test.stopTest();

        Form_Submission__c row = [SELECT Conversion_Status__c, Conversion_Status_Contact_2__c, Contact_2__c FROM Form_Submission__c WHERE Parent_Form_Submission__c = :parentId LIMIT 1];
        assertStatusWithLogs('Complete', row.Conversion_Status__c, row.Id, 'A blank relationship value is not an error');
        System.assertEquals('Created', row.Conversion_Status_Contact_2__c);
        System.assertEquals(1, [SELECT COUNT() FROM AccountContactRelation WHERE ContactId = :row.Contact_2__c AND AccountId = :reload(parentId).Account__c], 'The relative still joins the Household');
        System.assertEquals(0, [SELECT COUNT() FROM ContactContactRelation WHERE Contact.LastName = 'Haddad'], 'Nothing to record without a value');
        assertStatusWithLogs('Complete', reload(parentId).Conversion_Status__c, parentId, 'membershipSubRulesOff');
    }

    @IsTest
    static void membershipSubRulesOff_leavesGroupFlagsFalse() {
        Id parentId = submitFamily('NPC Household Intake Plain', 'Haddad', 'omar', new List<Relative>{ new Relative('Layla', 'Haddad', 'layla', 'Spouse or Partner') });

        Test.startTest();
        runConversion();
        Test.stopTest();

        assertStatusWithLogs('Complete', reload(parentId).Conversion_Status__c, parentId, 'membershipSubRulesOff');
        for (AccountContactRelation member : [SELECT IsPrimaryGroup, IsIncludedInGroup, IsPrimaryMember, Contact.FirstName FROM AccountContactRelation WHERE Account.Name = 'Haddad Household']) {
            System.assert(!member.IsPrimaryGroup, member.Contact.FirstName + ': without the sub-rule this is not the primary group');
            System.assert(!member.IsIncludedInGroup, member.Contact.FirstName + ': without the sub-rule the person is not included in the group');
        }
        System.assertEquals(1, [SELECT COUNT() FROM AccountContactRelation WHERE Account.Name = 'Haddad Household' AND IsPrimaryMember = true], 'The head is still the primary member regardless of the sub-rules');
    }

    @IsTest
    static void primaryGroup_movingToAnotherHousehold_clearsThePreviousPrimaryGroup() {
        Id firstId = submitFamily('Haddad', 'omar', new List<Relative>{ new Relative('Layla', 'Haddad', 'layla', 'Spouse or Partner') });

        Test.startTest();
        runConversion();
        Id firstHousehold = reload(firstId).Account__c;
        System.assertEquals(1, [SELECT COUNT() FROM AccountContactRelation WHERE AccountId = :firstHousehold AND Contact.FirstName = 'Layla' AND IsPrimaryGroup = true], 'Layla starts with the Haddad Household as her primary group');
        Id secondId = submitFamily('Karam', 'nadia', new List<Relative>{ new Relative('Layla', 'Haddad', 'layla', 'Sibling') });
        insert new PartyRoleRelation(Name = 'Sibling-Sibling-CCR', RoleName = 'Sibling', RelatedRoleName = 'Sibling', RelationshipObjectName = 'Contact_Contact_Relationship', ShouldCreaInversRoleAuto = false);
        runConversion();
        Test.stopTest();

        Id secondHousehold = reload(secondId).Account__c;
        System.assertNotEquals(firstHousehold, secondHousehold, 'Nadia creates her own Household');
        System.assertEquals('Complete', reload(secondId).Conversion_Status__c);
        List<AccountContactRelation> laylas = [SELECT AccountId, IsPrimaryGroup FROM AccountContactRelation WHERE Contact.FirstName = 'Layla' AND IsDirect = false];
        System.assertEquals(2, laylas.size(), 'Layla is a member of both Households');
        for (AccountContactRelation membership : laylas) {
            System.assertEquals(membership.AccountId == secondHousehold, membership.IsPrimaryGroup, 'Only the newest Household is Layla\'s primary group; the previous one was cleared');
        }
    }

    @IsTest
    static void accountOnly_householdWithoutPeople_createsAccountAndGroup() {
        Id templateId = [SELECT Id FROM Form_Template__c WHERE Name = 'NPC Household Only'].Id;
        Form_Submission__c parent = newSubmission(templateId, 'Solo', 'Solo', 'solo.solo.test@example.com', 'Submitted');

        Test.startTest();
        insert parent;
        runConversion();
        Test.stopTest();

        Form_Submission__c reloaded = reload(parent.Id);
        assertStatusWithLogs('Complete', reloaded.Conversion_Status__c, reloaded.Id, 'accountOnly');
        System.assertEquals('Created', reloaded.Conversion_Status_Account__c, 'The Account rule alone creates the Household');
        Account household = [SELECT Id, Name, IsPersonAccount FROM Account WHERE Id = :reloaded.Account__c];
        System.assertEquals('Solo Household', household.Name, 'Named after Contact 1 when the form has no Company');
        System.assert(!household.IsPersonAccount, 'A Household is a business account');
        System.assertEquals(1, [SELECT COUNT() FROM PartyRelationshipGroup WHERE AccountId = :household.Id AND Type = 'Household'], 'With its Household group');
        System.assertEquals(0, [SELECT COUNT() FROM AccountContactRelation WHERE AccountId = :household.Id], 'Nobody converted, so nobody is a member yet');
        System.assert(!hasLogWithStatus(parent.Id, 'Error'), 'A clean run writes no Error log');
    }

    // ---- helpers ----

    private class Relative {
        String firstName; String lastName; String emailKey; String relationship;
        Relative(String firstName, String lastName, String emailKey, String relationship) {
            this.firstName = firstName; this.lastName = lastName; this.emailKey = emailKey; this.relationship = relationship;
        }
    }

    /**Head on the main submission, relatives as related rows of the Contact 2 repeater section; returns the parent Id, still to be converted.**/
    private static Id submitFamily(String lastName, String headKey, List<Relative> relatives) {
        return submitFamily('NPC Household Intake', lastName, headKey, relatives);
    }

    private static Id submitFamily(String templateName, String lastName, String headKey, List<Relative> relatives) {
        Form_Template__c template = [SELECT Id FROM Form_Template__c WHERE Name = :templateName];
        Form_Template_Page_Section__c section = [SELECT Id FROM Form_Template_Page_Section__c WHERE Form_Template_Page__r.Form_Template__c = :template.Id AND Conversion_Rule__c = 'Contact2' LIMIT 1];
        Form_Submission__c parent = newSubmission(template.Id, 'Omar', lastName, headKey + '.' + lastName.toLowerCase() + '.test@example.com', 'Draft');
        insert parent;
        List<Form_Submission__c> rows = new List<Form_Submission__c>();
        for (Relative relative : relatives) {
            rows.add(new Form_Submission__c(Form_Template__c = template.Id, Parent_Form_Submission__c = parent.Id, Internal_Is_Related_Record__c = true, Internal_SectionId__c = section.Id,
                Status__c = 'Submitted', Submission_Date__c = System.now(),
                Contact2_First_Name__c = relative.firstName, Contact2_Last_Name__c = relative.lastName,
                Contact2_Email__c = relative.emailKey + '.' + relative.lastName.toLowerCase() + '.test@example.com', Contact2_Relationship_to_Contact1__c = relative.relationship));
        }
        insert rows;
        parent.Status__c = 'Submitted';
        update parent; /**Submitted with a submission date and no parent: the packaged record-triggered flow publishes Start**/
        return parent.Id;
    }

    private static Form_Submission__c newSubmission(Id templateId, String firstName, String lastName, String email, String status) {
        return new Form_Submission__c(Form_Template__c = templateId, Status__c = status, Submission_Date__c = System.now(),
            Contact1_First_Name__c = firstName, Contact1_Last_Name__c = lastName, Contact1_Email__c = email);
    }

    /**Walks the event chain: each hop publishes the next event, which the next delivery runs. Forty is far above the longest chain here.**/
    /**Build-org diagnosis: a status assertion that fails inside a packaging build org is unreachable
       afterwards, so on mismatch the whole Conversion Log rides out in the assertion message.**/
    private static void assertStatusWithLogs(String expected, String actual, Id submissionId, String message) {
        if (expected == actual) return;
        List<String> lines = new List<String>();
        for (Form_Submission_Conversion_Log__c log : [SELECT Status__c, Log_Message__c FROM Form_Submission_Conversion_Log__c WHERE Form_Submission__c = :submissionId OR Parent_Form_Submission__c = :submissionId ORDER BY CreatedDate]) {
            lines.add(log.Status__c + ': ' + String.valueOf(log.Log_Message__c).replace('\n', ' ^ '));
        }
        System.assert(false, message + ' | expected ' + expected + ' got ' + actual + ' | LOGS >> ' + String.join(lines, ' /// '));
    }

    private static void runConversion() {
        for (Integer hop = 0; hop < 40; hop++) Test.getEventBus().deliver();
    }

    /**What the packaged Reprocess action does: the Log invocable in Start mode.**/
    private static void startAgain(Id submissionId) {
        Form_Submission__c submission = reload(submissionId);
        Form_Template__c template = [SELECT Id, Name, Conversion_Type__c, Conversion_Rules__c, Conversion_Map_Flow_Controller__c, FlowApiName_Controller__c FROM Form_Template__c WHERE Id = :submission.Form_Template__c];
        FormSubmission_LogEvent_Invocable.InvokedRequest request = new FormSubmission_LogEvent_Invocable.InvokedRequest();
        request.mode = 'Start';
        request.record = submission;
        request.formTemplate = template;
        request.elementApiName = 'NPC_Conversion_Test';
        FormSubmission_LogEvent_Invocable.logConversionEvent(new List<FormSubmission_LogEvent_Invocable.InvokedRequest>{request});
    }

    private static Form_Submission__c reload(Id submissionId) {
        return [SELECT Id, Form_Template__c, Conversion_Status__c, Conversion_Status_Contact_1__c, Conversion_Status_Contact_2__c, Conversion_Status_Account__c, Contact_1__c, Contact_2__c, Account__c FROM Form_Submission__c WHERE Id = :submissionId];
    }

    private static Map<String, Integer> relationPairs() {
        Map<String, Integer> pairs = new Map<String, Integer>();
        for (ContactContactRelation relation : [SELECT Contact.FirstName, RelatedContact.FirstName, PartyRoleRelation.RoleName FROM ContactContactRelation WHERE Contact.LastName = 'Haddad']) {
            String key = relation.Contact.FirstName + '>' + relation.RelatedContact.FirstName + ':' + relation.PartyRoleRelation.RoleName;
            pairs.put(key, (pairs.containsKey(key) ? pairs.get(key) : 0) + 1);
        }
        return pairs;
    }

    private static Boolean hasLogWithStatus(Id submissionId, String status) {
        return [SELECT COUNT() FROM Form_Submission_Conversion_Log__c WHERE (Form_Submission__c = :submissionId OR Parent_Form_Submission__c = :submissionId) AND Status__c = :status] > 0;
    }

    private static Boolean hasLogContaining(Id submissionId, String text) {
        for (Form_Submission_Conversion_Log__c log : [SELECT Log_Message__c FROM Form_Submission_Conversion_Log__c WHERE Form_Submission__c = :submissionId]) {
            if (log.Log_Message__c != null && log.Log_Message__c.contains(text)) return true;
        }
        return false;
    }
}
