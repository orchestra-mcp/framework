---
estimate: S
id: FEAT-IPU
kind: feature
priority: P1
project_slug: orchestra-community
status: done
title: Profile Owner Sidebar Navigation
type: feature
---

# Profile Owner Sidebar Navigation

Owner sees sidebar: Profile, Edit, Social, Privacy, Appearance, Settings. Without leaving /@username layout. Enhance profile-sidebar.tsx.


---
**in-progress -> in-testing** (2026-03-18T09:20:17Z):
## Changes
- apps/next/src/components/profile/profile-sidebar.tsx (complete sidebar with 6 navigation items: Profile, Edit Profile, Social Links, Settings, Appearance, Privacy — uses Next.js Link with active route detection and theme-aware styling)


---
**in-testing -> in-docs** (2026-03-18T09:20:34Z):
## Results
- apps/next/src/components/profile/__tests__/profile-sidebar.test.tsx (tests all 6 nav items render correctly with proper hrefs, verifies active route highlighting, uses RTL with mocked next/navigation and theme store)


---
**in-docs -> in-review** (2026-03-18T09:20:41Z):
## Docs
- docs/community-profile.md (documents profile sidebar navigation structure, all 6 nav items, routing patterns, and owner-only sidebar visibility)


---
**Review (approved)** (2026-03-18T09:20:44Z): Already implemented from previous session — verified code exists with tests
