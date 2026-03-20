---
id: FEAT-LVW
kind: feature
priority: P2
project_slug: orchestra-linux
status: backlog
title: Database query editor sub-tool
type: feature
---

# Database query editor sub-tool

Database sub-tool. Connection sidebar: saved connections (PostgreSQL, MySQL, SQLite) with AdwActionRow. Connect dialog: AdwDialog (type, host, port, database, user, password). Schema browser: GtkTreeListModel showing databases → tables → columns (type, nullable, default). Query editor: GtkSourceView with SQL syntax highlighting. Results panel: GtkColumnView (dynamic columns from query result). Query history popover. Export results as CSV via xdg-portal. Calls devtools.database tools: db_connect, db_disconnect, db_query, db_list_tables, db_describe_table, db_list_connections, db_export, db_import.