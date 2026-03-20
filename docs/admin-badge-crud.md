# Admin Badge Definitions CRUD

## API Endpoints

| Method | Path | Description |
|--------|------|-------------|
| GET | `/api/admin/badges` | List all badge definitions |
| POST | `/api/admin/badges` | Create badge definition |
| PUT | `/api/admin/badges/:id` | Update badge definition |
| DELETE | `/api/admin/badges/:id` | Delete badge definition |

## BadgeDefinition Model

| Field | Type | Description |
|-------|------|-------------|
| slug | string | Unique identifier |
| name | string | Display name |
| description | string | Badge description |
| icon | string | Boxicons class |
| color | string | Hex color |
| category | string | achievement/streak/points/special |
| points_required | int | 0 = manual award only |
| auto_award | bool | Auto-award when points threshold reached |
| sort_order | int | Display order |

## Flutter Admin UI

Badge management at Admin > Badges:
- List with icon, name, description, category badge
- Create dialog with name, description, category dropdown, icon, color
- Edit dialog (same fields)
- Delete confirmation dialog
- Search filter

## Files

- `apps/web/internal/models/badge.go` — BadgeDefinition + UserBadge models
- `apps/web/internal/handlers/admin_badges.go` — CRUD handlers
- `apps/flutter/lib/screens/web/admin/badges_admin_page.dart` — Flutter UI
