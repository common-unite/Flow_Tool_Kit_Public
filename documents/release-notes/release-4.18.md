# Release 4.18

4.18 pairs a form-runtime feature set built around one idea - a source record drives many forms - with a broad polish pass over Site Design Blocks, and closes a permission gap that affected delegated administrators.

Two items are **behavior changes** you should read before upgrading: [source overrides no longer replace a fixed template](#-source-overrides-without-template-replacement-543) and [related-record components are now editable](#-editable-related-records-with-autosave-545).

---

## Form runtime

### 📖 Read Only keeps navigation, drops every write (#531)

A Form Submission in Read Only mode now hides **Submit**, **Update**, and **Complete Stage** while keeping **Next**, **Back**, **Review**, and **Return**. Respondents and reviewers can walk the entire form - every page, every stage - without any path that changes it.

### 🔀 Source overrides without template replacement (#543)

The rule is now one sentence: **the source picks a template only when nothing else has.**

Navigate to any Form Template - its Experience Cloud record page, or a page with a fixed template - with `?sourceId=<record id>` in the URL, and that source record's overrides apply to the form being viewed: name, active window, start and close dates, prefill, confirmation and offline messages, theme, banner, submit label. The template itself is never swapped. Saved submissions remember their source, so a resumed submission re-applies the same overrides against its own template.

**What this unlocks:** one source record can drive several forms. A Volunteer Job's lookup names its default registration form, and additional Form Template lookups (say, Individual and Group registration) become sibling forms you link to - each URL carries the same job-driven overrides and stamps the job onto the submission.

**Behavior change:** a page with a fixed template plus `?sourceId=` previously rendered the *source's* template. It now keeps the fixed template and applies the source's overrides. The `sourceId` parameter matches any casing, and `c__sourceId` remains the bulletproof spelling on Aura sites.

### 📝 Review Mode for embedded submissions (#544)

The **View/Edit Form Submission** lookup override gains a **Review Mode** toggle in the form builder. The embedded submission opens as a one-page summary of every answer - no stage indicators, no page navigation - exactly like the Review Mode checkbox an admin sets on the form runtime component's record page. Combine it with the field's Read Only setting for a sealed summary.

### ✏️ Editable related records with autosave (#545)

A lookup rendered as a related Form Component is now **editable unless the field is read only**. Each change saves automatically about a second and a half after the respondent pauses, writing only the fields that changed - and holding silently while the embedded component's own validation fails, then committing once it passes.

Guest users keep the read-only display: the platform does not permit guest record updates through this path, and users without update permission on the related object are equally protected.

**Behavior change:** existing forms using this override become editable for authenticated users with update access. If a form relied on the always-read-only display, set the field itself to Read Only.

### 🔓 Delegated admins: two flows un-broken (#524)

The **Reprocess** quick action and **Review & Merge Form Submissions** were granted in no permission set - invisible to System Administrators, whose profile bypasses flow security, but an access error for Form Builder Manager users on controls the product put in front of them. Both flows are now granted in the Admin and Manager permission sets.

---

## Site Design Blocks

### 🧱 New Heading block type (#539)

A first-class page opener: eyebrow, heading, supporting copy, optional buttons and footnote. Pages no longer fake a heading with an image-less Hero.

### 🦸 Hero fixes (#536, #537, #540, #541)

The hero hugs its content - the tall empty band between the text column and the footnote is gone. Its image now follows the **Vertical Alignment** control instead of pinning to the top, the **Media Side** control moves the image to the side its label says, and **Timeline** joins Facts, Stats, and Quote as a hero media option.

### 🎛 Controls that mean what they say (#532, #542)

**Footnote Alignment** aligns the footnote. **Icon Size** is the icon's actual size - the invalid X-Large option is gone (saved values quietly map to Large), tile and circle backdrops wrap their icon proportionally at every size, and small tiles keep their corners instead of rounding into circles.

### 🎨 Under the hood

The entire block family moved to Lightning's native layout system, and the blocks' brand tokens now inherit your site's **Theme panel** - brand color, accent, body and heading fonts flow into every block with no custom CSS. Set your brand once in Experience Builder and the blocks follow.

---

## 🔧 What you need to do after upgrading

- **Load your public form pages once.** The first visit after an upgrade pays the component compile (several seconds); make that visit yours, not a respondent's.
- If any form relied on the related-component override being read-only, set that field to **Read Only** in the form builder.
- If any page combined a fixed template with `?sourceId=` links expecting the source's template to load, link directly to each template instead - the source's overrides follow the URL.
