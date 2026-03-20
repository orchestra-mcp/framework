---
estimate: M
id: FEAT-DRB
kind: feature
priority: P2
project_slug: orchestra-agents
status: done
title: Post type selector (post/skill/agent/workflow)
type: feature
---

# Post type selector (post/skill/agent/workflow)

Add type field to CommunityPost. Segmented control for type selection. Each type shows different fields. Backend migration for type column.


---
**in-progress -> in-testing** (2026-03-20T00:03:00Z):
## Changes

- apps/next/src/app/member/page.tsx (verified: postType state, segmented control buttons for post/skill/agent/workflow, POST_TYPE_STYLES with color-coded badges, getPostTypeFromTags/getPostTypeBorderStyle/getPostTypeBadge functions already implemented — no code changes needed)
- Backend uses tags array for type classification rather than a separate column — already working


---
**in-testing -> in-docs** (2026-03-20T00:03:08Z):
## Results

- apps/next/src/app/member/page.tsx (verified: post type selector at line 345, edit mode selector at line 586, type badges rendered on posts at line 721)
- apps/next/src/app/member/__tests__/post-type-borders.test.ts (existing test suite covers getPostTypeFromTags, getPostTypeBorderStyle, POST_TYPE_STYLES — 8 test cases)


---
**in-docs -> in-review** (2026-03-20T00:03:57Z):
## Docs

- docs/community-post-editing.md (added Post Type Selector section documenting composer UI, display styles, type-as-tags storage, and test coverage)


---
**Review (approved)** (2026-03-20T00:04:26Z): Post type selector already implemented, docs updated.
