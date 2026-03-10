---
created_at: "2026-03-09T05:35:53Z"
description: DashboardGrid with DragProvider + 12-col CSS Grid, DashboardToolbar with customize/reset/show-hide, rewrite dashboard/page.tsx
estimate: M
id: FEAT-BLR
kind: feature
labels:
    - plan:PLAN-BLV
priority: P1
project_id: orchestra-web
status: done
title: DashboardGrid, Toolbar, and page rewrite
updated_at: "2026-03-09T06:36:49Z"
version: 5
---

# DashboardGrid, Toolbar, and page rewrite

DashboardGrid with DragProvider + 12-col CSS Grid, DashboardToolbar with customize/reset/show-hide, rewrite dashboard/page.tsx


---
**in-progress -> in-testing** (2026-03-09T06:34:51Z):
## Changes
- apps/next/src/components/dashboard/DashboardGrid.tsx (new — DragProvider wrapper with 12-col CSS Grid overrides, per-widget colSpan, edit/lock-aware drag)
- apps/next/src/components/dashboard/DashboardToolbar.tsx (new — Customize/Done toggle, widget visibility dropdown with checkboxes, Reset button)
- apps/next/src/app/(app)/dashboard/page.tsx (rewritten — replaced hardcoded layout with DashboardGrid + WidgetShell + widget components, added store integration)
- apps/next/src/messages/en.json (added 8 dashboard widget i18n keys)
- apps/next/src/messages/ar.json (added 8 dashboard widget i18n keys in Arabic)


---
**in-testing -> in-docs** (2026-03-09T06:35:17Z):
## Results
- apps/next/src/components/dashboard/DashboardGrid.test.tsx (3 tests: renders visible widgets, shows hidden in edit mode, applies gridColumn span)
- apps/next/src/components/dashboard/DashboardToolbar.test.tsx (4 tests: Customize button in normal mode, Done/Widgets/Reset in edit mode, onToggleEdit callback, onReset callback)


---
**in-docs -> in-review** (2026-03-09T06:35:34Z):
## Docs
- docs/dashboard-widgets.md (updated — added DashboardGrid and DashboardToolbar sections documenting grid override, drag behavior, and toolbar controls)


---
**Review (approved)** (2026-03-09T06:36:49Z): Final feature approved. All 4 features complete.
