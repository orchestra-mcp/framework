# Flutter OAuth Social Login

## Overview

The Flutter login screen displays OAuth provider buttons for social sign-in. Tapping a button opens the backend's OAuth redirect URL in an external browser.

## Supported Providers

| Provider | Icon | ID |
|----------|------|----|
| Google | `g_mobiledata_rounded` | `google` |
| GitHub | `code_rounded` | `github` |
| Apple | `apple_rounded` | `apple` |
| Discord | `discord_rounded` | `discord` |
| Slack | `tag_rounded` | `slack` |

## Flow

1. User taps a provider button on the login screen
2. App opens `{API_BASE_URL}/api/auth/oauth/{provider}?redirect=orchestra://auth/callback` via `url_launcher`
3. Backend stores `redirect` in OAuth CSRF state (only `orchestra://` scheme allowed)
4. Browser handles the OAuth consent flow with the provider
5. Provider redirects back to the backend callback
6. Backend verifies OAuth, creates/links user, generates JWT
7. Backend redirects to `orchestra://auth/callback?token={jwt}` (deep link)
8. OS opens Flutter app via registered URL scheme
9. `AuthCallbackScreen` extracts token, stores via `TokenStorage`, refreshes auth state
10. App navigates to `/summary`

## Platform Deep Link Configuration

- **iOS**: `CFBundleURLTypes` in `ios/Runner/Info.plist` registers `orchestra://` scheme
- **Android**: `intent-filter` in `AndroidManifest.xml` with `android:scheme="orchestra"`
- **macOS**: `CFBundleURLTypes` in `macos/Runner/Info.plist` registers `orchestra://` scheme

## Configuration

The API base URL is read from the `API_BASE_URL` compile-time environment variable (defaults to `http://localhost:8080`).

Providers must be enabled in the admin settings (`integrations` system setting) for the backend to accept OAuth requests.

## Security

- Backend only allows `orchestra://` scheme for the redirect parameter (rejects all others)
- OAuth CSRF state token validates provider + expiration (10-minute window)
