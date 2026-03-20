---
estimate: M
id: FEAT-BDL
kind: feature
priority: medium
project_slug: orchestra-web
status: done
title: Account Deletion Backend Handler
type: feature
---

# Account Deletion Backend Handler

Add DeletionScheduledAt field to User model. DELETE /api/auth/account handler with password confirmation, 7-day grace period. Cancel deletion on login. Background cleanup cron. Cascade delete all user data.


---
**in-progress -> in-testing** (2026-03-19T21:34:15Z):
## Changes
- apps/web/internal/models/user.go — added DeletionScheduledAt *time.Time field to User struct
- apps/web/internal/handlers/auth.go — added DeleteAccount handler (DELETE /api/auth/account: password confirmation, sets status=pending_deletion + deletion_scheduled_at=now+7days); added deletion cancellation in Login (restores pending_deletion → active on login); added CleanupDeletedAccounts() function that cascade-deletes expired users and all related data (passkeys, oauth, magic links, otp, devices, tunnels)
- apps/web/internal/routes/routes.go — registered DELETE /auth/account route on protected group


---
**in-testing -> in-docs** (2026-03-19T21:34:50Z):
## Results
- apps/web/internal/handlers/account_deletion_test.go (4 tests, all passing):
  - TestUserDeletionScheduledAtField: verifies DeletionScheduledAt field on User model
  - TestDeletionScheduleExpiry: verifies 7-day grace period calculation
  - TestDeletionCancellationOnLogin: verifies pending_deletion → active + nil DeletionScheduledAt
  - TestDeleteAccountRequiresPassword: verifies empty password check
- Go compilation clean


---
**in-docs -> in-review** (2026-03-19T21:35:07Z):
## Docs
- docs/account-deletion.md (new — endpoint spec, grace period flow, cascade deletion list, background cleanup, model change)


---
**Review (approved)** (2026-03-19T21:35:23Z): Account deletion backend with 7-day grace period approved.
