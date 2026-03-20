# Desktop Push Notifications for Sync Events

## Overview

When team members update, share, or delete shared entities, the app shows native desktop/mobile push notifications in addition to the in-app banner. Notifications work via two complementary channels:

1. **Local notifications** (flutter_local_notifications) — fires immediately from WebSocket events when the app is in the foreground
2. **Firebase Cloud Messaging** — delivers notifications when the app is backgrounded or the WebSocket is disconnected

## Architecture

```
WebSocket event
  │
  ▼
SyncEventHandler._onEvent()
  ├── Invalidate Riverpod providers (UI refresh)
  └── SyncNotificationService.showForEvent()
        ├── Check user preference (sync toggle)
        └── flutter_local_notifications.show()

FCM (background)
  │
  ▼
MessagingService._handleForeground() / backgroundHandler
  └── OS notification tray
```

## Components

### SyncNotificationService (`sync_notification_service.dart`)

- **Initialization**: Lazy — initializes on first notification show
- **Preference check**: Reads `preferencesProvider` for `notifications.sync` toggle (default: enabled)
- **Event mapping**: Pattern matches on WsEvent subtype to build title/body

| Event | Title | Body |
|-------|-------|------|
| `SyncEntityUpdatedEvent` | `{author} updated a {type}` | Entity title |
| `SyncEntitySharedEvent` | `{author} shared a {type} with you` | Entity title |
| `SyncEntityDeletedEvent` | `{author} deleted a shared {type}` | `A shared {type} was removed` |

- **Deep link payload**: `/{entityType}` (e.g., `/note`, `/project`)
- **Android channel**: `sync_updates` with default importance

### FCM Topic Subscriptions

Teams subscribe to FCM topics with the `{teamId}_sync` naming convention:

```dart
await MessagingService.subscribeToTeam('${teamId}_sync');
```

This ensures sync notifications reach users even when:
- The app is fully closed / killed
- The WebSocket connection is dropped
- The device is in doze mode (Android)

### Notification IDs

| ID | Event |
|----|-------|
| 20000 | Entity updated |
| 20001 | Entity shared |
| 20002 | Entity deleted |

IDs start at 20000 to avoid collision with health notification IDs (1000-10000 range).

## Settings

A **Sync notifications** toggle appears in Settings > Notifications, between "Push notifications" and "Email digests". The preference key is `notifications.sync` (default: `true`).

When disabled, the `SyncNotificationService` skips showing local notifications. The WebSocket event handler still runs and refreshes the UI — only the OS-level push notification is suppressed.

## Agent Notifications (`agent_notification_service.dart`)

In addition to sync notifications, MCP hook events trigger desktop notifications when AI agents need user attention.

### Event Types

| Event | Title | Importance |
|-------|-------|-----------|
| `McpNotificationEvent` (delegation) | Delegation Request | High |
| `McpNotificationEvent` (permission) | Permission Required | High |
| `McpNotificationEvent` (review) | Review Requested | High |
| `McpAgentSpawnedEvent` | Agent Spawned | Default (verbose only) |

### Notification IDs

| ID | Event |
|----|-------|
| 30000 | Tool called (reserved) |
| 30001 | Agent spawned |
| 30002 | MCP notification |

### Settings

- `notifications.agent_push` — Enable/disable agent attention notifications (default: true)
- `notifications.agent_verbose` — Show notifications for agent spawns too (default: false)

### Activation

`agentNotificationsProvider` is watched in `SummaryScreen.build()` alongside sync and MCP providers.

## Platform Support

| Platform | Local Notifications | FCM |
|----------|-------------------|-----|
| macOS | DarwinNotificationDetails | Firebase Messaging |
| iOS | DarwinNotificationDetails | Firebase Messaging |
| Android | AndroidNotificationDetails | Firebase Messaging |
| Web | Browser Notification API | Firebase Messaging (FCM) |

## Web Push Notifications

Web push uses FCM with a service worker for background delivery and in-app foreground handling.

### Files

- `apps/next/public/firebase-messaging-sw.js` — Service worker for background notifications
- `apps/next/src/lib/fcm.ts` — Client library (permission request, token retrieval, foreground listener)
- `apps/next/src/components/NotificationBell.tsx` — UI component with bell icon, unread badge, dropdown

### Setup

1. Set env vars: `NEXT_PUBLIC_FIREBASE_API_KEY`, `NEXT_PUBLIC_FIREBASE_SENDER_ID`, `NEXT_PUBLIC_FIREBASE_APP_ID`, `NEXT_PUBLIC_FIREBASE_VAPID_KEY`
2. Add `<NotificationBell />` to the navbar
3. Backend needs `POST /api/notifications/subscribe` to store device tokens and `GET /api/notifications` to list notifications

### Flow

1. User clicks "Enable Push" in the notification dropdown
2. Browser requests notification permission
3. FCM generates a device token → `subscribeDevice()` sends it to the backend
4. Backend sends FCM messages when events occur (new shares, agent events, team updates)
5. Service worker shows native notification when app is backgrounded
6. Foreground listener adds notification to the dropdown in real-time
