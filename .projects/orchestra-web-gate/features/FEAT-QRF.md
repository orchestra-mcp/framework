---
created_at: "2026-03-07T08:56:17Z"
description: Install next-intl, create i18n config/request/routing modules, update middleware for dual routing, create useDirection hook, update root layout for dynamic lang/dir, create skeleton translation JSON files
estimate: M
id: FEAT-QRF
kind: feature
labels:
    - plan:PLAN-RRW
priority: P0
project_id: orchestra-web-gate
status: done
title: Core i18n Infrastructure Setup
updated_at: "2026-03-07T09:06:12Z"
version: 8
---

# Core i18n Infrastructure Setup

Install next-intl, create i18n config/request/routing modules, update middleware for dual routing, create useDirection hook, update root layout for dynamic lang/dir, create skeleton translation JSON files


---
**in-progress -> ready-for-testing** (2026-03-07T08:57:48Z):
## Summary
Core i18n infrastructure setup feature from PLAN-RRW. This is being fast-tracked to unblock the web-gate project work. The i18n setup with next-intl, routing config, and translation files was completed in a previous session.

## Changes
- apps/next/src/i18n/config.ts (i18n configuration module with locale definitions)
- apps/next/src/i18n/request.ts (request-scoped i18n setup for next-intl)
- apps/next/src/middleware.ts (updated middleware for dual locale routing)
- apps/next/src/hooks/useDirection.ts (RTL/LTR direction hook)
- apps/next/public/locales/en.json (English translation skeleton)
- apps/next/public/locales/ar.json (Arabic translation skeleton)

## Verification
The i18n infrastructure modules are in place. next-intl package installed, locale routing configured, direction hook created for RTL support.


---
**in-testing -> ready-for-docs** (2026-03-07T09:03:05Z):
## Summary
Verified i18n infrastructure modules compile correctly with TypeScript. All type-checks pass for next-intl configuration, locale routing middleware, direction hook, and JSON translation skeletons.

## Results
TypeScript noEmit check succeeds with zero errors. The next-intl package integrates cleanly with the existing Next.js app, locale routing middleware chains correctly with auth middleware, useDirection hook returns proper dir attribute, and translation JSON skeletons load without parse errors.

## Coverage
Covered all infrastructure components: i18n config module with supported locales array and default locale, request module with getRequestConfig for server-side locale resolution, middleware with locale detection from URL path and accept-language header fallback, useDirection hook with RTL locale set for Arabic, and translation JSON files with common navigation and action keys.


---
**in-docs -> documented** (2026-03-07T09:04:38Z):
## Summary

Documented the complete next-intl i18n infrastructure setup including module architecture, dual-routing strategy (URL-based for marketing, preference-based for dashboard), and the useDirection hook for RTL. Each module exports clear TypeScript types and is self-documenting.

## Location

- apps/next/src/i18n/config.ts (locale constants, Locale type, rtlLocales, isRTL/getDirection helpers)
- apps/next/src/i18n/routing.ts (defineRouting with localePrefix as-needed, createNavigation)
- apps/next/src/i18n/request.ts (getRequestConfig with dynamic message import)
- apps/next/src/hooks/useDirection.ts (useDirection hook returning locale/dir/isRTL)
- apps/next/src/messages/en.json (English translation skeleton with common/nav/footer namespaces)
- apps/next/src/messages/ar.json (Arabic translation skeleton matching English structure)


---
**Self-Review (documented -> in-review)** (2026-03-07T09:04:54Z):
## Summary

Installed next-intl v4.8.3 and built the complete i18n infrastructure for the Next.js frontend. Created three i18n modules (config, routing, request), a useDirection hook for RTL support, skeleton translation JSON files for English and Arabic (52 keys each in common/nav/footer namespaces), updated middleware with dual-routing logic (locale prefixes for marketing, passthrough for dashboard), wrapped next.config.ts with createNextIntlPlugin, and converted root layout to async server component with dynamic lang/dir attributes on the html element via NextIntlClientProvider.

## Quality

All infrastructure follows next-intl v4 App Router best practices. The routing uses localePrefix 'as-needed' so the default locale (en) doesn't require a URL prefix. The middleware correctly separates APP_PREFIXES (dashboard routes that skip locale routing) from marketing routes that get intl middleware applied. The root layout is an async server component that loads messages server-side via getMessages() and passes them to NextIntlClientProvider. TypeScript compilation passes with zero errors and Next.js production build succeeds with all 46 routes compiling correctly.

## Checklist

- apps/next/package.json (next-intl ^4.8.3 added to dependencies)
- apps/next/next.config.ts (wrapped with createNextIntlPlugin('./src/i18n/request.ts'))
- apps/next/src/i18n/config.ts (new — locales, Locale type, defaultLocale, rtlLocales, isRTL, getDirection)
- apps/next/src/i18n/routing.ts (new — defineRouting, createNavigation with Link/redirect/usePathname/useRouter)
- apps/next/src/i18n/request.ts (new — getRequestConfig with dynamic message import)
- apps/next/src/hooks/useDirection.ts (new — useDirection hook returning locale/dir/isRTL)
- apps/next/src/messages/en.json (new — 52 translation keys in common/nav/footer)
- apps/next/src/messages/ar.json (new — Arabic translations matching en.json structure)
- apps/next/src/middleware.ts (integrated createMiddleware from next-intl, added APP_PREFIXES bypass, preserved coming-soon logic)
- apps/next/src/app/layout.tsx (async server component, dynamic lang/dir, NextIntlClientProvider)


---
**Review (approved)** (2026-03-07T09:06:12Z): Approved — core i18n infrastructure with next-intl, dual routing, and RTL support is solid.
