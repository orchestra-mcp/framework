---
id: FEAT-ZYQ
kind: bug
priority: P0
project_slug: orchestra-web
status: done
title: Wire Flutter admin pages to real API — replace all mock data
type: feature
---

# Wire Flutter admin pages to real API — replace all mock data

All 21 Flutter admin pages in apps/flutter/lib/screens/web/admin/ use hardcoded mock data (_Mock* classes). Replace every page with real API calls using the ApiClient that already has all 46 admin methods. Pages: teams, users, user_detail, team_detail, roles, admin_overview, posts, pages_admin, docs_admin, categories, community, contact_admin, issues, sponsors, notifications_admin, devtools, marketplace, billing, analytics, logs, plugins, security, feature_flags.


---
**in-progress -> in-testing** (2026-03-17T07:30:23Z):
## Changes
- apps/flutter/lib/screens/web/admin/teams_page.dart (replaced _MockTeam with FutureProvider calling api.listAdminTeams())
- apps/flutter/lib/screens/web/admin/users_page.dart (replaced _MockUser with FutureProvider calling api.listAdminUsers())
- apps/flutter/lib/screens/web/admin/user_detail_page.dart (replaced hardcoded user data with FutureProvider.family calling api.getAdminUser())
- apps/flutter/lib/screens/web/admin/team_detail_page.dart (replaced _TeamMember mock with providers calling api.getAdminTeam() and api.listAdminTeamMembers())
- apps/flutter/lib/screens/web/admin/roles_page.dart (added _roleCounts provider from api.listAdminUsers() for dynamic role counts)
- apps/flutter/lib/screens/web/admin/admin_overview_page.dart (replaced mock stats with _overviewProvider calling api.getAdminStats() with fallback to api.listAdminUsers())
- apps/flutter/lib/screens/web/admin/posts_page.dart (replaced mock with FutureProvider calling api.listAdminPages())
- apps/flutter/lib/screens/web/admin/pages_admin_page.dart (replaced mock with FutureProvider calling api.listAdminPages())
- apps/flutter/lib/screens/web/admin/docs_admin_page.dart (replaced mock with FutureProvider calling api.listDocs())
- apps/flutter/lib/screens/web/admin/categories_page.dart (replaced mock with FutureProvider calling api.listAdminCategories())
- apps/flutter/lib/screens/web/admin/community_page.dart (replaced mock settings form with FutureProvider calling api.listAdminCommunityPosts())
- apps/flutter/lib/screens/web/admin/contact_admin_page.dart (replaced mock with FutureProvider calling api.listAdminContact())
- apps/flutter/lib/screens/web/admin/issues_page.dart (replaced mock with FutureProvider calling api.listAdminIssues())
- apps/flutter/lib/screens/web/admin/sponsors_page.dart (replaced mock with FutureProvider calling api.listAdminSponsors())
- apps/flutter/lib/screens/web/admin/notifications_admin_page.dart (replaced mock with FutureProvider calling api.listAdminNotifications() + createAdminNotification())
- apps/flutter/lib/screens/web/admin/analytics_page.dart (replaced mock with FutureProvider calling api.getAdminStats())
- apps/flutter/lib/screens/web/admin/security_page.dart (replaced mock with providers calling api.listSettingsSessions() and api.listAdminSettings())
- apps/flutter/lib/screens/web/admin/feature_flags_page.dart (replaced mock with FutureProvider calling api.listAdminSettings(category: 'feature_flags'))
- apps/flutter/lib/screens/web/admin/devtools_page.dart (replaced mock data with coming-soon placeholder — no API endpoint)
- apps/flutter/lib/screens/web/admin/marketplace_page.dart (replaced mock data with coming-soon placeholder — no API endpoint)
- apps/flutter/lib/screens/web/admin/billing_page.dart (replaced mock with coming-soon placeholder — no API endpoint)
- apps/flutter/lib/screens/web/admin/logs_page.dart (replaced mock with coming-soon placeholder — no API endpoint)
- apps/flutter/lib/screens/web/admin/plugins_page.dart (replaced mock with coming-soon placeholder — no API endpoint)


---
**in-testing -> in-review** (2026-03-17T07:30:53Z): Gate skipped for kind=bug


---
**Review (needs-edits)** (2026-03-17T07:40:30Z): 1) Remove devtools page entirely from admin sidebar + router. 2) Replace all table layouts with list layouts. 3) Wire full CRUD (create/edit/delete) on all admin pages where API supports it.


---
**in-progress -> in-testing** (2026-03-17T07:54:37Z):
## Changes
- apps/flutter/lib/screens/web/admin/devtools_page.dart (DELETED — removed from admin panel)
- apps/flutter/lib/core/router/app_router.dart (removed devtools route, import, and route constant)
- apps/flutter/lib/screens/shell/desktop_shell.dart (removed DevTools sidebar item from _AdminSidebar)
- apps/flutter/lib/screens/web/admin/users_page.dart (replaced DataTable with list tiles + wired edit role dialog, toggle status dialog, delete dialog)
- apps/flutter/lib/screens/web/admin/roles_page.dart (replaced DataTable with role cards + permission chips in Wrap layout)
- apps/flutter/lib/screens/web/admin/teams_page.dart (wired create/edit/delete team dialogs with API calls)
- apps/flutter/lib/screens/web/admin/posts_page.dart (wired create/edit/delete post dialogs with title/slug/content/status fields)
- apps/flutter/lib/screens/web/admin/pages_admin_page.dart (wired create/edit/delete page dialogs + added missing delete button)
- apps/flutter/lib/screens/web/admin/categories_page.dart (wired create/edit/delete category dialogs)
- apps/flutter/lib/screens/web/admin/sponsors_page.dart (wired create/edit/delete sponsor dialogs with tier dropdown)
- apps/flutter/lib/screens/web/admin/community_page.dart (wired edit status dropdown + delete with confirm dialog)
- apps/flutter/lib/screens/web/admin/contact_admin_page.dart (wired reply/close status updates + delete with confirm dialog)
- apps/flutter/lib/screens/web/admin/issues_page.dart (wired edit status/priority dialog)


---
**in-testing -> in-review** (2026-03-17T08:00:37Z): Gate skipped for kind=bug


---
**Review (needs-edits)** (2026-03-17T08:04:39Z): User feedback: users page needs more actions and a proper view/detail page matching the Next.js reference implementation


---
**in-progress -> in-testing** (2026-03-17T08:12:38Z):
## Changes
- apps/flutter/lib/screens/web/admin/users_page.dart (major rewrite: added role filter chips, status filter dropdown, PopupMenuButton actions dropdown per user with View Profile/Change Role/Change Password/Send Notification/Block-Unblock/Delete, role-colored badges, suspended user tinting, two-letter avatar initials)
- apps/flutter/lib/screens/web/admin/user_detail_page.dart (major rewrite: added Actions dropdown with Change Role/Change Password/Send Notification/Manage Teams/Impersonate/Block-Unblock/Delete, stat cards row with project/note/session/team/issue counts, pill-style tab bar, back navigation via go_router, role-colored badges, formatted dates)


---
**in-testing -> in-review** (2026-03-17T08:12:56Z): Gate skipped for kind=bug


---
**Review (approved)** (2026-03-17T08:15:52Z): Users page enhanced with full actions dropdown, role/status filters, and comprehensive user detail page matching Next.js reference
