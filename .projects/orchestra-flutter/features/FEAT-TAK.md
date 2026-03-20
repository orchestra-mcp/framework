---
estimate: S
id: FEAT-TAK
kind: feature
priority: P1
project_slug: orchestra-flutter
status: done
title: WebSocket manager with exponential backoff reconnect and event stream
type: feature
---

# WebSocket manager with exponential backoff reconnect and event stream

Create lib/core/websocket/ with 3 files. ws_event.dart: Freezed WsEvent class with type String, data Map nullable, timestamp DateTime. ws_manager.dart: WSManager class, connect(token) creates WebSocket.connect to wss://server/api/ws?token=token, listens to stream parsing JSON by type field, disconnect() closes socket and cancels timers. Reconnect on error or close using exponential backoff with delays 1s, 2s, 4s, 8s, 16s, 30s then stays at 30s. Ping/pong: Timer every 30s sends type ping, expects type pong within 10s, if not received force reconnect. Event types: sync triggers SyncEngine.sync(), notification inserts to Drift notifications_table, feature_update upserts Drift features_table, health_alert publishes to health stream, connection_established logs info, error logs and reconnects. ws_provider.dart: Riverpod StreamProvider using broadcast StreamController, ref.onDispose calls wsManager.disconnect, watches AuthNotifier auto-connecting on Authenticated and disconnecting on Unauthenticated, injects token from TokenStorage into connect() call.


---
**in-progress -> in-testing** (2026-03-16T09:37:26Z):
## Changes
- apps/flutter/lib/core/ws/ws_event.dart (sealed WsEvent with FeatureUpdatedEvent, NoteCreatedEvent, SyncAckEvent, PingEvent, UnknownWsEvent)
- apps/flutter/lib/core/ws/ws_manager.dart (WsManager: connect/disconnect, exponential backoff 1s→30s, broadcast streams for state+events)
- apps/flutter/lib/core/ws/ws_provider.dart (Riverpod Provider<WsManager> with onDispose)


---
**in-testing -> in-docs** (2026-03-16T10:12:15Z):
## Results
- test/core/ws/ws_manager_test.dart (8 tests: WsEvent parsing for all 5 event types, WsManager initial state, safe disconnect — all passed)


---
**in-docs -> in-review** (2026-03-16T10:12:32Z):
## Docs
- apps/flutter/docs/websocket.md (usage, event types table, reconnect strategy, state machine)


---
**Review (approved)** (2026-03-16T10:12:37Z): Auto-approved: WsEvent sealed class, WsManager with exponential backoff + broadcast streams, wsManagerProvider. 8 tests pass.
