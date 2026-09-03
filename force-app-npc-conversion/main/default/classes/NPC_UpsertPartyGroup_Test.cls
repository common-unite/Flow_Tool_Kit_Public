/**Direct coverage for the typed upsert action - the validated build computes code coverage.**/
@IsTest
private class NPC_UpsertPartyGroup_Test {

    @IsTest
    static void blankIdInserts_realIdUpdates_nullPassesThrough() {
        Account household = new Account(Name = 'Okafor Household');
        insert household;

        NPC_UpsertPartyGroup_Invocable.Request create = new NPC_UpsertPartyGroup_Invocable.Request();
        create.partyRelationshipGroup = new PartyRelationshipGroup(Name = 'Okafor Household', AccountId = household.Id, Status = 'Active', StartDate = Date.today());
        create.groupType = 'Household';
        List<NPC_UpsertPartyGroup_Invocable.Result> created = NPC_UpsertPartyGroup_Invocable.run(
                new List<NPC_UpsertPartyGroup_Invocable.Request>{create});
        Assert.isNotNull(created[0].partyRelationshipGroup.Id, 'A blank Id inserts');
        Assert.areEqual('Household', [SELECT Type FROM PartyRelationshipGroup WHERE Id = :created[0].partyRelationshipGroup.Id].Type, 'Group Type is stamped in Apex');

        NPC_UpsertPartyGroup_Invocable.Request rename = new NPC_UpsertPartyGroup_Invocable.Request();
        rename.partyRelationshipGroup = new PartyRelationshipGroup(Id = created[0].partyRelationshipGroup.Id, Name = 'Okafor Family');
        NPC_UpsertPartyGroup_Invocable.run(new List<NPC_UpsertPartyGroup_Invocable.Request>{rename});
        Assert.areEqual('Okafor Family', [SELECT Name FROM PartyRelationshipGroup WHERE Id = :created[0].partyRelationshipGroup.Id].Name, 'A real Id updates');

        NPC_UpsertPartyGroup_Invocable.Request blank = new NPC_UpsertPartyGroup_Invocable.Request();
        List<NPC_UpsertPartyGroup_Invocable.Result> results = NPC_UpsertPartyGroup_Invocable.run(
                new List<NPC_UpsertPartyGroup_Invocable.Request>{blank});
        Assert.isNull(results[0].partyRelationshipGroup, 'No record in means no record out, not an error');
    }
}
