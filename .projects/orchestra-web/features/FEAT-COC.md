---
id: FEAT-COC
kind: feature
priority: P1
project_slug: orchestra-web
status: done
title: Sponsors management panel in profile settings
type: feature
---

# Sponsors management panel in profile settings

Replace the PlaceholderPanel for 'sponsor' section in settings-content.tsx with a real SponsorsPanel component. Follow the SocialLinksPanel pattern: CRUD for sponsors array with name, logo_url, url, order fields. Reorder with up/down buttons. Max 10 sponsors. Save via PATCH /api/settings/profile.


---
**in-progress -> in-testing** (2026-03-19T22:35:28Z):
## Changes
- apps/next/src/components/profile/settings-content.tsx (added SponsorsPanel component with Sponsor interface, add/remove/update/move/save functions, 3-input row layout with up/down/trash buttons, max 10 limit, PATCH /api/settings/profile endpoint; replaced PlaceholderPanel at case 'sponsor' with SponsorsPanel)


---
**in-testing -> in-docs** (2026-03-19T22:35:39Z):
## Results
- apps/next/src/components/profile/__tests__/sponsors-panel.test.ts (12 tests passing: addSponsor with order increment and max-10 enforcement, removeSponsor with re-indexing, updateSponsor field isolation, moveSponsor up/down with boundary checks, filterForSave removing empty names)


---
**in-docs -> in-review** (2026-03-19T22:35:51Z):
## Docs
- docs/community-profile-sidebar-cards.md (documents SponsorsPanel component in profile settings including field specs, add/remove/reorder/save features, max 10 limit, PATCH endpoint, and data model)


---
**Review (approved)** (2026-03-19T22:36:23Z): User approved. SponsorsPanel replaces placeholder, full CRUD with reorder. All plan features complete.
