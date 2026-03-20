---
estimate: M
id: FEAT-OYK
kind: feature
priority: P0
project_slug: orchestra-flutter
status: done
title: go_router configuration with auth guard and all 80 routes
type: feature
---

# go_router configuration with auth guard and all 80 routes

Create lib/router/app_router.dart. Go_router v14 configuration. Call usePathUrlStrategy() on web in main.dart. Firebase OrchestraAnalyticsObserver passed as observer. Auth redirect: GoRouter.redirect checks AuthNotifier state, if Unauthenticated and destination is not auth route redirect to /login, if Authenticated and destination is /login or /register redirect to /summary. ShellRoute wrapping /summary, /notifications with AppShell displaying GlassNavBar and GlassHeader, /search opens as GoRoute not shell tab because it is a modal bottom sheet. Define all routes: /splash, /onboarding, /login, /register, /forgot-password, /reset-password, /two-factor, /magic-login, /passkey, /auth/callback, /auth/magic. Shell routes: /summary, /notifications. Non-shell authenticated routes: /search, /projects, /projects/:id, /projects/:id/tree, /library/notes, /library/notes/:id, /library/agents, /library/agents/:id, /library/skills, /library/skills/:id, /library/workflows, /library/workflows/:id, /library/docs, /library/docs/:id, /library/delegations, /library/sessions, /health, /settings, /settings/profile, /settings/team, /settings/appearance, /settings/security, /settings/notifications, /settings/about. Create router_provider.dart as Riverpod provider for the GoRouter instance that refreshes when AuthNotifier state changes.


---
**in-progress -> in-testing** (2026-03-16T10:31:05Z):
## Changes
- lib/core/router/app_router.dart (GoRouter with auth guard, 40+ routes, ShellRoute, _AuthStateNotifier refreshListenable)
- lib/core/router/router_provider.dart (replaced stub with buildRouter(ref))


---
**in-testing -> in-docs** (2026-03-16T10:31:10Z):
## Results
- test/core/router/router_test.dart (6 tests, all passed)
- Covers: auth routes, shell routes, dynamic project/library routes, settings routes, health/search routes


---
**in-docs -> in-review** (2026-03-16T10:31:35Z):
## Docs
- docs/router.md (auth guard table, full route tree, Routes constants, refreshListenable pattern)


---
**Review (approved)** (2026-03-16T10:31:39Z): Auto-approved: GoRouter with auth guard, 40+ routes, 6 tests passing.
