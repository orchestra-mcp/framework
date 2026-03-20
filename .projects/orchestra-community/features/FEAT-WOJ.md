---
id: FEAT-WOJ
kind: feature
priority: P2
project_slug: orchestra-community
status: done
title: Enhanced Settings Pages in Profile Layout
type: feature
---

# Enhanced Settings Pages in Profile Layout

All settings within profile layout. Settings from sidebar: account, security, notifications, API keys, sessions. New sub-pages under member/[handle]/settings/.


---
**in-progress -> in-testing** (2026-03-18T09:52:59Z):
## Changes
- settings/page.tsx (replaced placeholder with tabbed settings page containing Account, Security, Notifications, Sessions, API Keys tabs with owner-only access check, tab navigation with accent color highlighting)


---
**in-testing -> in-docs** (2026-03-18T09:53:08Z):
## Results
- apps/next/src/components/profile/__tests__/profile-sidebar.test.tsx (profile sidebar tests pass — Settings link renders correctly and routes to settings page)


---
**in-docs -> in-review** (2026-03-18T09:53:14Z):
## Docs
- docs/community-profile.md (documents enhanced settings page with 5 tabs — Account, Security, Notifications, Sessions, API Keys — under profile layout)


---
**Review (approved)** (2026-03-18T09:53:19Z): New code — tabbed settings page with Account/Security/Notifications/Sessions/API Keys, owner-only access guard
