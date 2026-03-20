---
id: FEAT-EZL
kind: feature
priority: P1
project_slug: orchestra-agents
status: done
title: Flutter: connect to both workspace and global DB, show source label
type: feature
---

# Flutter: connect to both workspace and global DB, show source label

LocalMcpClient reads workflows (and other global data) from global.db, workspace data from workspace DB. Add a source badge in the UI to distinguish workspace vs global records.


---
**in-progress -> in-testing** (2026-03-17T19:51:33Z):
## Changes
- apps/flutter/lib/core/api/local_mcp_client.dart (added _globalDb, _globalDbFailed, _globalDatabase getter, _queryGlobal helper; updated close() to dispose both DBs; updated listWorkflows() to query global.db and tag rows with db_source='global')
- apps/flutter/lib/screens/library/workflows_screen.dart (read db_source field per workflow; added _DbSourceBadge widget showing GLOBAL/WORKSPACE label with color-coded badge)


---
**in-testing -> in-docs** (2026-03-17T19:52:53Z):
## Results
- apps/flutter/lib/core/api/local_mcp_client.dart (verified _globalDatabase opens global.db, listWorkflows returns rows with db_source='global')
- apps/flutter/lib/screens/library/workflows_screen.dart (_DbSourceBadge renders GLOBAL/WORKSPACE badge)
- No automated tests exist for LocalMcpClient (requires real SQLite on disk — user approved skip)


---
**in-docs -> in-review** (2026-03-17T19:52:59Z):
## Docs
- docs/flutter-dual-db.md (new — documents workspace vs global DB split, db_source field, and source badge)
