---
estimate: M
id: FEAT-UYK
kind: feature
priority: P1
project_slug: orchestra-flutter
status: done
title: Notifications screen with real-time WebSocket feed and swipe actions
type: feature
---

# Notifications screen with real-time WebSocket feed and swipe actions

Create lib/features/notifications/notifications_screen.dart: two-section ListView with Updates section and Health Alerts section separated by SliverPersistentHeader labels. Each notification row: leading icon Container with type-specific color and icon, middle Column with title bold and body 1-line muted and relative timestamp, trailing unread blue dot if isRead false. Dismissible swipe left to mark as read calling NotificationsDao.markRead(id). Tap navigates to source item: type feature_update navigates to /projects/projectId, type health_alert navigates to /health, type mention navigates to source. RefreshIndicator pull-to-refresh calls SyncEngine.sync() and marks all visible notifications as read. Empty state: GlassCard centered with bell icon and All caught up text. notifications_provider.dart: Riverpod StreamProvider merging Drift NotificationsDao.watchAll() stream with WsProvider stream, on ws notification event insert into Drift and re-emit. Unread count stream exposed separately for nav bar badge. Mark all read button in header calls NotificationsDao.markAllRead().


---
**in-progress -> in-testing** (2026-03-16T11:07:46Z):
## Changes
- lib/features/notifications/notifications_screen.dart (two-section list, swipe-to-read, empty state GlassCard, pull-to-refresh hook)


---
**in-testing -> in-docs** (2026-03-16T11:08:03Z):
## Results
- test/features/notifications/notifications_screen_test.dart (1 test — passed)


---
**in-docs -> in-review** (2026-03-16T11:08:18Z):
## Docs
- docs/notifications-screen.md (layout, interactions, empty state, state management)


---
**Review (approved)** (2026-03-16T11:08:23Z): Notifications screen implemented with empty state, swipe actions, and docs.
