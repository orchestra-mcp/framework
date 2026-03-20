# Push Sync Flow

## Overview

The push sync flow handles the end-to-end process of sharing entities (notes, skills, workflows, docs, agents, projects) with team members. It connects the team selector dialog to the backend sync service and provides UI feedback.

## Architecture

```
Screen onSync callback
  → openSyncDialog(context, ref, entityData)
    → performPushSync()
      → showTeamSelectorDialog() → TeamShareSelection
      → PushSyncController.pushEntity()
        → TeamSyncService.shareEntity()
          → serialize → hash → POST → update metadata → save share
      → SnackBar feedback (success with Undo / error)
      → Invalidate entitySyncStatusProvider
```

## Key Components

### PushSyncController (`push_sync_controller.dart`)

Orchestrates the push flow:

- **`pushEntity()`** — Takes a `TeamShareSelection` and entity data, delegates to `TeamSyncService.shareEntity()`, returns `PushSyncResult`.
- **`pushBatch()`** — Pushes multiple entities with the same team/settings sequentially.
- **`pushSyncControllerProvider`** — Riverpod provider backed by `TeamSyncService`.

### PushSyncResult

```dart
class PushSyncResult {
  final bool success;
  final ShareResponse? shareResponse;  // For undo support
  final String? errorMessage;
}
```

### performPushSync() UI Helper

Top-level function callable from any screen:

1. Opens the team selector dialog
2. Pushes via `PushSyncController`
3. Shows success snackbar with **Undo** action (revokes share)
4. Shows error snackbar on failure
5. Invalidates `entitySyncStatusProvider` to refresh the sync button

### openSyncDialog() Update

The existing `openSyncDialog()` in `entity_context_actions.dart` now accepts optional `WidgetRef` and `entityData` parameters. When both are provided, it delegates to `performPushSync()` for the full flow. Without them, it falls back to just showing the dialog.

## Screen Integration

All 6 entity screens pass `ref` and entity data to `openSyncDialog`:

| Screen | Entity Type | Data Passed |
|--------|------------|-------------|
| NotesScreen | `note` | `{title, content}` |
| SkillsScreen | `skill` | `{name, command, source}` |
| WorkflowsScreen | `workflow` | Full workflow map |
| DocsScreen | `doc` | Full doc map |
| AgentsScreen | `agent` | Full agent map |
| ProjectsScreen | `project` | `{id, name, description, mode}` |

Both the trailing `SyncStatusButton` and context menu "Sync with Team" action trigger the same flow.

## Undo Support

On successful share, the snackbar includes an "Undo" button that calls `repository.deleteShare(shareId)` to revoke the share. This is best-effort — if the undo fails, it silently ignores the error.

## Error Handling

- Network errors are caught in `PushSyncController.pushEntity()` and returned as `PushSyncResult(success: false, errorMessage: ...)`
- Server conflicts return `errorMessage: 'Conflict during share operation'`
- The error snackbar uses a red background (`#EF4444`) for visibility
