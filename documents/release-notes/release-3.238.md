# Flow Tool Kit v3.238 Release Notes

A patch release that fixes a restricted-picklist error which blocked saving newer field options (most visibly the **Attestation** boolean display type) on orgs that were **upgraded** from an older version.

> **Upgrades cleanly from 3.237** — no managed-package members were removed.

## Fixes
- **Config values rejected on upgraded orgs** (#222): on an org that was **upgraded** (rather than freshly installed) from an older version, saving a form/table/section configuration that used a picklist value introduced in a later release — most visibly setting a boolean field's display type to **Attestation** — failed with *"bad value for restricted picklist field."* This is caused by a long-standing Salesforce behavior (since Spring '18) where new managed-package picklist values are **not** added to existing subscriber orgs during an upgrade, only on a fresh install. The internal config-storage picklists are now **unrestricted**, so configurations save regardless of when your org first installed the package — and picklist values added in future releases won't hit this again.
