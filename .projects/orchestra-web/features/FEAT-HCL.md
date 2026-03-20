---
id: FEAT-HCL
kind: bug
priority: P1
project_slug: orchestra-web
status: done
title: Fix Flutter user detail page — unwrap API response and wire tab data
type: feature
---

# Fix Flutter user detail page — unwrap API response and wire tab data

User detail page shows "Unknown" name with 0 counts because the API returns `{ user: {...}, project_count: N, ... }` but Flutter reads fields directly from the top-level map. Also tab content is all placeholders — need to add per-user endpoints and fetch real data for Projects/Notes/Chats/Teams/Issues tabs like the Next.js reference.


---
**in-progress -> in-testing** (2026-03-17T08:45:46Z):
## Changes
- apps/flutter/lib/screens/web/admin/user_detail_page.dart (fixed data provider to unwrap response['user'] + merge top-level counts; added 5 per-tab FutureProviders for projects/notes/sessions/teams/issues; replaced all PlaceholderTab with real data-fetching ConsumerWidgets; updated ManageTeamsDialog to use new membership endpoints)
- apps/flutter/lib/core/api/endpoints.dart (added 12 new endpoint methods: adminUserProjects, adminUserNotes, adminUserSessions, adminUserTeams, adminUserIssues, adminUserMemberships, adminUserMembership, adminUserPassword, adminUserNotify, adminUserImpersonate, adminUserSuspend, adminUserUnsuspend)
- apps/flutter/lib/core/api/api_client.dart (added 12 abstract method signatures for new user sub-resource endpoints)
- apps/flutter/lib/core/api/rest_client.dart (added 12 concrete REST implementations)
- apps/flutter/lib/core/api/local_mcp_client.dart (added 12 delegate methods)
- apps/flutter/lib/core/api/mcp_tcp_client.dart (added 12 stub methods with UnimplementedError)
- apps/flutter/lib/screens/web/admin/admin_shell.dart (replaced AnimatedSwitcher with KeyedSubtree to fix transparent page overlap animation)


---
**in-testing -> in-review** (2026-03-17T08:46:12Z): Gate skipped for kind=bug


---
**Review (approved)** (2026-03-17T08:47:38Z): Fixed user detail API response unwrapping, wired all 5 tabs with real data, added 12 new API endpoints/methods, and fixed admin page transition animation overlap.
