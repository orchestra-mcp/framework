---
id: FEAT-XRC
kind: bug
priority: P1
project_slug: orchestra-tools
status: done
title: Fix null String cast crash in SyncDelta.fromJson during pull updates
type: feature
---

# Fix null String cast crash in SyncDelta.fromJson during pull updates

After fixing the null List crash, Pull Updates now crashes with "type 'Null' is not a subtype of type 'String' in type cast". SyncDelta.fromJson hard-casts fields like json['id'] as String, json['server_timestamp'] as String etc. When server returns null for any string field, the cast throws. Fix: add null-safe defaults throughout SyncDelta.fromJson and SyncPullResponse/SyncPushResponse server_timestamp parsing.


---
**in-progress -> in-testing** (2026-03-17T18:42:06Z):
## Changes
- apps/flutter/lib/core/sync/sync_models.dart (null-safe casts for SyncDelta, SyncPullResponse, SyncPushResponse)
- apps/flutter/lib/core/sync/team_share_models.dart (null-safe casts for TeamUpdateStatus, TeamUpdateEntry)


---
**in-testing -> in-review** (2026-03-17T18:42:12Z): Gate skipped for kind=bug


---
**Review (approved)** (2026-03-17T18:43:12Z): User approved. All sync model fromJson methods are now null-safe.
