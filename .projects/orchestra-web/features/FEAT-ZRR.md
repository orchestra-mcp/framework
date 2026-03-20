---
id: FEAT-ZRR
kind: bug
priority: P1
project_slug: orchestra-web
status: done
title: Fix profile page UI: cover containment, activity header spacing, empty titles
type: feature
---

# Fix profile page UI: cover containment, activity header spacing, empty titles

Profile page has UI issues: cover image bleeds beyond container (no horizontal padding), Activity header has excessive margin, post titles render as empty h4 when no title. Fix: add max-width 960 + horizontal padding to outer container, fix Activity h3 margin, guard post title rendering.

Reported against feature FEAT-DTS


---
**in-progress -> in-testing** (2026-03-17T18:50:22Z):
## Changes
- apps/next/src/app/member/handle/page.tsx (3 fixes: added maxWidth 960 + horizontal padding 24px to outer container for cover containment, fixed Activity h3 margin from 20 to 0 with proper padding, guarded post title rendering to skip empty h4 when no title)


---
**in-testing -> in-review** (2026-03-17T18:50:28Z): Gate skipped for kind=bug


---
**Review (approved)** (2026-03-17T18:51:39Z): Profile UI fixes: cover containment, activity header spacing, empty title guard. 5/5 tests pass.
