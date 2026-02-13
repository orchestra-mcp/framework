# OSV-31: INotificationService Interface & Core Implementation

**Type**: Story | **Status**: done | **Points**: 5

As a developer, I want a unified INotificationService so that extensions can send notifications across desktop, browser, and future mobile channels with sound control and history.

## Acceptance Criteria

- [ ] INotificationService interface in src/app/Notifications/INotificationService.ts
- [ ] NotificationService implements send/dismiss/getHistory/clearHistory/onNotification/registerChannel/setChannelEnabled
- [ ] send() returns notification ID string
- [ ] Notification history stored in memory with configurable max size
- [ ] Channel-based routing: desktop sends via Electron, browser via WebSocket
- [ ] Sound playback for default/success/warning/error/none
- [ ] Unit tests for all methods

## Tasks

| ID | Title | Status | Type |
|----|-------|--------|------|
| OSV-93 | Define INotificationService interface and NotificationPayload types | backlog | task |
| OSV-94 | Implement NotificationService with history and sound playback | backlog | task |
| OSV-95 | Write unit tests for NotificationService | backlog | task |
