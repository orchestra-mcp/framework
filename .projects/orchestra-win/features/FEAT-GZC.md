---
id: FEAT-GZC
kind: feature
priority: P2
project_slug: orchestra-win
status: backlog
title: Database sub-plugin — SQL query editor + schema browser
type: feature
---

# Database sub-plugin — SQL query editor + schema browser

Implement `Orchestra.Desktop/Plugins/DevToolsPlugin/Database/` — multi-database query editor and schema explorer.

**`DatabasePage.xaml`** — three-panel IDE layout:
- Left: `SchemaTree` (`TreeView` — connections > databases > schemas > tables > columns/indexes/constraints)
- Center: SQL editor (`WebView2` + Monaco with SQL language support), Run (F5) / Run Selection, results below
- Right: `TableDetailPanel` — column definitions, indexes, foreign keys, row count, DDL

**Connection manager:** saved connections list with add/edit/delete. Types: PostgreSQL, MySQL/MariaDB, SQLite (file picker), SQL Server, Redis (key browser mode)

**`QueryResultGrid`** — `DataGrid` (WinUI Community Toolkit) with: pagination, column sort, copy cell/row/all, export CSV/JSON, NULL display as `[NULL]` in gray

**Query history:** last 100 queries per connection, searchable, replayable

**`DatabaseService.cs`** — dispatches to correct ADO.NET provider: `Npgsql` (PostgreSQL), `MySqlConnector`, `Microsoft.Data.Sqlite`, `Microsoft.Data.SqlClient`

**MCP tools called:** `db_query`, `db_list_tables`, `db_describe_table`, `db_list_databases`, `db_list_connections`, `db_add_connection`, `db_explain`, `db_export`

**Platform:** Desktop, HoloLens