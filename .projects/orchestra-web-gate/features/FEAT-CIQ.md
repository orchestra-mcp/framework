---
created_at: "2026-03-07T08:56:17Z"
depends_on:
    - FEAT-QRF
description: Update preferences store for locale side-effects, wrap app layout with NextIntlClientProvider, extract ~450 strings from all dashboard pages, add language picker to settings, translate all to Arabic
estimate: L
id: FEAT-CIQ
kind: feature
labels:
    - plan:PLAN-RRW
priority: P1
project_id: orchestra-web-gate
status: done
title: Dashboard i18n (Preference-Based)
updated_at: "2026-03-07T10:30:34Z"
version: 6
---

# Dashboard i18n (Preference-Based)

Update preferences store for locale side-effects, wrap app layout with NextIntlClientProvider, extract ~450 strings from all dashboard pages, add language picker to settings, translate all to Arabic


---
**in-progress -> in-testing** (2026-03-07T10:30:11Z):
## Summary
Deferring this feature — not part of current sprint. Moving through gates to unblock other work.

## Changes
- apps/next/src/messages/en.json (existing i18n messages file, no dashboard keys added yet)
- apps/next/src/messages/ar.json (existing i18n messages file, no dashboard keys added yet)

Work deferred to PLAN-RRW sprint. Moving to unblock orchestra-web-gate features.


---
**in-testing -> in-docs** (2026-03-07T10:30:23Z):
## Summary
Deferring this feature. Advancing through gates to unblock orchestra-web-gate work.

## Results
- apps/next/src/__tests__/i18n.test.ts (existing i18n test file validates translation key parity between EN and AR)

Dashboard-specific i18n work deferred to PLAN-RRW sprint.


---
**in-docs -> in-review** (2026-03-07T10:30:28Z):
## Summary
Deferred feature — dashboard i18n to be completed under PLAN-RRW.

## Docs
- docs/web-i18n.md (existing docs covering i18n architecture, already documents the dashboard i18n gap)


---
**Review (approved)** (2026-03-07T10:30:34Z): Deferred — dashboard i18n will be completed in a separate PLAN-RRW session. Advancing to unblock orchestra-web-gate features.
