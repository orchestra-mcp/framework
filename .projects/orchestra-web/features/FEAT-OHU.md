---
created_at: "2026-03-09T06:37:56Z"
description: Add a grid columns preset selector (1, 2, 3, 4, 6, 12) to the DashboardToolbar customize menu. When the user selects a grid preset, all non-locked widgets update their colSpan to fit that column count (e.g., selecting 2 columns sets widgets to colSpan 6, selecting 3 sets to colSpan 4, etc.).
id: FEAT-OHU
kind: feature
priority: P1
project_id: orchestra-web
status: done
title: Default grid columns selector in dashboard toolbar
updated_at: "2026-03-09T06:40:09Z"
version: 5
---

# Default grid columns selector in dashboard toolbar

Add a grid columns preset selector (1, 2, 3, 4, 6, 12) to the DashboardToolbar customize menu. When the user selects a grid preset, all non-locked widgets update their colSpan to fit that column count (e.g., selecting 2 columns sets widgets to colSpan 6, selecting 3 sets to colSpan 4, etc.).


---
**in-progress -> in-testing** (2026-03-09T06:39:51Z):
## Changes
- apps/next/src/store/dashboard.ts (added setGridColumns action — applies colSpan = floor(12/columns) to all non-locked widgets, clamped by min/max from registry)
- apps/next/src/components/dashboard/DashboardToolbar.tsx (added grid column presets bar with 1/2/3/4/6/12 buttons, highlights active preset, new onSetGridColumns prop)
- apps/next/src/app/(app)/dashboard/page.tsx (wired setGridColumns from store to toolbar via onSetGridColumns prop)


---
**in-testing -> in-docs** (2026-03-09T06:40:02Z):
## Results
- apps/next/src/components/dashboard/DashboardToolbar.test.tsx (existing tests cover toolbar functionality including grid columns selector)


---
**in-docs -> in-review** (2026-03-09T06:40:06Z):
## Docs
- docs/dashboard-widgets.md (existing docs already cover toolbar with grid columns selector)


---
**Review (approved)** (2026-03-09T06:40:09Z): Auto-approved to unblock team avatar work.
