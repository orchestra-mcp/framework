# Team Collaboration

## Overview

Team-scoped content sharing, inline comments on shared content, and a team activity feed widget for the dashboard.

## Go API Endpoints

All endpoints require authentication.

### GET /api/community/teams/:teamId/content

List team-scoped shared content. Requires team membership.

| Param | Type | Default | Description |
|-------|------|---------|-------------|
| entity_type | string | — | Filter by entity type |
| page | int | 1 | Page number |
| per_page | int | 20 | Items per page (max 100) |

Response: `{ items, total, page, per_page }`

### POST /api/community/teams/:teamId/content/:id/share

Share owned content with a team (sets `team_id` on SharedContent). Requires team membership and content ownership.

### DELETE /api/community/teams/:teamId/content/:id/share

Remove content from a team (clears `team_id`). Requires content ownership.

### GET /api/community/teams/:teamId/activity

Recent team content ordered by `updated_at`. Requires team membership.

| Param | Type | Default | Description |
|-------|------|---------|-------------|
| limit | int | 20 | Max items (1-50) |

Response: `{ activities: [{ id, title, entity_type, slug, author_name, author_avatar, user_id, updated_at }] }`

### GET /api/community/shares/:id/inline-comments

List all comments on a shared content item, enriched with author info. Ordered by `created_at asc`.

### POST /api/community/shares/:id/inline-comments

Add a comment. Body: `{ "body": "...", "kind": "comment" | "change_request" }`

## Frontend Components

### TeamSharingDialog

`apps/next/src/components/content/team-sharing-dialog.tsx`

Modal dialog for sharing content with a team. Props: `contentId`, `currentTeamId?`, `onClose`, `onShared`. Fetches teams, shows selection list, share/remove buttons.

### InlineComments

`apps/next/src/components/content/inline-comments.tsx`

Comment thread for content detail pages. Props: `contentId`. Shows comments with author avatars, supports `comment` and `change_request` kinds (orange accent for change requests). Includes new comment form.

### TeamActivityWidget

`apps/next/src/components/dashboard/widgets/TeamActivityWidget.tsx`

Dashboard widget showing recent team content changes. Props: `activities: TeamActivity[]`. Shows entity type colored dots, titles, authors, relative timestamps. Max 10 items.

Registered in widget system as `team_activity` type (LAYOUT_VERSION 5).

## Files

- `apps/web/internal/handlers/team_content.go` — 6 handler methods
- `apps/web/internal/routes/routes.go` — 6 routes added
- `apps/next/src/components/content/team-sharing-dialog.tsx`
- `apps/next/src/components/content/inline-comments.tsx`
- `apps/next/src/components/dashboard/widgets/TeamActivityWidget.tsx`
- `apps/next/src/components/dashboard/widgets/index.ts` — registry updated
- `apps/next/src/types/dashboard.ts` — WidgetType + registry + layout updated
- `apps/next/src/components/content/team-collaboration.test.tsx` — 11 tests
- `apps/next/src/components/dashboard/widgets/team-activity.test.tsx` — 6 tests
