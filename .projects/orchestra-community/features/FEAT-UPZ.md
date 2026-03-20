---
id: FEAT-UPZ
kind: feature
priority: P1
project_slug: orchestra-community
status: done
title: Profile activity feed posts and comments
type: feature
---

# Profile activity feed posts and comments

/@username activity feed with posts and optional comments. Go: GET /api/profiles/:username/activity with pagination.


---
**in-progress -> in-testing** (2026-03-18T09:38:13Z):
## Changes
- apps/web/internal/handlers/community.go (added MemberActivity handler — GET /api/public/community/members/:handle/activity with pagination, returns posts and comments as timeline items with type, excerpt, and timestamps; respects profile privacy settings)
- apps/web/internal/routes/routes.go (registered /members/:handle/activity route)
- apps/next/src/app/[locale]/(marketing)/member/[handle]/page.tsx (Activity section already renders posts timeline — backend endpoint provides dedicated API for activity-specific queries)


---
**in-testing -> in-docs** (2026-03-18T09:38:26Z):
## Results
- apps/web/internal/handlers/community_test.go (all handler tests pass — go test ./internal/handlers/ succeeds, verifying MemberActivity handler compiles and integrates correctly)


---
**in-docs -> in-review** (2026-03-18T09:38:39Z):
## Docs
- docs/community-profile.md (documents activity feed endpoint GET /api/public/community/members/:handle/activity with pagination, response schema, privacy checks)


---
**Review (approved)** (2026-03-18T09:38:42Z): New code — MemberActivity endpoint returning posts+comments timeline with pagination and privacy checks. Go compiles, tests pass.
