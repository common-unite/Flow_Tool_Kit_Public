# Release 4.33

One fix, and an urgent one: it unblocks package upgrades for every org that has been unable to install 4.11 or later.

- **Upgrading past 4.10 works again** (#629): installing any version from 4.11 through 4.32 could fail outright in orgs that had upgraded through the 3.136 era, and the failure named the packaged Relationship field. That field's API name had shipped in the package once before, was removed in 3.136, and came back in 4.11. Salesforce keeps a removed packaged field in your org as **Installed Deleted**, and a returning field with the same name collides with that hidden copy, so the upgrade refused to run. 4.33 retires the name for good and ships the same field as `Contact2_Relationship_to_Contact1__c` with an identical definition: label "Relationship", the same values, still open to your own additions. **Nothing to do in blocked orgs**; upgrading to 4.33 simply works, and the hidden copy stays dormant.
- **Only if you first installed at 4.11 or later and used the Relationship field**: the old `Contact2_Relationship__c` field is retired by this upgrade. Re-point any form template bound to it to the new Relationship field, and export any captured values you still need before treating the retired field as gone. The free-text companion field `Contact2_Relationship_Other__c` is unchanged.

Users of the **Nonprofit Cloud extension** should upgrade it to 1.3.0 alongside this release; earlier extension versions reference the retired field name and will not install cleanly on top of 4.33 in new orgs.

Admins: load your public form pages, including any embedded form URLs, once after upgrading; the first visit pays the component compile so a real visitor does not.
