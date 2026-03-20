# Sync Status Button

## Overview

The `SyncStatusButton` and `SyncStatusDot` widgets provide visual sync status indicators for every entity in the Orchestra Flutter app. They display the current sync state (never synced, synced, pending, outdated, conflict) using icons and color-coded dots.

## Widgets

### SyncStatusButton

A 28x28 tappable icon button used in list-view screens (notes, skills, workflows, docs). Shows a status-appropriate icon with color coding inside a Tooltip.

| Status | Icon | Color |
|--------|------|-------|
| neverSynced | `cloud_upload_outlined` | `fgDim` (muted) |
| synced | `cloud_done_rounded` | Green `#22C55E` |
| pending | `schedule_rounded` | Amber `#F59E0B` |
| outdated | `cloud_download_rounded` | Blue `#3B82F6` |
| conflict | `warning_amber_rounded` | Red `#EF4444` |

**Props:**
- `entityType` (String) — e.g. `'note'`, `'skill'`, `'workflow'`, `'doc'`
- `entityId` (String) — unique entity identifier
- `onSync` (VoidCallback) — called when the button is tapped

### SyncStatusDot

A compact 8x8 colored circle used in grid-view screens (projects, agents) where space is limited. Same color mapping as the button but without icons or tap handling.

**Props:**
- `entityType` (String)
- `entityId` (String)

## Integration Points

### Screen Integration

| Screen | Widget Used | Placement |
|--------|-------------|-----------|
| Notes | SyncStatusButton | `trailing` in GlassListTile |
| Skills | SyncStatusButton | `trailing` Row with ScopeBadge |
| Workflows | SyncStatusButton | `trailing` Row with badges |
| Docs | SyncStatusButton | `trailing` in GlassListTile |
| Projects | SyncStatusDot | Card content Row |
| Agents | SyncStatusDot | Card content Row |

### Context Menu

All screens include a "Sync with Team" action via `buildEntityContextActions(onSync: ...)`. The `onSync` parameter was added to the shared `buildEntityContextActions` function in `entity_context_actions.dart`.

## Data Flow

1. Widget reads `entitySyncStatusProvider((entityType, entityId))` via Riverpod
2. Provider returns `EntitySyncMetadata?` from the local Drift database
3. If `null`, status defaults to `neverSynced`
4. Icon/color is derived from `EntitySyncStatus` enum value

## Dependencies

- `team_sync_provider.dart` — `entitySyncStatusProvider` (FutureProvider.family)
- `team_share_models.dart` — `EntitySyncMetadata`, `EntitySyncStatus` enum
- `color_tokens.dart` — `ThemeTokens` for theme-aware colors
- `entity_context_actions.dart` — shared context menu builder
