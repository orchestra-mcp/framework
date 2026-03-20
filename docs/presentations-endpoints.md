# Presentations — REST Endpoints

CRUD API for managing presentations and slides, with export and public sharing.

## Authenticated Routes (require JWT)

### Presentations
| Method | Path | Handler | Description |
|--------|------|---------|-------------|
| GET | /api/presentations | List | List user's presentations |
| POST | /api/presentations | Create | Create a presentation |
| GET | /api/presentations/:id | Show | Get presentation with all slides |
| PUT | /api/presentations/:id | Update | Update presentation metadata |
| DELETE | /api/presentations/:id | Delete | Delete presentation (cascades slides) |

### Slides (nested under presentation)
| Method | Path | Handler | Description |
|--------|------|---------|-------------|
| POST | /api/presentations/:id/slides | CreateSlide | Add slide (auto-numbers) |
| PUT | /api/presentations/:id/slides/reorder | ReorderSlides | Reorder slides by ID array |
| PUT | /api/presentations/:id/slides/:slideId | UpdateSlide | Update slide content/layout |
| DELETE | /api/presentations/:id/slides/:slideId | DeleteSlide | Remove slide |

### Export
| Method | Path | Handler | Description |
|--------|------|---------|-------------|
| GET | /api/presentations/:id/export?format=pdf | Export | Returns HTML for headless PDF capture |
| GET | /api/presentations/:id/export?format=pptx | Export | Returns PPTX-ready markdown |
| GET | /api/presentations/:id/export?format=gslides | Export | Returns Google Slides creation URL |

## Public Routes (no auth)

| Method | Path | Handler | Description |
|--------|------|---------|-------------|
| GET | /api/public/presentations/:handle | PublicList | List user's public presentations |
| GET | /api/public/presentations/:handle/:slug | PublicShow | View presentation with slides |

## Files
- `apps/web/internal/handlers/presentations.go` — Handler implementation
- `apps/web/internal/routes/routes.go` — Route registration
