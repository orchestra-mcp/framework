# OMB-47: FCM Push Notification Setup (iOS + Android)

**Type**: Story | **Status**: backlog | **Points**: 8

As an employee, I want to receive push notifications on my phone for agent permissions, agent questions, task assignments, and meeting reminders, so that I can respond promptly even when the app is in the background.

## Acceptance Criteria

- [ ] FCM push notification permission requested on first login
- [ ] FCM device token sent to server via POST /api/devices/register
- [ ] Token refreshed and re-registered when FCM rotates it
- [ ] Push notifications received in foreground (shown as in-app banner)
- [ ] Push notifications received in background (system notification)
- [ ] Push notifications received when app is killed (system notification)
- [ ] Notification types handled: agent_permission, agent_question, task_assigned, meeting_reminder, mention, marketing
- [ ] Tapping notification navigates to relevant screen based on notification type and data
