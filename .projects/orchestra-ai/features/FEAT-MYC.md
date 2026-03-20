---
id: FEAT-MYC
kind: feature
priority: P1
project_slug: orchestra-ai
status: done
title: Sync Conflict Detection & Resolution
type: feature
---

# Sync Conflict Detection & Resolution

Handle merge conflicts when multiple team members edit the same entity:
- Conflict detection: Compare content hashes before push, detect version mismatches
- Conflict model: SyncConflict with local/remote versions, field-level diffs
- Resolution strategies: keep-local, keep-remote, merge (for text fields)
- Conflict UI: Bottom sheet showing side-by-side diff with resolution buttons
- Auto-resolve: Last-write-wins for non-text fields, manual merge for text content
- Mark entity as EntitySyncStatus.conflict until resolved


---
**in-progress -> in-testing** (2026-03-17T16:26:44Z):
## Changes
- apps/flutter/lib/core/sync/sync_conflict_models.dart (new — ConflictResolution enum, FieldDiff with text content detection, SyncConflict with local/remote data snapshots and field diffs, JSON round-trip serialization)
- apps/flutter/lib/core/sync/sync_conflict_resolver.dart (new — computeFieldDiffs, detectConflict with version/hash comparison, resolveKeepLocal/resolveKeepRemote/resolveMerge strategies, autoResolve for non-text fields, SyncConflictNotifier provider)
- apps/flutter/lib/widgets/sync_conflict_sheet.dart (new — bottom sheet UI showing field-level diffs with per-field local/remote toggles, version badges, Keep Local/Keep Remote/Merge action buttons)


---
**in-testing -> in-docs** (2026-03-17T16:29:39Z):
## Results
- apps/flutter/test/core/sync/sync_conflict_test.dart (37 tests, all passing)
  - ConflictResolution: fromString, toJson round-trip, unknown throws
  - FieldDiff: hasConflict, null handling, isTextContent, fromJson round-trip
  - SyncConflict: isOpen, conflictingFieldCount, hasTextConflicts, copyWith, fromJson round-trip with resolution
  - computeFieldDiffs: differing fields, local-only, remote-only, text detection, empty/identical maps
  - detectConflict: null for same version, matching hashes, identical data; conflict for diverged versions
  - Resolution strategies: keepLocal, keepRemote, merge with field choices, merge defaults
  - autoResolve: null for text conflicts, auto-resolve non-text
  - SyncConflictNotifier: add, resolve, get, clear


---
**in-docs -> in-review** (2026-03-17T16:30:28Z):
## Docs
- docs/sync-conflict-resolution.md (new — detection logic, text field classification, model schemas, resolution strategies table, auto-resolution rules, bottom sheet UI mockup, provider description, entity status lifecycle)


---
**Review (approved)** (2026-03-17T16:32:21Z): Approved. Conflict detection with auto-resolve for non-text, manual merge for text fields.
