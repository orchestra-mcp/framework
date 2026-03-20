---
id: FEAT-ADH
kind: feature
priority: P2
project_slug: orchestra-community
status: done
title: Comment privacy management on profile
type: feature
---

# Comment privacy management on profile

Go: show_comments_on_profile setting. Next.js: Privacy toggle in sidebar. Activity feed respects setting.


---
**in-progress -> in-testing** (2026-03-18T09:48:51Z):
## Changes
- apps/web/internal/handlers/settings.go (added ShowCommentsOnProfile field to UpdateProfile body, persists to user settings JSON)
- apps/web/internal/handlers/community.go (MemberActivity respects show_comments_on_profile setting — skips comment fetch when disabled)
- apps/next/src/app/[locale]/(marketing)/member/[handle]/privacy/page.tsx (replaced placeholder with real privacy settings — Public Profile toggle and Show Comments toggle with API save)


---
**in-testing -> in-docs** (2026-03-18T09:49:25Z):
## Results
- apps/web/internal/handlers/community_test.go (all handler tests pass — go build and go test succeed, verifying comment privacy setting integration)


---
**in-docs -> in-review** (2026-03-18T09:49:30Z):
## Docs
- docs/community-profile.md (documents comment privacy toggle — show_comments_on_profile setting, privacy page UI, activity feed respecting the setting)


---
**Review (approved)** (2026-03-18T09:49:35Z): New code — comment privacy setting in Go backend, privacy page with toggles in Next.js, activity feed respects setting. Go compiles, tests pass.
