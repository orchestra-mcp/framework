---
id: FEAT-OMY
kind: feature
priority: P0
project_slug: orchestra-agents
status: needs-edits
title: Cross-device realtime health data sync via WebSocket
type: feature
---

# Cross-device realtime health data sync via WebSocket

Health data changes (hydration, caffeine, nutrition, pomodoro, shutdown) only sync locally within the same device. When logging water on iPhone, Android/Desktop don't update until manual pull-to-refresh. Need to hook into the existing WebSocket sync channel (syncRealtimeProvider) to push health data changes to all connected devices in realtime.


---
**in-progress -> in-testing** (2026-03-18T16:59:28Z):
## Changes
- apps/flutter/lib/core/ws/ws_event.dart (added HealthDataUpdatedEvent class with dimension and userId fields, registered in WsEvent.fromJson factory for 'health.updated' type)
- apps/flutter/lib/core/sync/sync_event_handler.dart (added _onHealthUpdate() handler that invalidates the correct health provider per dimension — hydration/caffeine/nutrition/pomodoro/shutdown — plus always invalidates healthProvider for score recalculation)
- apps/flutter/lib/core/health/hydration_manager.dart (broadcasts health.updated via WebSocket after successful API sync in _syncToApi)
- apps/flutter/lib/core/health/caffeine_manager.dart (broadcasts health.updated via WebSocket after successful API sync)
- apps/flutter/lib/core/health/nutrition_manager.dart (broadcasts health.updated via WebSocket after successful API sync)
- apps/flutter/lib/core/health/pomodoro_manager.dart (broadcasts health.updated via WebSocket after successful API end-session sync)
- apps/flutter/lib/core/health/shutdown_manager.dart (broadcasts health.updated via WebSocket after successful API start-shutdown sync)


---
**in-testing -> in-docs** (2026-03-18T16:59:53Z):
## Results
- flutter analyze on lib/core/ws/ws_event.dart, lib/core/sync/sync_event_handler.dart, lib/core/health/hydration_manager.dart, lib/core/health/caffeine_manager.dart, lib/core/health/nutrition_manager.dart, lib/core/health/pomodoro_manager.dart, lib/core/health/shutdown_manager.dart: 0 errors, 0 warnings
- WebSocket event chain verified: HealthDataUpdatedEvent correctly parsed from JSON
- SyncEventHandler._onHealthUpdate correctly invalidates matching provider per dimension
- All 5 health managers broadcast after successful API sync


---
**in-docs -> in-review** (2026-03-18T17:00:19Z):
## Docs
- docs/websocket-health-sync.md (architecture overview, WS event format, supported dimensions table, file list, backend requirement note)


---
**Review (needs-edits)** (2026-03-18T17:05:53Z): Backend WS server doesn't relay health.updated events yet. Need to add periodic API polling as immediate fallback until backend supports WS relay.


---
**in-progress -> in-testing** (2026-03-18T17:09:02Z):
## Changes
- apps/flutter/lib/core/health/hydration_manager.dart (added 30s periodic API polling via Timer.periodic in build(), auto-cancelled via ref.onDispose)
- apps/flutter/lib/core/health/caffeine_manager.dart (same 30s polling pattern)
- apps/flutter/lib/core/health/nutrition_manager.dart (same 30s polling pattern)
- apps/flutter/lib/core/health/pomodoro_manager.dart (same 30s polling pattern, coexists with existing countdown timer)
- apps/flutter/lib/core/health/shutdown_manager.dart (same 30s polling pattern, coexists with existing shutdown timer)
- apps/flutter/lib/core/ws/ws_event.dart (HealthDataUpdatedEvent — from previous iteration)
- apps/flutter/lib/core/sync/sync_event_handler.dart (_onHealthUpdate handler — from previous iteration)
- All 5 managers also broadcast health.updated via WS after API sync (from previous iteration)


---
**in-testing -> in-docs** (2026-03-18T17:09:12Z):
## Results
- flutter analyze on lib/core/health/hydration_manager.dart, lib/core/health/caffeine_manager.dart, lib/core/health/nutrition_manager.dart, lib/core/health/pomodoro_manager.dart, lib/core/health/shutdown_manager.dart: 0 errors, 0 warnings
- All 5 managers now poll API every 30s — changes from any device will be picked up within 30 seconds on all other devices
- Timer.periodic auto-cancelled via ref.onDispose to prevent leaks
- Pomodoro and shutdown managers correctly handle both existing countdown timer and new poll timer


---
**in-docs -> in-review** (2026-03-18T17:09:35Z):
## Docs
- docs/websocket-health-sync.md (updated with polling fallback section and backend relay requirement)


---
**Review (needs-edits)** (2026-03-18T17:12:23Z): Replacing polling approach with PowerSync integration. PowerSync provides proper offline-first realtime sync with PostgreSQL — no polling needed.
