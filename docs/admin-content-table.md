# Admin Content Management Table

## Overview

A full-featured admin content management table for managing all shared content (docs, API collections, presentations, prompts, skills, agents, workflows, notes) with search, filtering, sorting, bulk actions, and pagination.

## Go API Endpoints

All endpoints require admin access (`isAdmin(c)`).

### GET /api/admin/content

List all shared content with filtering and pagination.

| Param | Type | Default | Description |
|-------|------|---------|-------------|
| page | int | 1 | Page number |
| per_page | int | 20 | Items per page (max 100) |
| search | string | — | ILIKE search on title and description |
| entity_type | string | — | Filter by entity type |
| visibility | string | — | Filter by visibility (public/unlisted/private) |
| sort_by | string | created_at | Sort column (allowlist: created_at, updated_at, title, views_count, likes_count, entity_type, visibility) |
| sort_dir | string | desc | Sort direction (asc/desc) |

Response: `{ items: ContentRow[], total: number, page: number, per_page: number }`

### PATCH /api/admin/content/:id/visibility

Update content visibility. Body: `{ "visibility": "public" | "unlisted" | "private" }`

### DELETE /api/admin/content/:id

Soft-delete a content item.

### POST /api/admin/content/bulk

Bulk actions on multiple items. Body: `{ "ids": [1,2,3], "action": "publish" | "unpublish" | "delete" }`

Response: `{ affected: number, action: string }`

## Frontend Component

`AdminContentTable` at `apps/next/src/components/dashboard/admin-content-table.tsx`

### Props

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| apiBase | string | `/api/admin/content` | API base URL |

### Features

- **Search**: Debounced (300ms) search input filtering by title/description
- **Entity type filter**: Dropdown for all 8 entity types
- **Visibility filter**: Dropdown for public/unlisted/private
- **Sortable columns**: Title, Type, Visibility, Views, Created (click header to toggle)
- **Row selection**: Checkbox per row + select-all header checkbox
- **Bulk actions**: Publish All, Unpublish All, Delete Selected (shown when items selected)
- **Row actions**: View (opens in new tab), Toggle visibility, Delete (with confirm)
- **Pagination**: Previous/Next buttons with "Page X of Y (N items)" info
- **Loading state**: Shows "Loading..." while fetching
- **Empty state**: Shows "No content found." when no results

### Entity Type Badges

| Type | Color | Label |
|------|-------|-------|
| note | #22c55e | Note |
| skill | #3b82f6 | Skill |
| agent | #a855f7 | Agent |
| workflow | #f59e0b | Workflow |
| prompt | #ec4899 | Prompt |
| api_collection | #7c4dff | API Collection |
| presentation | #ff6d00 | Presentation |
| doc | #00c853 | Doc |

## Files

- `apps/web/internal/handlers/admin_content.go` — Go handler (4 endpoints)
- `apps/web/internal/routes/routes.go` — Route registration (lines 675-678)
- `apps/next/src/components/dashboard/admin-content-table.tsx` — React component
- `apps/next/src/app/[locale]/(marketing)/member/[handle]/settings/admin-content/page.tsx` — Settings page
- `apps/next/src/components/dashboard/admin-content-table.test.tsx` — 12 tests
