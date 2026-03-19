# Flutter Magic Link & Password Reset

## Magic Link Login Flow

1. User enters email on `/magic-login` screen
2. App calls `POST /api/auth/magic-link/send` with `{email}`
3. Backend sends email with link containing a token
4. User clicks link → app opens `/auth/magic?token=xxx`
5. `MagicCallbackScreen` extracts token from query params
6. Calls `POST /api/auth/magic-link/verify` with `{token}`
7. On success: stores JWT via `TokenStorage`, refreshes auth state, navigates to `/summary`
8. On failure: shows error with "Back to Sign In" button

## Password Reset Flow

1. User enters email on `/forgot-password` screen
2. App calls `POST /api/auth/forgot-password` with `{email}`
3. Backend sends email with reset link containing a token
4. User clicks link → app opens `/reset-password?token=xxx`
5. `ResetPasswordScreen` shows new password + confirm fields
6. On submit: calls `POST /api/auth/reset-password` with `{token, password}`
7. On success: shows success view with "Sign In" button

## Deep Link Handling

Both flows rely on deep links passing a `token` query parameter. The GoRouter routes extract the token via `state.uri.queryParameters['token']` and pass it to the screen widget.
