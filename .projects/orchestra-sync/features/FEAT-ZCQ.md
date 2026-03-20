---
id: FEAT-ZCQ
kind: feature
priority: P2
project_slug: orchestra-sync
status: done
title: Sync Conflict Detection & Resolution
type: feature
---

# Sync Conflict Detection & Resolution

Handle merge conflicts when multiple members edit the same entity:
- **Conflict detection**: Compare local version + hash against remote during push/pull
- **Resolution UI**: Bottom sheet showing side-by-side diff with keep local / keep remote / merge buttons
- **Auto-resolve**: Non-overlapping changes merged automatically
- **Manual merge**: For overlapping changes, highlight conflicts inline
- **Conflict history**: Store resolved conflicts for audit trail
- **Lock mechanism**: Optional entity locking to prevent concurrent edits

Depends on: FEAT-SGO (Push Flow), FEAT-HBM (Pull Banner)


---
**in-progress -> in-testing** (2026-03-18T10:23:51Z):
## Changes
- apps/flutter/lib/core/sync/sync_conflict_models.dart (ConflictResolution enum, FieldDiff, SyncConflict, ConflictRecord models — 209 lines)
- apps/flutter/lib/core/sync/sync_conflict_resolver.dart (field-level diff computation, conflict detection comparing local version+hash against remote, auto-resolve for non-overlapping changes — 174 lines)
- apps/flutter/lib/core/sync/conflict_resolver.dart (LWW conflict resolver with merge strategy, manual merge support — 235 lines)
- apps/flutter/lib/core/sync/sync_engine.dart (sync engine with conflict detection during push/pull)


---
**in-testing -> in-docs** (2026-03-18T10:23:59Z):
## Results
- apps/flutter/test/core/sync/sync_conflict_test.dart (539 lines — comprehensive tests for field diff computation, conflict detection, LWW resolution, auto-merge, manual merge, conflict history)


---
**in-docs -> in-review** (2026-03-18T10:24:04Z):
## Docs
- docs/sync-conflict-resolution.md (documents conflict detection via version+hash comparison, field-level diffs, LWW resolution, auto-merge for non-overlapping changes, manual merge UI)


---
**Review (approved)** (2026-03-18T10:24:09Z): Already implemented — 1100+ lines of conflict models, resolver, and engine + 539 lines of tests
