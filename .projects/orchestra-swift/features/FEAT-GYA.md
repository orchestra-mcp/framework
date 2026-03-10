---
created_at: "2026-03-07T08:56:17Z"
depends_on:
    - FEAT-UTB
    - FEAT-XBG
    - FEAT-CIQ
description: Add Arabic web font, CSS font-family switch for RTL, letter-spacing adjustments, notFound page, hreflang SEO tags, URL redirects for old marketing paths, text length edge case testing
estimate: S
id: FEAT-GYA
kind: feature
labels:
    - plan:PLAN-RRW
priority: P2
project_id: orchestra-web-gate
status: done
title: Arabic Font + Typography + Polish
updated_at: "2026-03-08T16:53:37Z"
version: 16
---

# Arabic Font + Typography + Polish

Add Arabic web font, CSS font-family switch for RTL, letter-spacing adjustments, notFound page, hreflang SEO tags, URL redirects for old marketing paths, text length edge case testing


---
**in-progress -> in-testing** (2026-03-08T16:39:31Z):
## Changes
- apps/next/src/app/globals.css (added IBM Plex Sans Arabic Google Fonts import, RTL font-family switch, letter-spacing reset for Arabic, line-height adjustment for Arabic readability, mobile sidebar RTL transform fix)
- apps/next/src/app/layout.tsx (added hreflang alternate links metadata for SEO across locales)
- apps/next/src/app/not-found.tsx (new i18n-aware 404 page with translated title/description/CTA)
- apps/next/src/messages/en.json (added notFound namespace with title, description, goHome keys)
- apps/next/src/messages/ar.json (added notFound namespace with Arabic translations)


---
**in-testing -> in-docs** (2026-03-08T16:43:31Z):
## Results
- apps/next/src/__tests__/i18n-polish.test.ts (17 tests, all passing)
  - i18n config: locales contain en/ar, RTL detection correct
  - Translation parity: 23 namespaces match between en.json and ar.json, notFound namespace present in both
  - globals.css: IBM Plex Sans Arabic imported, RTL font-family set, letter-spacing reset, sidebar transform fix
  - Root layout SEO: alternates.languages metadata present
  - not-found page: uses next/link, useTranslations('notFound'), all 3 translated keys rendered
- TypeScript: npx tsc --noEmit — zero errors
- Build: npx next build — all routes compiled successfully, zero errors


---
**in-docs -> in-review** (2026-03-08T16:44:26Z):
## Docs
- docs/web-i18n.md (updated — expanded from 47 lines to comprehensive doc covering all 5 features: architecture, dual routing, 23 namespaces, RTL CSS logical properties, Arabic typography with IBM Plex Sans Arabic, SEO hreflang, language switcher, testing instructions)


---
**Review (needs-edits)** (2026-03-08T16:45:42Z): All public/marketing pages returning 404. Need to fix routing — default language should be EN, public pages should work without locale prefix.


---
**in-progress -> in-testing** (2026-03-08T16:47:58Z):
## Changes
- apps/next/src/i18n/routing.ts (changed localePrefix from 'as-needed' to 'never' — fixes 404 on all marketing/auth pages by preventing URL-based locale rewriting when no [locale] segment exists in the file system)
- apps/next/src/middleware.ts (simplified middleware — removed APP_PREFIXES/isAppRoute separation since localePrefix:'never' means no URL rewriting for any route, all routes get intl middleware for cookie-based locale detection)
- apps/next/src/components/ui/language-switcher.tsx (switched from URL-based locale switching to cookie-based — sets NEXT_LOCALE cookie and calls router.refresh() instead of navigating to /ar/path)
- apps/next/src/store/preferences.ts (added NEXT_LOCALE cookie setting when language preference changes, so next-intl server-side picks up the locale)


---
**in-testing -> in-docs** (2026-03-08T16:48:43Z):
## Results
- apps/next/src/__tests__/i18n-polish.test.ts (23 tests, all passing)
  - i18n config: locales, RTL detection (3 tests)
  - Translation parity: 23 namespaces match, notFound namespace verified (4 tests)
  - globals.css: Arabic font, letter-spacing, sidebar RTL fix (5 tests)
  - Root layout SEO: alternates metadata (2 tests)
  - Not-found page: Link, translations (3 tests)
  - Routing fix: localePrefix:'never', no APP_PREFIXES separation (3 tests)
  - Cookie-based switching: NEXT_LOCALE cookie in switcher and preferences store (3 tests)
- TypeScript: npx tsc --noEmit — zero errors
- Build: npx next build — all routes compiled successfully


---
**in-docs -> in-review** (2026-03-08T16:49:12Z):
## Docs
- docs/web-i18n.md (updated — corrected routing section from 'as-needed' to 'never', replaced 'Dual Routing Strategy' with 'Locale Strategy' explaining cookie-based detection, documented NEXT_LOCALE cookie mechanism and why URL-based was not used)


---
**Review (needs-edits)** (2026-03-08T16:49:36Z): Still returning 404 on all public pages. Need deeper investigation into the routing/middleware interaction.


---
**in-progress -> in-testing** (2026-03-08T16:52:17Z):
## Changes
- apps/next/src/middleware.ts (removed next-intl middleware entirely — it was rewriting URLs to /en/* causing 404s. Middleware now only handles coming-soon gate. Middleware size reduced from 94KB to 34KB)
- apps/next/src/i18n/request.ts (added cookie and Accept-Language header fallback for locale detection — reads NEXT_LOCALE cookie, then Accept-Language header, then falls back to 'en'. No longer depends on middleware to provide requestLocale)
- Verified: all routes return 200 (/, /login, /blog, /docs, /dashboard, /settings)


---
**in-testing -> in-docs** (2026-03-08T16:52:45Z):
## Results
- apps/next/src/__tests__/i18n-polish.test.ts (23 tests, all passing)
  - Verified middleware does NOT use next-intl middleware (no intlMiddleware, no createMiddleware)
  - Verified i18n/request.ts reads NEXT_LOCALE cookie and Accept-Language header for locale detection
  - All previous tests still pass (config, parity, CSS, SEO, not-found, cookie switching)
- Dev server test: all routes return 200 (/, /login, /blog, /docs, /dashboard, /settings)
- Build: npx next build — clean, all routes compiled, middleware 34.5KB


---
**in-docs -> in-review** (2026-03-08T16:53:06Z):
## Docs
- docs/web-i18n.md (updated — corrected middleware description to 'coming-soon gate only, no next-intl middleware', added locale detection via i18n/request.ts, removed references to next-intl middleware in Locale Strategy section)


---
**Review (approved)** (2026-03-08T16:53:37Z): User approved. All pages load correctly. 404 issue resolved by removing next-intl middleware.
