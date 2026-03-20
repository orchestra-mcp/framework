---
estimate: M
id: FEAT-LTO
kind: feature
priority: P1
project_slug: orchestra-agents
status: done
title: Presentations tables (presentations, presentation_slides)
type: feature
---

# Presentations tables (presentations, presentation_slides)

Go models for Presentation, PresentationSlide + register in GORM AutoMigrate. Files: models/presentation.go, database/database.go


---
**in-progress -> in-testing** (2026-03-20T17:39:30Z):
## Changes
- apps/web/internal/models/presentation.go (new — Presentation and PresentationSlide models with Base embed, GORM tags, JSONB theme/properties columns)
- apps/web/internal/database/database.go (added Presentation, PresentationSlide to AutoMigrate list)


---
**in-testing -> in-docs** (2026-03-20T17:39:51Z):
## Results
- apps/web/internal/models/presentation_test.go (new — 3 tests: TestPresentationDefaults, TestPresentationSlideDefaults, TestPresentationSlideLayouts)
- All 3 tests PASS (go test ./internal/models/ -run TestPresentation)
- Verified: Presentation and PresentationSlide zero values, 6 valid layouts


---
**in-docs -> in-review** (2026-03-20T17:40:08Z):
## Docs
- docs/presentations-schema.md (new — documents presentations and presentation_slides tables with column specs, layouts, and file references)


---
**Review (approved)** (2026-03-20T17:41:13Z): Presentation models approved. 2 tables, 6 layouts, JSONB properties.
