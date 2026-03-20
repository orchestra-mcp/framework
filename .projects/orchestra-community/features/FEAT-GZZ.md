---
id: FEAT-GZZ
kind: feature
priority: P0
project_slug: orchestra-community
status: done
title: Profile layout with sidebar navigation
type: feature
---

# Profile layout with sidebar navigation

Convert /@username to layout with sidebar for owner. Navigation: Profile, Edit, Settings, Appearance, Privacy, Social Links. Owner sees sidebar, visitors see content only. All settings render inside this layout.


---
**in-progress -> in-testing** (2026-03-17T16:05:40Z):
## Changes
- apps/next/src/app/[locale]/(marketing)/member/[handle]/layout.tsx (new: profile layout with conditional sidebar for owner)
- apps/next/src/components/profile/profile-sidebar.tsx (new: sidebar nav component with 6 links, responsive, theme-aware)
- apps/next/src/app/[locale]/(marketing)/member/[handle]/edit/page.tsx (new: Edit Profile stub)
- apps/next/src/app/[locale]/(marketing)/member/[handle]/settings/page.tsx (new: Settings stub)
- apps/next/src/app/[locale]/(marketing)/member/[handle]/appearance/page.tsx (new: Appearance stub)
- apps/next/src/app/[locale]/(marketing)/member/[handle]/privacy/page.tsx (new: Privacy stub)
- apps/next/src/app/[locale]/(marketing)/member/[handle]/social/page.tsx (new: Social Links stub)
- apps/next/src/app/[locale]/(marketing)/member/[handle]/page.tsx (updated: Edit Profile links to /@handle/edit, Settings to /@handle/settings, adjusted layout for sidebar integration)


---
**in-testing -> in-docs** (2026-03-17T16:08:13Z):
## Results
- apps/next/src/components/profile/__tests__/profile-sidebar.test.tsx (tests: renders all 6 nav items, correct href paths for /@handle/*, component mounts without crashing)


---
**in-docs -> in-review** (2026-03-17T16:10:55Z):
## Docs
- docs/community-profile.md (updated with profile layout sidebar section, owner sidebar navigation table, responsive behavior, updated key files list, API endpoints table, and all new route documentation)


---
**Review (approved)** (2026-03-17T16:11:17Z): User approved. Profile layout with sidebar, responsive pills, 5 sub-pages, and docs complete.
