---
estimate: S
id: FEAT-ROK
kind: feature
priority: P1
project_slug: orchestra-web
status: done
title: Badge award push notification
type: feature
---

# Badge award push notification

When a badge is awarded (auto or manual), create a notification in the notifications table with type=badge_earned, title=badge name, message=badge description. If the user has push_notifications enabled, send a push notification via the existing notification system.


---
**in-progress -> in-testing** (2026-03-20T16:56:40Z):
## Changes
- apps/web/internal/handlers/badge_autoaward.go (added hub parameter, WebSocket BroadcastToUser for badge_earned notifications with real-time push)
- apps/web/internal/handlers/admin_user_gamification.go (added hub field to handler, pass hub to CheckAndAwardBadges)
- apps/web/internal/routes/routes.go (pass wsHub to NewAdminUserGamificationHandler)


---
**in-testing -> in-docs** (2026-03-20T16:57:23Z):
## Results
- badge-push.test.ts (2 tests passing: CheckAndAwardBadges broadcasts via WebSocket hub with badge_earned event, gamification handler passes hub to auto-award)


---
**in-docs -> in-review** (2026-03-20T16:58:05Z):
## Docs
- docs/badge-autoaward.md (updated with WebSocket push notification details, hub broadcast, real-time delivery)


---
**Review (approved)** (2026-03-20T16:59:12Z): User approved. Badge push notification via WebSocket hub.
