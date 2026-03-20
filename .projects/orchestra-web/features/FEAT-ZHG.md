---
id: FEAT-ZHG
kind: feature
priority: P1
project_slug: orchestra-web
status: backlog
title: User Settings Pages (Profile, Password, 2FA, Sessions, API Tokens, Notifications)
type: feature
---

# User Settings Pages (Profile, Password, 2FA, Sessions, API Tokens, Notifications)

All user settings pages under `/settings/*` — profile, security, connected accounts, notifications, and appearance.

**Settings layout** (`resources/js/pages/settings/`):
- Shared settings layout: left nav (SettingsNav from @orchestra-mcp/settings), right content area
- Nav items: Profile, Password, Two-Factor Auth, Active Sessions, API Tokens, Connected Accounts, Notifications, Appearance

**Profile** (`settings/profile.tsx`):
- Avatar upload (drag-and-drop → `POST /settings/avatar`)
- Name, email inputs with inline validation
- Job title, phone, gender fields
- Save → `PATCH /settings/profile`
- Email change requires OTP verification

**Password** (`settings/password.tsx`):
- Current password, new password, confirm password
- Password strength indicator
- `PUT /settings/password`
- If social user with `password_set=false`: "Set Password" flow instead

**Two-Factor Auth** (`settings/two-factor.tsx`):
- Enable: show QR code (TOTP), confirm with 6-digit code → `POST /user/two-factor-authentication`
- Disable: confirm password → `DELETE /user/two-factor-authentication`
- Recovery codes: show list, regenerate → `POST /user/two-factor-recovery-codes`
- Status badge: Enabled/Disabled

**Active Sessions** (`settings/sessions.tsx`):
- Table: device name, platform, IP, last active, current badge
- `DELETE /settings/sessions/{token}` — revoke individual session
- "Logout All Other Devices" — revoke all except current

**API Tokens** (`settings/api-tokens.tsx`):
- List Sanctum tokens: name, abilities, last_used_at, created_at
- Create: name input, ability checkboxes → `POST /settings/api-tokens`
- Copy token (shown only once on creation)
- Revoke: `DELETE /settings/api-tokens/{token}`

**Connected Accounts** (`settings/connected-accounts.tsx`):
- List connected OAuth providers (GitHub, Google, Discord) with avatars
- Connect: redirect to OAuth → `GET /auth/{provider}`
- Disconnect: `DELETE /settings/connected-accounts/{provider}`

**Notifications** (`settings/notifications.tsx`):
- Toggles per notification type: email, push (FCM)
- Types: sync_conflict, team_invitation, subscription_expiry, security_alert
- Save → `PUT /settings/notifications`

**Appearance** (`settings/appearance.tsx`):
- Theme picker (ThemePicker from @orchestra-mcp/theme)
- Color scheme: light/dark/system
- Sidebar density: compact/comfortable
- Saves to user.settings JSON column

Acceptance: all 8 settings pages render, profile saves, avatar uploads, 2FA enable/disable with QR code works, API token creation shows token once, sessions table lists devices