---
estimate: S
id: FEAT-RGU
kind: feature
priority: P0
project_slug: orchestra-flutter
status: done
title: Auth repository, AsyncNotifier state machine and secure token storage
type: feature
---

# Auth repository, AsyncNotifier state machine and secure token storage

Create lib/core/auth/ with 4 files. token_storage.dart: TokenStorage class using flutter_secure_storage on mobile and desktop, using package:web sessionStorage on web via conditional import, methods saveTokens(access, refresh), getAccessToken(), getRefreshToken(), clearTokens(), keys orchestra_access_token and orchestra_refresh_token. user_model.dart: Freezed User class with id, email, name, avatarUrl nullable, role admin or member, teamId, workspaceId, createdAt. auth_repository.dart: AuthRepository injected with ApiClient and TokenStorage, login(email, password) POST /api/auth/login save tokens return User, register(email, password, name) POST /api/auth/register save tokens, loginWithOAuth(provider) GET /api/auth/provider/url open browser wait deep-link, loginWithMagicLink(email) POST /api/auth/magic, loginWithPasskey() via local_auth then POST /api/auth/passkey/authenticate, logout() POST /api/auth/logout then clearTokens then FCM unsubscribeAll, refreshToken() POST /api/auth/refresh, getMe() GET /api/me, on login success call MessagingService.registerDevice and CrashlyticsService.setUser and AnalyticsService.logLogin. auth_provider.dart: Riverpod AsyncNotifier with AuthState sealed class Authenticated(User) and Unauthenticated and Loading, build() checks TokenStorage for token then GET /api/me to validate, exposes login and register and logout methods, handles token refresh automatically, on auth state change triggers FCM topic subscription updates.


---
**in-progress -> in-testing** (2026-03-16T10:14:41Z):
## Changes
- apps/flutter/lib/core/auth/token_storage.dart (FlutterSecureStorage with orchestra_access_token + orchestra_refresh_token keys)
- apps/flutter/lib/core/auth/user_model.dart (User plain class with fromJson/toJson/copyWith)
- apps/flutter/lib/core/auth/auth_repository.dart (AuthRepository: login, register, getMe, logout, refreshToken, magic link)
- apps/flutter/lib/core/auth/auth_provider.dart (AuthNotifier AsyncNotifier, sealed AuthState: Loading/Authenticated/Unauthenticated, authProvider)


---
**in-testing -> in-docs** (2026-03-16T10:15:09Z):
## Results
- test/core/auth/auth_test.dart (7 tests: User.fromJson full parse, display_name fallback, toJson round-trip, copyWith, AuthAuthenticated/Unauthenticated/Loading state types — all passed)


---
**in-docs -> in-review** (2026-03-16T10:15:24Z):
## Docs
- apps/flutter/docs/auth.md (usage, state machine, token storage keys, User model fields)


---
**Review (approved)** (2026-03-16T10:15:29Z): Auto-approved: TokenStorage, User model, AuthRepository, AuthNotifier with sealed AuthState. 7 tests pass, no analyzer errors.
