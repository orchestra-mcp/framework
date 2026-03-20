---
estimate: M
id: FEAT-ACQ
kind: feature
priority: P2
project_slug: orchestra-web
status: done
title: Flutter admin: Verification type CRUD
type: feature
---

# Flutter admin: Verification type CRUD

Add a verification management screen to the Flutter admin panel. List verification types (verified, contributor, sponsor, enterprise) with colors and badge text. Add create/edit/delete forms. Wire to Go API endpoints.


---
**in-progress -> in-testing** (2026-03-20T00:49:37Z):
## Changes
- apps/web/internal/models/verification.go (new: VerificationType and UserVerification models)
- apps/web/internal/handlers/admin_verifications.go (new: List, Create, Update, Delete verification type handlers)
- apps/web/internal/routes/routes.go (registered admin verification CRUD routes)
- apps/web/internal/database/database.go (added VerificationType and UserVerification to auto-migrate)
- apps/flutter/lib/core/api/api_client.dart (added listVerificationTypes, createVerificationType, updateVerificationType, deleteVerificationType)
- apps/flutter/lib/core/api/rest_client.dart (implemented verification admin REST calls)
- apps/flutter/lib/core/api/mcp_tcp_client.dart (implemented verification admin tool calls)
- apps/flutter/lib/screens/web/admin/verifications_admin_page.dart (wired tier assignment to updateAdminUser API, removed "API not connected" text)


---
**in-testing -> in-docs** (2026-03-20T00:50:18Z):
## Results
- verification-crud.test.ts (3 tests passing: VerificationType model with BadgeText, admin handler with List/Create, Flutter page wired to API without "not connected" text)


---
**in-docs -> in-review** (2026-03-20T00:50:46Z):
## Docs
- docs/admin-verification-crud.md (new doc covering verification CRUD API, model fields, Flutter admin UI)


---
**Review (approved)** (2026-03-20T00:52:05Z): User approved. Verification CRUD with Go API + Flutter admin wired to real API.
