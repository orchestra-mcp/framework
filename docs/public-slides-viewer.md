# Public Presentation Viewer

## Overview

Public presentation pages at `/@username/slides` and `/@username/slides/:slug`. Lists presentations with slide counts and preview placeholders. Individual presentations render with a full CSS slide engine supporting keyboard navigation, fullscreen mode, and 6 slide layouts.

## Pages

### /@username/slides — Presentations Listing

`apps/next/src/app/[locale]/(marketing)/member/[handle]/slides/page.tsx`

Two-column grid of presentation cards with preview placeholder, title, description, slide count badge, and relative timestamp. Responsive single-column on mobile.

Fetches from `GET /api/public/presentations/:handle`.

### /@username/slides/:slug — Presentation Viewer

`apps/next/src/app/[locale]/(marketing)/member/[handle]/slides/[slug]/page.tsx`

Breadcrumb navigation, header with title/description/slide count, and the SlideRenderer component.

Fetches from `GET /api/public/presentations/:handle/:slug`.

## Components

### SlideRenderer

`apps/next/src/components/content/slide-renderer.tsx`

CSS-based slide engine. Props: `slides: Slide[]`, `title?: string`.

**Features:**
- **6 layouts**: title, title-content, two-column, image-full, quote, blank
- **Keyboard navigation**: Arrow keys, Space (next), Escape (exit fullscreen), F (toggle fullscreen)
- **Button navigation**: Previous/next buttons with slide counter (e.g., "3 / 12")
- **Fullscreen mode**: Fixed overlay with dark background, larger fonts
- **Markdown rendering**: Headers, bold/italic, code blocks, lists, links
- **Quote layout**: Styled blockquote with cyan left border

## API Endpoints Used

| Method | Path | Description |
|--------|------|-------------|
| GET | `/api/public/presentations/:handle` | List user's public presentations |
| GET | `/api/public/presentations/:handle/:slug` | Get presentation with slides |

## Tests

- `apps/next/src/components/content/slide-renderer.test.tsx` — 11 tests
- `apps/next/src/app/[locale]/(marketing)/member/[handle]/slides/slides.test.tsx` — 16 tests
