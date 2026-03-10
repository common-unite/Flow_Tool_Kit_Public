# Get URL Parameters

> Extract URL query parameters from the current page URL on Flow Screens — useful for Experience Cloud and Lightning Out.

## Overview

Form (Get URL Parameters) reads query string parameters from the current browser URL and outputs them as individual string values. This is essential for Experience Cloud sites and Lightning Out deployments where you need to pass context into a Flow via URL parameters.

The component supports standard parameter names (`pv1` through `pv9`), UTM marketing parameters, and common Salesforce identifiers (`recordId`, `submissionId`, `interviewId`).

## Where to Use It

- **Flow Screen** (utility — no visible UI)

## Video Walkthrough

{% embed url="https://vimeo.com/755296729" %}

## Properties

### Outputs

| Property | Type | Description |
|---|---|---|
| `pv1` through `pv9` | String | Custom parameters (URL: `?pv1=value&pv2=value`) |
| `recordId` | String | Record Id from URL (`?recordId=001...`) |
| `submissionId` | String | Submission Id from URL (`?submissionId=a0x...`) |
| `interviewId` | String | Flow interview Id from URL |
| `lang` | String | Language code from URL (`?lang=es`) |
| `payment_intent` | String | Payment intent parameter (Stripe integration) |
| `eventType` | String | Event type parameter |
| `utm_source` | String | UTM source tracking parameter |
| `utm_medium` | String | UTM medium tracking parameter |
| `utm_campaign` | String | UTM campaign tracking parameter |
| `utm_content` | String | UTM content tracking parameter |
| `utm_term` | String | UTM term tracking parameter |

## Common Patterns

### 1. Experience Cloud Record Context
Pass a record Id via URL: `https://yoursite.com/form?recordId=001XXXXXXXXXXXX`. Use the `recordId` output in a Get Records element to load the record into your Flow.

### 2. Pre-fill Form from URL
Encode field values in URL parameters (`?pv1=John&pv2=Smith`). Map `pv1` and `pv2` to record variables in your Flow to pre-fill form fields.

### 3. UTM Campaign Tracking
Capture marketing attribution from URL parameters. Store `utm_source`, `utm_campaign`, and other UTM values on the record for campaign tracking.

### 4. Save & Resume Deep Link
Generate a URL with `submissionId` in the query string. When users return via that link, query the submission record and pass it to the Form Template component to resume.

## Tips & Considerations

- **No Visible UI**: This component doesn't render anything. Place it on the first screen of your Flow to capture URL parameters early.
- **Experience Cloud Only**: URL parameters are primarily useful in Experience Cloud or Lightning Out. In standard Lightning, Flows receive context through input variables instead.
- **Language Override**: Use the `lang` output with the `languageOverride` input on Flow Form to render forms in the requested language.
