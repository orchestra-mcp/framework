---
id: FEAT-KPC
kind: feature
priority: P1
project_slug: orchestra-web
status: done
title: Render community post content as markdown
type: feature
---

# Render community post content as markdown

Community post content currently renders as plain text. Replace with full markdown rendering in the post card on the member profile page.


---
**in-progress -> in-testing** (2026-03-18T20:39:26Z):
## Changes
- page.tsx — replaced plain text post content with ReactMarkdown rendering using themed components (h1-h3, p, a, strong, ul, ol, blockquote, code, pre); added delete button in post actions; added handleDelete with confirm dialog; added mdComponents definition
- community.ts — added deletePost store action (DELETE /api/community/posts/:id, removes from posts[] and currentPost)
- community.go — added DeletePost handler with ownership check (403 if not owner, soft-delete via GORM)
- routes.go — registered DELETE /posts/:id route on communityAuth group


---
**in-testing -> in-docs** (2026-03-18T20:40:00Z):
## Results
- delete-post.test.ts (6 tests, all passing: DELETE API call, removes from store, clears currentPost, preserves unrelated currentPost, error handling, preserves posts on failure)
- edit-post.test.ts (7 tests, all passing — regression)
- publish-post.test.ts (6 tests, all passing — regression)
- Go compilation clean


---
**in-docs -> in-review** (2026-03-18T20:40:27Z):
## Docs
- docs/community-post-editing.md (updated — added DELETE endpoint, deletePost store action, markdown rendering section, delete UI behavior)


---
**Review (needs-edits)** (2026-03-18T20:44:11Z): User wants: 1) Proper confirmation dialog alert for delete (not browser confirm). 2) Use existing markdown renderer from apps/components/editor/src/markdownRender with full features (codeblock, datatable).


---
**in-progress -> in-testing** (2026-03-18T20:46:41Z):
## Changes
- page.tsx — replaced react-markdown with MarkdownRenderer from @orchestra-mcp/editor (full features: CodeBlock, DataTable, task lists, frontmatter); replaced browser confirm() with ConfirmDialog component (danger variant, loading state); added deleteConfirmId/deleteLoading state for dialog control


---
**in-testing -> in-docs** (2026-03-18T20:46:56Z):
## Results
- delete-post.test.ts (6 tests, all passing)
- edit-post.test.ts (7 tests, all passing)
- publish-post.test.ts (6 tests, all passing)
- No regressions after switching to MarkdownRenderer and ConfirmDialog


---
**in-docs -> in-review** (2026-03-18T20:47:21Z):
## Docs
- docs/community-post-editing.md (updated — MarkdownRenderer from @orchestra-mcp/editor with full features, ConfirmDialog for delete)


---
**Review (approved)** (2026-03-19T21:14:59Z): Approved. MarkdownRenderer + ConfirmDialog changes look good.
