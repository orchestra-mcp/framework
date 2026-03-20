# Cross-Device Realtime Health Data Sync

## Overview

Health data changes (hydration, caffeine, nutrition, pomodoro, shutdown) now propagate across all connected devices in realtime via WebSocket.

## Architecture

```
Device A: addWater(250ml)
  → Local state update (optimistic)
  → POST /api/health/water (API sync)
  → WS send: { type: "health.updated", dimension: "hydration" }
  → Server rebroadcasts to all connected clients

Device B: receives WS event
  → SyncEventHandler._onHealthUpdate("hydration")
  → ref.invalidate(hydrationProvider)
  → HydrationNotifier.build() re-fetches from API
  → UI rebuilds with fresh data
```

## WebSocket Event Format

```json
{
  "type": "health.updated",
  "dimension": "hydration",
  "user_id": "17"
}
```

### Supported Dimensions

| Dimension | Provider Invalidated | Trigger |
|-----------|---------------------|---------|
| `hydration` | `hydrationProvider` | Water logged |
| `caffeine` | `caffeineProvider` | Caffeine logged |
| `nutrition` | `nutritionProvider` | Meal logged |
| `pomodoro` | `pomodoroProvider` | Pomodoro session ended |
| `shutdown` | `shutdownProvider` | Shutdown started |
| `all` | All 5 providers | Full refresh |

The aggregated `healthProvider` is always invalidated regardless of dimension, ensuring the health score ring and daily flow components update.

## Files

- `lib/core/ws/ws_event.dart` — `HealthDataUpdatedEvent` class
- `lib/core/sync/sync_event_handler.dart` — `_onHealthUpdate()` handler
- `lib/core/health/*_manager.dart` — WebSocket broadcast after API sync

## Polling Fallback

Until the backend supports WebSocket relay, each health manager polls the API every 30 seconds via `Timer.periodic` in its `build()` method. This ensures changes from any device are picked up within 30 seconds on all other devices. The timer is auto-cancelled via `ref.onDispose`.

## Backend Requirement

The backend WebSocket server must relay `health.updated` events to all other connected clients for the same user/team. The Flutter app sends the event; the server must rebroadcast. Once the backend supports this, the 30s polling can be removed or extended to a longer interval as a fallback.
