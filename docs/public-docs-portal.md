# Public Documentation Portal

## Overview

Public documentation pages at `/@username/docs` and `/@username/docs/:slug`. Lists shared docs with descriptions and relative timestamps. Individual docs render markdown content with a sidebar for navigation between documents.

## Pages

### /@username/docs — Docs Listing

`apps/next/src/app/[locale]/(marketing)/member/[handle]/docs/page.tsx`

Vertical list of doc cards showing title, description (2-line clamp), and relative update time. Count badge in header. Uses doc icon with green accent color.

Fetches from `GET /api/public/community/shares/:handle?entity_type=doc`.

### /@username/docs/:slug — Doc Detail

`apps/next/src/app/[locale]/(marketing)/member/[handle]/docs/[slug]/page.tsx`

Two-column layout with sticky sidebar (when > 1 doc) and main content area. Features:
- **Sidebar**: Lists all docs with active state highlighting (blue left border)
- **Breadcrumb**: "Documentation > Doc Title" with back link
- **Header**: Title, description, update time, view count
- **Content**: Markdown rendered to HTML (headers, bold/italic, code blocks, lists, links, horizontal rules)
- **Not found state**: Error message with back link

Fetches both the doc and the full doc list in parallel for sidebar population.

## Components

### DocSidebar

`apps/next/src/components/content/doc-sidebar.tsx`

Searchable sidebar for doc navigation. Props: `docs`, `handle`, `activeSlug?`. Features search input, active state highlighting, description truncation (60 chars), and empty states.

## API Endpoints Used

| Method | Path | Description |
|--------|------|-------------|
| GET | `/api/public/community/shares/:handle?entity_type=doc` | List user's public docs |
| GET | `/api/public/community/shares/:handle/doc/:slug` | Get single doc with content |

## Tests

- `apps/next/src/components/content/doc-sidebar.test.tsx` — 8 tests
- `apps/next/src/app/[locale]/(marketing)/member/[handle]/docs/docs.test.tsx` — 16 tests
