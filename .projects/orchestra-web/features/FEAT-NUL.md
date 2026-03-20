---
estimate: M
id: FEAT-NUL
kind: feature
priority: P1
project_slug: orchestra-web
status: done
title: WidgetShell component
type: feature
---

# WidgetShell component

Reusable widget wrapper with header, resize dropdown, lock/hide toggles, drag handle, loading/error states


---
**in-progress -> in-testing** (2026-03-09T06:24:26Z):
## Changes
- apps/next/src/components/dashboard/WidgetShell.tsx (new — reusable widget wrapper with header, resize dropdown 1-12 with min/max from definition, lock/hide toggles, drag handle, loading shimmer, edit mode controls)


---
**in-testing -> in-docs** (2026-03-09T06:24:43Z):
## Results
- apps/next/src/components/dashboard/WidgetShell.test.tsx (6 tests: renders children, hides in normal mode, shows at reduced opacity in edit mode, edit controls visibility, loading shimmer state)


---
**in-docs -> in-review** (2026-03-09T06:24:56Z):
## Docs
- docs/dashboard-widgets.md (updated — added WidgetShell section documenting header, resize, lock, hide, loading states, and props)


---
**Review (approved)** (2026-03-09T06:30:11Z): WidgetShell approved. Moving to individual widget components.