---
id: FEAT-FMU
kind: bug
priority: P1
project_slug: orchestra-agents
status: done
title: Fix workflow display & team selector JSON parsing
type: feature
---

# Fix workflow display & team selector JSON parsing

Two UI bugs in the Flutter app:\n1. Workflow list/sidebar shows combined "name (project_id)" as the label. Should show name-only as label and project_id as subtitle.\n2. Team selector dialog shows only placeholder circle — backend returns nested {"team": {...}, "role": "..."} but Team.fromJson reads from top level.


---
**in-progress -> in-testing** (2026-03-17T20:39:17Z):
## Changes
- apps/flutter/lib/core/sync/sync_api_client.dart (unwrap nested `e['team']` before passing to `Team.fromJson` — fixes team selector showing only placeholder)
- apps/flutter/lib/screens/library/workflows_screen.dart (label uses rawName only, description includes project_id as subtitle)
- apps/flutter/lib/screens/shell/desktop_shell.dart (sidebar descriptionKey changed from 'description' to 'project_id' for workflows)
- apps/flutter/lib/screens/library/library_detail_screen.dart (detail title returns name without project_id suffix for workflows)


---
**in-testing -> in-review** (2026-03-17T20:39:56Z): Gate skipped for kind=bug


---
**Review (approved)** (2026-03-17T20:41:38Z): All 4 fixes verified: team selector unwraps nested JSON, workflow name/subtitle split across list, sidebar, and detail screens. 927 tests pass.
