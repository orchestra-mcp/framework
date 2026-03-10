---
created_at: "2026-03-09T05:35:53Z"
description: Extract StatsWidget, RecentProjectsWidget, RecentNotesWidget, QuickActionsWidget from current dashboard page
estimate: M
id: FEAT-SWR
kind: feature
labels:
    - plan:PLAN-BLV
priority: P1
project_id: orchestra-web
status: done
title: Individual widget components
updated_at: "2026-03-09T06:32:42Z"
version: 5
---

# Individual widget components

Extract StatsWidget, RecentProjectsWidget, RecentNotesWidget, QuickActionsWidget from current dashboard page


---
**in-progress -> in-testing** (2026-03-09T06:31:24Z):
## Changes
- apps/next/src/components/dashboard/widgets/StatsWidget.tsx (new — 4 stat cards with responsive auto-fit grid)
- apps/next/src/components/dashboard/widgets/RecentProjectsWidget.tsx (new — project list with links, empty state)
- apps/next/src/components/dashboard/widgets/RecentNotesWidget.tsx (new — notes list with dates, empty state)
- apps/next/src/components/dashboard/widgets/QuickActionsWidget.tsx (new — action buttons for new project/note/settings)
- apps/next/src/components/dashboard/widgets/index.ts (new — barrel export + WIDGET_COMPONENTS map)


---
**in-testing -> in-docs** (2026-03-09T06:31:43Z):
## Results
- apps/next/src/components/dashboard/widgets/widgets.test.tsx (10 tests: registry completeness, StatsWidget rendering + offline state, RecentProjectsWidget list + empty state, RecentNotesWidget list + empty state, QuickActionsWidget links + routing)


---
**in-docs -> in-review** (2026-03-09T06:31:57Z):
## Docs
- docs/dashboard-widgets.md (updated — added Widget Components section with props table for all 4 widgets)


---
**Review (approved)** (2026-03-09T06:32:42Z): Widget components approved. Moving to final feature: DashboardGrid + page rewrite.
