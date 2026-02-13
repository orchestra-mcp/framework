# OSV-5: Dynamic Notification Service

**Type**: Epic | **Status**: done | **Priority**: high

Unify scattered notification code from extensions/notifications/src/index.ts + notificationService.ts + notificationIpcServer.ts into src/app/Notifications/. Provides INotificationService with send/dismiss/getHistory/registerChannel API. Supports desktop (Electron native), browser (WebSocket push), sound control, notification history, and channel-based routing.

## Stories

| ID | Title | Status | Priority |
|----|-------|--------|----------|
| OSV-31 | INotificationService Interface & Core Implementation | done | high |
| OSV-32 | Notification IPC Handlers & Channel Routing | done | high |
| OSV-33 | Notification Settings Integration & Documentation | done | medium |
