# Getting started

This page takes you from nothing installed to your first Flow Tool Kit form designed by Claude, in four steps: install the plugin, connect a Salesforce org, check the org is ready, and run a first prompt. Set aside about 30 minutes the first time. Most of it is the one-time org connection.

**You need:**

- **A Claude plan.** Free lets you read a form and see a design in chat. Pro or higher adds Claude Code, which every step that writes metadata to an org needs. [Which Claude plans work](README.md#which-claude-plans-work) has the details.
- **A Salesforce org to practise in:** a Developer Edition, a scratch org or a sandbox, never a client's live org.
- **Flow Tool Kit in that org,** version 5.3 or later (5.4.0.2 is current). Step 3 covers it.

## 1. Install the plugin

Install it once on each surface where you work. A plugin added to your claude.ai account also reaches Claude Code when you sign in to Claude Code with the same account.

### claude.ai (chat and Cowork)

1. Open **Customize > Plugins** and select **Add marketplace** (in the **Add** menu).
2. Paste `https://github.com/common-unite/flow-tool-kit-claude` and add it.
3. Select the **flow-tool-kit** plugin and select **Install**. Open it to check that its 26 skills are listed.
4. Check that **Code execution and file creation** is on in **Settings > Capabilities** (called **Create and edit files** in the newer settings layout). Skills do not run without it. On Team and Enterprise an Owner manages it in **Organization settings > Plugins & skills**.

**Team and Enterprise:** members see **Add marketplace** only while an Owner has **User-created skills** turned on in **Organization settings > Plugins & skills > Policy**. An Owner can also install the plugin for everyone: **Organization settings > Plugins & skills > Add > Sync from GitHub**, choose `common-unite/flow-tool-kit-claude`, and pick who gets it. If you are a member and cannot see the option, ask your Owner for either one.

### Claude Code

From your shell:

```bash
claude plugin marketplace add common-unite/flow-tool-kit-claude
claude plugin install flow-tool-kit@common-unite
```

If your computer has no GitHub SSH key, set `CLAUDE_CODE_PLUGIN_PREFER_HTTPS=1` first so the install clones over HTTPS. Then turn on updates once: run `/plugin`, open **Marketplaces**, select `common-unite`, then **Enable auto-update**. More on updates: [Update](README.md#update).

## 2. Connect your Salesforce org

Where you work decides how Claude reaches the org:

| Where you work | How Claude reaches the org | What it can do there |
| :- | :- | :- |
| Claude Code (on your computer or on the web) | The Salesforce CLI (`sf`), signed in as you | Everything: reads, record builds and metadata deploys |
| claude.ai chat or Cowork | A Salesforce connector added to your claude.ai account | Reads, designs and record builds. **No metadata deploys** |

If you will build into the org, set up Claude Code. Chat is good for reading a form, designing it, reviewing it with a client and building draft records, and it hands the files over to Claude Code for the rest.

### In Claude Code

1. **Install the Salesforce CLI** (needs Node.js), then check it:

   ```bash
   npm install --global @salesforce/cli
   sf --version
   ```

   Salesforce also publishes installers for macOS and Windows on its Salesforce CLI page.

2. **Sign in to the org** in a browser. Give each org a short alias you will recognize:

   ```bash
   # Developer Edition or production
   sf org login web --alias riverbend-dev

   # Sandbox
   sf org login web --alias riverbend-uat --instance-url https://test.salesforce.com
   ```

   If the org blocks the shared login page, use its My Domain address instead, for example `--instance-url https://<your-domain>--<sandbox-name>.sandbox.my.salesforce.com`. A scratch org you create with `sf org create scratch` is signed in already.

3. **Make it the default org for your project folder.** Claude Code works in a Salesforce DX project folder, the kind the CLI makes. If you have none yet, make one, then set the org inside it:

   ```bash
   sf template generate project --name riverbend-forms
   cd riverbend-forms
   sf config set target-org riverbend-uat
   ```

   Claude uses that org in this folder unless you name another. `sf org list` shows every org you are signed in to.

4. **Start Claude Code in that folder** and ask for anything that needs the org (step 4 has a first prompt). The first time, Claude reads the org and saves what it learns, such as your Flow Tool Kit edition and who fills in your forms, in `flow-tool-kit.json` in the folder, keyed by the org's Id. It never asks those questions again for that org.

Working in Claude Code on the web? A cloud session has no browser for the sign-in. Follow [Claude Code on the web](README.md#claude-code-on-the-web) to sign in from an environment variable instead.

**Which org to use**

| Org | Use it for |
| :- | :- |
| Developer Edition | Your own practice org: free, and nothing in it belongs to a client |
| Scratch org | Short-lived orgs for trying a build from scratch, if you already use a Dev Hub |
| Sandbox | Real client work: build and review here, with the client's own objects and data model |
| Production | Read-only work only: mapping what the org has (org-catalog), a field audit (field-audit) and a guest exposure check (sf-guest-audit) |

Keep builds out of production. A build writes records and metadata, and during a review Claude rebuilds a draft form in seconds, many times. Do that in a sandbox, then move the finished form to production the way you move any other change.

### In claude.ai chat

Chat has no Salesforce CLI, so it reaches the org through a **connector**. Salesforce runs connectors for this, called **Hosted MCP Servers**, and you add one to Claude as a custom connector. Salesforce supports them on production, Developer Edition, sandbox and scratch orgs.

**Which server.** Use Salesforce's **Headless 360** server. One connection gives Claude the org's objects and fields, SOQL queries and record changes, which is everything the Flow Tool Kit skills ask of a connector, and it reaches Setup too. It is a beta. If Headless 360 cannot be turned on in your org, use **SObject All** instead: a released server that runs SOQL queries and creates, updates and deletes records, and nothing more. The steps below are the same for both; only the server name changes (`headless-360` or `sobject-all`).

Claude's connector directory also lists Headless 360 as **Salesforce - Beta**. That listing belongs to Salesforce's own beta plugin for Sales Cloud Enterprise, open only to organizations Salesforce approves, so add the server as your own custom connector as shown here.

**Check the cost first.** Salesforce says its hosted MCP servers are intended for customers with Flex Credits, and server use may be billed. Before you turn one on in a client's org, check with the client's Salesforce account team.

**In Salesforce** (a System Administrator, once per org):

1. In Setup, enter `MCP Servers` in Quick Find and open **MCP Servers** (under **API Catalog**). Activate **headless-360** (or **sobject-all**). It can take two minutes to become active.
2. In Setup, open **External Client App Manager** and select **New External Client App**. Fill in the basic information, then:
   - Under **API (Enable OAuth Settings)**, select **Enable OAuth**.
   - **Callback URL:** `https://claude.ai/api/mcp/auth_callback`
   - **OAuth Scopes:** **Access MCP servers (mcp_api)** and **Perform requests at any time (refresh_token)**.
   - Under **Security**, select **Issue JSON Web Token (JWT)-based access tokens for named users**, and leave the other options off.
   - Select **Create**. The app can take up to 30 minutes to start working.
3. In the app's **Settings**, open **Consumer Key and Secret** and copy the **Consumer Key**. It is a public identifier, not a password.
4. Recommended: in the app's **OAuth Policies**, set **Refresh Token Validity** to 30 days or less and turn on **Refresh Token Rotation**. To let only some people connect, require a permission set there and assign it to them.

A scratch org cannot create the External Client App in Setup: Salesforce's route is to create it in your Dev Hub org, package it and install the package in the scratch org. For chat, a Developer Edition or a sandbox is simpler.

**The server address** depends on the org. Using the org's My Domain name ties the connector to that one org, which matters once you work with several (see [Working with several client orgs](#working-with-several-client-orgs)):

| Org | Server address |
| :- | :- |
| Production | `https://api.salesforce.com/platform/mcp/v1/d/<my-domain>/platform/headless-360` |
| Developer Edition | `https://api.salesforce.com/platform/mcp/v1/d/<my-domain>/develop/platform/headless-360` |
| Sandbox | `https://api.salesforce.com/platform/mcp/v1/d/<my-domain>--<sandbox-name>/sandbox/platform/headless-360` |
| Scratch | `https://api.salesforce.com/platform/mcp/v1/d/<my-domain>/scratch/platform/headless-360` |

Find `<my-domain>` in Setup under **My Domain** (**My Domain Name**). For a sandbox, add two hyphens and the sandbox name after it. For SObject All, end the address with `platform/sobject-all` instead.

**In Claude:**

- **Pro, Max and Ultra:** open **Customize > Connectors**, select **Add**, then **Add custom connector**. Give it a name you will recognize (for example `Riverbend UAT`), paste the server address and select **Continue**. Under **OAuth client**, choose **Use your own OAuth client**, paste the Consumer Key as the **Client ID**, leave the secret blank and add it.
- **Team:** only an Owner or Primary Owner can add a custom connector. The Owner opens **Organization settings > Connectors**, selects **Add**, then **Custom** and **Web**, and fills in the same name, address and Client ID. **Enterprise:** an Owner, or a custom role that can manage connectors, does the same.
- **Free:** one custom connector.

**Connect.** In your default browser, sign out of every other Salesforce org and sign in to this one: the connector signs in through that browser, and an open session for another org can connect the wrong one. Then, in **Customize > Connectors**, select **Connect** next to the connector and approve the access. On Team and Enterprise every member connects with their own Salesforce login, and Claude sees only what that login can see.

**Confirm before writing.** In the connector's tool settings, set the tools that create, update or delete records to ask you first. Turn the connector on in each chat where you want it, from the **+** menu, **Connectors**.

**What works in chat.** With the connector on, chat maps what the org already has, audits where fields are used, reads an existing Form Template, and builds a draft form as records you can click through in the org. Chat does **not** deploy metadata: new custom fields, flows, Flow Sections, custom components, email templates, site pages and access fixes all need Claude Code. When a step needs it, Claude says so plainly and gives you `plan.json` and `flow-tool-kit.json`, which build in Claude Code without changes. The full list is in [Where each skill runs](README.md#where-each-skill-runs).

Two smaller gaps in chat: the skills do not read flows, Lightning pages or site pages through a connector, so the map of where each form is used covers Form Templates and components only (Claude says so); and a shared form component built in chat goes in through Form Builder's **Import** button, one at a time, unless the connector can run Apex. Claude Code adds them for you.

## 3. Get the org ready

Check these once per org, before your first build.

**Flow Tool Kit installed.** Version **5.3 or later** to build, and the current release (**5.4.0.2**) to get everything the skills use, such as the template logo settings. To see your version, open **Setup > Installed Packages**. To install or upgrade, follow [Installation](https://common-unite.gitbook.io/flow-tool-kit-or-form-and-table-builder/getting-started/installation), installing for Admins Only. The free and paid editions both work. Claude asks once per org which one you have, because it changes how forms save their answers.

**Permission sets.** Installing the package assigns none, so assign them yourself ([Permission sets](https://common-unite.gitbook.io/flow-tool-kit-or-form-and-table-builder/getting-started/permission-sets)):

| Permission set | Who gets it |
| :- | :- |
| Form Builder (Administrator) | You, and anyone who builds forms with Claude. It covers everything the skills create, and without it Form Builder hides its Save and Reset Form Cache buttons |
| Form Builder (Manager) | Builders who should change only the components they manage |
| Form (Flow User) | Everyone who fills in a form: staff, portal users and the site guest user |

**Your own access.** What the skills need from your Salesforce user:

| To | You need |
| :- | :- |
| Read the org (any surface) | API Enabled, and View Setup and Configuration |
| Build draft forms as records | Form Builder (Administrator) |
| Deploy from Claude Code (fields, flows, components, email templates, sites) | Modify Metadata Through Metadata API Functions and Customize Application, plus Author Apex for Apex and Manage Flow for flows. In practice, System Administrator in a sandbox or Developer Edition |
| Set up a chat connector | System Administrator, to turn on the server and create the External Client App |

## 4. Your first five-minute win

Start with a prompt that needs no org at all. In Claude Code or a chat with the plugin installed:

> Design a two-page volunteer sign-up form for a community garden with Flow Tool Kit: contact details, availability and a photo release. Show me the review canvas.

**What you see:** Claude states a short plan and the assumptions it made (for example the paid edition and a public site form), asks only what it cannot guess, and draws the form as a review canvas: both pages at desktop and phone width, with every field, its type and where it would save in Salesforce. Comment on the canvas to change it. Without the Design feature on your claude.ai account, you get a plain review page instead. The design is saved as `plan.json`, the file every later build step reads.

Then prove the org connection:

> Catalog the Flow Tool Kit components and Form Templates in my org.

**What you see:** a few lines with the counts (Form Components and Form Templates), the components that new forms could reuse, and anything that needs attention, such as a template section pointing at a component that no longer exists. The full map is saved as `catalog.md` in an `ftk-catalog` folder. If Claude says no org is connected, go back to step 2.

### Where to go next

- Ask for a real form in plain words, for example "Convert this FormAssembly form to Flow Tool Kit" with a link or a PDF. [ftk-start](skills/ftk-start.md) is the front door: it picks the skills and runs them in order.
- Watch a whole conversion: [End-to-end walkthrough](walkthroughs/end-to-end.md).
- Read the source of a form: [form-migrate](skills/form-migrate.md).
- Design and review: [form-design](skills/form-design.md), optionally after [brand-kit](skills/brand-kit.md).
- Build: [build-template](skills/build-template.md), then [new-mapping-flow](skills/new-mapping-flow.md) to save answers to records.
- Open a form to the public safely: [flow-access-fix](skills/flow-access-fix.md) and [sf-guest-audit](skills/sf-guest-audit.md).
- Every skill: [the skill list](README.md#every-skill).

## Working with several client orgs

Consultants keep many orgs signed in at once. Set each surface up so every piece of work points at exactly one org.

**Claude Code with the Salesforce CLI** (the cleanest setup):

- One Salesforce DX project folder (or repository) per client.
- One alias per org, named for the client and the org type: `riverbend-dev`, `riverbend-uat`, `riverbend-prod`.
- In each client's folder, `sf config set target-org riverbend-uat` makes that sandbox the default there. It is saved in the folder, so the next client's folder keeps its own.
- `flow-tool-kit.json` in each folder holds that client's org answers, keyed by org Id, so nothing carries over from one client to another.
- To touch another org of the same client, name it: "map the forms in riverbend-prod". Claude adds `--target-org` for that one request.

**Claude Code with a connector instead of the CLI:** a client's repository can carry its own connection in a `.mcp.json` file at its root, and Claude Code offers it only in that project:

```json
{
  "mcpServers": {
    "riverbend-uat": {
      "type": "http",
      "url": "https://api.salesforce.com/platform/mcp/v1/d/riverbend--uat/sandbox/platform/headless-360",
      "oauth": { "clientId": "<Consumer Key of the External Client App in that org>", "callbackPort": 8080 }
    }
  }
}
```

Add `http://localhost:8080/callback` as a second callback URL on that External Client App. Claude Code asks you once to approve the project's server, and you sign in with `/mcp`. <!-- partner-clean: allow R7 (Claude Code's own OAuth callback address) --> The sign-in is stored in your system's secure credential store, separately for each server address, never in the file. Put only the Consumer Key in the file: never a client secret or a token. Connectors you added in claude.ai also appear in Claude Code, so turn off the other clients' connectors for this project in `/mcp`.

**claude.ai chat:** claude.ai turns connectors on per chat, not per Project. So:

- Add one connector per org, each with its own My Domain address and its own External Client App, and a name that says which org it is: `Riverbend UAT`, `Lakeside Dev`.
- In each chat, turn on only the connector for the org you are working in.
- Keep one claude.ai Project per client, with that client's `flow-tool-kit.json` and catalog in the Project's files, and name the connector in the Project's instructions ("use only the Riverbend UAT connector").
- On Team, ask your Owner to add each client's connector. Every member sees it, but only people with a login in that client's org can connect.

Claude saves each org's catalog and answers under the org's Id and never reuses one org's catalog for another, so a connector pointed at the wrong org shows up at once as a different org name and Id.
