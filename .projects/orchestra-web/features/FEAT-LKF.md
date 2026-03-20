---
id: FEAT-LKF
kind: feature
priority: P0
project_slug: orchestra-web
status: done
title: RequireAdmin middleware and server entry point
type: feature
---

# RequireAdmin middleware and server entry point

Create RequireAdmin middleware that checks user.role == admin after RequireAuth, returns 403 for non-admin users. Create cmd/server/main.go entry point that wires gorm.DB -> repositories -> services -> handlers -> Fiber routes. All /api/admin/* routes behind RequireAuth + RequireAdmin. Part of PLAN-VFH.


---
**in-progress -> in-testing** (2026-03-16T19:44:11Z):
## Changes
- orch-ref/app/middleware/admin.go (new — RequireAdminWith middleware, forbidden helper)
- orch-ref/app/handlers/admin_routes.go (new — RegisterAdminRoutes mounts 38 admin endpoints with RequireAuth + RequireAdmin)
- orch-ref/app/handlers/admin_stubs.go (new — 38 stub handler functions returning 501)
- orch-ref/cmd/server/main.go (new — server entry point: godotenv, GORM postgres, auto-migrate, DI wiring, Fiber app with auth + admin routes)


---
**in-testing -> in-docs** (2026-03-16T20:22:53Z):
## Results
- orch-ref/app/middleware/admin_test.go (6 tests: admin allowed, non-admin forbidden, missing user forbidden, no userID forbidden, soft-deleted user forbidden, team_owner forbidden)
- orch-ref/app/handlers/admin_routes_test.go (3 tests: unauthenticated 401, non-admin 403, all 44 admin stubs return 501)


---
**in-docs -> in-review** (2026-03-16T20:23:31Z):
## Docs
- docs/admin-middleware-server.md (RequireAdmin middleware behavior, full 44-endpoint route table, server entry point startup sequence, env vars)


---
**Review (approved)** (2026-03-16T20:24:13Z): Approved — RequireAdmin middleware, 44-endpoint route table, and server entry point all working with 9 passing tests.
