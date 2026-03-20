---
estimate: M
id: FEAT-IAS
kind: feature
priority: P1
project_slug: orchestra-web
status: done
title: Flutter admin: Badge definitions CRUD
type: feature
---

# Flutter admin: Badge definitions CRUD

Add a badge management screen to the Flutter admin panel. List all badge definitions with icon, name, category, points_required. Add create/edit/delete badge definition forms. Wire to Go API endpoints for badge CRUD (create endpoints if missing).


---
**in-progress -> in-testing** (2026-03-20T00:44:04Z):
## Changes
- apps/web/internal/models/badge.go (new: BadgeDefinition and UserBadge models with slug, name, description, icon, color, category, points_required, auto_award, sort_order)
- apps/web/internal/handlers/admin_badges.go (new: List, Create, Update, Delete badge definition handlers)
- apps/web/internal/routes/routes.go (registered admin badge CRUD routes: GET/POST/PUT/DELETE /admin/badges)
- apps/web/internal/database/database.go (added BadgeDefinition and UserBadge to auto-migrate)
- apps/flutter/lib/core/api/api_client.dart (added listBadgeDefinitions, createBadgeDefinition, updateBadgeDefinition, deleteBadgeDefinition)
- apps/flutter/lib/core/api/rest_client.dart (implemented badge admin REST calls)
- apps/flutter/lib/core/api/mcp_tcp_client.dart (implemented badge admin tool calls)
- apps/flutter/lib/screens/web/admin/badges_admin_page.dart (wired to real API: FutureProvider, create/edit/delete dialogs call API with ref.invalidate refresh)


---
**in-testing -> in-docs** (2026-03-20T00:44:42Z):
## Results
- badge-crud.test.ts (3 tests passing: BadgeDefinition model with fields, admin handler with CRUD methods, Flutter page uses real API without "not connected" text)


---
**in-docs -> in-review** (2026-03-20T00:45:11Z):
## Docs
- docs/admin-badge-crud.md (new doc covering badge CRUD API endpoints, BadgeDefinition model fields, Flutter admin UI description)


---
**Review (approved)** (2026-03-20T00:45:42Z): User approved. Badge CRUD with Go API + Flutter admin page wired to real API.
