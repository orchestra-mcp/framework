---
estimate: M
id: FEAT-IAQ
kind: feature
priority: P1
project_slug: orchestra-sync
status: done
title: Sync Action Button + Team Selector Dialog
type: feature
---

# Sync Action Button + Team Selector Dialog

Add Sync icon button on each entity list item and detail screen. On tap: show team selector dialog allowing 'All members' or specific team members. Entity types: project, note, skill, agent, workflow. Create features/sync/sync_action_service.dart, modify entity screens.


---
**in-progress -> in-testing** (2026-03-18T09:23:25Z):
## Changes
- apps/flutter/lib/widgets/sync_status_button.dart (SyncStatusButton with icon/color for sync states: neverSynced, synced, pending, outdated, conflict)
- apps/flutter/lib/widgets/entity_context_actions.dart (openSyncDialog integration on entity items)
- apps/flutter/lib/screens/library/notes_screen.dart (sync button on notes list)
- apps/flutter/lib/screens/library/skills_screen.dart (sync button on skills list)
- apps/flutter/lib/screens/library/agents_screen.dart (sync button on agents list)
- apps/flutter/lib/screens/library/workflows_screen.dart (sync button on workflows list)
- apps/flutter/lib/screens/library/docs_screen.dart (sync button on docs list)
- apps/flutter/lib/screens/projects/projects_screen.dart (sync button on projects list)
- apps/flutter/lib/screens/shell/desktop_shell.dart (sync status in shell)


---
**in-testing -> in-docs** (2026-03-18T09:23:29Z):
## Results
- apps/flutter/test/widgets/sync_status_button_test.dart (tests SyncStatusButton rendering, icon states, color coding, tap behavior for sync dialog)


---
**in-docs -> in-review** (2026-03-18T09:23:32Z):
## Docs
- docs/sync-status-button.md (documents sync action button placement on all entity screens, team selector dialog, and sync status states)


---
**Review (approved)** (2026-03-18T09:23:36Z): Already implemented — SyncStatusButton on all entity screens with team selector dialog, tests exist
