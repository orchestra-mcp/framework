# Flutter User Detail — Badges & Points

## Badges Tab

- Lists all awarded badges with icon, name, category, award date
- **Award Badge** button opens dialog listing all badge definitions — tap to award
- **Revoke** button per badge removes the award
- Uses `listUserBadges`, `awardUserBadge`, `revokeUserBadge` API methods

## Points Tab

- Shows current points balance with star icon
- **Add or Deduct** form with amount (positive/negative) and reason
- After submit, shows auto-awarded badges in snackbar if any triggered
- Uses `getUserPoints`, `addUserPoints` API methods

## Files

- `apps/flutter/lib/screens/web/admin/user_detail_page.dart` — `_BadgesTab` and `_PointsTab` widgets
