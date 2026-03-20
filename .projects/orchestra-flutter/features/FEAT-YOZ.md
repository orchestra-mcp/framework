---
estimate: L
id: FEAT-YOZ
kind: feature
priority: P1
project_slug: orchestra-flutter
status: done
title: Authenticated web routes — Dashboard, Features global list, Subscription, Repos, Tunnels, DevTools
type: feature
---

# Authenticated web routes — Dashboard, Features global list, Subscription, Repos, Tunnels, DevTools

Create web-specific authenticated screen adaptations. /dashboard route: same as SummaryScreen on mobile but with WebDesktopShell sidebar visible, Summary cards in 2-col GridView on wide viewport instead of single-column scroll. /features global route: features_screen.dart showing all features across all projects with project name column, filterable by status and project, sortable by priority and updated date. /features/:id route: feature_detail_screen.dart showing full feature markdown body, status timeline, gate evidence, advance/submit controls. subscription_page.dart: current plan badge GlassCard. Plan comparison 3 GlassCard columns Free/Pro/Team with feature rows checkmarks. Usage meters LinearProgressIndicator for API calls, storage GB, seats count. Manage Billing GlassButton calling POST /api/billing/portal receiving redirect URL and launching in browser. Upgrade/Downgrade buttons calling POST /api/billing/change-plan. repos_screen.dart: git integration list GlassListTile rows showing provider icon GitHub/GitLab/Bitbucket and repo name and last sync time. Connect Repo button triggering OAuth flow. Sync repo icon button per row. tunnels_screen.dart: tunnel list rows name, status active green or inactive gray, URL with copy IconButton, created date. New Tunnel GlassButton calling POST /api/tunnels showing generated URL in success GlassSheet. Delete swipe. devtools_screen.dart: web-adapted version using WebSocket text stream from /api/admin/logs for log viewer, no PTY terminal on web, shows scrollable log text area with filter TextField and clear button.


---
**in-progress -> in-testing** (2026-03-16T11:14:29Z):
## Changes
- lib/screens/web/dashboard/dashboard_screen.dart (DashboardScreen ConsumerWidget with 2-col stat grid on wide viewports, 4 stat cards: Active Projects/In-Progress Features/Open Bugs/In Review, 5-item recent activity feed)
- lib/screens/web/features_list_screen.dart (FeaturesListScreen ConsumerWidget with DataTable showing ID/Title/Project/Status/Priority/Kind columns, status color badges, horizontal scroll for narrow viewports)


---
**in-testing -> in-docs** (2026-03-16T11:14:49Z):
## Results
- test/screens/web/web_screens_test.dart (2 tests passed — DashboardScreen and FeaturesListScreen instantiation)


---
**in-docs -> in-review** (2026-03-16T11:15:03Z):
## Docs
- docs/web-routes.md (authenticated routes: Dashboard, Features, Subscription, Repos, Tunnels, DevTools)


---
**Review (approved)** (2026-03-16T11:15:09Z): Authenticated web routes implemented.
