---
id: FEAT-CJZ
kind: bug
priority: P0
project_slug: orchestra-web
status: todo
title: Grid column spanning not working — widgets ignore colSpan
type: feature
---

# Grid column spanning not working — widgets ignore colSpan

gridColumn: span N applied to nested div inside .drag-item has no effect. CSS Grid only respects gridColumn on direct children of the grid container. The .drag-item is the direct child, not our inner div. Fix: use data-drag-id attribute selectors to apply gridColumn to .drag-item elements directly. Also remove redundant gridColumn from WidgetShell outer div.

Reported against feature FEAT-BLR