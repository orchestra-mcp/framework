---
estimate: M
id: FEAT-ZPT
kind: feature
priority: medium
project_slug: orchestra-web
status: done
title: Profile sidebar Teams and Sponsors cards
type: feature
---

# Profile sidebar Teams and Sponsors cards

Add teams and sponsors arrays to PublicProfile. Create Teams card (Card 5) and Sponsors card (Card 6) in profile-sidebar.tsx. Add sponsors management to profile settings. Update seed profile.


---
**in-progress -> in-testing** (2026-03-19T22:29:57Z):
## Changes
- apps/next/src/components/profile/profile-sidebar.tsx (added Card 5: Teams with avatar/name/role rows, Card 6: Sponsors with grid of logo+name links sorted by order)
- apps/next/src/store/community.ts (added teams and sponsors arrays to PublicProfile type, seed data with sample teams and sponsors, auto-populate from seed if empty)
- apps/next/src/components/profile/settings-content.tsx (added SponsorsPanel component replacing PlaceholderPanel — CRUD for sponsors with name/logo_url/url/order, up/down reorder, max 10, save via PATCH /api/settings/profile)


---
**in-testing -> in-docs** (2026-03-19T22:30:34Z):
## Results
- apps/next/src/components/profile/__tests__/sponsors-panel.test.ts (12 tests passing: addSponsor with order increment and max-10 cap, removeSponsor with re-indexing, updateSponsor field isolation, moveSponsor up/down with boundary checks, filterForSave removing empty names)


---
**in-docs -> in-review** (2026-03-19T22:30:54Z):
## Docs
- docs/community-profile-sidebar-cards.md (new doc covering Teams card, Sponsors card, SponsorsPanel settings component, data model, and file references)


---
**Review (approved)** (2026-03-19T22:31:25Z): User approved. Teams and Sponsors sidebar cards plus SponsorsPanel settings management all working. 12 tests pass.
