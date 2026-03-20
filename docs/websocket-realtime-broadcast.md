# WebSocket Realtime Broadcast

## Overview

All major CRUD operations now broadcast sync events via WebSocket so data changes appear in realtime across all connected devices (web, desktop, mobile).

## Architecture

```
Client A (edits note) → Go Handler → DB write + broadcastSync()
                                                    ↓
                                              WebSocket Hub
                                           ↓              ↓
                                    Client B (web)   Client C (mobile)
```

## Entity Types with Realtime Broadcast

| Entity Type | Handler | Operations |
|-------------|---------|-----------|
| `feature` | FeatureHandler | Update, Delete |
| `note` | NoteHandler | Create, Update, Delete |
| `agent` | AgentHandler | Create, Update, Delete |
| `workflow` | WorkflowHandler | Create, Update, Delete |
| `skill` | SkillHandler | Create, Update, Delete |
| `doc` | DocHandler | Update, Pin, Delete |
| `community_post` | CommunityHandler | Create, Update, Delete |
| `project` | ProjectHandler | Create, Update, Delete |
| `delegation` | DelegationHandler | Create (pre-existing) |
| `notification` | AdminCmsHandler | Send (pre-existing) |

## Event Format

```json
{
  "type": "sync",
  "entity_type": "note",
  "entity_id": "42",
  "action": "upsert",
  "user_id": 1,
  "timestamp": 1710892800000
}
```

- `type`: Always `"sync"` for data changes
- `entity_type`: The entity kind (see table above)
- `entity_id`: The entity's primary key (string or numeric)
- `action`: `"upsert"` for create/update, `"delete"` for deletion
- `user_id`: The user who made the change
- `timestamp`: Unix milliseconds

## Broadcast Helper

All handlers use the shared `broadcastSync()` helper in `internal/handlers/broadcast.go`:

```go
broadcastSync(h.hub, user.ID, "note", note.ID, "upsert")
```

The helper:
- Handles nil hub gracefully (no-op)
- Broadcasts to all WebSocket clients of the user who made the change
- Uses `BroadcastToUser` (user-scoped, not global)

## Handler Pattern

Handlers accept the hub as an optional variadic parameter to maintain backward compatibility with tests:

```go
func NewNoteHandler(db *gorm.DB, wsHub ...*hub.Hub) *NoteHandler {
    h := &NoteHandler{db: db}
    if len(wsHub) > 0 {
        h.hub = wsHub[0]
    }
    return h
}
```

## Client Integration

### Next.js (Web)

The `useRealtimeSync` hook in `src/hooks/useRealtimeSync.ts` handles incoming sync events:
- Dispatches `orchestra:sync` custom DOM events for page-level listeners
- Updates Zustand stores for features, projects
- Fires notification toasts for notification events

### Flutter (Mobile/Desktop)

The `SyncEngine` listens to WebSocket messages and applies changes via `ConflictResolver` (last-write-wins).

## Pull-Based Fallback

WebSocket broadcast is fire-and-forget. For guaranteed delivery:
- `GET /api/sync/pull?since=<timestamp>` returns all changes since a timestamp
- `SyncLog` table stores an immutable audit trail of all sync events
- Clients should pull on reconnect to catch events missed during disconnection
