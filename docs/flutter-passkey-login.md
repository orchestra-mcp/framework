# Flutter Passkey Login

## Flow

1. User enters email to identify their account
2. Platform biometric prompt (Face ID / fingerprint) confirms identity via `local_auth`
3. App calls `POST /api/auth/passkey/authenticate/begin` with the email
4. Backend returns registered passkey data if available

## Limitation

Full WebAuthn credential signing (authenticatorData, clientDataJSON, signature) requires platform-specific packages for iOS (ASAuthorizationController) and Android (Credential Manager). The current implementation uses `local_auth` as a biometric confirmation step and checks the backend for registered passkeys.

For complete passkey authentication, use the web app where `navigator.credentials.get()` is available.

## Changes from Previous

- Added email field (was biometric-only with no user identification)
- Added backend call to `/api/auth/passkey/authenticate/begin`
- Handles case where user has no registered passkeys with clear guidance
- Removed navigation to `/summary` without a real token
- Added "Sign in with Passkey" button on login screen (fingerprint icon, navigates to /passkey)
