---
estimate: L
id: FEAT-JWO
kind: feature
priority: P2
project_slug: orchestra-agents
status: done
title: Export service (HTML/PDF, PPTX markdown, Google Slides link)
type: feature
---

# Export service (HTML/PDF, PPTX markdown, Google Slides link)

ExportService with RenderPresentationHTML, GeneratePPTXMarkdown, GoogleSlidesURL + wire into PresentationHandler.Export. Files: services/export_service.go, handlers/presentations.go


---
**in-progress -> in-testing** (2026-03-20T17:48:57Z):
## Changes
- apps/web/internal/services/export_service.go (new — 203 lines: ExportService with RenderPresentationHTML for PDF capture, GeneratePPTXMarkdown for slide-per-slide markdown, GoogleSlidesURL for creation link, markdownToHTMLBasic helper with list/code/heading support)
- apps/web/internal/handlers/presentations.go (modified — wired ExportService into PresentationHandler, Export method uses 3 format handlers)


---
**in-testing -> in-docs** (2026-03-20T17:49:38Z):
## Results
- apps/web/internal/services/export_service_test.go (new — 4 tests: TestRenderPresentationHTML, TestGeneratePPTXMarkdown, TestGoogleSlidesURL, TestSlideHTML)
- All 4 tests PASS (go test ./internal/services/ -v)
- Verified: HTML output includes titles/slides/numbering/lists, PPTX markdown has separators/notes, Google Slides URL is well-formed, slide HTML has layout attributes


---
**in-docs -> in-review** (2026-03-20T17:49:57Z):
## Docs
- docs/presentation-export.md (new — documents 3 export formats (PDF/HTML, PPTX/markdown, Google Slides), 6 slide layouts, markdown rendering details)


---
**Review (approved)** (2026-03-20T17:50:43Z): Export service approved. 3 formats, clean architecture, well-tested.
