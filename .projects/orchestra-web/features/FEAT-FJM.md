---
estimate: M
id: FEAT-FJM
kind: feature
priority: P1
project_slug: orchestra-web
status: done
title: Flutter user detail: badges and points UI sections
type: feature
---

# Flutter user detail: badges and points UI sections

Add badges list section and points balance section to the Flutter admin user detail page. Show awarded badges with icons/colors and remove button. Show points balance with add/deduct form. Use the existing API endpoints: GET/POST/DELETE /api/admin/users/:id/badges and GET/POST /api/admin/users/:id/points.


---
**in-progress -> in-testing** (2026-03-20T17:06:16Z):
## Changes
- apps/flutter/lib/screens/web/admin/user_detail_page.dart (added Badges and Points tabs to tab list; _BadgesTab shows awarded badges with icon/color/category, Award Badge dialog listing all badge definitions, Revoke button per badge; _PointsTab shows points balance with star icon, Add/Deduct form with amount and reason, shows auto-awarded badges in snackbar after points change)


---
**in-testing -> in-docs** (2026-03-20T17:07:08Z):
## Results
- flutter-user-detail-ui.test.ts (5 tests passing: Badges and Points tabs exist, badges tab with list/revoke/award dialog, points tab with balance/add-deduct/auto-award snackbar)


---
**in-docs -> in-review** (2026-03-20T17:07:50Z):
## Docs
- docs/flutter-user-detail-gamification.md (new doc covering Badges tab with award/revoke, Points tab with balance and add/deduct form)


---
**Review (approved)** (2026-03-20T17:08:28Z): User approved. Flutter user detail with badges and points UI.
