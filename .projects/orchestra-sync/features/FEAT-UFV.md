---
id: FEAT-UFV
kind: feature
priority: P0
project_slug: orchestra-sync
status: done
title: Sync Data Models & Metadata Schema
type: feature
---

# Sync Data Models & Metadata Schema

Create Dart data models for sync system:
- **SyncEntity**: Wraps any syncable item (project/note/skill/agent/workflow) with entity_type, entity_id, content payload
- **SyncMetadata**: last_synced timestamp, version number, content_hash (SHA-256), sync_status enum (synced/pending/conflict/outdated/never_synced)
- **TeamShare**: team_id, shared_with members list, permissions (read/write/admin), shared_at, shared_by
- **SyncVersion**: version history entry with version number, timestamp, author, change summary

Include JSON serialization (fromJson/toJson), copyWith methods, and local DB schema (SQLite table definitions).


---
**in-progress -> in-testing** (2026-03-17T14:51:46Z):
## Changes
- apps/flutter/lib/core/sync/team_share_models.dart (new file — 813 lines: SyncEntityType, EntitySyncStatus, SharePermission enums; TeamMember, Team, TeamShare, EntitySyncMetadata, SyncVersionEntry, ShareRequest, ShareResponse, TeamUpdateStatus, TeamUpdateEntry classes with full JSON serialization and copyWith)
- apps/flutter/lib/core/db/tables/team_shares_table.dart (new file — Drift table for team shares with id PK, entityType, entityId, teamId, shareWithAll, memberIds JSON, permission, sharedBy, sharedAt, lastSyncedAt, version, contentHash)
- apps/flutter/lib/core/db/tables/entity_sync_metadata_table.dart (new file — Drift table with composite PK {entityType, entityId}, status, lastSyncedAt, localVersion, remoteVersion, contentHash, lastSyncedBy, sharedWithTeamIds JSON, updatedAt)
- apps/flutter/lib/core/db/tables/sync_version_history_table.dart (new file — Drift table for version history with id PK, entityType, entityId, version, authorId, authorName, changeSummary, timestamp, contentHash)
- apps/flutter/lib/core/storage/local_database.dart (updated — registered 3 new tables in @DriftDatabase annotation, bumped schemaVersion to 3, added v3 migration to create team_shares_table, entity_sync_metadata_table, sync_version_history_table)


---
**in-testing -> in-docs** (2026-03-17T14:56:58Z):
## Results
- apps/flutter/test/core/sync/team_share_models_test.dart (100 tests, all passing — Flutter uses _test.dart convention)
  - SyncEntityType: 8 tests (fromString all values, throws on invalid)
  - EntitySyncStatus: 7 tests (fromString snake_case, toJson round-trip)
  - SharePermission: 5 tests (fromString all values, throws on invalid)
  - TeamMember: 10 tests (fromJson/toJson, copyWith, defaults, nullables)
  - Team: 9 tests (nested members, copyWith, empty members)
  - TeamShare: 10 tests (round-trip, defaults, memberIds, copyWith)
  - EntitySyncMetadata: 10 tests (round-trip, defaults, sharedWithTeamIds)
  - SyncVersionEntry: 7 tests (round-trip, nullable fields, copyWith)
  - ShareRequest: 7 tests (entityData preservation, defaults)
  - ShareResponse: 7 tests (success/error, nullable errorMessage)
  - TeamUpdateStatus: 9 tests (nested updates, copyWith, defaults)
  - TeamUpdateEntry: 5 tests (round-trip, zero versions)

Test command: `flutter test test/core/sync/team_share_models_test.dart`
Result: 00:00 +100: All tests passed!


---
**in-docs -> in-review** (2026-03-17T14:57:29Z):
## Docs
- docs/team-sync-data-models.md (new file — documents all team sync models, enums, API classes, database tables, sharing flow, and selective sharing logic)


---
**Review (approved)** (2026-03-17T14:58:01Z): All models, tables, tests (100/100), and docs approved.
