---
estimate: M
id: FEAT-MIF
kind: feature
priority: P1
project_slug: orchestra-web
status: done
title: Post detail page with comments
type: feature
---

# Post detail page with comments

Create a /post/:id page that opens a post with full content, type badge, media embeds, author info, and a comment section below. Route from profile post cards to this detail page on click. Different post types (skill/agent/workflow) can show type-specific layouts.


---
**in-progress -> in-testing** (2026-03-20T00:10:37Z):
## Changes
- apps/next/post-detail-page.tsx (enhanced post detail page with type-specific colored left border, type badge label, PostEmbed media rendering for all URLs in content and media field, extractUrls helper, getPostType helper)


---
**in-testing -> in-docs** (2026-03-20T00:11:20Z):
## Results
- post-detail-page.test.ts (8 tests passing: PostEmbed import, POST_TYPE_STYLES with all types, type badge rendering, colored border, media embeds from URLs, comments section with form, related posts, like button)


---
**in-docs -> in-review** (2026-03-20T00:11:39Z):
## Docs
- docs/community-post-detail.md (new doc covering post detail page route, type-specific styling, media embeds, comments section, related posts, and API endpoints)


---
**Review (approved)** (2026-03-20T00:11:55Z): User approved. Post detail page with type styling, embeds, comments.
