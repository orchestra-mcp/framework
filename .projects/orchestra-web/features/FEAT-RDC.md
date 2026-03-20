---
estimate: M
id: FEAT-RDC
kind: feature
priority: P2
project_slug: orchestra-web
status: done
title: Nested sub-comments (threaded replies)
type: feature
---

# Nested sub-comments (threaded replies)

Add reply functionality to comments. Each comment can have child comments (1 level deep). Show reply button, reply input, and threaded display with left-indent. Both on profile inline comments and post detail page.


---
**in-progress -> in-testing** (2026-03-20T00:18:33Z):
## Changes
- apps/web/internal/handlers/community.go (PostComments now fetches replies per comment with 1-level nesting, returns replies array per comment row; AddComment accepts optional parent_id to reply to a comment instead of the post)
- apps/next/post-detail-page.tsx (added replyingTo/replyText state, handleReply function, Reply button per comment, threaded replies display with 42px left indent, reply input with Enter-to-submit)
- apps/next/src/store/community.ts (addComment already supported parentId parameter)


---
**in-testing -> in-docs** (2026-03-20T00:19:05Z):
## Results
- threaded-replies.test.ts (5 tests passing: replyingTo state, handleReply with parentId, Reply button per comment, threaded replies with indent, reply input with Enter-to-submit)


---
**in-docs -> in-review** (2026-03-20T00:19:24Z):
## Docs
- docs/community-threaded-replies.md (new doc covering threaded replies API with nested replies array, parent_id support, UI with indent and reply input)


---
**Review (approved)** (2026-03-20T00:19:53Z): User approved. Threaded replies with nested API, Reply button, indented display.
