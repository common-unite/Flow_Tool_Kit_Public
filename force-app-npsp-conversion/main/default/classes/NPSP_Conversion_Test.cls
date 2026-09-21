/**End-to-end tests for the NPSP conversion extension (#676): each test walks the whole platform-event chain with Test.getEventBus().deliver(). NPSP builds every Household itself, so the tests assert on the Contacts' Accounts, the submission's Account, affiliations and Primary Contacts - never on Household names, which NPSP may finalise asynchronously.**/
@IsTest
private class NPSP_Conversion_Test {

    /**Household mode is the HH_Account record type on the template, never a rule: Contact 1 converts first and its Household is stamped on the submission, and the Account rule then updates that Household. A person is linked to that Household only when an Add to Account rule (or the section's Add to Account box) asks for it (Bobby, 2026-09-17).**/
    private static final String HOUSEHOLD_RULES = 'Account;Contact1;Contact1 👉 Add to Account;Contact2;Contact2 👉 Add to Account';
    /**Organization mode: the packaged order stands (Account first), and the Add to Account rules affiliate each person with the Organization.**/
    private static final String ORGANIZATION_RULES = 'Account;Contact1;Contact1 👉 Add to Account;Contact2;Contact2 👉 Add to Account';

    @TestSetup
    static void setup() {
        /**a packaging build org installs NPSP without the configuration cci applies, so the tests state the model they assert**/
        npe01__Contacts_and_Orgs_Settings__c orgSettings = npe01__Contacts_and_Orgs_Settings__c.getOrgDefaults();
        orgSettings.npe01__Account_Processor__c = 'Household Account';
        upsert orgSettings;
        npe5__Affiliations_Settings__c affiliationSettings = npe5__Affiliations_Settings__c.getOrgDefaults();
        affiliationSettings.npe5__Automatic_Affiliation_Creation_Turned_On__c = true;
        upsert affiliationSettings;
        npo02__Households_Settings__c householdSettings = npo02__Households_Settings__c.getOrgDefaults();
        householdSettings.npo02__Household_Rules__c = 'No Contacts';
        upsert householdSettings;

        Form_Template__c household = new Form_Template__c(Name = 'NPSP Household Intake', Conversion_Type__c = 'Contact(s)', Account_Record_Type__c = 'HH_Account', Conversion_Rules__c = HOUSEHOLD_RULES, IsActive__c = true);
        Form_Template__c organization = new Form_Template__c(Name = 'NPSP Organization Intake', Conversion_Type__c = 'Contact(s)', Account_Record_Type__c = 'Organization', Conversion_Rules__c = ORGANIZATION_RULES, IsActive__c = true);
        Form_Template__c contactsOnly = new Form_Template__c(Name = 'NPSP Contacts Only', Conversion_Type__c = 'Contact(s)', Conversion_Rules__c = 'Contact1;Contact2', IsActive__c = true);
        Form_Template__c householdAddToAccount = new Form_Template__c(Name = 'NPSP Household Add to Account', Conversion_Type__c = 'Contact(s)', Account_Record_Type__c = 'HH_Account', Conversion_Rules__c = HOUSEHOLD_RULES, IsActive__c = true);
        Form_Template__c householdWithoutAccountRule = new Form_Template__c(Name = 'NPSP Household Without Account Rule', Conversion_Type__c = 'Contact(s)', Account_Record_Type__c = 'HH_Account', Conversion_Rules__c = 'Contact1;Contact1 👉 Add to Account;Contact2;Contact2 👉 Add to Account', IsActive__c = true);
        Form_Template__c householdWithoutAddToAccount = new Form_Template__c(Name = 'NPSP Household Without Add to Account', Conversion_Type__c = 'Contact(s)', Account_Record_Type__c = 'HH_Account', Conversion_Rules__c = 'Account;Contact1;Contact2', IsActive__c = true);
        Form_Template__c householdCampaign = new Form_Template__c(Name = 'NPSP Household Campaign', Conversion_Type__c = 'Contact(s)', Account_Record_Type__c = 'HH_Account', Conversion_Rules__c = HOUSEHOLD_RULES + ';Contact1 👉 Create Campaign Member;Contact2 👉 Create Campaign Member', IsActive__c = true);
        Form_Template__c otherObjects = new Form_Template__c(Name = 'NPSP Other Objects', Conversion_Type__c = 'Other', Account_Record_Type__c = 'HH_Account', Conversion_Rules__c = HOUSEHOLD_RULES + ';Opportunity 💰;Create Case', IsActive__c = true);
        Form_Template__c leadOnly = new Form_Template__c(Name = 'NPSP Lead', Conversion_Type__c = 'Other', Conversion_Rules__c = 'Lead1', IsActive__c = true);
        insert new List<Form_Template__c>{household, organization, contactsOnly, householdAddToAccount, householdWithoutAccountRule, householdWithoutAddToAccount, householdCampaign, otherObjects, leadOnly};

        Form_Template_Page__c householdPage = new Form_Template_Page__c(Form_Template__c = household.Id, Page_Label__c = 'Family', Position__c = 1, Visibility__c = 'Both');
        Form_Template_Page__c organizationPage = new Form_Template_Page__c(Form_Template__c = organization.Id, Page_Label__c = 'Organization', Position__c = 1, Visibility__c = 'Both');
        insert new List<Form_Template_Page__c>{householdPage, organizationPage};
        insert new List<Form_Template_Page_Section__c>{
            new Form_Template_Page_Section__c(Form_Template_Page__c = householdPage.Id, Component_Type__c = 'Repeater', Conversion_Rule__c = 'Contact2', Add_to_Account__c = true),
            new Form_Template_Page_Section__c(Form_Template_Page__c = organizationPage.Id, Component_Type__c = 'Repeater', Conversion_Rule__c = 'Contact2', Add_to_Account__c = true)};
    }

    // ---- households ----

    @IsTest
    static void household_newFamily_everyoneInOneNpspHousehold() {
        Id parentId = submit('NPSP Household Intake', person('Omar', 'Haddad'), person('Layla', 'Haddad'), new List<Contact>{person('Sami', 'Haddad'), person('Nour', 'Haddad')});

        Test.startTest();
        runConversion();
        Test.stopTest();

        Form_Submission__c parent = reload(parentId);
        assertStatusWithLogs('Complete', parent.Conversion_Status__c, parentId, 'household_newFamily');
        System.assertEquals('Created', parent.Conversion_Status_Contact_1__c, 'Contact 1 is new');
        System.assertEquals('Created', parent.Conversion_Status_Contact_2__c, 'Contact 2 is new');
        System.assertEquals('Updated', parent.Conversion_Status_Account__c, 'The Account rule updates the Household Contact 1 brought, it never creates one');

        Account household = [SELECT Id, RecordType.DeveloperName FROM Account WHERE Id = :parent.Account__c];
        System.assertEquals('HH_Account', household.RecordType.DeveloperName, 'The submission points at an NPSP Household');
        System.assertEquals(4, [SELECT COUNT() FROM Contact WHERE LastName = 'Haddad' AND AccountId = :household.Id], 'Head, spouse and both children are in that one Household');
        System.assertEquals(1, [SELECT COUNT() FROM Account WHERE Id IN (SELECT AccountId FROM Contact WHERE LastName = 'Haddad')], 'Nobody got a Household of their own');
        for (Form_Submission__c row : [SELECT Conversion_Status__c, Conversion_Status_Contact_2__c FROM Form_Submission__c WHERE Parent_Form_Submission__c = :parentId]) assertStatusWithLogs('Complete', row.Conversion_Status__c, row.Id, 'Every repeater row must finish');
        System.assert(!hasLogWithStatus(parentId, 'Error'), 'A clean run writes no Error log');
    }

    @IsTest
    static void household_returningFamily_matchesPeopleAndReusesTheirHousehold() {
        Id firstId = submit('NPSP Household Intake', person('Omar', 'Haddad'), person('Layla', 'Haddad'), new List<Contact>());
        Test.startTest();
        runConversion();
        Id householdId = reload(firstId).Account__c;

        Id secondId = submit('NPSP Household Intake', person('Omar', 'Haddad'), person('Layla', 'Haddad'), new List<Contact>{person('Rami', 'Haddad')});
        runConversion();
        Test.stopTest();

        Form_Submission__c second = reload(secondId);
        assertStatusWithLogs('Complete', second.Conversion_Status__c, secondId, 'household_returningFamily');
        System.assertEquals('Matched', second.Conversion_Status_Contact_1__c, 'The returning head is matched');
        System.assertEquals('Matched', second.Conversion_Status_Contact_2__c, 'The returning spouse is matched');
        System.assertEquals(householdId, second.Account__c, 'The returning family keeps its Household');
        System.assertEquals(3, [SELECT COUNT() FROM Contact WHERE LastName = 'Haddad'], 'Only the new child is a new Contact');
        System.assertEquals(3, [SELECT COUNT() FROM Contact WHERE LastName = 'Haddad' AND AccountId = :householdId], 'The new child joins the existing Household');
    }

    @IsTest
    static void reprocess_sameFamily_createsNothingNew() {
        Id parentId = submit('NPSP Household Intake', person('Omar', 'Haddad'), person('Layla', 'Haddad'), new List<Contact>{person('Sami', 'Haddad')});

        Test.startTest();
        runConversion();
        Integer contactsBefore = [SELECT COUNT() FROM Contact];
        Integer accountsBefore = [SELECT COUNT() FROM Account];
        startAgain(parentId);
        runConversion();
        Test.stopTest();

        Form_Submission__c parent = reload(parentId);
        assertStatusWithLogs('Complete', parent.Conversion_Status__c, parentId, 'reprocess');
        System.assertEquals(contactsBefore, [SELECT COUNT() FROM Contact], 'No new Contact on reprocess');
        System.assertEquals(accountsBefore, [SELECT COUNT() FROM Account], 'No new Household on reprocess');
        System.assert(!hasLogWithStatus(parentId, 'Error'), 'A clean reprocess writes no Error log');
    }

    @IsTest
    static void contactsOnly_withoutHouseholdMode_everyoneKeepsTheirOwnHousehold() {
        Id parentId = submit('NPSP Contacts Only', person('Priya', 'Shah'), person('Arjun', 'Mehta'), new List<Contact>());

        Test.startTest();
        runConversion();
        Test.stopTest();

        Form_Submission__c parent = reload(parentId);
        assertStatusWithLogs('Complete', parent.Conversion_Status__c, parentId, 'contactsOnly');
        System.assertEquals(null, parent.Account__c, 'Without the HH_Account record type there is no Household mode, so nothing is stamped on the submission');
        Contact priya = [SELECT AccountId FROM Contact WHERE LastName = 'Shah'];
        Contact arjun = [SELECT AccountId FROM Contact WHERE LastName = 'Mehta'];
        System.assertNotEquals(null, priya.AccountId, 'NPSP builds Contact 1 a Household');
        System.assertNotEquals(priya.AccountId, arjun.AccountId, 'Contact 2 is not moved into Contact 1 Household');
    }

    @IsTest
    static void householdWithAddToAccount_joinsTheHouseholdAndWritesNoAffiliation() {
        Id parentId = submit('NPSP Household Add to Account', person('Nina', 'Patel'), person('Dev', 'Patel'), new List<Contact>());

        Test.startTest();
        runConversion();
        Test.stopTest();

        Form_Submission__c parent = reload(parentId);
        assertStatusWithLogs('Complete', parent.Conversion_Status__c, parentId, 'householdWithAddToAccount');
        System.assertEquals(2, [SELECT COUNT() FROM Contact WHERE LastName = 'Patel' AND AccountId = :parent.Account__c], 'Both people are in the Household');
        System.assertEquals(0, [SELECT COUNT() FROM npe5__Affiliation__c WHERE npe5__Contact__r.LastName = 'Patel'], 'A Household is never an affiliation');
    }

    // ---- organizations ----


    @IsTest
    static void primaryContactChecked_onContact2_becomesTheOrganizationPrimaryContact() {
        Id parentId = submit('NPSP Organization Intake', person('Iris', 'Novak'), person('Marcus', 'Reed'), new List<Contact>(), 'Maple Tenants Union', true);

        Test.startTest();
        runConversion();
        Test.stopTest();

        Form_Submission__c parent = reload(parentId);
        assertStatusWithLogs('Complete', parent.Conversion_Status__c, parentId, 'primaryContactChecked_organization');
        System.assertEquals('Reed', [SELECT npe01__One2OneContact__r.LastName FROM Account WHERE Id = :parent.Account__c].npe01__One2OneContact__r.LastName, 'The checked Contact 2 is the Primary Contact, although Contact 1 converted first');
    }

    @IsTest
    static void primaryContactChecked_onContact2_becomesTheHouseholdPrimaryContact() {
        Id parentId = submit('NPSP Household Intake', person('Hana', 'Kim'), person('Joon', 'Kim'), new List<Contact>(), null, true);

        Test.startTest();
        runConversion();
        Test.stopTest();

        Form_Submission__c parent = reload(parentId);
        assertStatusWithLogs('Complete', parent.Conversion_Status__c, parentId, 'primaryContactChecked_household');
        System.assertEquals('Joon', [SELECT npe01__One2OneContact__r.FirstName FROM Account WHERE Id = :parent.Account__c].npe01__One2OneContact__r.FirstName, 'The checked Contact 2 is the Household Primary Contact');
    }

    // ---- more household paths ----

    @IsTest
    static void householdRecordTypeWithoutAccountRule_stampsTheHouseholdAndContact2StillJoins() {
        Id parentId = submit('NPSP Household Without Account Rule', person('Yusuf', 'Demir'), person('Elif', 'Demir'), new List<Contact>());

        Test.startTest();
        runConversion();
        Test.stopTest();

        Form_Submission__c parent = reload(parentId);
        assertStatusWithLogs('Complete', parent.Conversion_Status__c, parentId, 'householdWithoutAccountRule');
        System.assertNotEquals(null, parent.Account__c, 'Contact 1 still stamps its Household on the submission');
        System.assertEquals(2, [SELECT COUNT() FROM Contact WHERE LastName = 'Demir' AND AccountId = :parent.Account__c], 'Contact 2 joins it without an Account rule');
        System.assert(!hasLogWithStatus(parentId, 'Error'), 'A clean run writes no Error log');
    }

    @IsTest
    static void household_matchedContact2InAnotherHousehold_isAddedToTheFamilyHousehold() {
        Contact layla = person('Layla', 'Haddad');
        insertBypassingDuplicateRules(new List<Contact>{layla});
        Id previousHouseholdId = [SELECT AccountId FROM Contact WHERE Id = :layla.Id].AccountId;

        Id parentId = submit('NPSP Household Intake', person('Omar', 'Haddad'), person('Layla', 'Haddad'), new List<Contact>());

        Test.startTest();
        runConversion();
        Test.stopTest();

        Form_Submission__c parent = reload(parentId);
        assertStatusWithLogs('Complete', parent.Conversion_Status__c, parentId, 'matchedContact2InAnotherHousehold');
        System.assertEquals('Matched', parent.Conversion_Status_Contact_2__c, 'The existing spouse is matched, not duplicated');
        System.assertEquals(parent.Account__c, [SELECT AccountId FROM Contact WHERE Id = :layla.Id].AccountId, 'The matched spouse is added to the family Household');
        System.assertEquals(1, [SELECT COUNT() FROM Account WHERE Id = :previousHouseholdId], 'NPSP keeps the spouse previous Household; it is never deleted');
    }

    @IsTest
    static void primaryContactChecked_onRepeaterRow_becomesTheHouseholdPrimaryContact() {
        Id parentId = submit('NPSP Household Intake', person('Hana', 'Kim'), person('Joon', 'Kim'), new List<Contact>{person('Mina', 'Kim')});
        Form_Submission__c row = [SELECT Id FROM Form_Submission__c WHERE Parent_Form_Submission__c = :parentId];
        row.Contact2_Primary_Contact__c = true;
        update row;

        Test.startTest();
        runConversion();
        Test.stopTest();

        Form_Submission__c parent = reload(parentId);
        assertStatusWithLogs('Complete', parent.Conversion_Status__c, parentId, 'primaryContactChecked_repeaterRow');
        System.assertEquals('Mina', [SELECT npe01__One2OneContact__r.FirstName FROM Account WHERE Id = :parent.Account__c].npe01__One2OneContact__r.FirstName, 'The checked repeater row person is the Household Primary Contact');
    }

    @IsTest
    static void campaignMembers_bothContacts_areChainedAfterTheHouseholdFollowUps() {
        Campaign campaign = new Campaign(Name = 'Family Night', IsActive = true);
        insert campaign;
        Id parentId = submit('NPSP Household Campaign', person('Grace', 'Park'), person('Daniel', 'Park'), new List<Contact>());
        update new Form_Submission__c(Id = parentId, Campaign__c = campaign.Id);

        Test.startTest();
        runConversion();
        Test.stopTest();

        Form_Submission__c parent = [SELECT Conversion_Status__c, Conversion_Status_CampaignMember_1__c, Conversion_Status_CampaignMember_2__c, Account__c FROM Form_Submission__c WHERE Id = :parentId];
        assertStatusWithLogs('Complete', parent.Conversion_Status__c, parentId, 'campaignMembers');
        System.assertEquals('Created', parent.Conversion_Status_CampaignMember_1__c, 'Contact 1 Campaign Member created');
        System.assertEquals('Created', parent.Conversion_Status_CampaignMember_2__c, 'Contact 2 Campaign Member created');
        System.assertEquals(2, [SELECT COUNT() FROM CampaignMember WHERE CampaignId = :campaign.Id AND Contact.LastName = 'Park'], 'Both people are Campaign Members');
        System.assertEquals(2, [SELECT COUNT() FROM Contact WHERE LastName = 'Park' AND AccountId = :parent.Account__c], 'The Household follow-ups still ran before the Campaign Members');
    }

    @IsTest
    static void householdWithoutAddToAccount_contact2KeepsItsOwnHousehold() {
        Id parentId = submit('NPSP Household Without Add to Account', person('Leo', 'Marsh'), person('Ada', 'Marsh'), new List<Contact>());

        Test.startTest();
        runConversion();
        Test.stopTest();

        Form_Submission__c parent = reload(parentId);
        assertStatusWithLogs('Complete', parent.Conversion_Status__c, parentId, 'householdWithoutAddToAccount');
        System.assertEquals(parent.Account__c, [SELECT AccountId FROM Contact WHERE FirstName = 'Leo' AND LastName = 'Marsh'].AccountId, 'Contact 1 Household is stamped on the submission');
        System.assertNotEquals(parent.Account__c, [SELECT AccountId FROM Contact WHERE FirstName = 'Ada' AND LastName = 'Marsh'].AccountId, 'Without an Add to Account rule Contact 2 is not linked to the stamped Household');
    }

    // ---- NPSP contact preferences ----

    @IsTest
    static void preferredEmailAndPhone_fillTheNpspTypedFields() {
        Id parentId = submit('NPSP Household Intake', person('Rosa', 'Vega'), person('Tito', 'Vega'), new List<Contact>());
        update new Form_Submission__c(Id = parentId,
            Contact1_Email_Type__c = 'Work', Contact1_Phone__c = '5035550101', Contact1_Phone_Type__c = 'Mobile',
            Contact2_Email_Type__c = 'Other', Contact2_Phone__c = '5035550102', Contact2_Phone_Type__c = 'Home');

        Test.startTest();
        runConversion();
        Test.stopTest();

        assertStatusWithLogs('Complete', reload(parentId).Conversion_Status__c, parentId, 'preferredEmailAndPhone');
        Contact rosa = [SELECT Email, npe01__WorkEmail__c, npe01__Preferred_Email__c, MobilePhone, npe01__PreferredPhone__c FROM Contact WHERE FirstName = 'Rosa' AND LastName = 'Vega'];
        System.assertEquals('Work', rosa.npe01__Preferred_Email__c, 'Email Type Work is the Preferred Email');
        System.assertEquals(rosa.Email, rosa.npe01__WorkEmail__c, 'The email also lands in Work Email, so Preferred Email points at a filled field');
        System.assertEquals('Mobile', rosa.npe01__PreferredPhone__c, 'Phone Type Mobile is the Preferred Phone');
        System.assertEquals('5035550101', rosa.MobilePhone, 'The phone also lands in Mobile Phone');
        Contact tito = [SELECT Email, npe01__AlternateEmail__c, npe01__Preferred_Email__c, HomePhone, npe01__PreferredPhone__c FROM Contact WHERE FirstName = 'Tito' AND LastName = 'Vega'];
        System.assertEquals('Alternate', tito.npe01__Preferred_Email__c, 'Email Type Other becomes NPSP Alternate');
        System.assertEquals(tito.Email, tito.npe01__AlternateEmail__c, 'The email lands in Alternate Email');
        System.assertEquals('Home', tito.npe01__PreferredPhone__c, 'Phone Type Home is the Preferred Phone');
        System.assertEquals('5035550102', tito.HomePhone, 'The phone lands in Home Phone');
    }

    @IsTest
    static void doNotContact_isSetWhenCheckedAndNeverClearedByAForm() {
        Contact returning = person('June', 'Hale');
        returning.npsp__Do_Not_Contact__c = true;
        insertBypassingDuplicateRules(new List<Contact>{returning});
        Id parentId = submit('NPSP Household Intake', person('June', 'Hale'), person('Owen', 'Hale'), new List<Contact>());
        update new Form_Submission__c(Id = parentId, Contact1_DoNotCall__c = false, Contact2_DoNotCall__c = true);

        Test.startTest();
        runConversion();
        Test.stopTest();

        assertStatusWithLogs('Complete', reload(parentId).Conversion_Status__c, parentId, 'doNotContact');
        System.assert([SELECT npsp__Do_Not_Contact__c FROM Contact WHERE Id = :returning.Id].npsp__Do_Not_Contact__c, 'An unchecked box never clears an existing Do Not Contact');
        System.assert([SELECT npsp__Do_Not_Contact__c FROM Contact WHERE FirstName = 'Owen' AND LastName = 'Hale'].npsp__Do_Not_Contact__c, 'Contact 2 checked Do Not Call, read from the Contact 2 field');
    }

    // ---- errors and matching ----

    @IsTest
    static void blankLastName_errorsContact1_thenReprocessCompletes() {
        Id parentId = submit('NPSP Household Intake', new Contact(FirstName = 'Nameless', Email = 'nameless.npsp.test@example.com'), person('Partner', 'Vale'), new List<Contact>());

        Test.startTest();
        runConversion();
        Form_Submission__c failed = reload(parentId);
        System.assertEquals('Error', failed.Conversion_Status_Contact_1__c, 'A Contact needs a last name, so Contact 1 errors');
        System.assertNotEquals('Complete', failed.Conversion_Status__c, 'The conversion halts');
        System.assertEquals(0, [SELECT COUNT() FROM Contact WHERE LastName = 'Vale'], 'Contact 2 waits for the Household, so nobody else converts');

        update new Form_Submission__c(Id = parentId, Contact1_Last_Name__c = 'Vale');
        startAgain(parentId);
        runConversion();
        Test.stopTest();

        Form_Submission__c fixed = reload(parentId);
        assertStatusWithLogs('Complete', fixed.Conversion_Status__c, parentId, 'blankLastName reprocess');
        System.assertEquals(2, [SELECT COUNT() FROM Contact WHERE LastName = 'Vale' AND AccountId = :fixed.Account__c], 'After the fix both people convert into one Household');
    }

    @IsTest
    static void multipleMatches_withoutMostConfidentMatch_errorsInsteadOfGuessing() {
        insertBypassingDuplicateRules(new List<Contact>{person('Chris', 'Doyle'), person('Chris', 'Doyle')});
        Id parentId = submit('NPSP Household Intake', person('Chris', 'Doyle'), null, new List<Contact>());

        Test.startTest();
        runConversion();
        Test.stopTest();

        Form_Submission__c parent = reload(parentId);
        System.assertEquals('Error', parent.Conversion_Status_Contact_1__c, 'Two matching Contacts and no Update Most Confident Match: the pipeline refuses to guess');
        System.assertEquals(2, [SELECT COUNT() FROM Contact WHERE LastName = 'Doyle'], 'No third Contact is created');
    }

    // ---- more organization paths ----

    @IsTest
    static void existingOrganization_existingCurrentAffiliation_isUpdatedNotDuplicated() {
        Account organization = newOrganization('Riverside Elementary School');
        Contact sarah = person('Sarah', 'Johnson');
        insertBypassingDuplicateRules(new List<Contact>{sarah});
        insert new npe5__Affiliation__c(npe5__Contact__c = sarah.Id, npe5__Organization__c = organization.Id, npe5__Status__c = 'Current', npe5__Primary__c = true, npe5__StartDate__c = Date.newInstance(2019, 8, 15), npe5__Role__c = 'Teacher');

        Contact submitted = person('Sarah', 'Johnson');
        submitted.Title = 'Principal';
        Id parentId = submit('NPSP Organization Intake', submitted, null, new List<Contact>(), 'Riverside Elementary School', false);
        update new Form_Submission__c(Id = parentId, Account__c = organization.Id);

        Test.startTest();
        runConversion();
        Test.stopTest();

        Form_Submission__c parent = reload(parentId);
        assertStatusWithLogs('Complete', parent.Conversion_Status__c, parentId, 'existingOrganization');
        System.assertEquals('Updated', parent.Conversion_Status_Account__c, 'The Organization already on the submission is updated, not created');
        System.assertEquals('Matched', parent.Conversion_Status_Contact_1__c, 'Sarah is matched');
        List<npe5__Affiliation__c> affiliations = [SELECT npe5__Role__c, npe5__StartDate__c, npe5__Primary__c FROM npe5__Affiliation__c WHERE npe5__Contact__c = :sarah.Id AND npe5__Organization__c = :organization.Id];
        System.assertEquals(1, affiliations.size(), 'The existing Current affiliation is updated, never duplicated');
        System.assertEquals('Principal', affiliations[0].npe5__Role__c, 'The Role follows the new Title');
        System.assertEquals(Date.newInstance(2019, 8, 15), affiliations[0].npe5__StartDate__c, 'The original Start Date is kept');
        System.assert(affiliations[0].npe5__Primary__c, 'It stays primary: it already was this Organization');
    }

    @IsTest
    static void primaryContactChecked_onContact1_replacesTheOrganizationPrimaryContact() {
        Account organization = newOrganization('Maple Tenants Union');
        Contact previous = person('Former', 'Lead');
        insertBypassingDuplicateRules(new List<Contact>{previous});
        organization.npe01__One2OneContact__c = previous.Id;
        update organization;

        Id parentId = submit('NPSP Organization Intake', person('Iris', 'Novak'), null, new List<Contact>(), 'Maple Tenants Union', false);
        update new Form_Submission__c(Id = parentId, Account__c = organization.Id, Contact1_Primary_Contact__c = true);

        Test.startTest();
        runConversion();
        Test.stopTest();

        assertStatusWithLogs('Complete', reload(parentId).Conversion_Status__c, parentId, 'primaryContactChecked_contact1');
        System.assertEquals('Novak', [SELECT npe01__One2OneContact__r.LastName FROM Account WHERE Id = :organization.Id].npe01__One2OneContact__r.LastName, 'A checked Contact 1 replaces an existing Primary Contact');
    }

    @IsTest
    static void organizationRepeaterRow_isAffiliatedWithTheOrganization() {
        Contact staff = person('Omari', 'Hill');
        staff.Title = 'Tutor';
        Id parentId = submit('NPSP Organization Intake', person('Kofi', 'Mensah'), null, new List<Contact>{staff}, 'Northside Literacy Project', false);

        Test.startTest();
        runConversion();
        Test.stopTest();

        Form_Submission__c parent = reload(parentId);
        assertStatusWithLogs('Complete', parent.Conversion_Status__c, parentId, 'organizationRepeaterRow');
        npe5__Affiliation__c affiliation = [SELECT npe5__Status__c, npe5__Role__c FROM npe5__Affiliation__c WHERE npe5__Contact__r.LastName = 'Hill' AND npe5__Organization__c = :parent.Account__c];
        System.assertEquals('Current', affiliation.npe5__Status__c, 'The repeater row person is affiliated with the parent submission Organization');
    }

    @IsTest
    static void affiliationUtility_refusesAHouseholdAndAMissingAccount() {
        Contact person = person('Rae', 'Stone');
        insertBypassingDuplicateRules(new List<Contact>{person});
        Id householdId = [SELECT AccountId FROM Contact WHERE Id = :person.Id].AccountId;

        for (Id accountId : new List<Id>{householdId, null}) {
            Flow.Interview interview = Flow.Interview.createInterview('NPSP_Utility_Upsert_Affiliation', new Map<String, Object>{'ContactId' => person.Id, 'AccountId' => accountId});
            interview.start();
            System.assertEquals(true, interview.getVariableValue('HasError'), 'The utility refuses ' + (accountId == null ? 'a missing Account' : 'a Household'));
            System.assert(String.isNotBlank((String) interview.getVariableValue('ErrorMessage')), 'With a message the caller can log');
        }
        System.assertEquals(0, [SELECT COUNT() FROM npe5__Affiliation__c WHERE npe5__Contact__c = :person.Id], 'Nothing is written');
    }

    // ---- the packaged steps still run through the NPSP controller ----

    @IsTest
    static void opportunityAndCase_convertThroughTheNpspController() {
        Id parentId = submit('NPSP Other Objects', person('Lena', 'Brooks'), null, new List<Contact>());
        update new Form_Submission__c(Id = parentId, Stage_Status__c = 'Closed Won', Date__c = Date.today(), Amount__c = 250, Subject__c = 'Program question', Description__c = 'Asked about the youth program');

        Test.startTest();
        runConversion();
        Test.stopTest();

        Form_Submission__c parent = [SELECT Conversion_Status__c, Conversion_Status_Opportunity__c, Conversion_Status_Case__c, Opportunity__c, Case__c, Account__c FROM Form_Submission__c WHERE Id = :parentId];
        assertStatusWithLogs('Complete', parent.Conversion_Status__c, parentId, 'opportunityAndCase');
        System.assertEquals('Created', parent.Conversion_Status_Opportunity__c, 'The Opportunity step runs');
        System.assertEquals('Created', parent.Conversion_Status_Case__c, 'The Case step runs');
        System.assertNotEquals(null, parent.Opportunity__c, 'The Opportunity is stamped');
        System.assertNotEquals(null, parent.Case__c, 'The Case is stamped');
    }

    @IsTest
    static void lead_convertsThroughTheNpspController() {
        Form_Template__c template = [SELECT Id FROM Form_Template__c WHERE Name = 'NPSP Lead'];
        Form_Submission__c submission = new Form_Submission__c(Form_Template__c = template.Id, Status__c = 'Draft', Submission_Date__c = System.now(), Company__c = 'Lakeview Co-op',
            Contact1_First_Name__c = 'Tess', Contact1_Last_Name__c = 'Nolan', Contact1_Email__c = 'tess.nolan.npsp.test@example.com');
        insert submission;
        submission.Status__c = 'Submitted';
        update submission;

        Test.startTest();
        runConversion();
        Test.stopTest();

        Form_Submission__c reloaded = [SELECT Conversion_Status__c, Conversion_Status_Lead_1__c, Lead_1__c FROM Form_Submission__c WHERE Id = :submission.Id];
        assertStatusWithLogs('Complete', reloaded.Conversion_Status__c, submission.Id, 'lead');
        System.assertEquals('Created', reloaded.Conversion_Status_Lead_1__c, 'The Lead step runs');
        System.assertEquals(1, [SELECT COUNT() FROM Lead WHERE LastName = 'Nolan'], 'One Lead');
    }

    @IsTest
    static void fileUpload_isLinkedAndMarkedProcessed() {
        ContentVersion version = new ContentVersion(Title = 'Proof of residence', PathOnClient = 'proof.txt', VersionData = Blob.valueOf('proof'));
        insert version;
        version = [SELECT Id, ContentDocumentId FROM ContentVersion WHERE Id = :version.Id];
        Id parentId = submit('NPSP Household Intake', person('Ivy', 'Chen'), null, new List<Contact>());
        update new Form_Submission__c(Id = parentId, File_Upload_1__c = '{"files":[{"name":"proof.txt","documentId":"' + version.ContentDocumentId + '","contentVersionId":"' + version.Id + '"}],"processed":false}');

        Test.startTest();
        runConversion();
        Test.stopTest();

        Form_Submission__c parent = [SELECT Conversion_Status__c, File_Upload_1__c FROM Form_Submission__c WHERE Id = :parentId];
        assertStatusWithLogs('Complete', parent.Conversion_Status__c, parentId, 'fileUpload');
        System.assert(parent.File_Upload_1__c.replace(' ', '').contains('"processed":true'), 'The Files step runs once and marks the manifest processed');
    }

    @IsTest
    static void confirmationEmail_isSentThroughTheNpspController() {
        /**The Send Email step only accepts Lightning templates related to Form Submission.**/
        EmailTemplate emailTemplate = new EmailTemplate(DeveloperName = 'NPSP_Conversion_Test_Confirmation', Name = 'NPSP Conversion Test Confirmation', TemplateType = 'custom', UiType = 'SFX', RelatedEntityType = Form_Submission__c.SObjectType.getDescribe().getName(), FolderId = UserInfo.getUserId(), Subject = 'Thank you', HtmlValue = '<p>Thank you</p>');
        System.runAs(new User(Id = UserInfo.getUserId())) {
            insert emailTemplate;
        }
        Form_Template__c template = [SELECT Id FROM Form_Template__c WHERE Name = 'NPSP Household Intake'];
        update new Form_Template__c(Id = template.Id, Send_Confirmation__c = true, Email_Template_Name_Confirmation__c = 'NPSP_Conversion_Test_Confirmation');
        Id parentId = submit('NPSP Household Intake', person('Maya', 'Ross'), null, new List<Contact>());

        Test.startTest();
        runConversion();
        Test.stopTest();

        Form_Submission__c parent = [SELECT Conversion_Status__c, Internal_Confirmation_Last_Sent__c FROM Form_Submission__c WHERE Id = :parentId];
        assertStatusWithLogs('Complete', parent.Conversion_Status__c, parentId, 'confirmationEmail');
        System.assertNotEquals(null, parent.Internal_Confirmation_Last_Sent__c, 'The confirmation email step runs once Contact 1 exists | LOGS >> ' + logLines(parentId));
    }

    @IsTest
    static void additionalData_rowsAreCreatedAndJoinTheHousehold() {
        Form_Template__c template = [SELECT Id FROM Form_Template__c WHERE Name = 'NPSP Household Intake'];
        Form_Template_Page_Section__c section = [SELECT Id FROM Form_Template_Page_Section__c WHERE Form_Template_Page__r.Form_Template__c = :template.Id AND Conversion_Rule__c = 'Contact2' LIMIT 1];
        Id parentId = submit('NPSP Household Intake', person('Noah', 'Grant'), null, new List<Contact>());
        String payload = JSON.serialize(new List<Map<String, Object>>{new Map<String, Object>{
            'FlowToolKit__UniqueId__c' => 'npsp-additional-data-row',
            'FlowToolKit__Internal_Is_Related_Record__c' => true,
            'FlowToolKit__Internal_SectionId__c' => section.Id,
            'FlowToolKit__Form_Template__c' => template.Id,
            'FlowToolKit__Status__c' => 'Submitted',
            'FlowToolKit__Contact2_First_Name__c' => 'Ella',
            'FlowToolKit__Contact2_Last_Name__c' => 'Grant',
            'FlowToolKit__Contact2_Email__c' => 'ella.grant.npsp.test@example.com'}});
        update new Form_Submission__c(Id = parentId, Internal_Additional_Data__c = payload);

        Test.startTest();
        runConversion();
        Test.stopTest();

        Form_Submission__c parent = reload(parentId);
        assertStatusWithLogs('Complete', parent.Conversion_Status__c, parentId, 'additionalData');
        System.assertEquals(1, [SELECT COUNT() FROM Form_Submission__c WHERE Parent_Form_Submission__c = :parentId], 'The Additional Data row becomes a related submission');
        System.assertEquals(2, [SELECT COUNT() FROM Contact WHERE LastName = 'Grant' AND AccountId = :parent.Account__c], 'The row person joins the Household');
    }

    // ---- helpers ----

    private static Contact person(String firstName, String lastName) {
        return new Contact(FirstName = firstName, LastName = lastName, Email = firstName.toLowerCase() + '.' + lastName.toLowerCase() + '.npsp.test@example.com');
    }

    private static Id submit(String templateName, Contact contact1, Contact contact2, List<Contact> relatives) {
        return submit(templateName, contact1, contact2, relatives, null, false);
    }

    /**Contact 1 and Contact 2 on the main submission, relatives as related rows of the Contact 2 repeater section; returns the parent Id, converted once the test delivers the events.**/
    private static Id submit(String templateName, Contact contact1, Contact contact2, List<Contact> relatives, String company, Boolean contact2IsPrimaryContact) {
        Form_Template__c template = [SELECT Id FROM Form_Template__c WHERE Name = :templateName];
        Form_Submission__c parent = new Form_Submission__c(Form_Template__c = template.Id, Status__c = 'Draft', Submission_Date__c = System.now(), Company__c = company,
            Contact1_First_Name__c = contact1.FirstName, Contact1_Last_Name__c = contact1.LastName, Contact1_Email__c = contact1.Email, Contact1_Title__c = contact1.Title);
        if (contact2 != null) {
            parent.Contact2_First_Name__c = contact2.FirstName;
            parent.Contact2_Last_Name__c = contact2.LastName;
            parent.Contact2_Email__c = contact2.Email;
            parent.Contact2_Title__c = contact2.Title;
            parent.Contact2_Primary_Contact__c = contact2IsPrimaryContact;
        }
        insert parent;

        if (!relatives.isEmpty()) {
            Form_Template_Page_Section__c section = [SELECT Id FROM Form_Template_Page_Section__c WHERE Form_Template_Page__r.Form_Template__c = :template.Id AND Conversion_Rule__c = 'Contact2' LIMIT 1];
            List<Form_Submission__c> rows = new List<Form_Submission__c>();
            for (Contact relative : relatives) {
                rows.add(new Form_Submission__c(Form_Template__c = template.Id, Parent_Form_Submission__c = parent.Id, Internal_Is_Related_Record__c = true, Internal_SectionId__c = section.Id,
                    Status__c = 'Submitted', Submission_Date__c = System.now(),
                    Contact2_First_Name__c = relative.FirstName, Contact2_Last_Name__c = relative.LastName, Contact2_Email__c = relative.Email));
            }
            insert rows;
        }
        parent.Status__c = 'Submitted';
        update parent; /**Submitted with a submission date and no parent: the packaged record-triggered flow publishes Start**/
        return parent.Id;
    }

    private static void insertBypassingDuplicateRules(List<Contact> contacts) {
        Database.DMLOptions dmlOptions = new Database.DMLOptions();
        dmlOptions.duplicateRuleHeader.allowSave = true;
        Database.insert(contacts, dmlOptions);
    }

    private static Account newOrganization(String name) {
        Account organization = new Account(Name = name, RecordTypeId = [SELECT Id FROM RecordType WHERE SobjectType = 'Account' AND DeveloperName = 'Organization'].Id);
        insert organization;
        return organization;
    }

    /**Walks the event chain: each hop publishes the next event, which the next delivery runs. Forty is far above the longest chain here.**/
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
        request.elementApiName = 'NPSP_Conversion_Test';
        FormSubmission_LogEvent_Invocable.logConversionEvent(new List<FormSubmission_LogEvent_Invocable.InvokedRequest>{request});
    }

    private static Form_Submission__c reload(Id submissionId) {
        return [SELECT Id, Form_Template__c, Conversion_Status__c, Conversion_Status_Contact_1__c, Conversion_Status_Contact_2__c, Conversion_Status_Account__c, Contact_1__c, Contact_2__c, Account__c FROM Form_Submission__c WHERE Id = :submissionId];
    }

    /**Build-org diagnosis: on a status mismatch the whole Conversion Log rides out in the assertion message.**/
    private static void assertStatusWithLogs(String expected, String actual, Id submissionId, String message) {
        if (expected == actual) return;
        System.assert(false, message + ' | expected ' + expected + ' got ' + actual + ' | LOGS >> ' + logLines(submissionId));
    }

    private static String logLines(Id submissionId) {
        List<String> lines = new List<String>();
        for (Form_Submission_Conversion_Log__c log : [SELECT Status__c, Log_Message__c FROM Form_Submission_Conversion_Log__c WHERE Form_Submission__c = :submissionId OR Parent_Form_Submission__c = :submissionId ORDER BY CreatedDate]) lines.add(log.Status__c + ': ' + String.valueOf(log.Log_Message__c).replace('\n', ' ^ '));
        return String.join(lines, ' /// ');
    }

    private static Boolean hasLogWithStatus(Id submissionId, String status) {
        return [SELECT COUNT() FROM Form_Submission_Conversion_Log__c WHERE (Form_Submission__c = :submissionId OR Parent_Form_Submission__c = :submissionId) AND Status__c = :status] > 0;
    }
}
