# Flutter 2FA Settings Integration

## Overview

The Flutter 2FA settings tab (`TwoFactorSettingsTab`) is fully wired to the backend TOTP endpoints. Users can enable, verify, and disable two-factor authentication from the settings screen.

## API Endpoints Used

| Action | Method | Endpoint | Body |
|--------|--------|----------|------|
| Start setup | POST | `/api/auth/2fa/setup` | (none, authenticated) |
| Confirm code | POST | `/api/auth/2fa/confirm` | `{"code": "123456"}` |
| Disable 2FA | POST | `/api/auth/2fa/disable` | `{"password": "..."}` |

## User Flow

### Enable 2FA
1. User taps "Enable" button
2. App calls `/api/auth/2fa/setup` which returns `{qr_url, secret}`
3. QR code is rendered using `qr_flutter` package (QrImageView with otpauth:// URI)
4. Secret is also displayed with a copy button for manual entry into authenticator apps
4. User enters 6-digit TOTP code from their authenticator app
5. App calls `/api/auth/2fa/confirm` with the code
6. On success, user state is refreshed to reflect `two_factor_enabled: true`

### Disable 2FA
1. User enters their password in the disable section
2. App calls `/api/auth/2fa/disable` with the password
3. On success, user state is refreshed to reflect `two_factor_enabled: false`

## Model Changes

- `User.twoFactorEnabled` field added (reads from `two_factor_enabled` in JSON)
- `AuthNotifier.fetchMe()` method added to refresh user state after 2FA changes

## Error Handling

- DioException errors are parsed for backend error messages
- Error and success banners are shown inline above the main content
- 6-digit input enforces digits-only with max length 6
