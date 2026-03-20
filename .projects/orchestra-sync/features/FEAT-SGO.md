---
id: FEAT-SGO
kind: feature
priority: P0
project_slug: orchestra-sync
status: done
title: Push Sync Flow (Local to Server)
type: feature
---

# Push Sync Flow (Local to Server)

Complete end-to-end push sync flow:
1. User taps sync button on an entry
2. Team selector dialog opens, user picks team/members
3. User confirms sharing
4. Serialize entity to JSON payload
5. Compute content SHA-256 hash
6. POST to /api/sync/push with entity + metadata + share targets
7. On success: update local SyncMetadata (status=synced, version++, last_synced=now)
8. Show success snackbar with undo option
9. On error: show error dialog, queue for retry
10. Batch mode: sync multiple selected entities at once

Depends on: FEAT-Team Selector Dialog


---
**in-progress -> in-testing** (2026-03-17T15:58:08Z):
## Changes
- apps/flutter/lib/core/sync/push_sync_controller.dart (new — PushSyncController, PushSyncResult, pushSyncControllerProvider, performPushSync UI helper)
- apps/flutter/lib/widgets/entity_context_actions.dart (updated openSyncDialog to accept WidgetRef + entityData and delegate to performPushSync)
- apps/flutter/lib/screens/library/notes_screen.dart (wired entityData into both onSync callbacks)
- apps/flutter/lib/screens/library/skills_screen.dart (wired entityData into both onSync callbacks)
- apps/flutter/lib/screens/library/workflows_screen.dart (wired entityData into both onSync callbacks)
- apps/flutter/lib/screens/library/docs_screen.dart (wired entityData into both onSync callbacks)
- apps/flutter/lib/screens/library/agents_screen.dart (wired entityData into context menu onSync)
- apps/flutter/lib/screens/projects/projects_screen.dart (wired entityData into context menu onSync)


---
**in-testing -> in-docs** (2026-03-17T16:00:51Z):
## Results
- apps/flutter/test/core/sync/push_sync_controller_test.dart (21 tests — all passed)
  - PushSyncResult: success/failure/edge cases (5 tests)
  - TeamShareSelection integration: share-all, specific members, admin permission (3 tests)
  - ShareResponse: success, failure, shareId format (3 tests)
  - ShareRequest: construction, JSON serialization (2 tests)
  - Entity data construction: note, skill, project, workflow, doc, agent (6 tests)
  - Permission mapping: values, equality (2 tests)


---
**in-docs -> in-review** (2026-03-17T16:01:19Z):
## Docs
- docs/push-sync-flow.md (new — architecture, components, screen integration, undo support, error handling)


---
**Review (approved)** (2026-03-17T16:01:43Z): Push sync flow complete with controller, UI helper, undo support, and all 6 screens wired.
