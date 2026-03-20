# Presentations Schema

Database models for the Presentation Creator — a slide deck builder with AI generation, export, and public sharing.

## Tables

### presentations
A slide deck owned by a user.

| Column | Type | Description |
|--------|------|-------------|
| id | UUID (PK) | Auto-generated |
| user_id | uint | Owner |
| team_id | UUID | Optional team scope |
| title | string | Presentation title |
| slug | string | URL-safe identifier |
| description | string | Description |
| theme | JSONB | Theme config (colors, fonts, spacing) |
| visibility | string | private, team, public |
| slide_count | int | Cached count of slides |
| version | int | Optimistic concurrency |

### presentation_slides
A single slide within a presentation.

| Column | Type | Description |
|--------|------|-------------|
| id | UUID (PK) | Auto-generated |
| presentation_id | UUID (FK) | Parent presentation |
| user_id | uint | Owner |
| slide_number | int | Order within deck |
| layout | string | title, title-content, two-column, image-full, quote, blank |
| title | string | Slide heading |
| content | text | Markdown body |
| notes | text | Presenter notes |
| properties | JSONB | Per-slide overrides (bg color, image, transition) |

## Files
- `apps/web/internal/models/presentation.go` — GORM models
- `apps/web/internal/database/database.go` — AutoMigrate registration
