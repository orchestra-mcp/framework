---
created_at: "2026-03-09T05:35:53Z"
description: Create WidgetType, WidgetLayout, WidgetDefinition types, WIDGET_REGISTRY, DEFAULT_LAYOUT, and useDashboardStore with persist + server sync
estimate: M
id: FEAT-OIP
kind: feature
labels:
    - plan:PLAN-BLV
priority: P1
project_id: orchestra-web
status: done
title: Dashboard types and Zustand store
updated_at: "2026-03-09T05:38:51Z"
version: 5
---

# Dashboard types and Zustand store

Create WidgetType, WidgetLayout, WidgetDefinition types, WIDGET_REGISTRY, DEFAULT_LAYOUT, and useDashboardStore with persist + server sync


---
**in-progress -> in-testing** (2026-03-09T05:36:34Z):
## Changes
- apps/next/src/types/dashboard.ts (new — WidgetType, WidgetLayout, WidgetDefinition, WIDGET_REGISTRY, DEFAULT_LAYOUT)
- apps/next/src/store/dashboard.ts (new — useDashboardStore Zustand store with persist + debounced server sync)


---
**in-testing -> in-docs** (2026-03-09T05:37:50Z):
## Results
- apps/next/src/store/dashboard.test.ts (unit tests for DEFAULT_LAYOUT, WIDGET_REGISTRY, type constraints)
- TypeScript compilation passes with no errors on dashboard.ts and types/dashboard.ts


---
**in-docs -> in-review** (2026-03-09T05:38:18Z):
## Docs
- docs/dashboard-widgets.md (new — widget system overview, types, store API, persistence, default layout)


---
**Review (approved)** (2026-03-09T05:38:51Z): Types and store approved. Moving to WidgetShell component.
