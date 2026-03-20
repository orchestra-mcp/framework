# Database Browser — Flutter Screen

3-pane layout for connecting to databases, browsing schemas, and running SQL queries.

## Layout

### Desktop (3 panes)
```
┌──────────────┬─────────────────────────┬──────────────────┐
│ Connections  │   Schema Viewer         │  Query Results    │
│ (250px)      │   (flex)                │  (350px)          │
│              │                         │                   │
│ [+ Connect]  │   Table: users          │  2 rows · 12ms    │
│              │   ┌─────────────────┐   │  ┌──────────────┐│
│ ● postgres   │   │ 🔑 id   uuid   │   │  │ id │ name   ││
│   ├ users    │   │    name text    │   │  │ 1  │ Alice  ││
│   ├ orders   │   │    email text   │   │  │ 2  │ Bob    ││
│   └ products │   └─────────────────┘   │  └──────────────┘│
│              │                         │                   │
│              │   SQL Query             │                   │
│              │   ┌─────────────────┐   │                   │
│              │   │ SELECT * FROM   │   │                   │
│              │   │ users LIMIT 10  │   │                   │
│              │   └────────[Run]────┘   │                   │
└──────────────┴─────────────────────────┴──────────────────┘
```

### Mobile (tabbed)
- Connection picker dropdown at top
- 3 tabs: Schema (table list → column details), Query (editor + run), Results

## Features

- **Connect dialog**: Driver dropdown (postgres, sqlite, mysql, mongodb, redis) with driver-specific DSN placeholder hints
- **Connections sidebar**: Driver icon (color-coded), DSN, status dot, disconnect button, expandable table list
- **Schema viewer**: Column name (bold), type badge (monospace, accent), NOT NULL badge, PK badge, default value, "SELECT *" shortcut button
- **Query editor**: Monospace multiline TextField with Run button (shows spinner while querying)
- **Results table**: Scrollable DataTable with column headers, NULL values in dim italic, row count + duration badges
- **Error handling**: Query errors shown in results pane with red icon

## Supported Drivers
| Driver | Icon Color | DSN Example |
|--------|-----------|-------------|
| postgres | Blue | `postgres://user:pass@localhost:5432/dbname` |
| sqlite | Amber | `/path/to/database.db` |
| mysql | Orange | `mysql://user:pass@localhost:3306/dbname` |
| mongodb | Green | `mongodb://localhost:27017/dbname` |
| redis | Red | `redis://localhost:6379` |

## Files
- `apps/flutter/lib/screens/devtools/database_browser_screen.dart` (1525 lines)
- `apps/flutter/test/screens/devtools/database_browser_screen_test.dart` (13 tests)
