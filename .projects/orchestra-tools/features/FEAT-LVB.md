---
id: FEAT-LVB
kind: bug
priority: P1
project_slug: orchestra-tools
status: done
title: Fix null cast crash in sync models when pulling updates
type: feature
---

# Fix null cast crash in sync models when pulling updates

Pull Updates banner crashes with "type 'Null' is not a subtype of type 'List<dynamic>' in type cast". Three unsafe `as List` casts in sync_models.dart (lines 146, 175, 268) crash when the server returns null for list fields. Fix: use `as List? ?? []` pattern consistently.


---
**in-progress -> in-testing** (2026-03-17T18:23:06Z):
## Changes
- apps/flutter/lib/core/sync/sync_models.dart (fixed 3 unsafe `as List` casts to `as List? ?? []` — lines 146, 175, 268 in SyncPushRequest.fromJson, SyncPushResponse.fromJson, SyncPullResponse.fromJson)


---
**in-testing -> in-review** (2026-03-17T18:25:52Z): Gate skipped for kind=bug


---
**Review (approved)** (2026-03-17T18:26:37Z): User approved. Null-safe list parsing fixes the Pull Updates crash.
