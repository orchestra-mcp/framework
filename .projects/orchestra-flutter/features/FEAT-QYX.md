---
id: FEAT-QYX
kind: feature
priority: P0
project_slug: orchestra-flutter
status: todo
title: Auth Feature Providers — Token Management & Session Persistence
type: feature
---

# Auth Feature Providers — Token Management & Session Persistence

The 7 auth screens exist (login, register, forgot password, reset password, magic login, passkey, 2FA) but `lib/features/auth/` is empty. Need to implement:
- AuthProvider (Riverpod) for auth state management
- Token service (access/refresh token storage via flutter_secure_storage)
- Session persistence (auto-login on app restart)
- Auth interceptor for Dio HTTP client (attach Bearer token, handle 401 refresh)
- Logout flow (clear tokens, navigate to login)
- Wire auth state into GoRouter redirect guards
