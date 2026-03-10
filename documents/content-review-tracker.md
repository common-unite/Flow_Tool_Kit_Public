# Content Review Tracker

> Internal tracking file for videos and content that need updating due to changes in the package. This file is excluded from GitBook publishing.

## Videos Needing Re-Record or Retirement

| Video | Vimeo ID | Issue | Status |
|-------|----------|-------|--------|
| Permission Set Considerations | 756547514 | Permission set names and access levels may have changed since recording | Needs review |
| _No other videos reviewed yet_ | — | — | — |

## Doc Pages Needing Screenshot Refresh

| Page | Section | Issue | Status |
|------|---------|-------|--------|
| _No pages flagged yet_ | — | — | — |

## Deprecated Features Still Referenced in Videos

| Feature | Videos Affected | Deprecated In | Replacement |
|---------|----------------|---------------|-------------|
| _No deprecated features identified yet_ | — | — | — |

## Video-to-Page Mapping Status

Tracks which videos have been consumed into documentation pages.

| Status | Count | Description |
|--------|:-----:|-------------|
| Consumed | 0 | Video content fully incorporated into a doc page |
| Pending | 91 | Video exists but hasn't been used as a doc source yet |
| Outdated | 0 | Video content doesn't match current package — do NOT embed |
| Retired | 0 | Video removed from showcase or no longer relevant |

## How to Use This Tracker

1. **During doc authoring**: When writing a page based on a video transcript, compare against current source code. If the video doesn't match, add it to the tables above and create a [GitHub issue with the `content-update` label](https://github.com/common-unite/cUnite_FormBuilder/labels/content-update).
2. **At release time**: When features change, check which videos and pages are affected. Update this tracker and create issues.
3. **Quarterly review**: Prioritize re-records or retirements based on impact.
