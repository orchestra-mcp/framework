# WebSocket Real-time Sync Notifications

## Overview

When a team member updates, shares, or deletes a shared entity, the server pushes a WebSocket event to all affected users. The Flutter app listens for these events and automatically refreshes the relevant UI providers so data stays fresh without polling.

## Architecture

```
Server (WS push)
  │
  ▼
WsManager (connect/reconnect/eventStream)
  │
  ▼
SyncEventHandler (pattern-match on event type)
  │
  ├── SyncEntityUpdatedEvent → invalidate entitySyncStatusProvider, teamUpdatesProvider, reset banner
  ├── SyncEntitySharedEvent  → same + invalidate entitySharesProvider, teamsProvider
  └── SyncEntityDeletedEvent → invalidate entitySyncStatusProvider, entitySharesProvider, teamUpdatesProvider
```

## WebSocket Event Types

| Event Type | Class | Key Fields |
|-----------|-------|------------|
| `sync.entity_updated` | `SyncEntityUpdatedEvent` | entityType, entityId, entityTitle, authorId, authorName, teamId, version |
| `sync.entity_shared` | `SyncEntitySharedEvent` | entityType, entityId, entityTitle, authorId, authorName, teamId, permission |
| `sync.entity_deleted` | `SyncEntityDeletedEvent` | entityType, entityId, authorId, authorName, teamId |

All event classes live in `ws_event.dart` as part of the `WsEvent` sealed class hierarchy.

## Components

### SyncEventHandler (`sync_event_handler.dart`)

Subscribes to `WsManager.eventStream` and reacts to sync events:

- **SyncEntityUpdatedEvent**: Invalidates the entity's sync status, refreshes the team updates banner, resets banner dismissed state.
- **SyncEntitySharedEvent**: All of the above, plus invalidates the entity's shares list and the teams provider (membership may have changed).
- **SyncEntityDeletedEvent**: Invalidates entity sync status, shares, and team updates.

### Providers

| Provider | Purpose |
|----------|---------|
| `syncEventHandlerProvider` | Creates and manages the `SyncEventHandler` lifecycle |
| `syncRealtimeProvider` | Convenience — connects WS and activates the event handler |

### Activation

`syncRealtimeProvider` is watched in the `SummaryScreen.build()` method, so the WebSocket connects and the event handler activates as soon as the dashboard renders.

## JSON Payloads

### sync.entity_updated
```json
{
  "type": "sync.entity_updated",
  "entity_type": "note",
  "entity_id": "n1",
  "entity_title": "Meeting Notes",
  "author_id": "u42",
  "author_name": "Alice",
  "team_id": "team-1",
  "version": 3
}
```

### sync.entity_shared
```json
{
  "type": "sync.entity_shared",
  "entity_type": "project",
  "entity_id": "p1",
  "entity_title": "Orchestra",
  "author_id": "u10",
  "author_name": "Carol",
  "team_id": "team-3",
  "permission": "write"
}
```

### sync.entity_deleted
```json
{
  "type": "sync.entity_deleted",
  "entity_type": "workflow",
  "entity_id": "w1",
  "author_id": "u7",
  "author_name": "Eve",
  "team_id": "team-2"
}
```
