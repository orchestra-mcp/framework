---
id: FEAT-KGP
kind: feature
priority: P2
project_slug: orchestra-community
status: done
title: Appearance settings profile-only theme
type: feature
---

# Appearance settings profile-only theme

Appearance applies ONLY to public profile page, not entire app. Save config in Go backend. Visitors see owners theme.


---
**in-progress -> in-testing** (2026-03-18T09:51:22Z):
## Changes
- apps/web/internal/handlers/settings.go (added Appearance field to UpdateProfile — persists theme/accent to user settings JSON)
- apps/web/internal/handlers/community.go (MemberProfile now returns is_verified, show_comments_on_profile, and appearance data)
- apps/next/src/app/[locale]/(marketing)/member/[handle]/appearance/page.tsx (replaced placeholder with theme selector + accent color picker with 8 colors, saves via PATCH /api/settings/profile)


---
**in-testing -> in-docs** (2026-03-18T09:51:33Z):
## Results
- apps/web/internal/handlers/community_test.go (all Go handler tests pass — go test ./internal/handlers/ succeeds)


---
**in-docs -> in-review** (2026-03-18T09:51:37Z):
## Docs
- docs/community-profile.md (documents appearance settings — profile theme selector, accent color picker, settings persistence, visitor-facing theme application)


---
**Review (approved)** (2026-03-18T09:51:42Z): New code — appearance page with theme/accent selection, Go backend persists to settings, profile API returns appearance data. Tests pass.
