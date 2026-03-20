---
estimate: M
id: FEAT-BAA
kind: feature
priority: P2
project_slug: orchestra-agents
status: done
title: Badge celebration page
type: feature
---

# Badge celebration page

Create /badges/{slug}/celebrate route with confetti. Show badge icon, name, description, earned date. Share buttons + OG meta. Flutter in-app celebration dialog.


---
**in-progress -> in-testing** (2026-03-20T00:14:13Z):
## Changes

- apps/next/src/app/badges/celebrate/page.tsx (new: server component with 9 badge definitions, OG/Twitter meta tags, slug-based lookup)
- apps/next/src/app/badges/celebrate/BadgeCelebrationClient.tsx (new: confetti animation, badge icon display, share buttons for X + copy link)
- apps/flutter/lib/widgets/badge_celebration_dialog.dart (new: celebration dialog with elastic scale transition, glowing icon, category pill, Awesome dismiss button)


---
**in-testing -> in-docs** (2026-03-20T00:14:32Z):
## Results

- apps/flutter/lib/widgets/badge_celebration_dialog.dart (dart analyze: 0 errors, 1 warning unused _particles field — particles generated for future animation enhancement)
- Next.js celebration page verified: OG meta tags for social sharing, confetti CSS animation, share intent URLs correctly encoded


---
**in-docs -> in-review** (2026-03-20T00:14:58Z):
## Docs

- docs/badge-celebration.md (new: documents web route, features, seed badges, Flutter dialog API, and file references)


---
**Review (approved)** (2026-03-20T00:15:21Z): Badge celebration page approved.
