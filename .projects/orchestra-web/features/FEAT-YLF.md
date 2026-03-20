---
id: FEAT-YLF
kind: feature
priority: P2
project_slug: orchestra-web
status: backlog
title: FCM Push Notifications + Real-Time Sync via WebSocket
type: feature
---

# FCM Push Notifications + Real-Time Sync via WebSocket

Firebase Cloud Messaging for cross-device push notifications and real-time sync status updates via Laravel Echo + Redis pub/sub.

**FCM Integration**:
- `POST /api/fcm/token` — register device FCM token (stores in device_tokens.fcm_token)
- `DELETE /api/fcm/token` — unregister token on logout
- `FcmService` (`app/Services/FcmService.php`):
  - `sendToUser(User, string title, string body, array data)` — sends to all user devices
  - `sendToDevices(array fcm_tokens, Notification)` — batch send via Firebase HTTP v1 API
  - `sendToTopic(string topic, Notification)` — broadcast to platform topic
- Admin push notifications: `POST /admin/notifications` → calls FcmService::sendToAll or sendToUser

**When to send FCM**:
- AI session new message from desktop → web gets push notification with session_id
- Team invitation received
- Sync conflict detected
- Subscription expiry warning (7 days before)

**Web Push setup** (`resources/js/`):
- Register service worker for web push (PWA-ready)
- Request notification permission on dashboard load
- `FcmController::register` stores web push subscription alongside mobile FCM tokens

**Laravel Echo + Redis** (real-time sync status):
- `POST /api/sync/push` broadcasts `SyncPushed` event to private channel `sync.{user_id}`
- Frontend subscribes via Laravel Echo: `Echo.private('sync.{userId}').listen('SyncPushed', handler)`
- Handler updates sync status badge on Projects page in real time
- Notification unread count updates via `NotificationCreated` event on `notifications.{user_id}` channel

**AI Chat live sync**:
- Desktop Claude Code session streams to `ai_sessions.{session_id}` channel
- Web chat/show.tsx subscribes and appends messages in real time
- Shows "Live" indicator when desktop session is active
- Handles `MessageChunk` events for streaming text

**WebSocket server**: Laravel Reverb (or Pusher-compatible) on port 8080, connects via Redis pub/sub

Acceptance: FCM token registers on login, push notification arrives on web when desktop sends AI message, sync status updates in real time on project cards, notification unread count updates without page refresh