---
id: FEAT-IHW
kind: feature
priority: P1
project_slug: orchestra-tools
status: done
title: Database manager (devtools.database)
type: feature
---

# Database manager (devtools.database)

Tools: db_connect, db_disconnect, db_query, db_list_tables, db_describe_table, db_list_connections, db_export (CSV/JSON), db_import. Uses database/sql with drivers: lib/pq (Postgres), go-sql-driver/mysql, mattn/go-sqlite3.


---
**in-progress -> ready-for-testing**: Build: go build ./libs/plugin-devtools-database/... → BUILD OK. Tests: GONOSUMCHECK='*' go test ./libs/plugin-devtools-database/... → ok (all tests pass). 8 tools: db_connect, db_disconnect, db_query, db_list_tables, db_describe_table, db_list_connections, db_export (CSV/JSON), db_import. Pure-Go SQLite via modernc.org/sqlite (no CGO). Manager pattern with thread-safe connection map. 21 tests covering all tools with happy path + error cases including export/import round-trip.


---
**in-testing -> ready-for-docs**: 21 tests covering: db_connect (unsupported driver, missing dsn, sqlite in-memory), db_disconnect (not found, success, double disconnect), db_query (select 3 rows, no rows, missing connection_id), db_list_tables (with tables, empty db), db_describe_table (success with column names, nonexistent table), db_list_connections (empty, one connection), db_export (CSV + JSON + invalid format), db_import (CSV + JSON + unknown extension), and a full export→import round-trip that verifies row count via SQL COUNT(*).


---
**in-docs -> documented**: Plugin documented in cmd/main.go (binary=devtools-database, description="Database devtools — connect, query, inspect, import/export"). db/manager.go has docstrings on all public methods. Tools documented with format enums (csv/json), driver enum, schema param (postgres). db_import auto-detects format from .csv/.json extension.


---
**in-review -> done**: Code quality review: (1) Manager.Connect validates driver name before calling sql.Open — no panic on unsupported driver. (2) Thread-safe: sync.RWMutex with RLock for Get/List, Lock for Connect/Disconnect. (3) Query scans into []any via pointer-to-interface and converts []byte→string for JSON safety. (4) exportCSV collects columns from all rows (union) and sorts them — deterministic output regardless of map iteration order. (5) db_import uses parameterized queries with ? placeholders (? for sqlite/mysql, $N for postgres) — no SQL injection risk. (6) db_list_tables/describe_table have driver-specific switch with explicit default error — never silently returns wrong query for unknown driver. (7) generateID uses crypto/rand — no collisions. (8) All resources closed (defer conn.DB.Close, defer rows.Close, defer f.Close). Clean architecture.