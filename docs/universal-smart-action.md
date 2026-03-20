# Universal Smart Action Dialog

## Overview

A universal create dialog that supports all entity types in Orchestra. Replaces the original 4-type `SmartActionType` dialog with a 10-type grid + AI/Manual flow.

## Location

`apps/flutter/lib/widgets/smart_action_dialog.dart`

## Supported Types

| Type | Icon | Color | Description |
|------|------|-------|-------------|
| Note | sticky_note_2 | #FBBF24 | Quick notes with markdown |
| Agent | smart_toy | #A78BFA | AI agents with system prompts |
| Skill | bolt | #F97316 | Slash commands |
| Workflow | account_tree | #EC4899 | State machine workflows |
| Doc | description | #60A5FA | Documentation pages |
| Feature | auto_awesome | #00E5FF | Feature requests |
| Plan | map | #4ADE80 | Implementation plans |
| Request | inbox | #FBBF24 | User requests |
| Person | person | #818CF8 | Team members |
| Health Brief | favorite | #EF4444 | AI-generated health summary |

## Usage

### New API (recommended)

```dart
import 'package:orchestra/widgets/smart_action_dialog.dart';

showUniversalCreateMenu(
  context,
  ref,
  preselectedType: UniversalActionType.note,  // optional — skips grid
  projectId: 'my-project',                     // optional
  onCreate: (type, title, content) {
    // Handle creation based on type
  },
);
```

### Legacy API (deprecated, backward-compatible)

```dart
showCreateMenu(
  context,
  ref,
  type: SmartActionType.note,
  onManualCreate: (title, content) => ...,
  onSmartCreate: (title, content) => ...,
);
```

## Dialog Flow

1. **No preselected type**: Shows a 5-column grid of type chips. User picks a type.
2. **Type selected**: Shows AI tab (prompt + generate) and Manual tab (title + create).
3. **Health Brief**: Manual tab is hidden; prompt is auto-filled with health brief request.

## Global Entry Point

A "+" button is added to the desktop shell header bar (next to the refresh button) that opens the universal dialog with no preselected type, showing the full type grid.

## Backward Compatibility

- `SmartActionType` enum is preserved with `@Deprecated` annotation
- `showCreateMenu` function is preserved with `@Deprecated` annotation
- All existing callers (agents_screen, skills_screen, notes_screen) continue working without changes
