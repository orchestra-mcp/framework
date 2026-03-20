---
id: FEAT-WLM
kind: chore
priority: P1
project_slug: orchestra-web-gate
status: done
title: Remove devSeed fallbacks from admin.ts store
type: feature
---

# Remove devSeed fallbacks from admin.ts store

Remove all 39 devSeed guard blocks, remove 4 seed data arrays (devSeedSettings, devSeedSponsors, devSeedCommunityPosts, devSeedGitHubIssues), and clean up dead code from the admin Zustand store. Fix any endpoint path mismatches between frontend calls and backend routes. Part of PLAN-OUT.


---
**in-progress -> in-testing** (2026-03-17T06:17:11Z):
## Changes
- apps/next/src/store/admin.ts (removed all 39 devSeed guards, removed 4 seed arrays, fixed 4 endpoint mismatches — file 826→576 lines)
- apps/flutter/lib/core/api/endpoints.dart (added all admin endpoint path constants: stats, users, teams, settings, pages, categories, contact, issues, notifications, sponsors, community, github)
- apps/flutter/lib/core/api/api_client.dart (added ~46 admin method signatures to abstract interface)
- apps/flutter/lib/core/api/rest_client.dart (added full Dio REST implementations for all admin endpoints with _adminParams helper)
- apps/flutter/lib/core/api/local_mcp_client.dart (added all admin methods delegating to _rest)
- apps/flutter/lib/core/api/mcp_tcp_client.dart (added all admin methods via MCP tool calls)


---
**in-testing -> in-docs** (2026-03-17T06:17:45Z):
## Results
- apps/flutter/lib/core/api/ — dart analyze: 0 errors, 0 warnings (76 info-level lint only, all pre-existing use_null_aware_elements)
- orch-ref/app/handlers/ — go test: all 109 tests pass (admin_users_test.go, admin_content_test.go, admin_support_test.go, admin_external_test.go, admin_routes_test.go)


---
**in-docs -> in-review** (2026-03-17T06:18:12Z):
## Docs
- docs/flutter-admin-api.md (new — documents all 46 admin API methods, endpoint coverage table, query parameters, usage examples)


---
**Review (approved)** (2026-03-17T06:18:40Z): Admin.ts devSeed removal + Flutter admin API layer with all 46 endpoints across 4 client files.
