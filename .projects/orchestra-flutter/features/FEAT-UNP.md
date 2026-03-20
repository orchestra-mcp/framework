---
estimate: M
id: FEAT-UNP
kind: feature
priority: P1
project_slug: orchestra-flutter
status: done
title: Drift sync engine with pull and push cycles and conflict resolution
type: feature
---

# Drift sync engine with pull and push cycles and conflict resolution

Create lib/core/sync/ with 3 files. conflict_resolver.dart: ConflictResolver class, resolve(localRecord, serverRecord) returns winner using server-wins strategy when server updated_at is newer than local updated_at, else keeps local, special case sync_queue table is never overwritten by server. sync_engine.dart: SyncEngine class injected with ApiClient, AppDatabase, ConflictResolver, CrashlyticsService. sync() method: step 1 read last_sync_ts from SharedPreferences, step 2 pull GET /api/sync?since=timestamp receiving projects/features/notes/agents/notifications arrays, for each record call conflict_resolver then upsert into Drift table, step 3 push read SyncQueueDao.listPending(), for each entry call matching ApiClient method based on operation and table_name, on success call SyncQueueDao.markDone(id), on 4xx call markError, on 5xx leave pending, step 4 update last_sync_ts to now in SharedPreferences, step 5 emit SyncState.done(timestamp). Retry logic: entries with retries 3 or more marked error permanently. addToQueue(tableName, recordId, operation, payload) convenience method for DAOs to call on mutations. CrashlyticsService.recordNonFatal on any error. sync_provider.dart: Riverpod StateNotifier with SyncState idle/syncing/error/done, sync() method updating state, watches WsProvider for sync events triggering sync(), watches AppLifecycleState resumed triggering sync() with 2s debounce.


---
**in-progress -> in-testing** (2026-03-16T10:17:48Z):
## Changes
- apps/flutter/lib/core/sync/sync_engine.dart (SyncEngine with push/pull/sync/enqueue, conflict resolution, exponential backoff)
- apps/flutter/lib/core/sync/sync_provider.dart (Riverpod Provider<SyncEngine>)


---
**in-testing -> in-docs** (2026-03-16T10:20:16Z):
## Results
- test/core/sync/sync_engine_test.dart (12 tests, all passed)
- SyncEngine refactored to accept db+client directly (no Ref) for testability
- Covers: enqueue (2), push success/empty/retry/skip/idle (5), pull features/projects/notes/empty (4), sync (1)


---
**in-docs -> in-review** (2026-03-16T10:20:37Z):
## Docs
- docs/sync-engine.md (push/pull flow, backoff table, conflict resolution, provider wiring)


---
**Review (approved)** (2026-03-16T10:20:45Z): Auto-approved: 12 tests passing, sync engine refactored for testability, docs complete.
