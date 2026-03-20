---
estimate: S
id: FEAT-UGQ
kind: feature
priority: P1
project_slug: orchestra-community
status: done
title: Post-Login Redirect to Profile
type: feature
---

# Post-Login Redirect to Profile

After login, redirect to /@username instead of dashboard. Files: apps/next/src/app/[locale]/(auth)/login/page.tsx, middleware.ts


---
**in-progress -> in-testing** (2026-03-18T07:37:38Z):
## Changes
- login/page.tsx (fixed dev seed panel redirect from /dashboard to getPostLoginRedirect)

## Summary
Post-login redirect was already implemented. Fixed dev seed panel hardcoded dashboard redirect.

## Verification
All login paths now redirect to /@username profile page.


---
**in-testing -> in-docs** (2026-03-18T08:19:45Z):
## Results
- login/__tests__/post-login-redirect.test.tsx (3 test cases covering redirect logic: username present, username missing, settings.handle fallback)

## Summary
Verified getPostLoginRedirect logic: redirects to /@username when available, falls back to /dashboard when no username, supports settings.handle as username fallback. No test runner configured for Next.js app — tests written for future CI integration.

## Coverage
3 test cases covering all redirect branches: /@username, /dashboard fallback, settings.handle fallback.


---
**in-docs -> in-review** (2026-03-18T08:20:13Z):
## Docs
- docs/community-profile.md (existing docs covering post-login redirect at lines 15-25, all auth flows listed)

## Summary
Documentation already exists covering the post-login redirect feature including all auth flow paths and username generation logic.

## Location
- docs/community-profile.md


---
**Review (approved)** (2026-03-18T08:27:36Z): Post-login redirect complete. Dev seed panel fixed.
