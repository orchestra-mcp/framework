---
id: FEAT-QGC
kind: chore
priority: P1
project_slug: orchestra-web
status: done
title: Remove Flutter web deploy and simplify Next.js (no admin/dashboard)
type: feature
---

# Remove Flutter web deploy and simplify Next.js (no admin/dashboard)

Remove Flutter web deployment entirely (deploy.sh, Caddyfile, Makefile, GitHub Actions). Delete admin panel (16 pages) and dashboard from Next.js. Remove NEXT_PUBLIC_APP_URL token redirect flow from middleware/login/register. Keep auth services, settings, subscription, marketing pages intact.


---
**in-progress -> in-testing** (2026-03-17T09:08:39Z):
## Changes
- scripts/deploy/deploy.sh (removed deploy_flutter function and flutter case, now deploys web+next only)
- scripts/deploy/Caddyfile (removed app.orchestra-mcp.dev Flutter SPA block, now 2-domain config)
- Makefile (removed flutter-build-web, flutter-deploy-web, flutter-docker-web targets)
- .github/workflows/flutter-build.yml (removed web and docker-web jobs, removed web from platform defaults)
- apps/flutter/deploy/Dockerfile.web (deleted)
- apps/next/src/app/(app)/admin/ (deleted entire directory — 16 admin page files)
- apps/next/src/app/(app)/dashboard/page.tsx (deleted)
- apps/next/src/middleware.ts (removed DASHBOARD_URL, KEEP_ON_MARKETING, Flutter redirect logic)
- apps/next/src/app/[locale]/(auth)/login/page.tsx (removed APP_URL, redirects to /settings after login)
- apps/next/src/app/[locale]/(auth)/register/page.tsx (removed APP_URL, redirects to /settings after register)
- apps/next/src/components/layout/app-icon-bar.tsx (removed dashboard item, admin footer item, useRoleStore import)
- apps/next/src/app/(app)/layout.tsx (removed noSidebarPages /dashboard, changed fallback button to /projects)
- apps/next/.env.local (removed NEXT_PUBLIC_APP_URL)
- apps/next/.env.production (removed NEXT_PUBLIC_APP_URL)


---
**in-testing -> in-docs** (2026-03-17T09:11:16Z):
## Results
- Verified NEXT_PUBLIC_APP_URL is completely removed (0 references in apps/next/)
- Verified all router.push/replace('/dashboard') calls updated to /settings or /projects (0 remaining)
- Verified all /admin href references removed from sidebar, header, and icon bar (0 remaining)
- Verified deploy.sh only has web+next targets (no flutter)
- Verified Caddyfile has 2 domain blocks (api + marketing, no app.orchestra-mcp.dev)
- Verified flutter-build.yml has no web/docker-web jobs
- No test files needed for this removal chore — verification was done via grep sweeps across the codebase


---
**in-docs -> in-review** (2026-03-17T09:11:43Z):
## Docs
- docs/flutter-web-removal.md (documents the architecture change, what was removed, and remaining Next.js page structure)


---
**Review (approved)** (2026-03-17T09:12:30Z): User approved. Flutter web deployment removed, Next.js simplified to marketing+auth+settings only.
