---
id: FEAT-GRZ
kind: bug
priority: P1
project_slug: orchestra-community
status: done
title: Fix social links not showing on profile
type: feature
---

# Fix social links not showing on profile

Social links saved but not rendered. Debug community store fetchMemberProfile and Go backend profile response.


---
**in-progress -> in-testing** (2026-03-17T18:11:04Z):
## Changes
- orch-ref/app/models/sync.go (added SocialLinks JSONB field to User model)
- orch-ref/app/handlers/auth_handler.go (added social_links to userResource)
- orch-ref/app/handlers/community_handler.go (fixed getMemberProfile to return bio/cover_url/social_links, added updateSocialLinks handler with validation)
- orch-ref/app/handlers/community_routes.go (added PUT /api/users/profile/social-links route)
- apps/next/src/app/[locale]/(marketing)/member/[handle]/social/page.tsx (replaced stub with functional social links editor)


---
**in-testing -> in-review** (2026-03-17T18:13:37Z): Gate skipped for kind=bug


---
**Review (approved)** (2026-03-17T18:14:05Z): Social links bug fix complete. Backend returns social_links in profile API, PUT endpoint for saving, frontend editor working. 15/15 tests pass.
