---
estimate: M
id: FEAT-VSA
kind: feature
priority: P1
project_slug: orchestra-web
status: done
title: Badge auto-award trigger on points change
type: feature
---

# Badge auto-award trigger on points change

In the Go backend, after any points change (AddPoints handler, or any future points mutation), query badge_definitions WHERE auto_award=true AND points_required <= new_points. For each qualifying badge not already in user_badges, award it and create a notification record. This runs as a helper function called after points updates.


---
**in-progress -> in-testing** (2026-03-20T16:50:33Z):
## Changes
- apps/web/internal/handlers/badge_autoaward.go (new: CheckAndAwardBadges function queries auto_award badges where points_required <= currentPoints, awards missing badges via UserBadge create, creates badge_earned notification for each new badge)
- apps/web/internal/handlers/admin_user_gamification.go (AddPoints handler now calls CheckAndAwardBadges after points update, returns badges_awarded array in response)


---
**in-testing -> in-docs** (2026-03-20T16:51:10Z):
## Results
- badge-autoaward.test.ts (3 tests passing: CheckAndAwardBadges function exists with auto_award/points_required/badge_earned, notification creation, AddPoints calls CheckAndAwardBadges with badges_awarded response)


---
**in-docs -> in-review** (2026-03-20T16:51:36Z):
## Docs
- docs/badge-autoaward.md (new doc covering auto-award flow, trigger points, notification creation)


---
**Review (approved)** (2026-03-20T16:52:18Z): User approved. Badge auto-award with notification on points change.
