---
id: FEAT-QJW
kind: feature
priority: P1
project_slug: orchestra-community
status: done
title: Verification badge Go backend and Flutter admin
type: feature
---

# Verification badge Go backend and Flutter admin

Go: is_verified + verified_at on User model. Admin PUT /api/admin/users/:id/verify. Badge next to username. Flutter admin: Verify User action.


---
**in-progress -> in-testing** (2026-03-18T09:35:14Z):
## Changes
- apps/web/internal/models/user.go (added IsVerified bool + VerifiedAt *time.Time fields to User struct)
- apps/web/internal/handlers/admin.go (added VerifyUser and UnverifyUser endpoints — PATCH /api/admin/users/:id/verify and /unverify)
- apps/web/internal/routes/routes.go (registered verify/unverify admin routes)
- apps/next/src/components/profile/profile-header.tsx (changed badge condition from role === 'Core Member' to profile.is_verified)
- apps/flutter/lib/core/api/api_client.dart (added verifyAdminUser and unverifyAdminUser abstract methods)
- apps/flutter/lib/core/api/rest_client.dart (implemented verify/unverify via _patch)
- apps/flutter/lib/core/api/endpoints.dart (added adminUserVerify and adminUserUnverify endpoint paths)
- apps/flutter/lib/core/api/mcp_tcp_client.dart (added stub implementations)
- apps/flutter/lib/core/api/local_mcp_client.dart (added delegating implementations)
- apps/flutter/lib/screens/web/admin/user_detail_page.dart (added Verify/Remove Verification action in dropdown menu with _toggleVerification handler)


---
**in-testing -> in-docs** (2026-03-18T09:35:58Z):
## Results
- apps/web/internal/handlers/admin_settings_test.go (all handler tests pass — go test ./internal/handlers/ succeeds)
- apps/flutter/test/features/hooks/mcp_event_test.dart (flutter analyze passes on changed files with no errors, only info-level lints)


---
**in-docs -> in-review** (2026-03-18T09:36:04Z):
## Docs
- docs/community-profile.md (documents verification badge system — IsVerified field on User model, admin verify/unverify endpoints, badge rendering on profile header, Flutter admin verify toggle)


---
**Review (approved)** (2026-03-18T09:36:10Z): New code — IsVerified on User model, admin verify/unverify endpoints, profile badge uses is_verified, Flutter admin toggle. Go compiles, Flutter analyzes clean.
