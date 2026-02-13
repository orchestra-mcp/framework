# OSV-32: Notification IPC Handlers & Channel Routing

**Type**: Story | **Status**: done | **Points**: 5

As a developer, I want IPC handlers and multi-channel routing so that notifications can be sent from any process and delivered to the correct output channel.

## Acceptance Criteria

- [ ] IPC handlers: notification:send, notification:dismiss, notification:getHistory, notification:clearHistory
- [ ] Desktop channel: Electron Notification API with action buttons
- [ ] Browser channel: WebSocket push to Chrome extension
- [ ] Mobile channel: FCM stub (interface defined, not implemented)
- [ ] Action button callbacks routed back to sender via IPC
- [ ] setupNotificationHandlers/cleanupNotificationHandlers exported

## Tasks

| ID | Title | Status | Type |
|----|-------|--------|------|
| OSV-96 | Implement desktop and browser notification channels | backlog | task |
| OSV-97 | Implement notification IPC handlers | backlog | task |
| OSV-98 | Write tests for notification channels and IPC handlers | backlog | task |
