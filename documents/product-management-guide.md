# Working with Claude as Your Product Manager

## What This Is

You're a solo Salesforce ISV developer building and maintaining the Flow Tool Kit family of products. Claude acts as your product manager — handling the organizational, tracking, and communication work that a PM would normally do on a team. This document explains what that means, how it works, and how to use it day-to-day.

This process is shared across all your projects, not just Flow Tool Kit.

---

## Claude's Role as PM

### What Claude Does
- **Captures requirements** — Walks you through structured questions to turn ideas, bugs, and client feedback into well-written GitHub issues with proper labels and acceptance criteria
- **Manages the pipeline** — Maintains your GitHub Project board, moves issues through columns, and keeps things organized
- **Generates release notes** — Pulls closed issues tagged `client-facing` and writes client-friendly summaries
- **Drafts blog posts** — Expands release notes into blog-ready content for sharing with clients
- **Thinks about impact** — Considers managed package constraints, breaking changes, subscriber impact, and cross-product dependencies when discussing features
- **Tracks across products** — One project board spans all repos, so you see everything in one place

### What Claude Does NOT Do
- Make decisions for you — Claude presents options and tradeoffs, you decide
- Push code without permission — Always confirms before pushing to remote
- Modify `force-app/` without asking — The managed package source is protected
- Auto-generate tests — Only writes tests when explicitly asked

---

## Your Products

All tracked on a single cross-repo project board: **https://github.com/orgs/common-unite/projects/2**

| Product | Repo | Description |
|---------|------|-------------|
| Flow Tool Kit | `cUnite_FormBuilder` | Base 2GP managed package |
| V4SF | `FormBuilder_V4SF` | Volunteers for Salesforce extension |
| Stripe Connector | `FlowToolKit_Stripe_Connector_Accelerator` | Stripe integration extension |
| Outbound Funds | `FlowToolKit_OutboundFunds_Accelerator` | Grantmaking / budget extension |

---

## How to Work with Claude — Quick Reference

### Log a Bug
Say: **"Log a bug"** or **"I found a bug in..."**

Claude will ask you:
1. Which product?
2. Where does it happen? (Flow screen, EC, Builder, etc.)
3. What happened vs. what should have happened?
4. Steps to reproduce
5. How severe is it?
6. Should clients see this in release notes?

Result: A labeled GitHub issue with full details, added to the project board.

### Request a Feature
Say: **"New feature idea"** or **"I want to add..."**

Claude will ask you:
1. Which product?
2. What problem does it solve? Who needs it?
3. How do you envision it working?
4. How big is it? (small tweak vs. epic)
5. Who's the audience? (admins, developers, end users)
6. Client-facing?

Result: A feature request issue with scope, audience, and acceptance criteria.

### Propose an Enhancement
Say: **"I want to improve..."** or **"Enhancement for..."**

Claude will ask you:
1. Which product and component?
2. What's the current behavior?
3. What should change and why?
4. Could it break existing configurations?
5. Priority and visibility?

Result: An enhancement issue with current vs. desired behavior documented.

### Check the Pipeline
Say: **"What's in the pipeline?"** or **"Show me the board"**

Claude will pull the current state of your project board and show you what's in each column.

### Prepare for a Release
Say: **"Generate release notes for release 3.207"**

Claude will:
1. Find all closed issues tagged `client-facing` since the last release
2. Sort them into New Features, Enhancements, and Bug Fixes
3. Write client-friendly descriptions (no developer jargon)
4. Output formatted release notes ready for GitHub Releases

### Write a Blog Post
Say: **"Write a blog post for release 3.207"**

Claude will:
1. Start from the release notes
2. Expand highlights with context, use cases, and screenshot placeholders
3. Write in a friendly, admin-focused tone
4. Output markdown ready for your blog

### Move Issues on the Board
Say: **"Move #20 to In Progress"** or **"#21 is done"**

Claude will update the project board status.

---

## The Project Board

### Columns and What They Mean

| Column | Meaning | When to Move Here |
|--------|---------|-------------------|
| **Inbox** | New issues, not yet reviewed | Automatically on creation (or manually) |
| **Backlog** | Valid work, not scheduled yet | After triage — it's real, but not urgent |
| **Up Next** | Committed for the next 1-2 releases | When you decide to build it soon |
| **In Progress** | Actively being coded | When you start working on it |
| **Done** | Code complete and merged | After merging to master |
| **Released** | Shipped in a production package | After CCI release is complete |

### Weekly Triage (Recommended)
Spend 10 minutes once a week:
1. Review Inbox — label, prioritize, move to Backlog or close
2. Check Up Next — is anything blocked? Does priority still make sense?
3. Check In Progress — anything stale that should move back?

You can do this yourself in the GitHub UI, or say **"Let's triage the board"** and Claude will walk through it with you.

---

## Labels

Every repo uses the same label set for consistency:

| Label | When to Use |
|-------|-------------|
| `type: feature` | Brand new functionality |
| `type: bug` | Something broken |
| `type: enhancement` | Improving something that works |
| `type: chore` | Maintenance, CI, refactoring |
| `priority: critical` | Blocking users right now |
| `priority: high` | Should be in the next release |
| `priority: low` | Backlog — no rush |
| `status: ready` | Requirements are clear, ready to build |
| `status: blocked` | Waiting on something external |
| `client-facing` | Include in release notes and blog posts |

---

## Issue Templates

Every repo has three issue templates in `.github/ISSUE_TEMPLATE/`:

- **Bug Report** — Structured form: product, version, context, severity, repro steps
- **Feature Request** — Problem/use case, proposed solution, scope, audience
- **Enhancement** — Current vs. desired behavior, breaking change risk

These templates appear automatically when creating issues through the GitHub web UI. When working with Claude, the question flow captures the same information conversationally.

---

## How This Works Across Projects

The PM framework is stored in your global Claude configuration (`~/.claude/product-management.md`), which means it's available in **every project** — not just Flow Tool Kit. When you open Claude Code in any extension repo, Claude already knows:

- The full product lineup and repo names
- The label system and board columns
- How to create issues, generate release notes, and write blog posts
- Your preferences (scratch orgs only, don't modify force-app, teach mode, etc.)

So whether you're working in `FormBuilder_V4SF` or `FlowToolKit_Stripe_Connector_Accelerator`, the same PM workflows are available.

---

## Release Workflow — End to End

Here's the full flow from "code is done" to "clients are notified":

1. **Finish coding** — Merge feature branch to master. Move issues to Done.
2. **Say**: "Generate release notes for 3.207"
3. **Review** the notes Claude generates. Edit if needed.
4. **Update footer tag** — Claude bumps `flowToolKitFooterTag.html` to the next version.
5. **Commit and push** to master.
6. **Run beta**: `cci flow run release_2gp_beta --org release`
7. **Run production**: `cci flow run release_2gp_production --org release`
8. **Say**: "Create a GitHub release for 3.207" — Claude creates it with the notes.
9. **Say**: "Write a blog post for 3.207" — Claude drafts it.
10. **Move issues** from Done to Released on the board.

---

## Adding a New Product

When you create a new extension package:

1. Tell Claude: "Add [repo name] to the PM system"
2. Claude will:
   - Create labels on the new repo
   - Copy issue templates
   - Link the repo to the project board
   - Update the product list in the PM framework

---

## Key Files

| File | Location | Purpose |
|------|----------|---------|
| `product-management.md` | `~/.claude/` | Full PM framework (global, shared across projects) |
| `CLAUDE.md` | `~/.claude/` | Global Claude instructions including PM section |
| `setup-github-pm.sh` | `~/.claude/scripts/` | Setup script for labels and project board |
| Issue templates | `.github/ISSUE_TEMPLATE/` | Bug, feature, enhancement templates (in each repo) |
| This document | `documents/` | Human-readable guide (you're reading it) |
