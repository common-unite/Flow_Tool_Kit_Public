# Unreleased: sprint 2026-11-19

## 🛠 Fixes

- The installer's cache step is now **Reset the Flow Tool Kit cache** and does what Reset Form Cache in the Form Builder does: it clears and rebuilds the cache for every form, theme and flow after an install or upgrade, where before it cleared only the cached list of themes.
- A success Log action whose **Record Id** is not an Id (for example a Create Records element that creates from a record variable, which returns `true`) no longer fails in silence: the step stops there, and an Error row names the value, the lookup and the fix, which is `{!Variable.Id}` for that kind of element. The Log action's property editor flags that kind of Record Id with "This is an invalid reference" and clears it, and Finish names the fields still in Error. [Learn more](../form-template-framework/submission-conversion.md#record-id-must-be-the-new-records-id)
- Old nightly cache schedules (**Cache_FlowToolKit_Components**, created by older installers) run the full cache reset and flow warm-up again after this upgrade, with no admin action.
