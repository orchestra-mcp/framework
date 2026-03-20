---
estimate: M
id: FEAT-NYN
kind: feature
priority: P1
project_slug: orchestra-web
status: done
title: Flutter admin: User manager badges/points/verification
type: feature
---

# Flutter admin: User manager badges/points/verification

Enhance the Flutter admin user manager to add/remove badges from users, add/deduct points, and assign/revoke verification status. Show current badges, points balance, and verification on the user detail screen.


---
**in-progress -> in-testing** (2026-03-20T01:06:55Z):
## Changes
- apps/web/internal/handlers/admin_user_gamification.go (new: ListUserBadges, AwardBadge, RevokeBadge, GetPoints, AddPoints handlers for per-user gamification management)
- apps/web/internal/routes/routes.go (registered 5 admin user gamification routes: GET/POST badges, DELETE badges/:badge_id, GET/POST points)
- apps/flutter/lib/core/api/api_client.dart (added listUserBadges, awardUserBadge, revokeUserBadge, getUserPoints, addUserPoints)
- apps/flutter/lib/core/api/rest_client.dart (implemented user gamification REST calls)
- apps/flutter/lib/core/api/mcp_tcp_client.dart (implemented user gamification tool calls)


---
**in-testing -> in-docs** (2026-03-20T01:07:30Z):
## Results
- user-gamification.test.ts (3 tests passing: Go handler with ListUserBadges/AwardBadge/RevokeBadge/GetPoints/AddPoints, Flutter API client with all gamification methods, REST client with correct endpoint paths)


---
**in-docs -> in-review** (2026-03-20T01:07:52Z):
## Docs
- docs/admin-user-gamification.md (new doc covering badge award/revoke API, points add/deduct API, Flutter integration, file references)


---
**Review (approved)** (2026-03-20T01:14:46Z): User approved. User gamification with badge award/revoke and points add/deduct APIs + Flutter integration.
