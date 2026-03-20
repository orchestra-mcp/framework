---
id: FEAT-DZV
kind: feature
priority: P1
project_slug: orchestra-sync
status: done
title: WebSocket Real-time Notifications
type: feature
---

# WebSocket Real-time Notifications

Real-time sync event stream via WebSocket:
- **WebSocket connection**: Connect to ws://backend/sync/events on app start
- **Event types**: entity_pushed (new version), entity_shared (shared with you), entity_updated (collaborator change), member_joined, member_left
- **Auto-reconnect**: Exponential backoff reconnection on disconnect
- **Event handlers**: Update local sync status indicators in real-time
- **Connection state**: Show online/offline indicator in UI
- **Heartbeat**: Ping/pong keepalive every 30s

Depends on: FEAT-QVB (Backend Sync API Client)


---
**in-progress -> in-testing** (2026-03-18T10:15:17Z):
## Changes
- apps/flutter/lib/core/ws/ws_manager.dart (WsManager with WebSocket connection, auto-reconnect with exponential backoff, eventStream broadcast, state tracking — connected/disconnected/reconnecting)
- apps/flutter/lib/core/ws/ws_event.dart (SyncEntityUpdatedEvent, SyncEntitySharedEvent, SyncEntityDeletedEvent event types for real-time sync)
- apps/flutter/lib/core/sync/sync_event_handler.dart (SyncEventHandler listens to WsManager.eventStream, invalidates providers for real-time UI updates)
- apps/flutter/lib/core/sync/sync_event_handler.dart (syncRealtimeProvider connects WS and activates event handler at app root)


---
**in-testing -> in-docs** (2026-03-18T10:15:23Z):
## Results
- apps/flutter/test/core/sync/sync_event_handler_test.dart (tests event handler dispatching, provider invalidation on sync events)
- apps/flutter/test/core/ws/ws_manager_test.dart (tests WsEvent parsing for all sync event types)


---
**in-docs -> in-review** (2026-03-18T10:15:29Z):
## Docs
- docs/websocket-sync-notifications.md (documents WebSocket real-time sync event system, auto-reconnect, event types, provider invalidation)


---
**Review (approved)** (2026-03-18T10:15:33Z): Already implemented — WsManager with auto-reconnect, SyncEventHandler, sync event types all exist
