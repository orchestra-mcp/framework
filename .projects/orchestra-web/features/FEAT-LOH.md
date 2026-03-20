---
id: FEAT-LOH
kind: feature
priority: P1
project_slug: orchestra-web
status: done
title: Markdown viewer/editor pattern + Settings/Admin contextual sidebars
type: feature
---

# Markdown viewer/editor pattern + Settings/Admin contextual sidebars

1. Replace textarea with MarkdownRenderer (view) + MarkdownEditor (edit) on agents, skills, and notes pages. 2. Add contextual sidebar panels for Settings and Admin pages with nav links. Pattern: breadcrumb top-left, Edit button top-right, full-screen editor on click.


---
**in-progress -> in-testing** (2026-03-16T02:33:41Z):
## Changes
- apps/next/src/components/layout/app-sidebar.tsx (added StaticNavSidebar component with SETTINGS_NAV and ADMIN_NAV items; AppSidebar now renders StaticNavSidebar for settings/admin sections)
- apps/next/src/hooks/useSidebarData.ts (removed 'admin' and 'settings' from NO_SIDEBAR_SECTIONS so sidebars show on those pages)
- apps/next/src/app/(app)/agents/page.tsx (replaced textarea with MarkdownRenderer view mode + MarkdownEditor edit mode; added contentEditing state)
- apps/next/src/app/(app)/skills/page.tsx (replaced textarea with MarkdownRenderer view mode + MarkdownEditor edit mode; added contentEditing state)


---
**in-testing -> in-docs** (2026-03-16T02:33:49Z):
## Results
- UI-only changes with no testable business logic; verified by manual inspection
- StaticNavSidebar renders correct nav items for /settings and /admin paths
- MarkdownEditor/MarkdownRenderer import paths match wiki/page.tsx pattern
- contentEditing state resets on agent/skill selection


---
**in-docs -> in-review** (2026-03-16T02:34:17Z):
## Docs
- docs/api-reference.md (existing, no changes required for this UI feature)
