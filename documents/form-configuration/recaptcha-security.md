# reCAPTCHA Security
> Protect your public-facing forms from bot submissions with Google reCAPTCHA integration, configured per-button for fine-grained control.

## Overview

Flow Tool Kit integrates Google reCAPTCHA v3 to protect forms from automated bot submissions. This is particularly important for Experience Cloud (community) forms where unauthenticated guest users can access your flows.

reCAPTCHA v3 works invisibly — it scores user interactions in the background without presenting a challenge (no "select all traffic lights" puzzles). Each interaction gets a score from 0.0 (likely a bot) to 1.0 (likely a human). You configure a threshold score, and the button action only proceeds if the user's score meets or exceeds it.

## Where to Configure

reCAPTCHA is configured **per-button** on the Custom Buttons component. Each button can independently enable or disable reCAPTCHA and set its own threshold.

## Quick Start

1. **Set Up reCAPTCHA** — Register your site with Google reCAPTCHA v3 and obtain site and secret keys.
2. **Configure in Salesforce** — Store the reCAPTCHA keys in your Salesforce org's custom settings or metadata (see setup section below).
3. **Enable on Button** — In the Custom Buttons property editor, enable `reCAPTCHA_Enabled` on the button that should be protected.
4. **Set Threshold** — Set `reCAPTCHA_Threshold` to your desired minimum score (e.g., 50 for 0.5 score).
5. **Deploy** — Publish your Experience Cloud site. reCAPTCHA verification runs when the protected button is clicked.

## Properties

These properties are available on each button (1-5) in the Custom Buttons component:

| Property | Type | Default | Description |
|---|---|---|---|
| `reCAPTCHA_Enabled` | Boolean | false | Enable reCAPTCHA verification for this button |
| `reCAPTCHA_Threshold` | Integer | — | Minimum score (0-100) required to proceed. Maps to Google's 0.0-1.0 scale (e.g., 50 = 0.5) |

## How It Works

1. **Page Load**: When a screen with reCAPTCHA-enabled buttons loads, the reCAPTCHA v3 script initializes in the background.
2. **User Interaction**: As the user fills out the form, reCAPTCHA v3 monitors their behavior (mouse movements, typing patterns, interaction timing) to build a risk score.
3. **Button Click**: When the user clicks a reCAPTCHA-enabled button, the component requests a verification token from Google.
4. **Server Verification**: The token is sent to Salesforce, which verifies it with Google's API and receives the score.
5. **Score Check**: If the score meets or exceeds the threshold, the button's action proceeds normally. If not, the action is blocked and the user sees an error.

### Score Guidelines

| Score Range | Interpretation | Recommended Use |
|---|---|---|
| 70-100 (0.7-1.0) | Very likely human | Standard forms |
| 50-69 (0.5-0.69) | Probably human | Low-risk forms |
| 30-49 (0.3-0.49) | Suspicious | May need additional verification |
| 0-29 (0.0-0.29) | Likely bot | Should be blocked |

## Works With

| Component | Integration |
|---|---|
| **Custom Buttons** | reCAPTCHA is configured per-button on the buttons component |
| **Flow Form** | Form validation still runs before reCAPTCHA — both must pass |
| **Data Table** | Table buttons can also enable reCAPTCHA |
| **Experience Cloud** | Primary use case — protecting public-facing community forms |

## Common Patterns

### 1. Protected Submit Button
On a public-facing intake form, enable reCAPTCHA on the "Submit" button with a threshold of 50. The "Save Draft" and "Go Back" buttons don't need reCAPTCHA since they don't submit data.

### 2. Tiered Protection
For a high-value form (payment, account creation), set the threshold to 70+. For lower-risk forms (feedback, newsletter signup), use a threshold of 30-50.

### 3. Internal Forms
For internal Lightning flows (not Experience Cloud), you typically don't need reCAPTCHA since all users are authenticated. Save reCAPTCHA for guest-accessible forms.

## Tips & Considerations

- **Experience Cloud Only (Practical)**: While reCAPTCHA technically works in any context, it's only practically useful in Experience Cloud where guest/unauthenticated users can access forms. Internal Lightning users are already authenticated.
- **v3 is Invisible**: reCAPTCHA v3 does not present visual challenges to users. It works entirely in the background. Users won't see any CAPTCHA UI.
- **Per-Button Control**: You can enable reCAPTCHA on your Submit button while leaving Back, Cancel, and Save Draft buttons unprotected. This provides security without adding friction to non-submission actions.
- **Form Validation First**: Flow Form validation runs before reCAPTCHA. If the form has validation errors, they're shown first — the reCAPTCHA check only happens when the form is valid.
- **Score Tuning**: Start with a threshold of 50 and adjust based on your experience. If you're getting false positives (real users blocked), lower the threshold. If bots are getting through, raise it.
- **Google Account Required**: You need a Google Cloud account to register your site and obtain reCAPTCHA v3 keys.
- **Network Dependency**: reCAPTCHA requires network access to Google's servers. If users are behind strict firewalls that block Google, reCAPTCHA may not work.
