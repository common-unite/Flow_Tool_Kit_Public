/**Direct coverage for the query action - the validated package build computes code coverage, so the
   action cannot rely only on the flow suite exercising it through platform events.**/
@IsTest
private class NPC_GetPartyRelationshipGroup_Test {

    @IsTest
    static void singleAccount_findsTheGroup_andCollectionMode_prefersTheOldest() {
        Account householdOne = new Account(Name = 'Rivera Household');
        Account householdTwo = new Account(Name = 'Rivera Second Household');
        insert new List<Account>{householdOne, householdTwo};
        PartyRelationshipGroup older = new PartyRelationshipGroup(Name = 'Rivera Household', AccountId = householdOne.Id, Type = 'Household', Status = 'Active', StartDate = Date.today());
        insert older;
        PartyRelationshipGroup newer = new PartyRelationshipGroup(Name = 'Rivera Second Household', AccountId = householdTwo.Id, Type = 'Household', Status = 'Active', StartDate = Date.today());
        insert newer;

        NPC_GetPartyRelationshipGroup_Invocable.Request single = new NPC_GetPartyRelationshipGroup_Invocable.Request();
        single.accountId = householdOne.Id;
        NPC_GetPartyRelationshipGroup_Invocable.Request oldest = new NPC_GetPartyRelationshipGroup_Invocable.Request();
        oldest.accountIds = new List<String>{householdOne.Id, householdTwo.Id};
        NPC_GetPartyRelationshipGroup_Invocable.Request blank = new NPC_GetPartyRelationshipGroup_Invocable.Request();

        List<NPC_GetPartyRelationshipGroup_Invocable.Result> results = NPC_GetPartyRelationshipGroup_Invocable.run(
                new List<NPC_GetPartyRelationshipGroup_Invocable.Request>{single, oldest, blank});

        Assert.areEqual(older.Id, results[0].partyRelationshipGroup.Id, 'Single-account mode finds that Account\'s group');
        Assert.areEqual(older.Id, results[1].partyRelationshipGroup.Id, 'Collection mode returns the OLDEST active Household');
        Assert.isNull(results[2].partyRelationshipGroup, 'No inputs means no group, not an error');
    }
}
