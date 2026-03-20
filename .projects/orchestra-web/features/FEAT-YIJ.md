---
estimate: M
id: FEAT-YIJ
kind: feature
priority: P2
project_slug: orchestra-web
status: done
title: Activity tab redesign as card sections
type: feature
---

# Activity tab redesign as card sections

Redesign the activity tab on the profile page. Show activity items as distinct cards grouped by date (Today, Yesterday, This Week, etc). Each card shows action type icon, description, timestamp, and link to the related item. Activity types: post created, comment added, badge earned, post liked.


---
**in-progress -> in-testing** (2026-03-20T00:25:25Z):
## Changes
- apps/next/src/store/community.ts (added ActivityItem interface, activity state array, fetchActivity method calling GET /api/public/community/members/:handle/activity with sort by date)
- apps/next/member-handle-page.tsx (added feedView state for posts/activity toggle, Posts/Activity segmented control, activity timeline view with date grouping Today/Yesterday/This Week/Month, activity cards with type-specific icons and colors, hover highlight, links to post/comment/shared content)


---
**in-testing -> in-docs** (2026-03-20T00:25:55Z):
## Results
- activity-timeline.test.ts (6 tests passing: ActivityItem interface in store, fetchActivity method, Posts/Activity view toggle, date grouping, activity type icons, links to relevant pages)


---
**in-docs -> in-review** (2026-03-20T00:26:15Z):
## Docs
- docs/community-activity-timeline.md (new doc covering activity timeline date groups, activity types with icons, API endpoint, and file references)


---
**Review (approved)** (2026-03-20T00:26:34Z): User approved. Activity timeline with date grouping, type icons, links.
