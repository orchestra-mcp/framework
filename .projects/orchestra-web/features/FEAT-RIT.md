---
id: FEAT-RIT
kind: feature
priority: P1
project_slug: orchestra-web
status: done
title: Add edit community post functionality
type: feature
---

# Add edit community post functionality

Allow post owners to edit their community posts inline. Requires: backend PUT endpoint, store updatePost action, and UI edit toggle on the member profile page.


---
**in-progress -> in-testing** (2026-03-18T20:30:40Z):
## Changes
- apps/web/internal/handlers/community.go (added UpdatePost handler — PUT /api/community/posts/:id with ownership check)
- apps/web/internal/routes/routes.go (registered PUT /posts/:id route on communityAuth group)
- apps/next/src/store/community.ts (added updatePost action with store state sync)
- apps/next/src/app/[locale]/(marketing)/member/[handle]/page.tsx (added inline edit mode with edit/cancel/save buttons, MarkdownEditor for content editing, error feedback)


---
**in-testing -> in-docs** (2026-03-18T20:31:31Z):
## Results
- edit-post.test.ts (7 tests, all passing: PUT API call, store posts update, currentPost sync, unrelated currentPost unchanged, error throw, error state, field preservation)
- publish-post.test.ts (6 tests, all passing — regression check)
- Go compilation clean, no handler test regressions


---
**in-docs -> in-review** (2026-03-18T20:31:46Z):
## Docs
- docs/community-post-editing.md (new — documents PUT endpoint, store action, UI edit flow)


---
**Review (approved)** (2026-03-18T20:33:57Z): User approved. Full-stack edit post feature: backend PUT with ownership check, store action, inline edit UI with error feedback.
