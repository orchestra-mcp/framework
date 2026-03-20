# Sync Status Dashboard

## Overview

The Sync Status Dashboard provides a real-time overview of all entity sync states across the team. It shows connection status, aggregate counts, and a filterable entity list with version and timing details.

## Screen Layout

```
┌─────────────────────────────────────────────────┐
│  Sync Status                    [● Connected]   │
├─────────────────────────────────────────────────┤
│  ┌──────┐ ┌──────┐ ┌──────┐ ┌──────┐          │
│  │  ✓   │ │  ↑   │ │  ↓   │ │  ⚠   │          │
│  │  12  │ │  3   │ │  1   │ │  0   │          │
│  │Synced│ │Pend. │ │Outd. │ │Confl.│          │
│  └──────┘ └──────┘ └──────┘ └──────┘          │
├─────────────────────────────────────────────────┤
│  [All] [Synced] [Pending] [Outdated] [Conflict] │
├─────────────────────────────────────────────────┤
│  📁 project/p1        v3 → v5   3h ago  Synced │
│  📝 note/n1           v2        just now Pending│
│  ⚡ skill/s1          v1 → v3   5d ago  Outdated│
│  📄 doc/d1            v0               Not sync │
└─────────────────────────────────────────────────┘
```

## Components

### Connection Badge

Displays WebSocket connection state from `wsManagerProvider`:
- **Connected** (green dot + label) — WS state is `WsState.connected`
- **Disconnected** (red dot + label) — any other state

### Stat Cards

Four cards in a horizontal row showing aggregate counts:

| Card | Color | Icon | Source |
|------|-------|------|--------|
| Synced | `#4ADE80` (green) | check_circle | `EntitySyncStatus.synced` count |
| Pending | `#FBBF24` (amber) | upload | `EntitySyncStatus.pending` count |
| Outdated | `#38BDF8` (blue) | download | `EntitySyncStatus.outdated` count |
| Conflicts | `#EF4444` (red) | warning | `syncConflictsProvider` length |

### Filter Chips

Horizontal chip row for filtering the entity list:
- **All** (default) — shows every entity
- One chip per `EntitySyncStatus` value, colored to match the status

Filter state is managed by `_FilterNotifier` (Riverpod `NotifierProvider`).

### Entity List

Each row displays:
- **Entity icon** — mapped by type (project, note, skill, workflow, doc, agent)
- **Entity path** — `{entityType}/{entityId}`
- **Version info** — `v{localVersion}` and optionally `→ v{remoteVersion}`
- **Last synced** — relative time (just now, Xm ago, Xh ago, Xd ago)
- **Status badge** — colored icon + label

## Providers

| Provider | Type | Description |
|----------|------|-------------|
| `allSyncMetadataProvider` | `AsyncNotifierProvider` | All entity sync metadata |
| `syncConflictsProvider` | `NotifierProvider` | Active unresolved conflicts |
| `wsManagerProvider` | `Provider` | WebSocket connection manager |
| `_filterProvider` | `NotifierProvider` (private) | Current status filter |

## Entity Type Icons

| Type | Icon |
|------|------|
| project | folder |
| note | sticky_note_2 |
| skill | bolt |
| workflow | account_tree |
| doc | description |
| agent | smart_toy |
| (unknown) | data_object |

## Time Formatting

| Duration | Format |
|----------|--------|
| < 1 minute | "just now" |
| < 1 hour | "{minutes}m ago" |
| < 24 hours | "{hours}h ago" |
| >= 24 hours | "{days}d ago" |
