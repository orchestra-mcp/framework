# SEO and Open Graph Metadata

## Overview

SEO utilities and JSON-LD structured data for all public content pages. Provides Open Graph tags, Twitter cards, canonical URLs, and Schema.org structured data.

## SEO Utility Library

`apps/next/src/lib/seo.ts`

### buildMetadata(content)

Generates Next.js `Metadata` object for content pages. Includes:
- Title: `{title} | @{handle} | Orchestra`
- Canonical URL: `/@{handle}/{type}/{slug}`
- Open Graph: article type, title, description, URL, site name
- Twitter: summary_large_image card
- Robots: index + follow

### buildProfileMetadata(handle, name?)

Generates metadata for profile pages. Uses `profile` OG type.

### buildJsonLd(content)

Generates Schema.org JSON-LD structured data:

| Content Type | Schema Type |
|-------------|-------------|
| apis | APIReference |
| docs | TechArticle |
| slides | PresentationDigitalDocument |

## JSON-LD Component

`apps/next/src/components/content/json-ld.tsx`

Injects `<script type="application/ld+json">` with serialized structured data. Used in all detail pages.

## Integration

JSON-LD added to:
- `member/[handle]/apis/[slug]/page.tsx`
- `member/[handle]/docs/[slug]/page.tsx`
- `member/[handle]/slides/[slug]/page.tsx`

## Tests

- `apps/next/src/lib/seo.test.ts` — 13 tests
- `apps/next/src/components/content/json-ld.test.tsx` — 2 tests
