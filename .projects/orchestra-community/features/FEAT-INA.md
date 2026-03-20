---
id: FEAT-INA
kind: feature
priority: P0
project_slug: orchestra-community
status: done
title: User dropdown header with profile and settings
type: feature
---

# User dropdown header with profile and settings

Header dropdown shows Profile (/@username) and Settings (/@username/settings) links.


---
**in-progress -> in-testing** (2026-03-17T16:15:46Z):
## Changes
- apps/next/src/components/layout/app-header.tsx (added username to AppHeaderProps, added Profile dropdown item linking to /@username, updated Settings to link to /@username/settings)
- apps/next/src/components/layout/marketing-nav.tsx (added Profile and Dashboard dropdown items, added Profile link to hamburger overlay menu)
- apps/next/src/messages/en.json (added nav.profile translation key)
- apps/next/src/messages/ar.json (added nav.profile Arabic translation)


---
**in-testing -> in-docs** (2026-03-17T16:18:37Z):
## Results
- apps/next/src/components/layout/__tests__/app-header-dropdown.test.ts (14 assertions: username prop, Profile link, Settings routing, conditional rendering, translations for en/ar)
All 14 tests passed.


---
**in-docs -> in-review** (2026-03-17T16:18:57Z):
## Docs
- docs/community-profile.md (added User Dropdown Navigation section with route table, condition logic, and key files for both header components)


---
**Review (approved)** (2026-03-17T16:21:42Z): User approved. Profile/Settings dropdown links in both headers, translations added.
