# Presentation Export Service

Converts presentations to multiple output formats for sharing and distribution.

## Export Formats

### PDF (via HTML)
- `GET /api/presentations/:id/export?format=pdf`
- Returns a full HTML document with `@page` CSS for landscape A4
- Each slide is a `<section>` with `page-break-after: always`
- Supports all 6 layouts via CSS `data-layout` attribute
- Includes slide numbering
- Intended for capture by headless browser (wkhtmltopdf or Puppeteer)

### PPTX (via Markdown)
- `GET /api/presentations/:id/export?format=pptx`
- Returns slide-per-slide markdown with `---` separators
- Includes presenter notes as `**Notes:**` sections
- Can be imported into presentation tools or converted via pandoc

### Google Slides
- `GET /api/presentations/:id/export?format=gslides`
- Returns a Google Slides creation URL with pre-filled title
- User copies content manually (full API integration planned for future)

## Slide Layouts
The HTML renderer supports 6 layouts via CSS:

| Layout | CSS Behavior |
|--------|-------------|
| title | Centered, larger heading (3.5rem) |
| title-content | Standard heading + body |
| two-column | CSS Grid 1fr 1fr |
| image-full | No padding, full bleed |
| quote | Italic, centered, larger text |
| blank | Empty canvas |

## Markdown Rendering
The `markdownToHTMLBasic` helper converts slide content markdown to HTML:
- Headings (`#`, `##`, `###`)
- Bullet lists (`-`, `*`)
- Code blocks (triple backticks)
- Paragraphs

## Files
- `apps/web/internal/services/export_service.go` — Export logic
- `apps/web/internal/handlers/presentations.go` — Export endpoint wiring
