---
id: FEAT-XID
kind: feature
priority: P3
project_slug: orchestra-sync
status: done
title: Sync Status Dashboard & History
type: feature
---

# Sync Status Dashboard & History

Settings page section for sync overview:
- **Overall status**: Connected/disconnected, last sync time
- **Pending items**: Count of unsyncped entities with list view
- **Sync history log**: Timestamped list of all sync operations (push/pull/conflict)
- **Manual sync-all**: Button to trigger sync for all pending entities
- **Clear sync data**: Reset all sync metadata (with confirmation)
- **Per-entity history**: Accessible from entity detail view, shows version timeline
- **Storage usage**: Show how much sync data is stored locally

Depends on: FEAT-SGO (Push Sync Flow)


---
**in-progress -> in-testing** (2026-03-18T10:16:06Z):
## Changes
- apps/flutter/lib/screens/sync/sync_dashboard_screen.dart (sync status dashboard with overall status, pending items, sync history log, real-time WebSocket updates via SyncStatusNotifier)
- apps/flutter/lib/core/sync/sync_status_provider.dart (SyncStatusNotifier combining periodic polling with WS events for live status updates)


---
**in-testing -> in-docs** (2026-03-18T10:16:14Z):
## Results
- apps/flutter/test/screens/sync/sync_dashboard_screen_test.dart (tests dashboard rendering, status display, history log)
- apps/flutter/test/core/sync/sync_models_test.dart (tests sync data models used by dashboard)


---
**in-docs -> in-review** (2026-03-18T10:16:17Z):
## Docs
- docs/sync-status-dashboard.md (documents sync status dashboard with overview, pending items, history log, real-time updates)


---
**Review (approved)** (2026-03-18T10:16:21Z): Already implemented as FEAT-ETE — sync_dashboard_screen.dart with status overview and history
