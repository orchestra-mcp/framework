# Team & Member Management

## Overview

The team management layer provides cached access to teams, members, and entity shares. It sits between the raw `SyncApiClient` REST calls and the UI, adding a 5-minute in-memory cache and a combined `TeamSelectorData` aggregator for the selector dialog.

## Architecture

```
UI (TeamSelectorDialog)
  ↓ reads
Riverpod Providers (team_management_provider.dart)
  ↓ depends on
TeamManagementService (team_management_service.dart)
  ↓ wraps
SyncApiClient (sync_api_client.dart)
  ↓ HTTP
Backend REST API
```

## Service — `TeamManagementService`

| Method | Returns | Description |
|--------|---------|-------------|
| `getTeams()` | `List<Team>` | Cached team list (5 min TTL) |
| `getTeamMembers(teamId)` | `List<TeamMember>` | Cached per-team member list |
| `getEntityShares(type, id)` | `List<TeamShare>` | Who has access to an entity |
| `revokeShare(shareId)` | `void` | Revoke a share by ID |
| `loadSelectorData()` | `TeamSelectorData` | All teams + all members pre-fetched |
| `invalidateTeamsCache()` | `void` | Force next getTeams to hit server |
| `invalidateMembersCache(teamId)` | `void` | Force next getTeamMembers to hit server |

## Providers — `team_management_provider.dart`

### Data Providers

| Provider | Type | Key | Description |
|----------|------|-----|-------------|
| `teamsProvider` | `FutureProvider<List<Team>>` | — | All user teams |
| `teamMembersProvider` | `FutureProvider.family` | `String` (teamId) | Members of a team |
| `teamSelectorDataProvider` | `FutureProvider<TeamSelectorData>` | — | Pre-fetched teams + members |
| `entitySharesListProvider` | `FutureProvider.family` | `(String, String)` | Shares for an entity |

### State Providers (for selector dialog)

| Provider | Type | Default | Description |
|----------|------|---------|-------------|
| `selectedTeamProvider` | `Notifier<String?>` | `null` | Currently selected team |
| `selectedMembersProvider` | `Notifier<Set<String>>` | `{}` | Selected member IDs |
| `shareWithAllProvider` | `Notifier<bool>` | `true` | Share with all vs selected |
| `sharePermissionProvider` | `Notifier<SharePermission>` | `read` | Permission level |

## Models

All models live in `team_share_models.dart` with full JSON serialization:

- **Team** — id, name, description, avatarUrl, members, createdAt
- **TeamMember** — id, name, email, avatarUrl, role, isOnline
- **TeamShare** — entity reference, team, permission, version tracking
- **SharePermission** — `read`, `write`, `admin` enum
- **ShareRequest** / **ShareResponse** — REST request/response DTOs
- **TeamSelectorData** — aggregated teams + membersByTeamId map

## Usage

```dart
// Read teams in a widget
final teams = ref.watch(teamsProvider);

// Read members for selected team
final members = ref.watch(teamMembersProvider(teamId));

// Pre-fetch all selector data
final selectorData = ref.watch(teamSelectorDataProvider);

// Track dialog state
ref.read(selectedTeamProvider.notifier).select('team-123');
ref.read(selectedMembersProvider.notifier).toggle('user-456');
ref.read(shareWithAllProvider.notifier).setShareWithAll(false);
ref.read(sharePermissionProvider.notifier).select(SharePermission.write);
```
