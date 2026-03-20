# Badge Auto-Award System

## How It Works

When a user's points change (via `POST /api/admin/users/:id/points`), the system automatically checks for eligible badges:

1. Query `badge_definitions` WHERE `auto_award=true` AND `points_required <= new_points`
2. For each qualifying badge NOT already in `user_badges`, award it
3. Create a `badge_earned` notification for each new badge
4. Push real-time WebSocket notification to the user
5. Return `badges_awarded` array in the API response

## Trigger Points

- `AddPoints` handler in `admin_user_gamification.go` — called after every points change

## Notification

Each auto-awarded badge creates:
- **DB notification**: type=`badge_earned`, title=`Badge Earned: {name}`, message=`{description}`
- **WebSocket push**: `BroadcastToUser` with `hub.Event` type=`notification`, ntype=`badge_earned`

The WebSocket push delivers instant in-app notification without page refresh.

## Files

- `apps/web/internal/handlers/badge_autoaward.go` — `CheckAndAwardBadges()` with hub broadcast
- `apps/web/internal/handlers/admin_user_gamification.go` — `AddPoints` calls auto-award with hub
