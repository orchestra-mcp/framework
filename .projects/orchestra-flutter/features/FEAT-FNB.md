---
estimate: L
id: FEAT-FNB
kind: feature
priority: P2
project_slug: orchestra-flutter
status: todo
title: Admin panel — Users, Billing, Analytics, Logs, Plugins, Security and Feature Flags
type: feature
---

# Admin panel — Users, Billing, Analytics, Logs, Plugins, Security and Feature Flags

Create lib/features/web/admin/ with protected admin screens behind isAdmin guard in go_router redirect. admin_dashboard.dart: overview GlassCard stats grid showing total users, active projects, total agents, MRR value from /api/admin/stats. admin_users_page.dart: sortable DataTable of users with columns email, name, role, createdAt, status. Sort by any column. Filter TextField. Ban/Unban action per row calling PUT /api/admin/users/:id. Impersonate button calling POST /api/admin/users/:id/impersonate. Pagination with next/prev buttons. admin_billing_page.dart: MRR LineChart fl_chart from /api/admin/billing/mrr, subscription DataTable with plan and status and amount per user. admin_analytics_page.dart: event counts from /api/admin/analytics, user funnel BarChart. admin_logs_page.dart: live WebSocket stream from /api/admin/logs, auto-scrolling log text area with level filter chips debug/info/warn/error and search TextField. admin_plugins_page.dart: installed plugins list with enable/disable Toggle per plugin. admin_security_page.dart: audit log DataTable with user/action/timestamp/IP, IP allowlist management TextField. feature_flags_page.dart: feature flag list with Toggle per flag. admin_packs_page.dart: packs DataTable with installs count and rating. All admin pages wrapped in AdminShell showing Admin badge in header and admin-specific NavigationRail items.
