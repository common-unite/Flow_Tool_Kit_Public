# Google reCAPTCHA Setup

> The complete setup for Google reCAPTCHA v3 on Flow Tool Kit forms: the external credential that holds the secret, the site key, the Experience Cloud head JavaScript, and the guest user permissions.

{% hint style="info" %}
For the short version, see [Add reCAPTCHA](../how-to-guides/add-recaptcha.md). This page is the full setup with every exact name, verified against a working production configuration.
{% endhint %}

## How it works

Flow Tool Kit uses **reCAPTCHA v3** (invisible scoring). There is no checkbox and no image challenge: Google scores each interaction from 0.0 (likely bot) to 1.0 (likely human), and a protected button only proceeds when the score meets that button's threshold.

The moving parts, and where each key lives:

| Piece | What it is | Where it lives |
| --- | --- | --- |
| **Site Key** (public) | Loads the reCAPTCHA script and requests tokens in the browser | The Experience Cloud site's head markup, and the **Google reCAPTCHA Site Key** field in Flow Tool Kit Settings (used by the iframe embed page) |
| **Secret Key** (private) | Authenticates the server-side verification call to Google | A parameter named `secret_key` on the **GoogleRecaptcha** External Credential's principal. Never in a custom setting, never in the browser |
| **Named Credential `GoogleRecaptcha`** | The callout endpoint the package's Apex uses | Created by you in Setup, with exactly this name |
| **Head markup JavaScript** | Bridges the package's events to Google's script | Your Experience Cloud site's Advanced settings |

At runtime: clicking a protected button dispatches a `grecaptchaExecute` browser event. The head-markup script asks Google for a token and answers with a `grecaptchaVerified` event. The package sends that token to Apex, which calls `callout:GoogleRecaptcha`, reads the secret from the credential, and returns Google's score. The button proceeds only if the score meets its threshold. If nothing answers the event within 10 seconds, the user sees a sticky **reCAPTCHA Timeout** toast, which almost always means the head markup script is missing or carries the wrong site key.

## Step 1: Register with Google

1. Go to the [Google reCAPTCHA Admin Console](https://www.google.com/recaptcha/admin).
2. Add a new site with **reCAPTCHA v3** as the type.
3. Under **Domains**, add every domain the form is served from: your Experience Cloud domain (`yourorg.my.site.com`), any custom domain, and your Salesforce org domain if forms run inside Lightning.
4. Submit, then copy the **Site Key** and the **Secret Key**.

## Step 2: Create the External Credential (holds the secret)

Go to **Setup → Named Credentials → External Credentials** tab, and create:

| Setting | Value |
| --- | --- |
| Label / Name | `GoogleRecaptcha` |
| Authentication Protocol | **Custom** |

Then on the new external credential:

1. Under **Principals**, add a Named Principal called exactly `External Form User` (leave its other fields default).
2. Under the principal's **Authentication Parameters**, add one parameter: **Name** `secret_key`, **Value** = your Google Secret Key.

{% hint style="warning" %}
The names are load-bearing. The package's Apex reads the secret with the merge field `{!$Credential.GoogleRecaptcha.secret_key}`, so the external credential must be named `GoogleRecaptcha` and the parameter must be named `secret_key`, exactly. The principal name `External Form User` is what you will grant to the guest user in Step 5.
{% endhint %}

## Step 3: Create the Named Credential (the endpoint)

Still in **Setup → Named Credentials**, create a Named Credential:

| Setting | Value |
| --- | --- |
| Label / Name | `GoogleRecaptcha` |
| URL | `https://www.google.com/recaptcha/api/siteverify` |
| External Credential | `GoogleRecaptcha` (from Step 2) |
| Generate Authorization Header | on (default) |
| **Allow Formulas in HTTP Body** | **checked** - required; the secret travels in the request body via the merge field |

Then, under the named credential's **Managed Package Access** (Allowed Namespaces), add `FlowToolKit`. Without it, the packaged Apex is not allowed to use the credential.

## Step 4: Set the Site Key

Two places, for two rendering surfaces:

**Flow Tool Kit Settings (for iframe embeds):** Setup → Custom Settings → **Flow Tool Kit Settings** → Manage → set **Google reCAPTCHA Site Key**. The packaged embed page (`EmbedForm`) reads this setting and wires everything below automatically, so iframe embeds need nothing else client-side.

**Experience Cloud head markup (for sites):** in Experience Builder, **Settings → Advanced → Edit Head Markup**, add the bridge and the script tag, with your real site key in both places:

```html
<!-- reCAPTCHA v3 -->
<script>
    document.addEventListener('grecaptchaExecute', function(event) {
        grecaptcha.execute('YOUR_SITE_KEY', {action: event.detail.action}).then(function(token) {
            document.dispatchEvent(new CustomEvent('grecaptchaVerified', {'detail': {
                response: token,
                action: event.detail.action,
                key: event.detail.key
            }}));
        });
    });
</script>
<script src="https://www.google.com/recaptcha/api.js?render=YOUR_SITE_KEY" async defer></script>
```

Publish the site after saving. This script is the piece most orgs miss: without it, protected buttons wait 10 seconds and show the **reCAPTCHA Timeout** toast.

### CSP Trusted Sites

So the site may load and talk to Google's script, add in **Setup → CSP Trusted Sites** (context: your Experience Cloud sites):

| Trusted Site URL | Permissions |
| --- | --- |
| `https://www.google.com` | Connect, Script |
| `https://www.gstatic.com` | Connect, Script, Style |

## Step 5: Grant Guest User Access

{% hint style="danger" %}
**Required for every public site.** Missing any item below blocks the verification callout, most famously with `You don't have read permissions on the User External Credential object` when a guest clicks a protected button.
{% endhint %}

Granting the credential principal alone is **not** enough: Salesforce queries the standard `UserExternalCredential` object at callout time to resolve the principal, and guests cannot read it by default.

1. Create (or edit) a permission set for your site's guest user and grant **all** of:

| Permission | Where to set |
| --- | --- |
| **Read** on the `User External Credential` standard object | Object Settings |
| **External Credential Principal Access**: `GoogleRecaptcha - External Form User` | External Credential Principal Access |

2. Make sure the guest also has Apex access to `FlowToolKit.reCAPTCHA`. The packaged **Form Flow User** permission set carries it, and a guest serving Flow Tool Kit forms should hold Form Flow User already; if you manage guest Apex access yourself, add the class to your permission set.
3. Assign the permission set(s) to the **Site Guest User**: Experience Workspaces → Administration → Pages → **Go to Force.com** → **Public Access Settings** → **View Users** → the guest user → Permission Set Assignments. (Regular user assignment screens cannot see guest users.)
4. In **Setup → Session Settings**, confirm **Let guest users make callouts using Named Credentials** is enabled.
5. Re-check Step 3's **Allowed Namespaces** contains `FlowToolKit`.

## Step 6: Enable it on buttons

reCAPTCHA is **per button**, not per form. In the Custom Buttons property editor (the Next/Submit buttons on your form or table):

1. Enable **reCAPTCHA** on the button that submits data.
2. Set the **reCAPTCHA Threshold**: a score from **0.0 to 1.0** (default 0.5). The button proceeds only when Google's score is at or above it.

Buttons that navigate without submitting (Back, Save Draft) do not need protection.

## Verifying and troubleshooting

Test as a real guest: open the public form in a private browser window, submit, and confirm completion. Then check the stored response: the submission's button metadata records the returned score and Google's response for protected clicks.

| Symptom | Cause | Fix |
| --- | --- | --- |
| Sticky **reCAPTCHA Timeout** toast after ~10 seconds | The head-markup script is missing, unpublished, or has the wrong site key, so nothing answers the package's event | Step 4's head markup; republish the site |
| `You don't have read permissions on the User External Credential object` | Guest lacks Read on `UserExternalCredential` | Step 5; this exact error means item 1 in the table |
| Verification works for logged-in users, fails for guests | Any Step 5 item missing: principal access, guest assignment, session setting, or namespace allowlist | Walk the Step 5 checklist top to bottom |
| `Invalid site key` or script errors in the console | Domain not registered with Google, or CSP blocking | Add the exact domain in the Google console; add the two CSP Trusted Sites |
| Every submission blocked | Threshold too high for your audience | Lower the button threshold (try 0.3 to 0.5); remember the scale is 0.0 to 1.0 |
| Works in sandbox, not production | Different domain, and credentials do not deploy their secrets | Register the production domain with Google; re-enter `secret_key` on the production external credential |
| Embedded (iframe) form shows no reCAPTCHA behaviour | Site key not set in Flow Tool Kit Settings | Step 4's custom setting; the embed page wires itself from it |

## Related Pages

* [Add reCAPTCHA (How-To)](../how-to-guides/add-recaptcha.md): the short version
* [reCAPTCHA & Security Reference](../form-configuration/recaptcha-security.md): per-button properties and score guidance
* [Deploy to Experience Cloud](../how-to-guides/deploy-to-experience-cloud.md): EC deployment guide
