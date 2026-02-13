# OMB-48: Notification Center Screen

**Type**: Story | **Status**: backlog | **Points**: 5

As an employee, I want an in-app notification center showing all my notifications with read/unread status and the ability to tap to navigate to the relevant content, so that I have a complete history of alerts.

## Acceptance Criteria

- [ ] Notification center screen accessible from More tab
- [ ] FlatList of notifications sorted by newest first
- [ ] Each notification shows: type icon, title, body, relative time, read/unread indicator
- [ ] Unread notifications have blue dot indicator
- [ ] Tapping a notification marks it as read and navigates to relevant screen
- [ ] Mark all as read button in header
- [ ] Pull-to-refresh fetches latest notifications from API
- [ ] Badge count on More tab reflects unread count
- [ ] API endpoints: GET /api/notifications, PATCH /api/notifications/:id/read, POST /api/notifications/read-all
