---
estimate: M
id: FEAT-JAD
kind: feature
priority: P2
project_slug: orchestra-agents
status: done
title: Sub-comments / threaded replies
type: feature
---

# Sub-comments / threaded replies

Add nullable parent_id to comments table. Accept parent_id in create comment. Client nests by parent_id. Render with indentation max 2 levels.


---
**in-progress -> in-testing** (2026-03-20T00:10:58Z):
## Changes

- orch-ref/database/migrations/20260320004000_add_comment_parent_id.sql (new: adds nullable parent_id column to post_comments with self-referencing FK and partial index)
- orch-ref/app/models/admin.go (added ParentID field to PostComment model)
- orch-ref/app/handlers/community_handler.go (updated addComment to accept optional parent_id with depth validation, updated listComments to include parent_id in response)
- apps/next/src/store/community.ts (added parent_id to PostComment interface, updated addComment signature and body to pass parentId)
- apps/next/src/components/community/ThreadedComments.tsx (new: tree builder with useMemo, recursive rendering with depth-based indentation, inline reply input, max 2 levels)


---
**in-testing -> in-docs** (2026-03-20T00:11:08Z):
## Results

- orch-ref/app/handlers/community_handler.go (verified: parent validation checks parent exists, same post, and top-level only — prevents >2 level nesting)
- apps/next/src/components/community/ThreadedComments.tsx (verified: tree builder correctly separates top-level from replies, Map grouping by parent_id, recursive render stops at depth 2)
- apps/next/src/store/community.ts (verified: addComment body conditionally includes parent_id)


---
**in-docs -> in-review** (2026-03-20T00:11:29Z):
## Docs

- docs/community-post-editing.md (added Threaded Comments section documenting backend validation, frontend tree builder, indentation, and reply UX)


---
**Review (approved)** (2026-03-20T00:11:51Z): Threaded comments approved.
