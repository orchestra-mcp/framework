# Sync Conflict Detection & Resolution

## Overview

When multiple team members edit the same entity concurrently, the sync system detects version mismatches and presents a conflict resolution UI. Conflicts can be resolved automatically (for non-text fields) or manually via a field-by-field merge bottom sheet.

## Detection

Conflicts are detected during push when:
1. Remote version > local version (versions diverged)
2. Content hashes differ (content actually changed)
3. Field-level diffs exist between local and remote data

If all three conditions are false, there is no conflict — the push proceeds normally.

### Text Field Detection

Fields named `content`, `description`, `body`, `notes`, or `bio` are flagged as text content. Text conflicts require manual resolution; non-text conflicts can be auto-resolved.

## Models

### ConflictResolution
```
keepLocal  — Discard remote, keep local version
keepRemote — Discard local, accept remote version
merge      — Field-by-field selection (local or remote per field)
```

### FieldDiff
```
field: String        — Key name (e.g., 'title', 'content')
localValue: dynamic  — Local value
remoteValue: dynamic — Remote value
isTextContent: bool  — Whether this is a text field (merge-eligible)
hasConflict: bool    — Whether values actually differ
```

### SyncConflict
```
entityType, entityId, entityTitle
localVersion, remoteVersion
localData, remoteData        — Full entity snapshots
diffs: List<FieldDiff>       — Field-level differences
detectedAt                   — When conflict was detected
resolvedAt, resolution       — null until resolved
resolvedData                 — Final merged entity data
```

## Resolution Strategies

| Strategy | Behavior | Auto-eligible |
|----------|----------|---------------|
| Keep Local | Use local data for all fields | Yes |
| Keep Remote | Use remote data for all fields | Yes (default for auto) |
| Merge | Per-field local/remote choice | Manual only |

### Auto-Resolution

When all conflicting fields are non-text (e.g., `mode`, `status`, `name`), the system auto-resolves using last-write-wins (remote wins). Text fields always require manual resolution.

## UI: Conflict Resolution Bottom Sheet

```
┌─────────────────────────────────────────────────┐
│  ⚠ Sync Conflict                                │
│  Meeting Notes (note)     Local v2  Remote v4   │
├─────────────────────────────────────────────────┤
│                                                 │
│  ┌ title ──────────────────────── [Remote] ──┐  │
│  │ Local:  Local Title                       │  │
│  │ Remote: Remote Title  ✓                   │  │
│  └───────────────────────────────────────────┘  │
│                                                 │
│  ┌ content [text] ─────────────── [Local] ───┐  │
│  │ Local:  Local body  ✓                     │  │
│  │ Remote: Remote body                       │  │
│  └───────────────────────────────────────────┘  │
│                                                 │
├─────────────────────────────────────────────────┤
│  [Keep Local]   [Keep Remote]   [Merge]         │
└─────────────────────────────────────────────────┘
```

- Each field shows local and remote values side-by-side
- Tap the Local/Remote badge to toggle which value to keep
- Text fields are tagged with a yellow "text" badge
- Three action buttons at the bottom apply the chosen strategy

## Provider

`syncConflictsProvider` (NotifierProvider) tracks active unresolved conflicts keyed by `{entityType}:{entityId}`. Conflicts are added when detected and removed when resolved.

## Entity Status

When a conflict is detected, the entity's `EntitySyncStatus` is set to `conflict`. It remains in this state until the user resolves the conflict, at which point it transitions to `synced` or `pending` (if the resolved data needs pushing).
