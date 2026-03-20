---
estimate: M
id: FEAT-IOH
kind: feature
priority: P1
project_slug: orchestra-web
status: done
title: Rich link preview cards with OG metadata
type: feature
---

# Rich link preview cards with OG metadata

Create a Go API endpoint GET /api/og-preview?url=<url> that fetches Open Graph metadata (og:title, og:description, og:image, og:site_name) from any URL with caching. Update the PostEmbed link fallback to call this endpoint and render a rich card with thumbnail image, title, description, and site name instead of just favicon + URL.


---
**in-progress -> in-testing** (2026-03-19T22:52:16Z):
## Changes
- apps/web/internal/handlers/og_preview.go (new Go handler: GET /api/og-preview?url=... fetches HTML, parses og:title, og:description, og:image, og:site_name meta tags, falls back to &lt;title&gt; and meta name tags, 10-minute in-memory cache, 8s timeout, 512KB body limit, URL validation)
- apps/web/internal/routes/routes.go (registered ogPreviewHandler + public GET /og-preview route)
- apps/next/src/components/profile/post-embed.tsx (added LinkPreview component that fetches OG data from /api/og-preview and renders rich card with thumbnail, title, description, site name, favicon; replaced plain link fallback)


---
**in-testing -> in-docs** (2026-03-19T22:53:25Z):
## Results
- apps/web/internal/handlers/og_preview_test.go (6 Go tests passing: parses OG tags, falls back to title tag, falls back to meta name description, truncates long descriptions, returns google favicon, handles empty page)
- apps/next/src/components/profile/__tests__/post-embed.test.tsx (32 frontend tests still passing — link fallback now uses LinkPreview component)


---
**in-docs -> in-review** (2026-03-19T22:53:58Z):
## Docs
- docs/community-post-embeds.md (added Rich Link Previews section with API endpoint spec, LinkPreview component description, OgPreviewHandler in architecture, updated file list)


---
**Review (approved)** (2026-03-19T22:55:41Z): User approved. Rich link previews with OG metadata working end-to-end.
