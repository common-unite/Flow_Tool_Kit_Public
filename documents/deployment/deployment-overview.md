# Deployment Overview

> What form metadata needs to be deployed between environments and why.

## Overview

When you build forms, templates, themes, and labels in Flow Tool Kit, the configuration is stored as **Custom Metadata Type** (CMDT) records. These records live in the org where you created them — they don't automatically appear in other orgs.

To move your forms between environments (sandbox → production, org A → org B), you need to **deploy the CMDT records** using standard Salesforce deployment tools.

{% hint style="info" %}
**Deploy ≠ Install.** The Flow Tool Kit managed package is installed once (from AppExchange). Deployment is about moving the **form configuration** you've built — the metadata records that define your forms, sections, fields, themes, and labels.
{% endhint %}

## What Needs to Be Deployed

| Custom Metadata Type | What It Stores | Always Deploy? |
|---------------------|----------------|:--------------:|
| `Form__mdt` | Form definitions (name, object, settings) | Yes |
| `Form_Section__mdt` | Sections within forms | Yes |
| `Form_Field__mdt` | Fields within sections | Yes |
| `Form_Conditional_Logic__mdt` | Conditional visibility rules | If used |
| `Form_Conditional_Logic_Condition__mdt` | Conditions within logic rules | If used |
| `Form_Style_Sheet__mdt` | Themes (visual styling) | If customized |
| `Form_Labels__mdt` | Label overrides and translations | If used |
| `Form_Template__c` | Form Templates (multi-page forms) | If used |
| `Form_Template_Page__c` | Pages within templates | If used |
| `Form_Template_Page_Section__c` | Sections within pages | If used |

{% hint style="warning" %}
**Dependencies matter.** Sections reference Forms, Fields reference Sections, and Conditions reference Logic rules. Deploy them together or in dependency order — Forms first, then Sections, then Fields.
{% endhint %}

## Why Not Automatic?

CMDT records are org-specific. Unlike managed package code (which updates automatically when you upgrade the package), your form configurations are unique to your org. Salesforce doesn't have a mechanism to automatically sync CMDT records between orgs — that's by design, since your sandbox forms may differ from production.

## Deployment Methods

| Method | Best For | Guide |
|--------|----------|-------|
| **Change Sets** | Simple sandbox → production deployments | [Deploying Metadata](deploying-metadata.md) |
| **Metadata API / SFDX** | Scripted, repeatable deployments | [Deploying Metadata](deploying-metadata.md) |
| **Third-party tools** (Copado, Gearset, etc.) | Teams with CI/CD pipelines | [Deploying Metadata](deploying-metadata.md) |
| **JSON Export/Import** | Quick form copying between orgs | Use Form Builder's export feature |

## Next Steps

- [Deploying Metadata](deploying-metadata.md) — step-by-step for each method
- [Deploying to Production](deploying-to-production.md) — production-specific checklist
- [Deploying to Experience Cloud](deploying-to-experience-cloud.md) — EC-specific considerations
- [Upgrading Versions](upgrading-versions.md) — upgrading the managed package
