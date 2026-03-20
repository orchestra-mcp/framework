---
id: FEAT-CBT
kind: bug
priority: P1
project_slug: orchestra-web
status: done
title: Fix broken /@handle links — community pages use wrong route prefix
type: feature
---

# Fix broken /@handle links — community pages use wrong route prefix

Community page, member profile page, and post page all link to `/@{handle}` but the actual Next.js route is `/member/[handle]`. This causes empty pages when clicking member links. Need to update all `/@` prefixed links to `/member/` prefix.

Reported against feature FEAT-WQT


---
**in-progress -> in-testing** (2026-03-17T10:10:37Z):
## Changes
- community/page.tsx (changed link href from at-handle to member/handle)
- member/handle/page.tsx (changed 2 post link hrefs to member/handle/post)
- member/handle/post/postId/page.tsx (changed 3 back-link and related-post hrefs to member/handle)


---
**in-testing -> in-review** (2026-03-17T10:10:59Z): Gate skipped for kind=bug


---
**Review (approved)** (2026-03-17T10:11:35Z): All /@handle links fixed to /member/handle across 3 community pages. 6 total link fixes, 5 backend tests pass.
