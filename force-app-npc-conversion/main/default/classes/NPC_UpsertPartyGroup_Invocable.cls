/**
 * (NPC) Upsert Party Relationship Group - the write half of the party-object packaging bypass.
 *
 * WHY THIS EXISTS: package validation refuses a native Create element on PartyRelationshipGroup in the
 * licence-less build org (#628), and the packaged GENERIC upsert action cannot carry this object at
 * runtime: this object's enum picklists (Type, Status) cannot cross the Flow-to-Apex ACTION INPUT
 * boundary at all - the marshaller fails with 'Unable to convert value ... to Apex type String' the
 * moment either is set on the record (Apex-to-Flow, the other direction, is fine). So both travel as
 * plain String inputs and are stamped onto the record here.
 *
 * PUBLIC ON PURPOSE, NEVER GLOBAL: only the packaged utility flow calls it. A subscriber cloning the
 * flow uses a plain Create element instead - their org has the licence assigned.
 *
 * Upserts on Id exactly as the Create element it replaces did: blank Id inserts, a real Id updates.
 */
public with sharing class NPC_UpsertPartyGroup_Invocable {

    @InvocableMethod(Label='(NPC) Upsert Party Relationship Group' Category='Flow Tool Kit' Description='Inserts or updates one Party Relationship Group by the Id it carries: blank Id inserts, a real Id updates.')
    public static List<Result> run(List<Request> requests) {
        List<Result> results = new List<Result>();
        for (Request request : requests) {
            Result result = new Result();
            if (request.partyRelationshipGroup != null) {
                if (String.isNotBlank(request.groupType)) request.partyRelationshipGroup.Type = request.groupType;
                Boolean isNew = String.isBlank(request.partyRelationshipGroup.Id);
                /**A brand-new group takes the requested status; an existing one is always set back to Active, so a closed group comes back with the family.**/
                request.partyRelationshipGroup.Status = isNew && String.isNotBlank(request.groupStatus) ? request.groupStatus : 'Active';
                if (isNew) insert request.partyRelationshipGroup;
                else update request.partyRelationshipGroup;
                /**A fresh echo without Type or Status: an enum field carrying a value cannot cross back to Flow under the managed runtime (proven by returningHead stalling in the 1.1.0.1 subscriber install, the one scenario where a populated group crosses).**/
                result.partyRelationshipGroup = new PartyRelationshipGroup(
                        Id = request.partyRelationshipGroup.Id,
                        AccountId = request.partyRelationshipGroup.AccountId,
                        Name = request.partyRelationshipGroup.Name,
                        StartDate = request.partyRelationshipGroup.StartDate);
            }
            results.add(result);
        }
        return results;
    }

    public class Request {
        @InvocableVariable(Label='Party Relationship Group' Description='The group to save, with its Id filled in when it already exists. Leave its Type blank and use Group Type instead.')
        public PartyRelationshipGroup partyRelationshipGroup;
        @InvocableVariable(Label='Group Type' Description='The party group type, stamped onto the record in Apex - this object\'s enum picklists cannot cross the Flow action input boundary.')
        public String groupType;
        @InvocableVariable(Label='Group Status' Description='Status for a brand-new group; an existing group is always set back to Active.')
        public String groupStatus;
    }

    public class Result {
        @InvocableVariable(Label='Party Relationship Group' Description='The saved group, carrying its Id.')
        public PartyRelationshipGroup partyRelationshipGroup;
    }
}
