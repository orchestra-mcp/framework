---
id: FEAT-JIP
kind: bug
priority: P0
project_slug: orchestra-agents
status: done
title: Fix Vitals tab re-checking permissions on every visit despite cached grant
type: feature
---

# Fix Vitals tab re-checking permissions on every visit despite cached grant

HealthKit hasPermissions() returns false on iOS even after user granted read permissions (Apple privacy design). The current code re-verifies with hasPermissions() on every visit and clears the cached SharedPreferences when it returns false, causing the empty state to reappear. Fix: trust the cached permission and load data directly.


---
**in-progress -> in-testing** (2026-03-18T12:04:52Z):
## Changes

- apps/flutter/lib/screens/health/tabs/vitals_tab.dart (fixed _checkPermissions to trust the cached SharedPreferences grant instead of re-verifying with hasPermissions() which returns false on iOS for read permissions due to Apple privacy design; removes the code path that cleared the cache and showed empty state on every visit)


---
**in-testing -> in-review** (2026-03-18T12:05:07Z): Gate skipped for kind=bug


---
**Review (approved)** (2026-03-18T12:05:44Z): User approved. Fixed HealthKit permission re-check bug — cached grant is now trusted.
