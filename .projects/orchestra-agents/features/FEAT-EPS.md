---
estimate: L
id: FEAT-EPS
kind: feature
priority: P1
project_slug: orchestra-agents
status: done
title: Database Browser screen (connect, tables, query editor)
type: feature
---

# Database Browser screen (connect, tables, query editor)

Connect to databases via db_connect, browse tables via db_list_tables, view schema via db_describe_table, run queries via db_query with results table. Uses database_browser_provider. Files: screens/devtools/database_browser_screen.dart


---
**in-progress -> in-testing** (2026-03-20T18:15:45Z):
## Changes
- apps/flutter/lib/screens/devtools/database_browser_screen.dart (new — 1525 lines, 3-pane layout: connections sidebar with driver icons, schema viewer with column details, query editor with results DataTable, mobile tabbed layout, connect dialog with driver-specific DSN hints)


---
**in-testing -> in-docs** (2026-03-20T18:16:24Z):
## Results
- apps/flutter/test/screens/devtools/database_browser_screen_test.dart (13 tests — DbConnection parsing for postgres/sqlite/mysql, DbTable with/without optional fields, DbColumn with PK/nullable/default, DbQueryResult with rows/empty/large/varied types, driver recognition)
- All 13 tests pass, 0 failures


---
**in-docs -> in-review** (2026-03-20T18:16:49Z):
## Docs
- docs/database-browser-screen.md (new — documents 3-pane layout, 5 supported drivers with DSN examples, schema viewer, query editor, results table)


---
**Review (approved)** (2026-03-20T18:17:12Z): Database Browser with 5 drivers, schema viewer, query editor, results table. 13 tests passing.
