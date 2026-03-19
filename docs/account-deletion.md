# Account Deletion (7-Day Grace Period)

## Endpoint

`DELETE /api/auth/account` (authenticated)

### Request Body
```json
{"password": "current_password"}
```

### Response
```json
{
  "ok": true,
  "message": "Account scheduled for deletion. Log in within 7 days to cancel.",
  "deletion_scheduled_at": "2026-03-26T21:00:00Z"
}
```

## How It Works

1. User confirms with password → status set to `pending_deletion`, `deletion_scheduled_at` set to now + 7 days
2. If user logs in during grace period → status restored to `active`, `deletion_scheduled_at` cleared
3. After 7 days, `CleanupDeletedAccounts()` permanently deletes the user and all related data

## Cascade Deletion

When the grace period expires, the following data is permanently deleted:
- Passkeys
- OAuth accounts
- Magic link tokens
- OTP codes
- Device tokens
- Tunnels
- User record (hard delete, bypasses GORM soft-delete)

## Background Cleanup

`CleanupDeletedAccounts(db)` should be called on server start and on a daily schedule. It queries users where `status = 'pending_deletion' AND deletion_scheduled_at < now()` and performs cascade deletion.

## Model Change

`User.DeletionScheduledAt *time.Time` added — stores the scheduled permanent deletion timestamp.

## UI

### Flutter (`profile_settings_tab.dart`)
- Red "Delete Account" button at bottom of profile settings under "Danger Zone" heading
- Tapping opens AlertDialog with password field and 7-day grace period info
- On success: logout + navigate to `/login`

### Web (`settings/page.tsx`)
- "Delete Account" section at bottom of profile settings page
- Click button → expands inline password confirmation form with 7-day warning
- `handleDeleteAccount` calls `DELETE /api/auth/account` with password
- On success: clears token + cookie, redirects to `/login?message=account_deletion_scheduled`
- Cancel button resets the form state
