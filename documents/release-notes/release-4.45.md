# Release 4.45

Forms now keep their full design for every user, and the package installs again in orgs without the Individual object. Experience Cloud components get record-driven visibility rules, the Record Picker filter uses the same rule editor as the rest of Form Builder, and image assets show on LWR sites.

## 🛠 Forms keep their full design for every user (#751)

- **Fields no longer disappear from a form for everyone.** A form built in custom metadata is assembled once and shared by every user. If the first person to load it could not read some of its fields, the shared copy was stored without them, and every user, admins included, saw the short form until an admin opened it in Form Builder. The form is now always assembled exactly as designed. Each user's field access still applies when the form renders: a field the user cannot read shows its "Field is not accessible" placeholder.
- **Saved form versions keep every field too.** Saving a form in Form Builder stores a version of it. That version is now also built from the full design, whoever saves it.
- **PDFs are unchanged.** A PDF still leaves out fields the user generating it cannot read, because it prints record values.
- **If a form is missing fields today,** click **Reset Form Cache** in Form Builder once after upgrading. See [Cache Reset](../advanced-topics/cache-reset.md).

## 🛠 Installs and upgrades work in orgs without the Individual object (#750)

- **Fixed an install failure introduced in 4.42.** Releases 4.42 to 4.44 failed to install or upgrade with "Variable does not exist: Individual" in orgs where **Make data protection details available in records** is off (Setup, Data Protection and Privacy). The Merge Records action no longer requires the object, and Individual records still merge where it exists.
- **If an upgrade to 4.42, 4.43 or 4.44 failed with that error,** upgrade straight to this release.

## 🆕 Record-driven visibility on more Experience Cloud components (#743, #745)

- **Show or hide a component based on the page's record.** The Visibility rule from the Site Design Block is now on **Form (Dynamic Flow)**, **Form (Dynamic Component)**, **Illustration**, **Form Template** and **Header**. Build the rule with the same rule editor used for page conditional logic, for example show a form only when the Account's Type is Prospect.
- **Nothing flashes in and out.** The component waits until the rule decides; a hidden Form Template loads nothing, so it cannot show a load error for a record it will not display.
- **The page record comes from the component's Record Id,** or from `?recordId=` in the URL when Record Id is blank. Header and Illustration gain a Record Id property in Experience Cloud.
- **No rule means no change.** Components without a rule behave exactly as before.

## 🛠 Record Picker filter uses the shared rule editor (#747)

- **Pick picklist values instead of typing them,** search the Field list, and choose operators that match the field type (In, Not In, Includes, Like, Is True, Is False and the comparisons).
- **Merge values** such as `{{AccountId}}` have a button per row, and **cross-object paths** have their own choice in Field.
- **Suggestion fields are searchable.** Show as title, Show below the title, Search on and Also search on use the same searchable list as Field, by label, API name or type.
- **Filters saved in 4.44 load and save unchanged.**

## 🛠 Fixes

- **Dropdowns float over modals and scrolling panels (#744).** Searchable dropdowns in Form Builder and property editors were cut off at the edge of a modal or panel. They now open over it, and upward when there is more room above.
- **Clicking a searchable dropdown selects its text (#747).** Typing then replaces the chosen value instead of being inserted into it.
- **Rich text fields clear when a flow empties them after a save (#746).** The old text stayed in the editor under the placeholder.

## 🛠 Visual Picker and background images on LWR sites (#742)

- **Asset images now load on LWR sites.** Visual Picker option images and form, section and header background images used a URL from the domain root, which an LWR site does not serve, so they stayed blank. On a site, Flow Tool Kit now builds the URL from the site's own path (for example `/portal/sfsites/c/file-asset/<asset>`). Lightning Experience, flows in the org and embedded forms keep the URL they used before.
- **After upgrading, publish each LWR site.** An LWR site serves the component code captured at its last publish.
- **Guests on LWR sites** also need **Allow guest users to access public APIs**, and **Let guest users view asset files** for image assets. See [LWR Sites: Setup and Considerations](../experience-cloud/lwr-site-component-support.md).

## Considerations

- **Publish your Experience Cloud sites after upgrading** to pick up the visibility rules and the LWR image fix.
- **The Visibility setting is not offered in embed mode,** because a form embedded on a third-party site has no page record.
