# Google reCAPTCHA Setup

> Complete setup guide for integrating Google reCAPTCHA with Flow Tool Kit forms.

{% hint style="info" %}
For a quick how-to, see [Add reCAPTCHA](../how-to-guides/add-recaptcha.md). This page covers the full technical setup in detail.
{% endhint %}

## Video Walkthrough

{% embed url="https://vimeo.com/759593737" %}

## Overview

reCAPTCHA protects your public-facing forms from automated bot submissions. Flow Tool Kit supports both reCAPTCHA v2 (checkbox) and v3 (invisible scoring).

![reCAPTCHA setup screen](../.gitbook/assets/recaptcha-setup-screen.png)

## Step 1: Register with Google

1. Go to [Google reCAPTCHA Admin Console](https://www.google.com/recaptcha/admin).
2. Click **+** to add a new site.
3. Configure:

| Setting            | Value                                                      |
| ------------------ | ---------------------------------------------------------- |
| **Label**          | Your site name (e.g., "Salesforce Forms")                  |
| **reCAPTCHA Type** | v2 ("I'm not a robot") or v3 (score-based)                 |
| **Domains**        | Your Experience Cloud domain (e.g., `yourorg.my.site.com`) |

4. Accept the terms and click **Submit**.
5. Copy the **Site Key** (public) and **Secret Key** (private).

{% hint style="warning" %}
**Add all domains.** If your site is accessible from multiple domains (e.g., a custom domain and the default `.my.site.com` domain), add them all.
{% endhint %}

## Step 2: Salesforce Configuration

### CSP Trusted Sites

Add these trusted sites in **Setup → CSP Trusted Sites**:

| Trusted Site URL          | Context | Permissions            |
| ------------------------- | ------- | ---------------------- |
| `https://www.google.com`  | All     | Connect, Script        |
| `https://www.gstatic.com` | All     | Connect, Script, Style |

### Named Credential (for server-side validation)

For reCAPTCHA v3 (and recommended for v2):

1. Go to **Setup → Named Credentials**.
2. Create a new Named Credential:

| Setting                     | Value                                  |
| --------------------------- | -------------------------------------- |
| **Label**                   | Google reCAPTCHA                       |
| **URL**                     | `https://www.google.com/recaptcha/api` |
| **Identity Type**           | Anonymous                              |
| **Authentication Protocol** | No Authentication                      |

### Store Keys in Flow Tool Kit Settings

1. Navigate to the reCAPTCHA configuration in Flow Tool Kit.
2. Enter:
   * **Site Key** — the public key from Google
   * **Secret Key** — the private key from Google
   * **Version** — v2 or v3
   * **Score Threshold** (v3 only) — minimum score to accept (0.0-1.0, recommended: 0.5)

### Grant Guest User Access to the External Credential

{% hint style="danger" %}
**This step is required for Experience Cloud guest users.** Missing any of these permissions will block the callout and throw `You don't have read permissions on the User External Credential object` when a guest clicks a reCAPTCHA-enabled button.
{% endhint %}

Granting access to the external credential principal alone is **not** enough. Salesforce queries the standard `UserExternalCredential` object at callout time to resolve which principal to use, and guest users do not have access to that object by default.

1. Create (or edit) a Permission Set intended for your guest user.
2. On the permission set, grant **all three** of the following:

| Permission                                                                          | Where to set                                                |
| ----------------------------------------------------------------------------------- | ----------------------------------------------------------- |
| **Read** on the `UserExternalCredential` standard object                            | Object Settings → User External Credential → Read           |
| **External Credential Principal Access** for `GoogleRecaptcha - External Form User` | Permission Set → External Credential Principal Access → Add |
| Apex class access to `FlowToolKit.reCAPTCHA`                                        | Permission Set → Apex Class Access                          |

3. Assign this permission set to the **Site Guest User** via the Experience Cloud site's public access settings (not regular user assignment):
   * Experience Cloud Workspaces → Administration → Pages → **Go to Force.com**
   * Public Access Settings → **Manage Assignments → Edit Assignments**
   * Add the permission set and save.
4. In **Setup → Session Settings**, ensure **Let guest users make callouts using Named Credentials** is enabled (Winter '24 release update).
5. In **Setup → Named Credentials → GoogleRecaptcha**, confirm that **Allowed Namespaces** includes `FlowToolKit`.

## Step 3: Enable on Forms

1. In Form Builder or template configuration, enable reCAPTCHA.
2. Select the reCAPTCHA configuration.
3. Save.

## How Validation Works

### reCAPTCHA v2 (Checkbox)

1. User sees "I'm not a robot" checkbox on the form.
2. User clicks the checkbox (may get an image challenge).
3. Google returns a token.
4. Flow Tool Kit sends the token to Google's verification endpoint.
5. Google confirms the token is valid.
6. Form submission proceeds.

### reCAPTCHA v3 (Invisible)

1. reCAPTCHA v3 runs silently in the background — no user interaction.
2. Google assigns a score from 0.0 (likely bot) to 1.0 (likely human).
3. Flow Tool Kit checks the score against your threshold.
4. If the score is above the threshold, submission proceeds.
5. If below, the submission is blocked.

## Troubleshooting

| Issue                                                                                      | Cause                                                                                                                                                                                                                                                                                     | Fix                                                                                                                                                                                                                                                                                                                                   |
| ------------------------------------------------------------------------------------------ | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Widget doesn't load                                                                        | CSP blocking Google scripts                                                                                                                                                                                                                                                               | Add `www.google.com` and `www.gstatic.com` to CSP Trusted Sites                                                                                                                                                                                                                                                                       |
| "Invalid site key"                                                                         | Domain mismatch                                                                                                                                                                                                                                                                           | Add your exact domain to the Google reCAPTCHA site registration                                                                                                                                                                                                                                                                       |
| All submissions blocked (v3)                                                               | Score threshold too high                                                                                                                                                                                                                                                                  | Lower the threshold (try 0.3-0.5)                                                                                                                                                                                                                                                                                                     |
| Works in sandbox, not production                                                           | Different domains                                                                                                                                                                                                                                                                         | Register the production domain with Google                                                                                                                                                                                                                                                                                            |
| "Timeout or duplicate" error                                                               | Token expired                                                                                                                                                                                                                                                                             | Tokens are valid for 2 minutes — check for slow form submissions                                                                                                                                                                                                                                                                      |
| `You don't have read permissions on the User External Credential object` (guest user only) | Guest user's permission set is missing **Read** on the `UserExternalCredential` standard object. Granting External Credential Principal Access alone is not sufficient — Salesforce still queries `UserExternalCredential` to resolve the principal at callout time.                      | Follow [Grant Guest User Access to the External Credential](google-recaptcha-setup.md#grant-guest-user-access-to-the-external-credential) above. Most common cause: permission set was created but never assigned via **Public Access Settings → Manage Assignments**, or the `UserExternalCredential` object read was never granted. |
| Works in one org, fails in another with the External Credential error                      | Partial setup in the broken org — typically missing one of: `UserExternalCredential` read, guest assignment on the Site, the **Let guest users make callouts using Named Credentials** session setting, or the `FlowToolKit` namespace in the Named Credential's Allowed Namespaces list. | Diff both orgs against the checklist in [Grant Guest User Access to the External Credential](google-recaptcha-setup.md#grant-guest-user-access-to-the-external-credential).                                                                                                                                                           |

## Related Pages

* [Add reCAPTCHA (How-To)](../how-to-guides/add-recaptcha.md) — quick setup guide
* [reCAPTCHA & Security Reference](../form-configuration/recaptcha-security.md) — configuration reference
* [Deploy to Experience Cloud](../how-to-guides/deploy-to-experience-cloud.md) — EC deployment guide
