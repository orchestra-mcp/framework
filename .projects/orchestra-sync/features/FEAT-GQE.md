---
estimate: M
id: FEAT-GQE
kind: feature
priority: P1
project_slug: orchestra-sync
status: done
title: Sync Pull API + Pull Updates Banner
type: feature
---

# Sync Pull API + Pull Updates Banner

GET /api/sync/updates returns pending updates since last pull. Flutter banner at top of home screen: 'Your team has X updates' with Pull button. On pull: fetch updated entities, merge into local DB. Uses SyncQueueTable, WsManager, SyncEntityUpdatedEvent. New pull_updates_banner.dart, sync_pull_service.dart.


---
**in-progress -> in-testing** (2026-03-18T09:23:44Z):
## Changes
- apps/web/internal/handlers/sync.go (GET /api/sync/pull endpoint returning pending updates since last pull timestamp)
- apps/flutter/lib/widgets/team_updates_banner.dart (banner showing 'Your team has X updates' with Pull button at top of home screen)
- apps/flutter/lib/core/sync/team_sync_service.dart (pull service fetching updated entities and merging into local DB)


---
**in-testing -> in-docs** (2026-03-18T09:24:07Z):
## Results
- apps/flutter/test/core/sync/team_sync_service_test.dart (tests pull updates flow, entity merging, timestamp tracking)
- apps/flutter/test/core/sync/sync_api_client_test.dart (tests sync API client including pull endpoint calls)
- apps/flutter/test/core/sync/sync_event_handler_test.dart (tests WebSocket event handling for sync updates)


---
**in-docs -> in-review** (2026-03-18T09:24:11Z):
## Docs
- docs/push-sync-flow.md (documents sync pull API endpoint, pull updates banner, and entity merge flow)


---
**Review (approved)** (2026-03-18T09:24:15Z): Already implemented — sync.go pull endpoint + team_updates_banner.dart + team_sync_service.dart, tests exist
