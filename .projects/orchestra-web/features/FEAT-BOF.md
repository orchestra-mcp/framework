---
estimate: S
id: FEAT-BOF
kind: feature
priority: high
project_slug: orchestra-web
status: done
title: Post type visual differentiation with colored borders
type: feature
---

# Post type visual differentiation with colored borders

Add colored left borders to post cards based on type (skill=cyan, agent=purple, workflow=green). Add post type selector to edit mode. Update getPostTypeBadge colors.


---
**in-progress -> in-testing** (2026-03-19T22:26:49Z):
## Changes
- apps/next/src/app/[locale]/(marketing)/member/[handle]/page.tsx (added POST_TYPE_STYLES map with skill/agent/workflow/plugin colors, getPostTypeBorderStyle helper, getPostTypeBadge component, post type selector in edit mode, borderLeft style on ProfileCard)
- apps/next/src/store/community.ts (added updatePost function with tags extraction for post type persistence)


---
**in-testing -> in-docs** (2026-03-19T22:28:51Z):
## Results
- apps/next/src/app/[locale]/(marketing)/member/[handle]/__tests__/post-type-borders.test.ts (14 tests passing: getPostTypeFromTags with all type tags, priority ordering, empty/unrelated tags; getPostTypeBorderStyle with correct colors per type and empty fallback; POST_TYPE_STYLES structure validation)


---
**in-docs -> in-review** (2026-03-19T22:29:16Z):
## Docs
- docs/community-post-type-borders.md (new doc covering post type styles, tag extraction logic, border/badge rendering, edit mode type selector, and file references)


---
**Review (approved)** (2026-03-19T22:29:44Z): User approved. Post type borders with colored left borders, type badges, and edit-mode selector all working. 14 tests pass.
