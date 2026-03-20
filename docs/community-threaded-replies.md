# Threaded Replies (Sub-Comments)

## Overview

Comments support one level of nesting. Users can reply to any comment, and replies appear indented below the parent comment.

## API

### GET /api/public/community/posts/:id/comments
Returns comments with nested `replies` array per comment:
```json
{ "comments": [{ "id": 1, "content": "...", "replies": [{ "id": 2, "content": "...", "parent_id": 1 }] }] }
```

### POST /api/community/posts/:id/comments
Accepts optional `parent_id` to reply to a comment:
```json
{ "content": "reply text", "parent_id": 123 }
```

## UI

- **Reply button** on each comment (authenticated users only)
- **Reply input** appears below the comment with Enter-to-submit
- **Replies** displayed with 42px left indent, smaller avatars (24px vs 32px)
- **1 level deep** — replies to replies are flat under the same parent

## Files
- `apps/web/internal/handlers/community.go` — PostComments with nested replies, AddComment with parent_id
- `apps/next/src/app/[locale]/(marketing)/member/[handle]/post/[slug]/page.tsx` — threaded UI
