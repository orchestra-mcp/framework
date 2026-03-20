---
id: FEAT-BOR
kind: bug
priority: P1
project_slug: orchestra-web
status: done
title: Fix member profile page empty — API response shape mismatch + restore /@handle links
type: feature
---

# Fix member profile page empty — API response shape mismatch + restore /@handle links

MemberProfile returns flat object but frontend expects `{profile: ...}`. MemberPosts returns `{items}` but frontend expects `{posts}`. Also restore /@handle links since middleware already rewrites them to /member/handle internally.

Reported against feature FEAT-CBT


---
**in-progress -> in-testing** (2026-03-17T10:16:57Z):
## Changes
- apps/web/internal/handlers/community.go (MemberProfile now returns {profile: {stats, social_links[], recent_posts[]}}; MemberPosts returns {posts} with author info instead of {items, meta})
- apps/next/src/app/[locale]/(marketing)/community/page.tsx (restored /@handle links)
- apps/next/src/app/[locale]/(marketing)/member/[handle]/page.tsx (restored /@handle/post links)
- apps/next/src/app/[locale]/(marketing)/member/[handle]/post/[postId]/page.tsx (restored /@handle back-links and related post links)


---
**in-testing -> in-review** (2026-03-17T10:18:34Z): Gate skipped for kind=bug


---
**Review (approved)** (2026-03-17T10:18:52Z): Fixed MemberProfile/MemberPosts API response shapes to match frontend expectations. Restored /@handle links with middleware rewrite. 8 tests pass.
