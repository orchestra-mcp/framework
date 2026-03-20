# Share Controls

## Overview

Share control panel for managing content visibility, share links, and embed codes. Profile layout updated with content type tabs (Overview, APIs, Docs, Slides).

## Components

### ShareControlPanel

`apps/next/src/components/content/share-control-panel.tsx`

Props: `shareId`, `visibility`, `handle`, `entityType`, `slug`, `onVisibilityChange?`.

**Features:**
- **Visibility toggle**: Public (globe), Unlisted (link), Private (lock) — calls `PUT /api/community/shares/:id`
- **Copy link**: Generates `/@handle/:type/:slug` URL, copies to clipboard with confirmation
- **Embed code**: Collapsible section with iframe snippet (`?embed=true` param)
- **Entity type path mapping**: `doc` → `docs`, `api_collection` → `apis`, `presentation` → `slides`

### Profile Layout Tabs

`apps/next/src/app/[locale]/(marketing)/member/[handle]/layout.tsx`

Added 4 content type tabs to the profile layout:

| Tab | Path | Icon |
|-----|------|------|
| Overview | `/@handle` | bx-user |
| APIs | `/@handle/apis` | bx-collection |
| Docs | `/@handle/docs` | bx-file |
| Slides | `/@handle/slides` | bx-slideshow |

Active tab detected from pathname. Tabs scroll horizontally on mobile.

## Tests

- `apps/next/src/components/content/share-control-panel.test.tsx` — 11 tests
- `apps/next/src/app/[locale]/(marketing)/member/[handle]/layout.test.tsx` — 7 tests
