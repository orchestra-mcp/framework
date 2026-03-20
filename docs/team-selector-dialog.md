# Team Selector Dialog

## Overview

The team selector dialog is a glass-styled modal bottom sheet that appears when users tap sync on any entity. It allows selecting a team, choosing between sharing with all members or specific individuals, setting permissions, and confirming the share.

## Usage

```dart
final result = await showTeamSelectorDialog(
  context: context,
  entityType: 'note',
  entityId: 'n1',
);

if (result != null) {
  // result.teamId, result.shareWithAll, result.memberIds, result.permission
}
```

Or use the convenience helper from `entity_context_actions.dart`:

```dart
onSync: () => openSyncDialog(context, entityType: 'note', entityId: note.id),
```

## Dialog Flow

1. User taps sync button or "Sync with Team" context menu action
2. Dialog opens showing team chips (horizontal scroll)
3. User taps a team chip to select it
4. Controls appear: share-with-all toggle, permission selector, confirm/cancel
5. If share-with-all is off, member list with checkboxes and search appears
6. User confirms → `TeamShareSelection` returned; cancel → `null` returned

## Components

| Widget | Purpose |
|--------|---------|
| `_TeamChip` | Selectable team pill with avatar/initial and name |
| `_ShareModeToggle` | Switch between share-all and select-members |
| `_SearchField` | Filter members by name or email |
| `_MemberList` | Scrollable list with checkboxes, avatars, online dots |
| `_MemberTile` | Individual member row with checkbox, avatar, name, email, role badge |
| `_PermissionSelector` | Three-option selector (Read/Write/Admin) with icons |

## Result Model

```dart
class TeamShareSelection {
  final String teamId;
  final bool shareWithAll;
  final List<String> memberIds;
  final SharePermission permission;
}
```

## State Providers

The dialog uses four Riverpod notifiers (reset on open):

| Provider | Type | Default |
|----------|------|---------|
| `selectedTeamProvider` | `String?` | `null` |
| `selectedMembersProvider` | `Set<String>` | `{}` |
| `shareWithAllProvider` | `bool` | `true` |
| `sharePermissionProvider` | `SharePermission` | `read` |

## Integration

All 6 entity screens (notes, skills, workflows, docs, projects, agents) wire their sync callbacks to `openSyncDialog()` which calls `showTeamSelectorDialog`. The returned `TeamShareSelection` will be passed to the push sync flow (FEAT-SGO).
