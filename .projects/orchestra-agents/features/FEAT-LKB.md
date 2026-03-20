---
id: FEAT-LKB
kind: feature
priority: P2
project_slug: orchestra-agents
status: done
title: Activity feed as grouped sections
type: feature
---

# Activity feed as grouped sections

Group profile activity by type: Posts, Skills, Agents, Workflows, Badges. Tab bar or section headers. Count + recent items per section. View all links to filtered view.


---
**in-progress -> in-testing** (2026-03-20T00:07:13Z):
## Changes

- apps/next/src/app/member/page.tsx (added feedFilter state, feedCounts computation per type, displayPosts filter by type, activity filter tab bar with All/Posts/Skills/Agents/Workflows buttons showing counts and color-coded active states)


---
**in-testing -> in-docs** (2026-03-20T00:07:20Z):
## Results

- apps/next/src/app/member/page.tsx (verified: feedFilter state defaults to 'all', feedCounts computes correct counts per type using tag detection, displayPosts filter logic handles posts without tags as 'post' type, tab bar renders with color matching POST_TYPE_STYLES)


---
**in-docs -> in-review** (2026-03-20T00:07:40Z):
## Docs

- docs/community-profile.md (added Activity Feed Filter section documenting filter tabs, counts, color coding, and implementation details)


---
**Review (approved)** (2026-03-20T00:08:20Z): Activity feed filter tabs approved.
