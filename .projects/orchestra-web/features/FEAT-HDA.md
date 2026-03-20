---
id: FEAT-HDA
kind: bug
priority: P1
project_slug: orchestra-web
status: done
title: Fix ShowPost API missing author fields + guard against undefined posts
type: feature
---

# Fix ShowPost API missing author fields + guard against undefined posts

ShowPost returns {post, author} separately but frontend expects author_name/author_handle embedded in the post object. Also PostComments/RelatedPosts return {items} but store expects {comments}/{posts}.

Reported against feature FEAT-BOR


---
**in-progress -> in-testing** (2026-03-17T10:30:15Z):
## Changes
- apps/web/internal/handlers/community.go (ShowPost embeds author fields in post; PostComments returns {comments}; RelatedPosts returns {posts} with author info; CreatePost returns {post} with author fields)
- apps/next/src/store/community.ts (null safety guards on all store setters)
- apps/next/src/app/[locale]/(marketing)/member/[handle]/page.tsx (guard getInitials, filter undefined posts)
- apps/next/src/app/[locale]/(marketing)/member/[handle]/post/[postId]/page.tsx (guard getInitials)


---
**in-testing -> in-review** (2026-03-17T10:31:03Z): Gate skipped for kind=bug


---
**Review (approved)** (2026-03-17T10:32:07Z): Fixed all 4 community API endpoints to match frontend expectations. Added frontend null safety guards. 9 tests pass.
