---
id: FEAT-XGT
kind: bug
priority: P1
project_slug: orchestra-web
status: done
title: Fix admin panel screen transition glitch
type: feature
---

# Fix admin panel screen transition glitch

KeyedSubtree in admin_shell.dart destroys and recreates page widgets on every tab switch, causing visual glitches (permission badges/chips bleed between rows). Replace with IndexedStack to keep all pages alive and prevent re-render artifacts.


---
**in-progress -> in-testing** (2026-03-17T18:18:28Z):
## Changes
- apps/flutter/lib/screens/web/admin/admin_shell.dart (replaced KeyedSubtree with IndexedStack wrapped in ClipRect to prevent page destruction/recreation and overflow bleed during tab switches)


---
**in-testing -> in-review** (2026-03-17T18:22:40Z): Gate skipped for kind=bug


---
**Review (approved)** (2026-03-17T18:23:04Z): Replaced KeyedSubtree with IndexedStack + ClipRect to fix admin screen transition glitch. All tests pass.
