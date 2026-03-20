# Health API Integration

All health managers now load data from the backend API on initialization and sync mutations back.

## Architecture

Each manager follows the same pattern:
1. **`build()`** — Returns loading state, kicks off `_loadFromApi()` async
2. **`_loadFromApi()`** — Calls the API client, parses response, updates state
3. **Mutations** (e.g., `addWater()`) — Updates local state immediately for fast UI, then calls `_syncToApi()` in the background
4. **`_syncToApi()`** — Sends the mutation to the API, invalidates downstream FutureProviders
5. **`refresh()`** — Public method to reload data from API

## Managers Updated

| Manager | API Endpoints Used |
|---------|-------------------|
| `HydrationNotifier` | `getHydrationStatus()`, `listWaterLogs()`, `logWater()` |
| `CaffeineNotifier` | `listCaffeineLogs()`, `getCaffeineScore()`, `logCaffeine()` |
| `NutritionNotifier` | `listMealLogs()`, `logMeal()` |
| `PomodoroNotifier` | `listPomodoroSessions()`, `startPomodoro()`, `endPomodoro()` |
| `ShutdownNotifier` | `getShutdownStatus()`, `startShutdown()` |

## State Fields

All state classes now include:
- `isLoading: bool` — true during initial API load
- `error: String?` — set when API call fails (null on success)

## Optimistic Updates

Mutations update local state first (optimistic), then sync to API. If the API call fails, the local state remains (the error is logged but not surfaced to the user to avoid blocking the UX). The next `refresh()` call will reconcile.
