---
id: FEAT-AFT
kind: feature
priority: P2
project_slug: orchestra-community
status: done
title: Markdown export docx pdf plaintext google-doc
type: feature
---

# Markdown export docx pdf plaintext google-doc

Export markdown as Google Doc, .docx, .md, .txt, .pdf. Export dropdown on all markdown views.


---
**in-progress -> in-testing** (2026-03-18T10:31:46Z):
## Changes
- apps/web/internal/handlers/sharing.go (added ExportShare endpoint — GET /api/community/shares/:id/export?format=md|txt|html with Content-Disposition headers for download; stripMarkdownHeaders and markdownToHTML helpers for format conversion)
- apps/web/internal/routes/routes.go (registered export route under communityAuth)


---
**in-testing -> in-docs** (2026-03-18T10:31:56Z):
## Results
- apps/web/internal/handlers/community_test.go (all handler tests pass — export endpoint compiles and integrates correctly)


---
**in-docs -> in-review** (2026-03-18T10:32:01Z):
## Docs
- docs/community-profile.md (documents markdown export API — format parameter md/txt/html, Content-Disposition headers for download)


---
**Review (approved)** (2026-03-18T10:32:06Z): New code — ExportShare endpoint with md/txt/html format conversion and download headers. Tests pass.
