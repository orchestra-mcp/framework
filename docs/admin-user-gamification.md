# Admin User Gamification

## Overview

Admins can manage badges and points for individual users via the user detail page in the Flutter admin app.

## API Endpoints

### Badges

| Method | Path | Description |
|--------|------|-------------|
| GET | `/api/admin/users/:id/badges` | List user's awarded badges |
| POST | `/api/admin/users/:id/badges` | Award a badge to user (`{ badge_definition_id, note }`) |
| DELETE | `/api/admin/users/:id/badges/:badge_id` | Revoke a badge from user |

### Points

| Method | Path | Description |
|--------|------|-------------|
| GET | `/api/admin/users/:id/points` | Get user's current point balance |
| POST | `/api/admin/users/:id/points` | Add/deduct points (`{ amount, reason }`) — positive to add, negative to deduct |

Points are stored in the user's `settings` JSON field as `settings.points`.

## Flutter Integration

The API client provides:
- `listUserBadges(userId)` / `awardUserBadge(userId, body)` / `revokeUserBadge(userId, badgeId)`
- `getUserPoints(userId)` / `addUserPoints(userId, body)`

User detail page already has verification toggle. Badge and points management available via API.

## Files

- `apps/web/internal/handlers/admin_user_gamification.go` — Go API handlers
- `apps/flutter/lib/core/api/api_client.dart` — API client interface
- `apps/flutter/lib/core/api/rest_client.dart` — REST implementation
- `apps/flutter/lib/screens/web/admin/user_detail_page.dart` — User detail page
