# Sync API Client

## Overview

The `SyncApiClient` is the HTTP layer for the team sync system. It wraps all sync-related REST endpoints using the shared Dio instance (with auth/error interceptors).

## Endpoints

| Method | HTTP | Path | Purpose |
|--------|------|------|---------|
| `pushDeltas` | POST | `/api/sync/push` | Send local deltas to server |
| `pullDeltas` | GET | `/api/sync/pull` | Fetch server deltas since timestamp |
| `pullAllDeltas` | (paginated) | `/api/sync/pull` | Auto-page through all available deltas |
| `getStatus` | GET | `/api/sync/status` | Current sync status |
| `shareEntity` | POST | `/api/sync/share` | Share entity with team/members |
| `getTeamUpdates` | GET | `/api/sync/team-updates` | Check for available team updates (banner) |
| `getEntityHistory` | GET | `/api/sync/history/:type/:id` | Version history for an entity |
| `getTeams` | GET | `/api/teams` | List teams the user belongs to |
| `getTeamMembers` | GET | `/api/teams/:id/members` | Members of a specific team |
| `getEntityShares` | GET | `/api/sync/share/:type/:id` | Who has access to an entity |
| `revokeShare` | DELETE | `/api/sync/share/:id` | Revoke a share by ID |

## Usage

```dart
final client = SyncApiClient(dio: dio);

// Share an entity
final response = await client.shareEntity(ShareRequest(
  entityType: SyncEntityType.project,
  entityId: 'proj-123',
  teamId: 'team-456',
  shareWithAll: false,
  memberIds: ['user-1', 'user-2'],
  permission: SharePermission.write,
  payload: {'name': 'My Project', ...},
));

// Check for team updates (banner)
final updates = await client.getTeamUpdates();
if (updates.hasUpdates) { ... }

// List teams and members
final teams = await client.getTeams();
final members = await client.getTeamMembers(teams.first.id);

// Version history
final history = await client.getEntityHistory(
  entityType: 'project',
  entityId: 'proj-123',
  limit: 10,
);

// Revoke access
await client.revokeShare('share-789');
```

## Dependencies

- `SyncApiClient` requires a configured `Dio` instance with auth interceptors
- Models from `sync_models.dart` (push/pull/status) and `team_share_models.dart` (sharing/teams)
- Used by `TeamSyncService` for all network operations
