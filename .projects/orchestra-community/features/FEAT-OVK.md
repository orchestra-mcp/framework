---
id: FEAT-OVK
kind: feature
priority: P0
project_slug: orchestra-community
status: done
title: Public/private profile visibility toggle
type: feature
---

# Public/private profile visibility toggle

Go: Add is_public to User model + visibility endpoint. Next.js: private profiles show message unless owner.


---
**in-progress -> in-testing** (2026-03-17T15:53:14Z):
## Changes
- orch-ref/app/models/sync.go (added IsPublic bool field to User model)
- orch-ref/app/handlers/auth_handler.go (added is_public to userResource response)
- orch-ref/app/handlers/community_handler.go (added privacy check in getMemberProfile, added updateProfileVisibility handler)
- orch-ref/app/handlers/community_routes.go (added /api/users/profile/visibility PUT route)
- apps/next/src/store/auth.ts (added is_public to User interface)
- apps/next/src/store/community.ts (added is_public to PublicProfile interface)
- apps/next/src/app/[locale]/(marketing)/member/[handle]/page.tsx (added private profile message for non-owners)


---
**in-testing -> in-docs** (2026-03-17T15:57:12Z):
## Results
- orch-ref/app/handlers/community_visibility_test.go (12 tests: private profile 404, public profile returns data, visibility toggle, unauthenticated check, end-to-end integration, list members filtering)


---
**in-docs -> in-review** (2026-03-17T15:58:02Z):
## Docs
- docs/community-profile.md (added Profile Visibility section, updated API endpoints table with visibility endpoint)


---
**Review (approved)** (2026-03-17T15:58:25Z): Profile visibility toggle with privacy enforcement.
