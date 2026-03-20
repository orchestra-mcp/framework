---
id: FEAT-DTS
kind: bug
priority: P0
project_slug: orchestra-web
status: done
title: Redesign profile page to match tomatophp.com design
type: feature
---

# Redesign profile page to match tomatophp.com design

Complete profile page redesign based on tomatophp.com/@fadymondy reference. Key changes: left-aligned avatar overlapping cover, left-aligned profile info (name with verified badge, handle, bio, location+date row, social icons row), two-column grid below with Profile Stats card (left) and Activity feed (right), owner edit mode shows subtle edit buttons that open modals. Use our dark/light theme colors. Remove center-aligned layout and 4-column stats grid.

Reported against feature FEAT-GZZ


---
**in-progress -> in-testing** (2026-03-17T18:32:40Z):
## Changes
- apps/next/src/app/member/handle/page.tsx (complete profile page rewrite with tomatophp.com-style design: left-aligned avatar overlapping cover, two-column stats+activity grid, edit buttons for owner mode)
- apps/next/src/app/member/handle/layout.tsx (skip tab bar on main profile page, show only on sub-pages)


---
**in-testing -> in-review** (2026-03-17T18:34:26Z): Gate skipped for kind=bug


---
**Review (approved)** (2026-03-17T18:35:00Z): Profile page redesigned to match tomatophp.com style. Left-aligned avatar+header, two-column stats+activity grid, owner edit mode with modals. 45/45 tests pass.
