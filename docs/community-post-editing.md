# Community Posts — Edit, Delete & Markdown Rendering

## Overview

Post owners can edit and delete their community posts from their profile page (`/@handle`). Post content renders as full markdown using `react-markdown` with themed components.

## API

### `PUT /api/community/posts/:id`

Updates a community post. Requires authentication. Only the post owner can edit.

**Request body:**
```json
{ "title": "Updated title", "content": "Updated content" }
```

**Responses:**
- `200` — returns `{ post: { id, author_id, author_name, ... } }`
- `401` — unauthorized (missing/expired token)
- `403` — forbidden (not the post owner)
- `404` — post not found

### `DELETE /api/community/posts/:id`

Soft-deletes a community post. Requires authentication. Only the post owner can delete.

**Responses:**
- `200` — returns `{ ok: true }`
- `401` — unauthorized
- `403` — forbidden (not the post owner)
- `404` — post not found

## Store

- `updatePost(id, { title, content })` — PUT endpoint, updates `posts[]` and `currentPost`
- `deletePost(id)` — DELETE endpoint, removes from `posts[]`, clears `currentPost` if matched

## Markdown Rendering

Post content renders via `MarkdownRenderer` from `@orchestra-mcp/editor`. This provides full-featured rendering including: headings, paragraphs, links, bold/italic/strikethrough, ordered and unordered lists, task lists with checkboxes, blockquotes, inline code, fenced code blocks with syntax highlighting (via `CodeBlock`), data tables (via `DataTable`), horizontal rules, and YAML frontmatter display.

## UI Behavior

### Edit
1. Owner clicks pencil icon (top-right of post card)
2. Card switches to inline edit mode: title input + MarkdownEditor + Cancel/Save
3. Save calls `updatePost` and syncs `allPosts` local state
4. Errors display inline below the editor

### Delete
1. Owner clicks trash icon (bottom action bar, next to Like/Comment)
2. `ConfirmDialog` modal opens (danger variant with red styling, loading spinner)
3. On confirm, calls `deletePost` and removes from `allPosts`
4. Cancel or Escape dismisses the dialog without action

## Post Type Selector

Posts support 4 types: `post`, `skill`, `agent`, `workflow`. Types are stored as tags (not a separate column).

### Composer UI
- Segmented control with 4 buttons: Post, Skill, Agent, Workflow
- Active button highlighted with cyan border and text
- Non-post types show marketplace toggle
- Type added as tag on submit (e.g., `tags: ['skill', 'marketplace']`)

### Display
- `POST_TYPE_STYLES` maps types to colors: skill=#22c55e, agent=#f59e0b, workflow=#8b5cf6
- `getPostTypeBadge()` renders colored pill badge on posts
- `getPostTypeBorderStyle()` adds left border color matching type
- Edit mode preserves post type via `getPostTypeFromTags()`

### Tests
- `__tests__/post-type-borders.test.ts` — 8 test cases covering type detection from tags, border styles, and style mapping

## Threaded Comments

Comments support 2-level threading via an optional `parent_id` field.

### Backend
- `POST /posts/:id/comments` accepts optional `parent_id` in body
- Validates: parent exists, belongs to same post, is top-level (prevents >2 nesting)
- `GET /posts/:id/comments` returns flat list with `parent_id` field
- Migration: `20260320004000_add_comment_parent_id.sql`

### Frontend
- `ThreadedComments` component at `apps/next/src/components/community/ThreadedComments.tsx`
- Builds tree from flat array using `useMemo` (Map grouping by parent_id)
- Renders with 24px indentation per level, left border on nested comments
- Reply button opens inline input, hidden at depth >= 2
- Enter-to-submit, loading state on send
