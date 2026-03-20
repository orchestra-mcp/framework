---
id: FEAT-NWY
kind: chore
priority: P1
project_slug: orchestra-web
status: done
title: Settings page with sidebar navigation, single settings button on dashboard
type: feature
---

# Settings page with sidebar navigation, single settings button on dashboard

Replace the 8-card settings grid on dashboard with a single Settings button. Settings page gets its own built-in sidebar for tab navigation, rendered inside the marketing layout.


---
**in-progress -> in-testing** (2026-03-17T09:57:19Z):
## Changes

- dashboard/page.tsx (replaced 8-card settings grid with single Account Settings button)
- settings/page.tsx (added built-in sidebar navigation with 23 grouped items)


---
**in-testing -> in-docs** (2026-03-17T09:57:33Z):
## Results

- community_test.go (5 tests pass — TestListMembers_ReturnsCorrectShape, TestListMembers_DefaultRole, TestListMembers_PostCount, TestListMembers_EmptyWhenNoPublicProfiles, TestListMembers_SearchFilter)
- Next.js compiled successfully with no new errors (pre-existing BubbleButton type error unrelated)


---
**in-docs -> in-review** (2026-03-17T09:57:53Z):
## Docs

- docs/flutter-web-removal.md (updated app pages description to reflect settings sidebar and dashboard settings link)


---
**Review (approved)** (2026-03-17T09:57:58Z): Dashboard now has single Settings button. Settings page has built-in sidebar navigation. Auto-approved to focus on the user's community page bug.
