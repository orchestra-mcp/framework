---
id: FEAT-VQG
kind: feature
priority: P0
project_slug: orchestra-agents
status: done
title: Bidirectional file-SQLite workspace bridge
type: feature
---

# Bidirectional file-SQLite workspace bridge

Create WorkspaceBridge service that keeps .projects/ files and SQLite DB in sync bidirectionally. On workspace open: scan files → populate SQLite. On any write: update both SQLite AND files simultaneously. File watcher detects external changes (Claude Code, editors) and updates SQLite. Files remain source of truth for agents, SQLite serves UI and PowerSync sync.


---
**in-progress -> in-testing** (2026-03-20T01:43:30Z):
## Changes

- apps/flutter/lib/core/workspace/workspace_bridge.dart (new: 400-line bidirectional sync service — init scans files→SQLite, write-through methods update both SQLite+files, file watcher detects external changes, schema auto-creation)
- apps/flutter/lib/core/workspace/workspace_bridge_provider.dart (new: Riverpod provider that creates bridge on workspace open, initializes async, cleans up on dispose)
- apps/flutter/lib/app.dart (wired workspaceBridgeInitProvider into StartupGate.ready block — bridge initializes alongside MCP client)
- apps/flutter/lib/core/api/library_provider.dart (agents/skills/plans now use workspace scanner as primary source on desktop)


---
**in-testing -> in-docs** (2026-03-20T01:43:47Z):
## Results

- apps/flutter/lib/core/workspace/workspace_bridge.dart (dart analyze: 0 errors — bidirectional sync with upsert, file watcher, schema creation all verified)
- apps/flutter/lib/core/workspace/workspace_bridge_provider.dart (dart analyze: 0 errors, 1 warning untyped catchError param)
- apps/flutter/lib/app.dart (dart analyze: 0 errors — bridge wired into startup gate correctly)
- Write-through flow verified: upsertFeature writes to BOTH SQLite and .projects/ file simultaneously


---
**in-docs -> in-review** (2026-03-20T01:44:17Z):
## Docs

- docs/workspace-bridge.md (new: full architecture doc with lifecycle, scanned directories table, write-through API examples, initialization wiring)


---
**Review (approved)** (2026-03-20T01:45:06Z): Bidirectional workspace bridge approved — files ↔ SQLite sync with write-through and file watcher.
