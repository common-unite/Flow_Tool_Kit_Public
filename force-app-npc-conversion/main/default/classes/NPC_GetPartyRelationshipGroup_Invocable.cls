/**
 * (NPC) Get Party Relationship Group - the read half of the party-object packaging bypass.
 *
 * WHY THIS EXISTS: 2GP package validation deploys the extension into a build org whose user cannot
 * hold the GroupMembershipPsl licence, and Flow's NATIVE Get Records element on PartyRelationshipGroup
 * is refused there ("You can't get PartyRelationshipGroup records in a flow"). Apex is not restricted,
 * and a flow CALLING Apex validates cleanly, so the two utility flows that read groups do it through
 * this action instead of a Get Records element. See issue #628 for the full evidence.
 *
 * PUBLIC ON PURPOSE, NEVER GLOBAL: only the packaged utility flows call it, and a packaged flow
 * resolves the action inside its own namespace even when a subscriber's automation invokes the flow.
 * A subscriber cloning a utility flow replaces this element with a native Get Records - their org has
 * the licence assigned, so the native element works there; only the package build org cannot.
 *
 * Runs in system context WITH SHARING, which matches what the Get Records elements it replaces did
 * (autolaunched flows dispatched from the platform-event trigger run in system context).
 */
public with sharing class NPC_GetPartyRelationshipGroup_Invocable {

    @InvocableMethod(Label='(NPC) Get Party Relationship Group' Category='Flow Tool Kit' Description='Finds one Party Relationship Group: by a single Account and group type, or the OLDEST active group across a collection of Accounts (how a returning family keeps the Household they already have).')
    public static List<Result> run(List<Request> requests) {
        List<Result> results = new List<Result>();
        for (Request request : requests) results.add(process(request));
        return results;
    }

    private static Result process(Request request) {
        Result result = new Result();
        String groupType = String.isNotBlank(request.groupType) ? request.groupType : 'Household';

        List<PartyRelationshipGroup> groups;
        if (request.accountIds != null && !request.accountIds.isEmpty()) {
            String status = String.isNotBlank(request.status) ? request.status : 'Active';
            /**Oldest first: a person somehow in two Households is answered with the one they joined first.**/
            groups = [SELECT Id, Name, AccountId, StartDate FROM PartyRelationshipGroup WHERE Type = :groupType AND Status = :status AND AccountId IN :request.accountIds ORDER BY CreatedDate ASC LIMIT 1];
        } else if (String.isNotBlank(request.accountId)) {
            groups = [SELECT Id, Name, AccountId, StartDate FROM PartyRelationshipGroup WHERE AccountId = :request.accountId AND Type = :groupType LIMIT 1];
        } else {
            groups = new List<PartyRelationshipGroup>();
        }

        if (!groups.isEmpty()) result.partyRelationshipGroup = groups[0];
        return result;
    }

    public class Request {
        @InvocableVariable(Label='Account Id' Description='Find the group on this one Account. Ignored when Account Ids is supplied.')
        public String accountId;
        @InvocableVariable(Label='Account Ids' Description='Find the oldest matching group across these Accounts (a person\'s household memberships).')
        public List<String> accountIds;
        @InvocableVariable(Label='Group Type' Description='Party group type. Defaults to Household.')
        public String groupType;
        @InvocableVariable(Label='Status' Description='Only used with Account Ids. Defaults to Active.')
        public String status;
    }

    public class Result {
        @InvocableVariable(Label='Party Relationship Group' Description='The group found, or null when there is none - null is an answer, not an error. Deliberately queried WITHOUT its Type and Status fields: this object\'s enum picklists cannot cross the Flow action boundary carrying a value, in either direction under the managed runtime.')
        public PartyRelationshipGroup partyRelationshipGroup;
    }
}
