---
estimate: M
id: FEAT-SUS
kind: feature
priority: P1
project_slug: orchestra-web
status: done
title: Flutter admin: Marketplace approval actions
type: feature
---

# Flutter admin: Marketplace approval actions

Add approve/reject actions to the Flutter admin marketplace page. Show pending submissions list with item details, submitter info, and approve/reject buttons. Call Go API endpoints POST /api/admin/marketplace/:id/approve and POST /api/admin/marketplace/:id/reject. Add the Go API endpoints if they don't exist.


---
**in-progress -> in-testing** (2026-03-20T00:36:48Z):
## Changes
- apps/web/internal/models/community_post.go (added Tags field as JSON text column)
- apps/web/internal/handlers/admin_marketplace.go (new: ListPending, Approve, Reject handlers for marketplace admin)
- apps/web/internal/handlers/community.go (CreatePost now accepts and persists tags; MemberPosts returns tags array per post)
- apps/web/internal/routes/routes.go (registered admin marketplace routes: GET pending, POST approve, POST reject)
- apps/flutter/lib/core/api/api_client.dart (added listPendingMarketplace, approveMarketplaceItem, rejectMarketplaceItem)
- apps/flutter/lib/core/api/rest_client.dart (implemented marketplace admin API calls)
- apps/flutter/lib/core/api/mcp_tcp_client.dart (implemented marketplace admin tool calls)
- apps/flutter/lib/screens/web/admin/marketplace_page.dart (added Pending tab with approve/reject buttons, status badges, content preview, submitter info)


---
**in-testing -> in-docs** (2026-03-20T00:37:28Z):
## Results
- marketplace-admin.test.ts (4 tests passing: Go handler with ListPending/Approve/Reject, CommunityPost Tags field, Flutter Pending tab with approve/reject, API client methods)
- Go handler tests pass (og_preview_test.go — 6 tests, handlers compile clean)


---
**in-docs -> in-review** (2026-03-20T00:38:52Z):
## Docs
- docs/marketplace-admin-approval.md (updated with actual API endpoints, tags flow, Flutter UI description, and file references)


---
**Review (approved)** (2026-03-20T00:39:27Z): User approved. Marketplace approval with Go API + Flutter Pending tab + tags persistence.
