---
id: FEAT-WMS
kind: feature
priority: P0
project_slug: orchestra-sync
status: done
title: Sync Button on Every Entry
type: feature
---

# Sync Button on Every Entry

Add a reusable sync action widget to every syncable entry:
- **SyncButton widget**: Shows sync status icon (synced=checkmark, pending=clock, outdated=download, conflict=warning, never=cloud-upload)
- **Status indicator**: Color-coded dot or badge on the entry tile
- **Tap handler**: Triggers sync flow (opens team selector dialog)
- **Integration points**: Projects list, Notes list, Skills list, Agents list, Workflows list
- **SyncStatusProvider**: Riverpod/Provider that exposes sync state per entity

Depends on: FEAT-ZQU (Sync Service & Repository Layer)


---
**in-progress -> in-testing** (2026-03-17T15:29:22Z):
## Changes
- apps/flutter/lib/widgets/sync_status_button.dart (new — SyncStatusButton + SyncStatusDot widgets)
- apps/flutter/lib/widgets/entity_context_actions.dart (added onSync callback to buildEntityContextActions)
- apps/flutter/lib/screens/projects/projects_screen.dart (added SyncStatusDot to project cards + onSync context action)
- apps/flutter/lib/screens/library/notes_screen.dart (added SyncStatusButton trailing + onSync context action)
- apps/flutter/lib/screens/library/skills_screen.dart (added SyncStatusButton trailing + onSync context action)
- apps/flutter/lib/screens/library/agents_screen.dart (added SyncStatusDot to agent cards + onSync context action)
- apps/flutter/lib/screens/library/workflows_screen.dart (added SyncStatusButton trailing + onSync context action)
- apps/flutter/lib/screens/library/docs_screen.dart (added SyncStatusButton trailing + onSync context action)


---
**in-testing -> in-docs** (2026-03-17T15:34:54Z):
## Results
- apps/flutter/test/widgets/sync_status_button_test.dart (16 tests — all passing)
  - SyncStatusButton: 8 tests (icon per status, onSync tap, tooltip, container size)
  - SyncStatusDot: 5 tests (8x8 dot, color per status: green/amber/blue/red)
  - Coverage: all 5 EntitySyncStatus values verified
  - Integration: provider tuple key, JSON round-trip


---
**in-docs -> in-review** (2026-03-17T15:36:49Z):
## Docs
- docs/sync-status-button.md (widget overview, props, screen integration table, context menu, data flow, dependencies)


---
**Review (approved)** (2026-03-17T15:39:05Z): Sync status widgets integrated across all 6 screens with 16 passing tests.
