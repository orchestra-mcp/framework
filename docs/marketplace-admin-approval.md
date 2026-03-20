# Marketplace Admin Approval

## Overview

Community posts tagged `marketplace` require admin approval before being listed publicly. The Flutter admin app has a "Pending" tab in the Marketplace page for reviewing submissions.

## API Endpoints

| Method | Path | Description |
|--------|------|-------------|
| GET | `/api/admin/marketplace/pending` | List all marketplace-tagged posts with approval status |
| POST | `/api/admin/marketplace/:id/approve` | Add `marketplace_approved` tag, set status to published |
| POST | `/api/admin/marketplace/:id/reject` | Add `marketplace_rejected` tag. Accepts `{ reason }` body |

## Tags Flow

1. User creates a skill/agent/workflow post with "Publish to Marketplace" toggle — adds `marketplace` tag
2. Admin reviews in Flutter app Pending tab
3. Approve — adds `marketplace_approved` tag, removes `marketplace_rejected` if present
4. Reject — adds `marketplace_rejected` tag, removes `marketplace_approved` if present

## Flutter UI

- **Pending tab** (first tab in Marketplace page)
- Each submission shows: title, submitter name, date, content preview, status badge (Pending/Approved/Rejected)
- Approve button (green) and Reject button (red outline) for pending items
- List auto-refreshes after action via `ref.invalidate`

## Files

- `apps/web/internal/handlers/admin_marketplace.go` — Go API handlers
- `apps/web/internal/models/community_post.go` — Tags field on CommunityPost
- `apps/flutter/lib/screens/web/admin/marketplace_page.dart` — Flutter Pending tab UI
- `apps/flutter/lib/core/api/api_client.dart` — API client interface
- `apps/flutter/lib/core/api/rest_client.dart` — REST implementation
