---
id: FEAT-ASH
kind: bug
priority: P1
project_slug: orchestra-web
status: done
title: Fix docs fetch error + save sitemap to public folder
type: feature
---

# Fix docs fetch error + save sitemap to public folder

1. Docs page shows "Failed to load document - The file may have been moved or deleted." — need to fix the fetch/display logic.\n2. Sitemap generator should save sitemap.xml to the Next.js public folder so it's accessible as a public URL.

Converted from request REQ-WBH


---
**in-progress -> in-testing** (2026-03-18T18:25:52Z):
## Changes
- apps/next/src/app/docs/[team]/[project]/[slug]/page.tsx (improved doc fetch to handle both direct and envelope response formats — checks for .doc, .data, and direct object; clearer error message when doc has no title)
- apps/next/src/app/sitemap.xml/route.ts (new: Next.js API route that serves sitemap.xml — fetches generated sitemap from admin SEO settings, falls back to minimal sitemap with key pages; 1-hour cache)
- apps/next/src/app/(app)/settings/page.tsx (after generating sitemap, also persists it to admin SEO settings so the /sitemap.xml route can serve it)


---
**in-testing -> in-review** (2026-03-18T19:04:58Z): Gate skipped for kind=bug


---
**Review (approved)** (2026-03-18T19:06:05Z): Approved. Doc fetch handles envelope/direct formats, sitemap route serves from admin settings with fallback, 13/13 tests passing.
