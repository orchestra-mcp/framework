---
created_at: "2026-03-08T16:55:43Z"
description: Marketing/auth pages must support locale in URL path (e.g. /ar/blog, /en/docs). Dashboard pages use settings-based locale. Currently all routes use cookie-based detection with no URL prefix support, so /ar/blog returns 404.
id: FEAT-WYL
kind: bug
labels:
    - reported-against:FEAT-GYA
priority: P0
project_id: orchestra-swift
status: done
title: Public pages need URL-based locale routing (/ar/blog, /en/docs)
updated_at: "2026-03-08T17:10:55Z"
version: 4
---

# Public pages need URL-based locale routing (/ar/blog, /en/docs)

Marketing/auth pages must support locale in URL path (e.g. /ar/blog, /en/docs). Dashboard pages use settings-based locale. Currently all routes use cookie-based detection with no URL prefix support, so /ar/blog returns 404.

Reported against feature FEAT-GYA


---
**in-progress -> in-testing** (2026-03-08T17:10:17Z):
## Changes
- apps/next/src/middleware.ts (rewrote: dual routing — intlMiddleware for public routes via isPublicRoute(), passthrough for dashboard)
- apps/next/src/i18n/routing.ts (changed localePrefix to 'always' for URL-based locale on all public pages)
- apps/next/src/app/[locale]/layout.tsx (added generateStaticParams + setRequestLocale for SSG)
- apps/next/src/app/[locale]/LandingClient.tsx (moved from app/ root)
- apps/next/src/app/page.tsx (new: redirects root / to /en)
- apps/next/src/app/page.stories.tsx (updated import path)
- apps/next/src/components/ui/language-switcher.tsx (rewritten: dropdown menu with URL-based navigation, LOCALE_LABELS map)
- apps/next/src/app/(app)/settings/page.tsx (moved language picker from Appearance to Profile Information section in 2-col grid with timezone)


---
**in-testing -> in-review** (2026-03-08T17:10:31Z): Gate skipped for kind=bug


---
**Review (approved)** (2026-03-08T17:10:55Z): Dual routing working correctly: URL-based locale for public pages, cookie-based for dashboard. All 27 tests pass, build succeeds.
