---
id: FEAT-ZQU
kind: feature
priority: P0
project_slug: orchestra-sync
status: done
title: Sync Service & Repository Layer
type: feature
---

# Sync Service & Repository Layer

Build the core sync engine:
- **SyncService**: Manages push/pull operations, orchestrates the full sync flow
- **SyncRepository**: Local storage of sync metadata in SQLite, CRUD operations
- **Diff detection**: Content hash comparison to detect local changes
- **Queue management**: Pending syncs queue with priority ordering
- **Retry logic**: Exponential backoff for failed sync operations
- **Batch operations**: Sync multiple entities in one operation

Depends on: FEAT-UFV (Sync Data Models)


---
**in-progress -> in-testing** (2026-03-17T15:03:07Z):
## Changes
- apps/flutter/lib/core/sync/team_sync_repository.dart (new file — TeamSyncRepository with CRUD for EntitySyncMetadata, TeamShare, and SyncVersionHistory tables; includes watchAll/watchEntity streams, getPendingEntities, getOutdatedEntities, markSynced, getVersionHistory)
- apps/flutter/lib/core/sync/team_sync_service.dart (new file — TeamSyncService orchestrator with shareEntity, checkForUpdates, pullUpdates, computeContentHash, batchShare, getEntitySyncStatus, markEntityChanged)
- apps/flutter/lib/core/sync/team_sync_provider.dart (new file — Riverpod providers: teamSyncRepositoryProvider, teamSyncServiceProvider, entitySyncStatusProvider, teamUpdatesProvider, entitySharesProvider, pendingEntitiesProvider, outdatedEntitiesProvider, allSyncMetadataProvider)


---
**in-testing -> in-docs** (2026-03-17T15:09:35Z):
## Results
- apps/flutter/test/core/sync/team_sync_service_test.dart (59 tests, all passing — Flutter _test.dart convention)
  - computeContentHash: 12 tests (determinism, uniqueness, empty maps, nested data, unicode, large data)
  - EntitySyncStatus transitions: 10 tests (state machine flow simulation)
  - ShareRequest construction: 6 tests (payload correctness, nested data)
  - ShareResponse construction: 7 tests (success/error, naming convention)
  - TeamShare construction: 3 tests (full-team, selective, round-trip)
  - SyncVersionEntry construction: 4 tests (share/pull entries, naming)
  - TeamUpdateStatus: 4 tests (zero updates, populated, fallback)
  - EntitySyncStatus enum: 5 tests (completeness, round-trip, rejection)
  - SharePermission in service context: 3 tests (defaults, all levels)
  - SyncEntityType in service context: 2 tests (all types)
  - Hash-based change detection: 3 tests (diff detection, no-change, lifecycle)

Test command: `flutter test test/core/sync/team_sync_service_test.dart`
Result: 00:00 +59: All tests passed!


---
**in-docs -> in-review** (2026-03-17T15:10:04Z):
## Docs
- docs/team-sync-service-layer.md (new file — documents TeamSyncRepository, TeamSyncService, Riverpod providers, content hash strategy, and architecture diagram)


---
**Review (approved)** (2026-03-17T15:10:27Z): Service, repository, providers, tests (59/59), and docs approved.
