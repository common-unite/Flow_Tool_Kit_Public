# Flow Tool Kit for Claude Code

If you're not building with Claude and Claude Code yet, you're behind. With the Flow Tool Kit plugin you build forms, Experience Cloud pages and Flow Tool Kit Form Templates fast.

These are the skills we use ourselves. As the makers of Flow Tool Kit, we curated and built them to deliver forms for our own clients. Now you have the same tooling. Bring us whatever form you have, or just describe the one you need, and spin up a working form for your client in minutes.

No hand-built flows. No need to know how to build them. No hours spent wiring long components. Claude and Flow Tool Kit do the building, and you deliver.

## What it does

- Reads any form: FormAssembly, a PDF, a Word document, a web page, Google or Microsoft Forms, a photo of a paper form, a spreadsheet of questions, or a plain description.
- Asks only what the form didn't say, in one short round, with a sensible default for each.
- Designs it in the Flow Tool Kit design system, then builds the Form Template, its components, sections and emails. It prototypes as records straight from chat, and turns the result into metadata when it's final.
- Builds the flows that save each submission to the right records, and the ones that prefill a form from them.
- Opens forms safely to guests, portal users and staff, and checks what an anonymous visitor's browser actually receives.
- Builds Experience Cloud pages, simple site forms and record displays.
- Reuses what your org already has. It looks first and asks before building anything new.

**Paid or free edition:** it works on both. Claude asks once per org and picks the right approach.

## The skills at a glance

- **Start:** ftk-start, the front door, and org-catalog, which maps what the org already has.
- **Read the source:** form-migrate and formassembly-capture.
- **Design:** brand-kit (optional), form-design and design-to-blocks.
- **Build:** build-template, build-form-component, repeating-data with build-repeater and build-table, build-flow-section, build-custom-lwc, build-email-templates, build-site-pages, new-record-page-form, new-invocable and pull-form.
- **Finish and tidy:** convert-to-metadata, and consolidate-sections (optional).
- **Connect and secure:** new-mapping-flow, flow-access-fix and sf-guest-audit.
- **Audit:** field-audit.
- **Library:** ftk-design-system holds the two design systems the design skills draw with. You never call it; the other skills read it.

> **Requirement:** whatever Claude plan you're on, you need the Design feature on your claude.ai account to see the review canvases. Without it the build still runs, but you can't review the design visually.

Start with the [end-to-end walkthrough](walkthroughs/end-to-end.md) to watch a whole conversion. Every skill page has its own demo.

## Every skill

| Skill | What it does |
| :- | :- |
| [`ftk-start`](skills/ftk-start.md) | The front door: takes a plain request and runs the right skills in the right order. |
| [`org-catalog`](skills/org-catalog.md) | Maps the org's existing Flow Tool Kit components and templates so nothing is rebuilt by accident. |
| [`form-migrate`](skills/form-migrate.md) | Reads an existing form and records exactly what it asks, does and where its answers go. |
| [`formassembly-capture`](skills/formassembly-capture.md) | Archives and reads a whole FormAssembly account at once, connectors included. |
| [`brand-kit`](skills/brand-kit.md) | Optional: pulls an organization's colors, fonts, images and voice from its website, saved in the org for reuse. |
| [`form-design`](skills/form-design.md) | Turns what a form asks into a build-ready design: plan.json plus a review canvas. |
| [`build-template`](skills/build-template.md) | Builds the approved design as a working draft Form Template: as records for fast prototyping from chat, or as metadata through Claude Code. |
| [`convert-to-metadata`](skills/convert-to-metadata.md) | Turns an approved records-mode prototype into metadata: converts only the components and JSON sections it created. |
| [`repeating-data`](skills/repeating-data.md) | Listens to the outcome and decides Repeater or Table, then hands off. |
| [`build-repeater`](skills/build-repeater.md) | Builds a Repeater page section or repeating flow screen component. |
| [`build-table`](skills/build-table.md) | Builds a Table page section or table screen component, with its row form. |
| [`consolidate-sections`](skills/consolidate-sections.md) | Optional: merges repeated JSON sections across templates into one shared component. |
| [`build-form-component`](skills/build-form-component.md) | Designs and writes Form Components in the shape that fits: a metadata component, a record component or JSON. |
| [`pull-form`](skills/pull-form.md) | Pulls one Form Builder form's whole metadata tree into your project. |
| [`field-audit`](skills/field-audit.md) | Finds where every field is used across Form Templates and writes a data dictionary. |
| [`new-mapping-flow`](skills/new-mapping-flow.md) | Builds the conversion flows that turn a Form Submission into real records, plus prefill flows. |
| [`flow-access-fix`](skills/flow-access-fix.md) | Fixes 'You do not have the level of access necessary' on a flow, and wires new flows so it never happens. |
| [`new-invocable`](skills/new-invocable.md) | Scaffolds a bulk-safe Invocable Action Apex class and its test, for when Flow cannot do the job. |
| [`build-flow-section`](skills/build-flow-section.md) | Builds Flow Sections: screen flows inside a Form Template page for logic plain questions cannot do. |
| [`build-custom-lwc`](skills/build-custom-lwc.md) | Builds a custom Lightning web component on Flow Tool Kit's contract when Flow and templates cannot do it well. |
| [`design-to-blocks`](skills/design-to-blocks.md) | Designs an Experience Cloud page with Flow Tool Kit's Site Blocks and produces page.json. |
| [`build-site-pages`](skills/build-site-pages.md) | Lands site design blocks in an Experience Cloud site and proves they render. |
| [`sf-guest-audit`](skills/sf-guest-audit.md) | Check your client's guest exposure: what an anonymous visitor can read on a site you built. |
| [`new-record-page-form`](skills/new-record-page-form.md) | Puts Flow Tool Kit's form component on a site page or a Lightning record page and sets it up there: simple forms and record displays with no Flow or custom code. |
| [`build-email-templates`](skills/build-email-templates.md) | Builds the confirmation and resume-link emails a Form Template sends. |
| `ftk-design-system` | The library the design skills draw with: the FlowToolKit Forms and Site Blocks design systems, inside the plugin ([The design systems](#the-design-systems)). |

How they fit together: [ftk-start](skills/ftk-start.md) is the front door. [org-catalog](skills/org-catalog.md) always runs first. For a conversion the usual order is read the source ([form-migrate](skills/form-migrate.md) or [formassembly-capture](skills/formassembly-capture.md)), optional [brand-kit](skills/brand-kit.md), [form-design](skills/form-design.md), [build-template](skills/build-template.md) (which calls [build-form-component](skills/build-form-component.md), [build-flow-section](skills/build-flow-section.md), [build-custom-lwc](skills/build-custom-lwc.md) and [build-email-templates](skills/build-email-templates.md) as needed, and [repeating-data](skills/repeating-data.md) with [build-repeater](skills/build-repeater.md) or [build-table](skills/build-table.md) when the form collects several of the same thing), then [new-mapping-flow](skills/new-mapping-flow.md), [flow-access-fix](skills/flow-access-fix.md) and [field-audit](skills/field-audit.md).

## Which Claude plans work

**Pro or higher runs the whole workflow.** On Pro you get Claude Code in the terminal and on the web, Cowork, skills, plugins and Design, and you can add this plugin's marketplace yourself. Max and Ultra add usage, not features. Team and Enterprise add organization controls. Skills need "Code execution and file creation" turned on. For chat to reach an org, add one of Salesforce's hosted MCP servers as a custom connector ([Connect your Salesforce org](getting-started.md#2-connect-your-salesforce-org)); the **Salesforce - Beta** listing in Claude's connector directory is part of Salesforce's own beta plugin, open only to organizations Salesforce approves and on Sales Cloud Enterprise edition.

> **Requirement: Design on your claude.ai account.** Whatever plan you are on, you need the Design feature turned on for your claude.ai account to see the review canvases that form-design and design-to-blocks draw, and to comment on them. Without it the build still runs from plan.json or page.json, but you cannot review the design visually; you get only a plain review page.

- **Free.** Skills and Design work, so you can read a form, plan it and see the design in chat. Anthropic's pages do not list Claude Code, Cowork or cloud sessions for Free, so nothing can be deployed to your org from a Free account.
- **Pro.** The full workflow: Claude Code in your terminal and at claude.ai/code, Cowork, skills, plugins and Design. You add the marketplace yourself. You do not get syncing the plugin for a whole team, or admin control over who has it.
- **Max and Ultra.** The same features as Pro, with more usage.
- **Team.** Claude Code on every seat; Premium seats only add usage. An Owner can give this plugin to everyone and choose whether it is available, installed by default or required ([Update](#update) says how). Design and artifacts are on by default once an Owner has turned on cloud code execution and file creation. An Owner adds connectors, the Salesforce one included, then each person connects their own account. Custom roles and plugin access by group are Enterprise only.
- **Enterprise.** Everything in Team, plus custom roles and plugin access by group. An Owner must confirm that code execution and file creation, and skills, are both on; Cowork in the cloud also needs an Owner to turn it on. Claude Code is in the standard seat on new plans; older plans need a Chat plus Claude Code or Premium seat for cloud sessions.

The standalone Claude Design site closes on December 14, 2026; Design now lives inside Claude as an artifact, which is how this plugin's review canvases already work.

Sources (Anthropic's official pages, read 2026-11-18 and 2026-11-19): [install plugins in Cowork and claude.ai](https://claude.com/docs/cowork/guide/plugins), [plugins in Claude Code](https://code.claude.com/docs/en/discover-plugins), [plugins on claude.ai](https://claude.com/docs/plugins/overview), [organization plugins](https://support.claude.com/en/articles/13837433-manage-plugins-for-your-organization), [sync from GitHub](https://claude.com/docs/plugins/org-sync), [Claude Code on Pro and Max](https://support.claude.com/en/articles/11145838-using-claude-code-with-your-pro-or-max-plan), [Claude Code on Team and Enterprise](https://support.claude.com/en/articles/11845131-using-claude-code-with-your-team-or-enterprise-plan), [Claude Code on the web](https://code.claude.com/docs/en/claude-code-on-the-web), [Cowork](https://support.claude.com/en/articles/13345190-getting-started-with-cowork), [Claude Design](https://support.claude.com/en/articles/14604416-get-started-with-claude-design), [Design moving into Claude](https://support.claude.com/en/articles/17440474-move-from-standalone-claude-design-to-claude), [artifacts for Team and Enterprise](https://support.claude.com/en/articles/16994751-artifacts-admin-guide-for-team-and-enterprise-plans), [skills](https://support.claude.com/en/articles/12512180-use-skills-in-claude), [connectors](https://claude.com/docs/connectors/getting-started), [Salesforce connector](https://support.claude.com/en/articles/16952184-set-up-salesforce-in-claude-for-your-organization).

## Install

**New here? Start with [Getting started](getting-started.md):** install the plugin, connect your Salesforce org, check the org is ready, and design your first form.

The plugin is published in the public repository [common-unite/flow-tool-kit-claude](https://github.com/common-unite/flow-tool-kit-claude), as the `flow-tool-kit` plugin in the `common-unite` marketplace.

### Claude Code

From your shell:

```bash
claude plugin marketplace add common-unite/flow-tool-kit-claude
claude plugin install flow-tool-kit@common-unite
```

or inside a session:

```text
/plugin marketplace add common-unite/flow-tool-kit-claude
/plugin install flow-tool-kit@common-unite
```

Each skill then runs as `/flow-tool-kit:<skill-name>`, or Claude picks it up when your request matches. If your computer has no GitHub SSH key, set `CLAUDE_CODE_PLUGIN_PREFER_HTTPS=1` so installs and updates clone over HTTPS.

### claude.ai (chat and Cowork)

A plugin added to your claude.ai account works in chat, in Cowork, and in Claude Code signed in to the same account. Install it from its marketplace:

1. Open **Customize > Plugins** and select **Add marketplace** (in the **Add** menu).
2. Paste `https://github.com/common-unite/flow-tool-kit-claude` and add it.
3. Select the **flow-tool-kit** plugin and select **Install**. Open it to check that its 26 skills are listed (25 that do the work, and ftk-design-system, the design-system library they read).

Updates arrive on their own: the marketplace syncs automatically, so each release reaches you with nothing to click ([Update](#update)).

**Team and Enterprise:** an Owner may need to allow it. Members see the marketplace option in **Add** only while **User-created skills** is on in **Organization settings > Plugins & skills > Policy**, and an Owner can limit which marketplaces members add.

**For a whole Team or Enterprise organization**, an Owner can give the plugin to every member instead, installed by default or required. [Update](#update) explains how, and why it takes a private copy of this repository or an uploaded plugin.

### The design systems

The review canvases draw with two design systems: **FlowToolKit Forms**, every Flow Tool Kit form component and its variants, and **FlowToolKit Site Blocks**, the design blocks for Experience Cloud pages. Both ship inside the plugin, in its **ftk-design-system** skill, at the version that matches the plugin. **There is nothing to download or attach**, in Claude Code, in claude.ai chat (Team and Enterprise included) or in Cowork, and nothing to unpack: installing the plugin installs them, and each plugin update brings the matching kits.

| Kit | What it is used for |
| :- | :- |
| FlowToolKit Forms | form-design's review canvas and review page. Site Blocks links to it, so it is installed first. |
| FlowToolKit Site Blocks | design-to-blocks' review canvas, review page and render checks for site pages. Needed only for site work. |

The kits are built for previews: minified, with only the files the canvases, review pages, render checks and your own Design System use. Their third-party licences are in the skill's `THIRD_PARTY_NOTICES.md`.

**Your own copy in claude.ai.** The canvases draw with your own copy of each design system, a Design System artifact in your claude.ai account. The first time a request needs one, ftk-start installs it from the plugin's files and saves its link in your project's `flow-tool-kit.json`. To do it up front, ask Claude: "Install the Flow Tool Kit design systems." On Team and Enterprise, each person installs their own copy into their own account; an Owner syncing the plugin for the organization does not install the design systems for anyone. form-design and design-to-blocks read the bundled kits directly for the review page and the render checks, so those work before your copy is installed; the canvases also need Design on your claude.ai account (see the requirement above).

**Check what you have:** ask Claude to "check my Flow Tool Kit design systems". ftk-start runs its status check and prints one line per kit, for example:

```text
ftk-forms: plugin ships 2.1.0; bundled kit ok; design system installed 2.0.0, plugin ships 2.1.0: offer to install the new version
site-blocks: plugin ships 2.1.0; bundled kit ok; design system not installed
```

- **bundled kit damaged:** the plugin's own files do not match their checksum. Update or reinstall the plugin.
- **design system not installed:** no design system link is saved in `flow-tool-kit.json` yet. ftk-start installs it when a request needs it.
- **design system installed (an older version), plugin ships (a newer one):** your design system is from an earlier release. ftk-start offers to install the new version as a new design system, and never replaces yours without asking.

### Claude Code on the web

Cloud sessions cannot run `/plugin`, and they do not load plugins enabled only in your local settings. They do load the skills enabled on your claude.ai account, so install the plugin in claude.ai first (above). Then set up your cloud environment at claude.ai/code:

1. **Network access:** choose **Limited**, keep **Allow package managers** checked, and add these to **Allowed domains**:

   ```text
   *.salesforce.com
   *.force.com
   *.site.com
   *.salesforce-sites.com
   *.formassembly.com
   *.tfaforms.com
   *.tfaforms.net
   docs.google.com
   fonts.googleapis.com
   fonts.gstatic.com
   ```

   Add your client's own website when brand-kit or design-to-blocks reads it. The design systems need no download: they ship in the plugin.

2. **Setup script:**

   ```bash
   #!/bin/bash
   apt update && apt install -y poppler-utils || true
   npm install -g @salesforce/cli || true
   ```

3. **Sign in to your org from an environment variable.** A cloud session has no browser for the usual Salesforce login. On a computer where you are already signed in, run `sf org display --target-org <org-alias> --verbose --json` and copy its `sfdxAuthUrl`. Put it in the environment's **Environment variables** as `SFDX_AUTH_URL=<the URL>`, then ask Claude to run:

   ```bash
   echo "$SFDX_AUTH_URL" | sf org login sfdx-url --sfdx-url-stdin --alias <org-alias> --set-default
   ```

   Anyone who uses an environment can read its variables, so keep this in your own environment, never a shared one, never paste it into the chat or a project file, and sign in again when it is revoked.

## Update

Every release raises `version` in `flow-tool-kit/.claude-plugin/plugin.json`, and the design-system kits inside the plugin come with it. Claude Code gives you a new copy only when that version changes.

| Where you installed it | How a new release reaches you |
| :- | :- |
| claude.ai (chat and Cowork), Team included | On its own. Nothing to click. |
| claude.ai, given to everyone by a Team or Enterprise Owner | When the Owner's copy has the release (below). |
| Claude Code | Turn on auto-update once, or run `claude plugin update`. |
| Claude Code on the web | It follows your claude.ai account, so it updates there. |

### claude.ai (chat and Cowork), Team included

A plugin you added with **Add marketplace** stays up to date on its own: when a release is published, the marketplace syncs and the new version is there the next time you use it.

The setting behind this is on the marketplace, not the plugin. Open **Customize > Plugins**, select **Add > Manage marketplaces**, and open the **...** menu on `flow-tool-kit-claude`:

- **Sync automatically** (Re-syncs on GitHub changes) is a switch, and it should be on. You can turn it off; you then stay on the version you have until you select **Check for updates**.
- **Check for updates** pulls the latest release now. You need it only when Sync automatically is off.
- The marketplace shows **Synced** with the synced commit; point at **Synced** to see when it last synced. After a release it may show **1 notice** saying the plugin's executable files or settings changed since your last version: that is the new release arriving, not an error.

The plugin's own page and its **...** menu have no update or sync setting.

On the Team account we checked on 2026-11-19, Sync automatically was already on and 2.1.0 arrived without anyone selecting anything. Anthropic's [install page](https://claude.com/docs/cowork/guide/plugins) describes Sync automatically as something you turn on, so check the switch once.

### Team and Enterprise Owners (optional)

Instead of each member adding the marketplace, an Owner can give the plugin to everyone from **Organization settings > Plugins & skills** and set its **Default access** to **Installed by default** (members can turn it off) or **Required** (members cannot turn it off or remove it, and it stays on in Claude Code signed in to the same account) ([manage plugins for your organization](https://claude.com/docs/plugins/admin)).

Organization sync takes only a private or internal repository on github.com, and `common-unite/flow-tool-kit-claude` is public ([sync from a repository](https://claude.com/docs/plugins/org-sync), [organization plugins](https://support.claude.com/en/articles/13837433-manage-plugins-for-your-organization)). So an Owner does one of these:

- **Sync a private copy:** keep a private copy of this repository in your own GitHub organization. Then select **Add > Sync from GitHub**, choose your copy, leave **Sync automatically** on, pick the **Default access**, and select **Create**. A release reaches your members once your copy has it.
- **Upload the plugin:** select **Add > Upload a plugin** with a `.zip` of the `flow-tool-kit` folder, then set its **Default access**. An upload is one release: upload the new zip for each release.

### Claude Code

Auto-update is off by default for a third-party marketplace such as `common-unite` ([discover plugins](https://code.claude.com/docs/en/discover-plugins)). Turn it on once:

- **You:** run `/plugin`, open **Marketplaces**, select `common-unite`, then **Enable auto-update**. Claude Code then updates the plugin after a session starts.
- **An administrator, for everyone:** `"autoUpdate": true` on the `common-unite` entry under `extraKnownMarketplaces` in managed settings.

Or update by hand: `claude plugin update flow-tool-kit@common-unite` in your shell, or open the plugin on the **Installed** tab of `/plugin` and select **Update now**.

The new version loads in your next session, or in the current one after `/reload-plugins`. `claude plugin marketplace update` on its own refreshes the marketplace's listing but does not update the installed plugin (checked 2026-11-19).

If you installed the plugin in claude.ai rather than with `/plugin`, Claude Code signed in to the same account picks up that copy each time it starts ([use plugins in Claude](https://support.claude.com/en/articles/13837440-use-plugins-in-claude)).

### Design systems

The kits update with the plugin. When a release changes a kit, ftk-start's status check says so and offers to install the new version of your own copy ([The design systems](#the-design-systems)).

## Where each skill runs

Claude Code (local or web) can do everything. claude.ai chat can read, plan and design, and can write records through a Salesforce connector, but metadata deploys, flows and Apex need Claude Code. Chat skips hooks, agents and local tools. No skill needs a page served from your own computer or a particular operating system; review files live in your project, with an optional claude.ai artifact where available, and browser checks run headless.

| Skill | Runs in |
| :- | :- |
| [`ftk-start`](skills/ftk-start.md) | Claude Code (local or web) and claude.ai chat. It plans and asks; the skills it calls say where they run. |
| [`org-catalog`](skills/org-catalog.md) | Claude Code (reads metadata and records). In chat with a Salesforce connector it reads Form Template records only; chat without one says so in a line. |
| [`form-migrate`](skills/form-migrate.md) | Claude Code and claude.ai chat. Plain Python, nothing to install; PDF forms need poppler (one install line). In chat, Claude extracts what the source will give it. |
| [`formassembly-capture`](skills/formassembly-capture.md) | Claude Code, local or web (add *.formassembly.com and *.tfaforms.com to the web environment's allowed domains). Default needs no browser. |
| [`brand-kit`](skills/brand-kit.md) | Claude Code and claude.ai chat. The site crawl is plain Python with no browser. |
| [`form-design`](skills/form-design.md) | Claude Code and claude.ai chat. The review canvas needs a claude.ai account with Design and the [FlowToolKit Forms design system](#the-design-systems); without them, plan.json alone still drives the build. |
| [`build-template`](skills/build-template.md) | Records mode: claude.ai chat with a Salesforce connector, or Claude Code. Metadata mode: Claude Code. |
| [`convert-to-metadata`](skills/convert-to-metadata.md) | The dry run in chat with a Salesforce connector or in Claude Code; writing and deploying the metadata needs Claude Code. |
| [`repeating-data`](skills/repeating-data.md) | Claude Code (local or web) and claude.ai chat. It writes a spec; the build skills it hands to say where they run. |
| [`build-repeater`](skills/build-repeater.md) | Claude Code (local or web) for everything. claude.ai chat writes and checks the spec, and with a Salesforce connector updates an existing section record. |
| [`build-table`](skills/build-table.md) | Claude Code (local or web) for everything. claude.ai chat writes and checks the spec, and with a Salesforce connector updates an existing section record. |
| [`consolidate-sections`](skills/consolidate-sections.md) | claude.ai chat with a Salesforce connector, or Claude Code (which adds a shared component as metadata). |
| [`build-form-component`](skills/build-form-component.md) | Claude Code (all three shapes; a metadata component needs it to deploy) and claude.ai chat (record components and JSON; when you ask for metadata in chat, Claude asks whether to build a record component now or wait for Claude Code). |
| [`pull-form`](skills/pull-form.md) | Claude Code (it writes files and runs the sf CLI). |
| [`field-audit`](skills/field-audit.md) | Claude Code, or claude.ai chat with a Salesforce connector that can run queries. |
| [`new-mapping-flow`](skills/new-mapping-flow.md) | Claude Code (it deploys flows). |
| [`flow-access-fix`](skills/flow-access-fix.md) | Claude Code (it deploys). In chat it can diagnose and give you the exact changes. |
| [`new-invocable`](skills/new-invocable.md) | Claude Code. |
| [`build-flow-section`](skills/build-flow-section.md) | Claude Code (it builds and deploys flows). |
| [`build-custom-lwc`](skills/build-custom-lwc.md) | Claude Code. |
| [`design-to-blocks`](skills/design-to-blocks.md) | Claude Code and claude.ai chat. The review canvas needs a claude.ai account with Design and the [FlowToolKit Site Blocks design system](#the-design-systems). |
| [`build-site-pages`](skills/build-site-pages.md) | Claude Code. It deploys and runs headless browser checks, so it works in the web environment too. |
| [`sf-guest-audit`](skills/sf-guest-audit.md) | Claude Code. |
| [`new-record-page-form`](skills/new-record-page-form.md) | Claude Code. In claude.ai chat it gives the click-by-click setup. |
| [`build-email-templates`](skills/build-email-templates.md) | Claude Code. |
| `ftk-design-system` | Everywhere the plugin is installed. Nothing to run: form-design, design-to-blocks and ftk-start read it. |
