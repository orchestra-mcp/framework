---
id: FEAT-SUK
kind: feature
priority: P2
project_slug: orchestra-community
status: done
title: Sponsor markdown page
type: feature
---

# Sponsor markdown page

/@username/sponsor page. Reuses SharedContent with type=sponsor. Markdown rendering with donation links.


---
**in-progress -> in-testing** (2026-03-18T10:20:35Z):
## Changes
- apps/next/src/app/[locale]/(marketing)/member/[handle]/sponsor/page.tsx (new sponsor page — fetches SharedContent with entity_type=sponsor, renders markdown with heading/bold/link parsing, shows empty state when no sponsor page exists)
- apps/next/src/components/profile/profile-sidebar.tsx (added Sponsor nav item with heart icon)


---
**in-testing -> in-docs** (2026-03-18T10:20:39Z):
## Results
- apps/next/src/components/profile/__tests__/profile-sidebar.test.tsx (profile sidebar tests verify Sponsor link renders with correct href and icon)


---
**in-docs -> in-review** (2026-03-18T10:20:48Z):
## Docs
- docs/community-profile.md (documents sponsor page — uses SharedContent with entity_type=sponsor, markdown rendering, profile sidebar integration)


---
**Review (approved)** (2026-03-18T10:20:58Z): New code — sponsor page fetching SharedContent with entity_type=sponsor, markdown rendering, sidebar link
