# Unreleased: conditional logic performance (#687)

Form Template conditional show and hide is fast again. One toggle on a large template used to trigger hundreds of messages and full rule passes across every section; now the sections only announce real changes, the template only pushes real changes, and a pushed record applies only what differs. On a large membership template one toggle's script work dropped from 1.1 to 2.3 seconds to under 0.4 seconds.

## What changed for subscribers

- **The `Flow_Form__c` message channel is quieter.** Every real value change, clear and restore is still announced; only exact repeats of an unchanged value are no longer re-broadcast on every render. Custom components listening on this exposed channel must not rely on the full re-broadcast.
- **A hidden field inside a Repeater row now comes back with its last value** when its rule shows it again. Before, it came back blank.
- **An address section without an Address-type field no longer breaks the form** (#713): validation used to throw on it; it is now skipped.
- Nothing about what a form shows, keeps, clears or saves changes otherwise. Every scenario in the issue was captured before and after and compared field by field.

## After upgrading

Open each public form page once after the upgrade, so the first-load compile happens for you rather than a visitor.
