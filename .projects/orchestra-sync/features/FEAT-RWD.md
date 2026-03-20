---
id: FEAT-RWD
kind: feature
priority: P1
project_slug: orchestra-sync
status: done
title: Team & Member Management for Sharing
type: feature
---

# Team & Member Management for Sharing

Team selector logic and member management:
- **TeamService**: Fetch teams from backend, cache locally
- **MemberService**: List team members with avatars, roles, online status
- **Sharing modes**: Share with all team members OR selected individuals
- **Permissions model**: read / write / admin per share
- **TeamSelectorService**: Combines team + member data for the selector UI

Depends on: FEAT-QVB (Backend Sync API Client)


---
**in-progress -> in-testing** (2026-03-17T15:40:49Z):
## Changes
- apps/flutter/lib/core/sync/team_management_service.dart (new — TeamManagementService with cached team/member fetching, entity share management, TeamSelectorData aggregator)
- apps/flutter/lib/core/sync/team_management_provider.dart (new — Riverpod providers: teamsProvider, teamMembersProvider, teamSelectorDataProvider, entitySharesListProvider, selectedTeamProvider, selectedMembersProvider, shareWithAllProvider, sharePermissionProvider)


---
**in-testing -> in-docs** (2026-03-17T15:43:23Z):
## Results
- apps/flutter/test/core/sync/team_management_service_test.dart (45 tests — TeamSelectorData, Team, TeamMember, TeamShare, SharePermission, SyncEntityType, EntitySyncStatus, EntitySyncMetadata, SyncVersionEntry, ShareRequest, ShareResponse, TeamUpdateStatus, TeamUpdateEntry)


---
**in-docs -> in-review** (2026-03-17T15:43:51Z):
## Docs
- docs/team-management.md (architecture, service API, providers reference, models summary, usage examples)


---
**Review (approved)** (2026-03-17T15:44:11Z): Team management service with caching, 8 providers, 45 tests passing.
