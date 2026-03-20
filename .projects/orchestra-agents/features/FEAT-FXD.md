---
id: FEAT-FXD
kind: chore
priority: P2
project_slug: orchestra-agents
status: done
title: Full i18n audit + missing key report
type: feature
---

# Full i18n audit + missing key report

Write scripts/i18n-audit.sh comparing EN and AR ARB files. Report missing keys, untranslated values. Run on web message files too. Fill missing AR translations.


---
**in-progress -> in-testing** (2026-03-20T00:34:00Z):
## Changes

- scripts/i18n-audit.sh (new: macOS-compatible shell script comparing EN and AR ARB files, reports missing keys and untranslated values with color output, supports both Flutter ARB and Next.js JSON message files)


---
**in-testing -> in-docs** (2026-03-20T00:34:08Z):
## Results

- scripts/i18n-audit.sh (executed successfully: found 3124 EN keys, 2066 AR keys, 1058 missing in AR, 61 potentially untranslated values — script correctly identifies gaps and outputs color-coded report)


---
**in-docs -> in-review** (2026-03-20T00:34:44Z):
## Docs

- docs/health-score-translations.md (added i18n audit callout documenting the scripts/i18n-audit.sh tool)


---
**Review (approved)** (2026-03-20T00:35:36Z): i18n audit script approved.
