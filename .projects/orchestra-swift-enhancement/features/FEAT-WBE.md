---
id: FEAT-WBE
kind: feature
priority: P0
project_slug: orchestra-swift-enhancement
status: done
title: Fix iOS login 401 — align Swift auth with Go backend response format
type: feature
---

# Fix iOS login 401 — align Swift auth with Go backend response format

The iOS app gets 401/logout on login because:
1. `/api/auth/me` returns raw user JSON but Swift expects `{"data": {...}}` wrapper — causes immediate logout after login
2. Swift `AuthUser` model missing fields from Go backend User model (status, settings, password_set, etc.)
3. `fetchMe()` catch-all calls `logout()` on any error including decode errors, making it appear as auth failure


---
**in-progress -> in-testing** (2026-03-15T22:12:47Z):
## Changes
- apps/swift/OrchestraKit/Sources/OrchestraKit/Auth/AuthStore.swift (fixed fetchMe() to decode raw AuthUser instead of ApiSingleResponse wrapper; only logout on 401 not decode errors; fixed verifyOtp field names: otp→code, purpose→type with mapping; fixed resetPassword signature to use email+code instead of token; removed avatar field from AuthUser; added status and passwordSet fields; fixed AvatarResponse to match backend; fixed updateProfile to decode raw AuthUser)
- apps/swift/OrchestraKit/Sources/OrchestraKit/Network/APIClient.swift (added Accept: application/json header to all requests)
- apps/swift/Shared/Sources/Shared/Plugins/AuthPlugin/ForgotPasswordView.swift (updated resetPassword call to pass email and otp code instead of resetToken)


---
**in-testing -> in-review** (2026-03-15T22:13:27Z): Gate skipped for kind=bug


---
**Review (approved)** (2026-03-15T22:18:28Z): User approved the auth fix. All auth files compile cleanly. Pre-existing build errors in ContentView.swift are unrelated.
