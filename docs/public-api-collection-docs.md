# Public API Collection Docs

## Overview

Public-facing API documentation pages at `/@username/apis` and `/@username/apis/:slug`. Renders API collections with an OpenAPI-style endpoint browser including method badges, parameter tables, request body display, and folder grouping.

## Pages

### /@username/apis — Collection Listing

`apps/next/src/app/[locale]/(marketing)/member/[handle]/apis/page.tsx`

Two-column grid of API collection cards. Each card shows:
- Collection name + version badge
- Description (2-line clamp)
- Base URL (monospace)
- Auth type badge (color-coded: bearer=green, api_key=blue, basic=yellow, oauth2=purple, none=gray)
- Endpoint count

Fetches from `GET /api/public/api-collections/:handle`. Links to detail page at `/@handle/apis/:slug`. Responsive: single column on mobile (< 640px).

### /@username/apis/:slug — Collection Detail

`apps/next/src/app/[locale]/(marketing)/member/[handle]/apis/[slug]/page.tsx`

Breadcrumb navigation back to listing. Header card with collection name, version, auth badge, description, and base URL. Renders endpoints via `ApiDocRenderer`.

Fetches from `GET /api/public/api-collections/:handle/:slug`. Shows "Collection not found" with back link on 404.

## Components

### ApiDocRenderer

`apps/next/src/components/content/api-doc-renderer.tsx`

OpenAPI-style endpoint documentation renderer. Props: `endpoints: ApiEndpoint[]`, `baseUrl?: string`.

Features:
- **Folder grouping**: Endpoints grouped by `folder_path` with folder headers
- **Collapsible cards**: Click to expand/collapse endpoint details
- **Method badges**: Color-coded (GET=green, POST=blue, PUT=yellow, PATCH=purple, DELETE=red)
- **Parameter table**: Headers + query params with name, value, description columns
- **Request body**: Formatted JSON with body type badge
- **Full URL**: Combines base URL + path when expanded
- **Empty state**: "No endpoints documented" when no endpoints

Handles malformed JSON in headers/query_params gracefully.

## Go API Endpoints

Both endpoints are public (no auth required). Defined in `apps/web/internal/handlers/api_collections.go`.

| Method | Path | Description |
|--------|------|-------------|
| GET | `/api/public/api-collections/:handle` | List public collections for a user |
| GET | `/api/public/api-collections/:handle/:slug` | Get collection with endpoints |

## Tests

- `apps/next/src/components/content/api-doc-renderer.test.tsx` — 11 tests (empty state, method badges, paths, names, folders, expand/collapse, parameters, body, malformed data)
- `apps/next/src/app/[locale]/(marketing)/member/[handle]/apis/apis.test.tsx` — 18 tests (listing: collections, version, auth, endpoints, description, URL, empty/error, API path, links; detail: header, breadcrumb, description, URL, endpoints, not found, back link, API path)
