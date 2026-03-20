# Team Sync Data Models

## Overview

The team sync system extends Orchestra's existing delta-based sync engine with team-aware sharing. These models enable selective entity sharing (projects, notes, skills, agents, workflows) with teams or individual members.

## Models

### Enums

| Enum | Values | Purpose |
|------|--------|---------|
| `SyncEntityType` | project, note, skill, agent, workflow, doc | Identifies the type of syncable entity |
| `EntitySyncStatus` | neverSynced, synced, pending, outdated, conflict | Per-entity sync state |
| `SharePermission` | read, write, admin | Access level for shared entities |

### Core Classes

| Class | File | Purpose |
|-------|------|---------|
| `TeamMember` | team_share_models.dart | Team member with id, name, role, online status |
| `Team` | team_share_models.dart | Team with nested members list |
| `TeamShare` | team_share_models.dart | Share record: entity + team + permissions + selective members |
| `EntitySyncMetadata` | team_share_models.dart | Local bookkeeping: sync status, versions, content hash per entity |
| `SyncVersionEntry` | team_share_models.dart | Version history entry with author and change summary |

### API Classes

| Class | Endpoint | Purpose |
|-------|----------|---------|
| `ShareRequest` | POST /api/sync/share | Request body with entity payload + team target |
| `ShareResponse` | POST /api/sync/share | Server response with share ID and version |
| `TeamUpdateStatus` | GET /api/sync/team-updates | Update banner data: available update count + entries |
| `TeamUpdateEntry` | (nested) | Single pending update from a team member |

## Database Tables (Drift)

| Table | Primary Key | Purpose |
|-------|-------------|---------|
| `TeamSharesTable` | `id` (UUID) | Locally cached team shares |
| `EntitySyncMetadataTable` | `{entityType, entityId}` | Per-entity sync tracking |
| `SyncVersionHistoryTable` | `id` (UUID) | Entity version history |

Schema version bumped from 2 to 3 in `local_database.dart`. Migration creates all three tables for existing installs.

## Sharing Flow

1. User taps sync on an entity
2. Team selector dialog shows teams + members
3. User picks team/members and confirms
4. `ShareRequest` sent to server with full entity payload
5. `ShareResponse` returns share ID and version
6. Local `EntitySyncMetadata` updated (status=synced, version++)
7. `TeamShare` cached locally for quick status checks

## Selective Sharing

- `shareWithAll: true` — entire team has access (current + future members)
- `shareWithAll: false` — only members in `memberIds` list have access
- Permissions: `read` (view only), `write` (edit), `admin` (edit + re-share)
