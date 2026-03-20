# Admin Verification Type CRUD

## API Endpoints

| Method | Path | Description |
|--------|------|-------------|
| GET | `/api/admin/verifications` | List all verification types |
| POST | `/api/admin/verifications` | Create verification type |
| PUT | `/api/admin/verifications/:id` | Update verification type |
| DELETE | `/api/admin/verifications/:id` | Delete verification type |

## VerificationType Model

| Field | Type | Description |
|-------|------|-------------|
| slug | string | Unique identifier (verified, contributor, sponsor, enterprise) |
| name | string | Display name |
| color | string | Hex color for badge |
| badge_text | string | Tooltip text |
| icon | string | Boxicons class |
| sort_order | int | Display order |

## Flutter Admin UI

Verification management at Admin > Verifications:
- List users with current verification tier
- Change tier dialog (none, verified, contributor, sponsor, enterprise)
- Saves via PATCH /api/admin/users/:id with is_verified + verification_tier

## Files

- `apps/web/internal/models/verification.go` — VerificationType + UserVerification models
- `apps/web/internal/handlers/admin_verifications.go` — CRUD handlers
- `apps/flutter/lib/screens/web/admin/verifications_admin_page.dart` — Flutter UI
