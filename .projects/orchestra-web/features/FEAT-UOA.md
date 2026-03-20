---
estimate: M
id: FEAT-UOA
kind: feature
priority: P1
project_slug: orchestra-web
status: done
title: Inline comments on profile posts
type: feature
---

# Inline comments on profile posts

Add a collapsible comment section under each post on the profile page. Show comment count, latest 2-3 comments inline, and 'View all comments' link to post detail page. Add a compact comment input at bottom of each post card.


---
**in-progress -> in-testing** (2026-03-20T00:14:09Z):
## Changes
- apps/next/src/app/locale/marketing/member/handle/page.tsx (added expandedComments state set, inlineComments cache, inlineCommentText per-post, toggleComments function that fetches comments on expand, submitInlineComment function, replaced Comment link with toggle button showing count, replaced View comments link with collapsible section showing latest 3 comments with avatars plus View all link plus compact input with Enter-to-submit and send button)


---
**in-testing -> in-docs** (2026-03-20T00:14:55Z):
## Results
- inline-comments.test.ts (8 tests passing: expandedComments state, inlineComments cache, toggleComments with fetch, submitInlineComment, comment toggle button, inline comments with avatars, compact input with Enter, View all link for 3+ comments)


---
**in-docs -> in-review** (2026-03-20T00:15:17Z):
## Docs
- docs/community-inline-comments.md (new doc covering inline comments behavior, expand/collapse, comment caching, compact input, View all link, state management)


---
**Review (approved)** (2026-03-20T00:15:46Z): User approved. Inline comments with expand/collapse, compact input, caching.
