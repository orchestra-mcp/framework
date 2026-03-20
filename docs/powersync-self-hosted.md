# PowerSync Self-Hosted Setup

## Overview

Orchestra uses PowerSync for offline-first, realtime data sync across all devices (Flutter desktop, iOS, Android, Web, Next.js). PowerSync connects to our PostgreSQL database and provides local SQLite/IndexedDB on each client with automatic bidirectional sync.

## Architecture

```
PostgreSQL 16 (wal_level=logical)
    ↕ replication
PowerSync Service (Docker, port 8585)
    ↕ sync protocol
Caddy reverse proxy (sync.orchestra-mcp.dev)
    ↕ HTTPS
┌─────────┬─────────┬──────────┬─────────┐
│ Flutter │   iOS   │ Android  │   Web   │
│ Desktop │         │          │         │
│ SQLite  │ SQLite  │  SQLite  │IndexedDB│
└─────────┴─────────┴──────────┴─────────┘
```

## Deployment

PowerSync is automatically installed by `scripts/deploy/setup-server.sh`:

1. Enables PostgreSQL logical replication (`wal_level=logical`)
2. Creates `powersync_storage` database for bucket metadata
3. Installs Docker
4. Copies config files to `/opt/orchestra/powersync/`
5. Starts PowerSync container via Docker Compose
6. Configures Caddy reverse proxy at `sync.orchestra-mcp.dev`

## Configuration Files

| File | Purpose |
|------|---------|
| `scripts/deploy/powersync/powersync.yaml` | Service config — PostgreSQL connection, auth, port |
| `scripts/deploy/powersync/sync-rules.yaml` | Sync rules — 13 bucket definitions with row-level security |
| `scripts/deploy/powersync/docker-compose.yml` | Docker container setup |

## Sync Rules

13 per-user buckets + 1 team-shared bucket:

| Bucket | Tables | Security |
|--------|--------|----------|
| `user_health` | hydration, caffeine, nutrition, pomodoro, shutdown, weight, sleep, vitals, settings | `user_id` |
| `user_notes` | notes | `user_id` |
| `user_projects` | projects | `user_id` |
| `user_features` | features | `user_id` |
| `user_agents` | agents | `user_id` |
| `user_skills` | skills | `user_id` |
| `user_workflows` | workflows | `user_id` |
| `user_docs` | docs | `user_id` |
| `user_delegations` | delegations | `from_user_id` OR `to_user_id` |
| `user_sessions` | sessions | `user_id` |
| `user_settings` | user_settings | `user_id` |
| `team_data` | projects, notes (team-scoped) | `team_id` via team_members |

## Authentication

PowerSync verifies client JWTs via JWKS endpoint at `/api/powersync/keys` on the Orchestra backend. The JWT must contain a `user_id` claim for row-level security.

## Management

```bash
# Check status
docker compose -f /opt/orchestra/powersync/docker-compose.yml ps

# View logs
docker compose -f /opt/orchestra/powersync/docker-compose.yml logs -f

# Restart
docker compose -f /opt/orchestra/powersync/docker-compose.yml restart

# Update sync rules (edit sync-rules.yaml, then restart)
docker compose -f /opt/orchestra/powersync/docker-compose.yml restart
```

## Database Migration

Run the migration before starting PowerSync:
```bash
psql -U orchestra -d orchestra_web -f /opt/orchestra/powersync/migrations/001_powersync_tables.sql
```

This creates all health tables and enables the `powersync` publication for logical replication.

## Authentication Flow

```
Client App → POST /api/powersync/token (with session JWT)
  ← { token: "<RS256 JWT>", expires_at: ... }
Client App → PowerSync.connect(token)
PowerSync → GET /api/powersync/keys (JWKS)
  ← { keys: [{ kty: RSA, kid: powersync-1, ... }] }
PowerSync verifies token → grants sync access
```

**Endpoints:**
- `GET /api/powersync/keys` — Public JWKS endpoint (RS256 public key)
- `POST /api/powersync/token` — Authenticated, returns 1-hour PowerSync JWT with `user_id` claim

## Health Data Sync (PowerSync)

All 5 health managers are backed by PowerSync watched queries:

| Manager | Table | Watch Query | Mutation |
|---------|-------|-------------|----------|
| HydrationNotifier | `health_hydration` | Today's entries | `addWater(ml)` → INSERT |
| CaffeineNotifier | `health_caffeine` | Today's entries | `addCaffeine(type)` → INSERT |
| NutritionNotifier | `health_nutrition` | Today's entries | `logMeal(food, spoons)` → INSERT |
| PomodoroNotifier | `health_pomodoro` | Today's sessions | `startWork()` → INSERT, `_endSession()` → UPDATE |
| ShutdownNotifier | `health_shutdown` | Latest session | `startShutdown()` → INSERT, tasks → UPDATE |

**How it works:**
1. Each manager calls `_db.watch(sql)` in `build()` — streams results from local SQLite
2. Mutations write to local SQLite via `_db.execute(INSERT/UPDATE)`
3. PowerSync auto-uploads changes to PostgreSQL via the backend connector
4. Other devices receive changes via PowerSync sync protocol
5. Their watched queries automatically emit new results → UI rebuilds

No polling. No WebSocket broadcast. No pull-to-refresh needed.

## App Data Sync (PowerSync)

All library entities are backed by PowerSync StreamProviders:

| Provider | Table | Query |
|----------|-------|-------|
| `agentsProvider` | `agents` | `SELECT * FROM agents ORDER BY updated_at DESC` |
| `skillsProvider` | `skills` | `SELECT * FROM skills ORDER BY updated_at DESC` |
| `workflowsProvider` | `workflows` | `SELECT * FROM workflows ORDER BY updated_at DESC` |
| `docsProvider` | `docs` | `SELECT * FROM docs ORDER BY updated_at DESC` |
| `delegationsProvider` | `delegations` | `SELECT * FROM delegations ORDER BY updated_at DESC` |

Additional synced providers in `sync_providers.dart`: notes, projects, features, sessions, user_settings.

All use `db.watch()` so changes propagate to UI instantly — no refresh needed.

## Flutter SDK Integration

**Files:**
- `lib/core/powersync/schema.dart` — 19-table SQLite schema
- `lib/core/powersync/connector.dart` — Auth + CRUD backend connector
- `lib/core/powersync/powersync_provider.dart` — Riverpod providers

**Usage:**
```dart
// Watch the database
final db = ref.watch(powersyncDatabaseProvider);

// Reactive query (auto-updates when data changes locally or via sync)
final notes = ref.watch(powersyncWatchProvider(
  ('SELECT * FROM notes WHERE user_id = ?', [userId]),
));

// Write (syncs to all devices automatically)
await db.execute(
  'INSERT INTO notes(id, user_id, title, content) VALUES(uuid(), ?, ?, ?)',
  [userId, 'My Note', 'Content here'],
);
```

**Build flags:**
```bash
flutter run --dart-define=POWERSYNC_URL=https://sync.orchestra-mcp.dev
```

## Client URLs

| Environment | PowerSync URL |
|-------------|---------------|
| Production | `https://sync.orchestra-mcp.dev` |
| Local dev | `http://localhost:8585` |
