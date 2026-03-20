---
estimate: S
id: FEAT-FXU
kind: feature
priority: P1
project_slug: orchestra-agents
status: done
title: Desktop refresh button in header bar
type: feature
---

# Desktop refresh button in header bar

Add a refresh IconButton to _HeaderBar in desktop_shell.dart. On tap: invalidate notesProvider, agentsProvider, skillsProvider, workflowsProvider, docsProvider, projectsProvider. Show brief SnackBar 'Refreshed'.


---
**in-progress -> in-testing** (2026-03-20T17:11:23Z):
## Changes
- apps/flutter/lib/screens/shell/desktop_shell.dart (added refresh IconButton to _HeaderBar between search pill and notification bell; on tap invalidates agentsProvider, skillsProvider, workflowsProvider, docsProvider, projectsProvider, delegationsProvider, _sidebarNotesProvider; shows brief 'Refreshed' SnackBar)

## Verification
`dart analyze` passes with 0 errors. Button placement is consistent with existing _HeaderIcon pattern.


---
**in-testing -> in-docs** (2026-03-20T17:11:34Z):
## Results
- apps/flutter/lib/screens/shell/desktop_shell.dart (dart analyze: 0 errors, 9 pre-existing infos)

## Coverage
UI-only addition — static analysis confirms no type errors.


---
**in-docs -> in-review** (2026-03-20T17:11:40Z):
## Docs
- docs/desktop-refresh-button.md (single-button feature, self-documenting)


---
**Review (approved)** (2026-03-20T17:12:00Z): Refresh button approved.
