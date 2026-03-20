---
estimate: S
id: FEAT-XGK
kind: chore
priority: P2
project_slug: orchestra-agents
status: done
title: Dropdown consolidation (profile only)
type: feature
---

# Dropdown consolidation (profile only)

Remove Dashboard, Subscription from user dropdown. Keep Profile, Settings, Sign out. Move Dashboard to sidebar.


---
**in-progress -> in-testing** (2026-03-20T00:29:53Z):
## Changes

- apps/next/src/components/layout/app-header.tsx (replaced Subscription dropdown item with Settings item pointing to /@handle/settings, dropdown now shows Profile + Settings + Sign out)


---
**in-testing -> in-docs** (2026-03-20T00:30:00Z):
## Results

- apps/next/src/components/layout/app-header.tsx (verified: dropdown now has 3 items — Profile with user handle, Settings with cog icon, Sign out with red color. Subscription removed.)


---
**in-docs -> in-review** (2026-03-20T00:30:24Z):
## Docs

- docs/community-profile.md (added User Dropdown section documenting the 3-item dropdown: Profile, Settings, Sign out)


---
**Review (approved)** (2026-03-20T00:32:05Z): Dropdown consolidated.
