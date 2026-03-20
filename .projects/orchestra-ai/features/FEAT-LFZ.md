---
id: FEAT-LFZ
kind: feature
priority: P1
project_slug: orchestra-ai
status: done
title: WebSocket Real-time Sync Notifications
type: feature
---

# WebSocket Real-time Sync Notifications

WebSocket channel for real-time push notifications when team members push changes:
- WebSocket provider: Connect to ws://api/sync/ws on app start, auto-reconnect
- Event model: SyncEvent with type (entity_updated/shared/deleted), entity info, author
- Event handler: On receive, invalidate relevant providers
- Connection status: Track connected/disconnected/reconnecting state
- Badge updates: Update sync status dots in real-time without polling


---
**in-progress -> in-testing** (2026-03-17T16:16:18Z):
## Changes
- apps/flutter/lib/core/ws/ws_event.dart (added SyncEntityUpdatedEvent, SyncEntitySharedEvent, SyncEntityDeletedEvent sealed class members with fromJson factories)
- apps/flutter/lib/core/sync/sync_event_handler.dart (new file — SyncEventHandler listens to WsManager.eventStream, pattern-matches sync events, invalidates Riverpod providers; syncEventHandlerProvider and syncRealtimeProvider)
- apps/flutter/lib/screens/summary/summary_screen.dart (added ref.watch(syncRealtimeProvider) to activate WS connection and sync handler on app launch)


---
**in-testing -> in-docs** (2026-03-17T16:18:05Z):
## Results
- apps/flutter/test/core/sync/sync_event_handler_test.dart (15 tests, all passing)
  - SyncEntityUpdatedEvent: fromJson parsing, defaults, WsEvent dispatch
  - SyncEntitySharedEvent: fromJson parsing, defaults, WsEvent dispatch
  - SyncEntityDeletedEvent: fromJson parsing, defaults, WsEvent dispatch
  - WsEvent dispatch: unknown fallthrough, existing events, pattern matching coverage
  - Constructor field storage for all 3 event types


---
**in-docs -> in-review** (2026-03-17T16:18:32Z):
## Docs
- docs/websocket-sync-notifications.md (new — architecture overview, event types table, SyncEventHandler behavior, provider activation, JSON payload examples)


---
**Review (approved)** (2026-03-17T16:18:55Z): Approved. FCM to be added in FEAT-HKL as complementary push channel.
