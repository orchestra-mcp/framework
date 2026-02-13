---
name: database-sync
description: Database design and sync system patterns. Activates when working with PostgreSQL schemas, SQLite local storage, sync protocol, Redis pub/sub, migrations, conflict resolution, or any data layer code.
---

# Database & Sync System

Orchestra MCP uses a three-layer database strategy: PostgreSQL (cloud source of truth), SQLite (local offline), Redis (real-time pub/sub and cache).

## Three-Layer Architecture

```
Client (Desktop/Mobile/Extension)
  └── SQLite (local) ──WebSocket──▶ Go Backend
                                      ├── PostgreSQL (cloud)
                                      └── Redis (pub/sub + cache)
```

## PostgreSQL Schema (Cloud — Source of Truth)

Location: `database/migrations/*.sql`

### Core Tables

```sql
-- 001_create_users.sql
CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    email VARCHAR(255) UNIQUE NOT NULL,
    name VARCHAR(255) NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    avatar_url TEXT,
    plan VARCHAR(50) DEFAULT 'free',
    settings JSONB DEFAULT '{}',
    email_verified_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    deleted_at TIMESTAMPTZ
);

-- 002_create_projects.sql
CREATE TABLE projects (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    name VARCHAR(255) NOT NULL,
    path TEXT,
    settings JSONB DEFAULT '{}',
    last_synced_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    deleted_at TIMESTAMPTZ
);
CREATE INDEX idx_projects_user ON projects(user_id);

-- 003_create_files.sql
CREATE TABLE files (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    project_id UUID NOT NULL REFERENCES projects(id) ON DELETE CASCADE,
    path TEXT NOT NULL,
    content_hash VARCHAR(64),
    size_bytes BIGINT DEFAULT 0,
    language VARCHAR(50),
    metadata JSONB DEFAULT '{}',
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);
CREATE INDEX idx_files_project ON files(project_id);
CREATE INDEX idx_files_path ON files(project_id, path);

-- 004_create_sync_log.sql
CREATE TABLE sync_log (
    id BIGSERIAL PRIMARY KEY,
    user_id UUID NOT NULL REFERENCES users(id),
    entity_type VARCHAR(50) NOT NULL,
    entity_id UUID NOT NULL,
    action VARCHAR(20) NOT NULL,  -- create, update, delete
    version BIGINT NOT NULL,
    device_id VARCHAR(100) NOT NULL,
    data JSONB,
    checksum VARCHAR(64),
    created_at TIMESTAMPTZ DEFAULT NOW()
) PARTITION BY RANGE (created_at);
CREATE INDEX idx_sync_user_version ON sync_log(user_id, version);
CREATE INDEX idx_sync_entity ON sync_log(entity_type, entity_id);

-- 005_create_subscriptions.sql
CREATE TABLE subscriptions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id),
    stripe_customer_id VARCHAR(255),
    stripe_subscription_id VARCHAR(255),
    plan VARCHAR(50) NOT NULL,
    status VARCHAR(50) NOT NULL,  -- active, cancelled, past_due
    current_period_end TIMESTAMPTZ,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- 006_create_ai_conversations.sql
CREATE TABLE ai_conversations (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id),
    project_id UUID REFERENCES projects(id),
    title VARCHAR(255),
    messages JSONB DEFAULT '[]',
    model VARCHAR(100),
    token_count INT DEFAULT 0,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- 007_enable_pgvector.sql
CREATE EXTENSION IF NOT EXISTS vector;

ALTER TABLE files ADD COLUMN embedding vector(1536);
CREATE INDEX idx_files_embedding ON files USING ivfflat (embedding vector_cosine_ops);

-- 008_enable_fts.sql
ALTER TABLE files ADD COLUMN search_vector tsvector;
CREATE INDEX idx_files_search ON files USING gin(search_vector);

CREATE OR REPLACE FUNCTION files_search_trigger() RETURNS trigger AS $$
BEGIN
    NEW.search_vector := to_tsvector('english', COALESCE(NEW.path, ''));
    RETURN NEW;
END $$ LANGUAGE plpgsql;

CREATE TRIGGER trg_files_search BEFORE INSERT OR UPDATE ON files
    FOR EACH ROW EXECUTE FUNCTION files_search_trigger();
```

## SQLite Schema (Local — Offline Support)

Each client has a local SQLite database for offline work.

```sql
-- Local schema (mirrors relevant cloud tables)
CREATE TABLE local_meta (
    key TEXT PRIMARY KEY,
    value TEXT
);
-- Stores: device_id, last_sync_version, user_id

CREATE TABLE projects (
    id TEXT PRIMARY KEY,
    name TEXT NOT NULL,
    path TEXT,
    settings TEXT DEFAULT '{}',  -- JSON string
    synced INTEGER DEFAULT 0,
    version INTEGER DEFAULT 0,
    updated_at TEXT DEFAULT (datetime('now'))
);

CREATE TABLE files (
    id TEXT PRIMARY KEY,
    project_id TEXT NOT NULL REFERENCES projects(id),
    path TEXT NOT NULL,
    content_hash TEXT,
    metadata TEXT DEFAULT '{}',
    synced INTEGER DEFAULT 0,
    version INTEGER DEFAULT 0,
    updated_at TEXT DEFAULT (datetime('now'))
);

CREATE TABLE sync_queue (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    entity_type TEXT NOT NULL,
    entity_id TEXT NOT NULL,
    action TEXT NOT NULL,
    data TEXT,
    version INTEGER NOT NULL,
    created_at TEXT DEFAULT (datetime('now'))
);
-- Pending changes to push to cloud

CREATE TABLE settings (
    key TEXT PRIMARY KEY,
    value TEXT,
    synced INTEGER DEFAULT 0,
    version INTEGER DEFAULT 0
);
```

## Sync Protocol

### Push Flow (Client → Server)
```
1. Client writes to local SQLite + appends to sync_queue
2. Client sends batch of sync_queue entries via WebSocket
3. Go backend validates, writes to PostgreSQL + sync_log
4. Go backend publishes to Redis channel: sync:{user_id}
5. Go backend responds with server versions
6. Client marks sync_queue entries as synced
```

### Pull Flow (Server → Client)
```
1. Client sends: { last_sync_version: N, device_id: "..." }
2. Go backend queries sync_log WHERE version > N AND device_id != client
3. Returns batch of changes
4. Client applies changes to local SQLite
5. Client updates last_sync_version
```

### Conflict Resolution
```
Strategy: Last-Write-Wins with Version Vectors

1. Each entity has a monotonically increasing version (server-assigned)
2. On conflict (same entity, same version):
   - Compare timestamps → latest wins
   - If timestamps identical → higher device_id wins (deterministic tiebreak)
3. Server is always authoritative — client rebases on conflict
4. Deleted entities use soft-delete (deleted_at) to propagate
```

## Redis Channels

```
sync:{user_id}              # All sync events for a user
sync:{user_id}:{device_id}  # Device-specific notifications
presence:{user_id}          # Which devices are online
rate_limit:{user_id}        # Rate limiting counters
cache:user:{user_id}        # User session cache
cache:project:{project_id}  # Project metadata cache
```

## GORM Model Patterns

```go
// Sync-aware base model
type SyncModel struct {
    ID        uuid.UUID      `gorm:"type:uuid;primaryKey;default:gen_random_uuid()"`
    Version   int64          `gorm:"not null;default:0"`
    CreatedAt time.Time
    UpdatedAt time.Time
    DeletedAt gorm.DeletedAt `gorm:"index"`
}

// Always increment version on update
func (db *DB) SaveWithSync(model interface{}, userID, deviceID string) error {
    return db.Transaction(func(tx *gorm.DB) error {
        if err := tx.Save(model).Error; err != nil {
            return err
        }
        // Append to sync_log
        return tx.Create(&SyncLog{
            UserID:     userID,
            EntityType: tableName(model),
            EntityID:   modelID(model),
            Action:     "update",
            Version:    nextVersion(tx, userID),
            DeviceID:   deviceID,
            Data:       toJSON(model),
        }).Error
    })
}
```

## Migration Commands

```bash
# Run PostgreSQL migrations
make migrate

# Rollback last migration
make migrate-rollback

# Fresh database (drop + recreate)
make migrate-fresh

# Seed database
make seed
```

## Conventions

- All IDs are UUIDs (PostgreSQL: `gen_random_uuid()`, SQLite: generated client-side)
- Timestamps: PostgreSQL uses `TIMESTAMPTZ`, SQLite uses ISO 8601 strings
- JSON: PostgreSQL uses `JSONB` columns, SQLite uses `TEXT` with JSON strings
- Soft deletes: `deleted_at` column on all syncable entities
- Version: monotonically increasing per-user, server-assigned
- Sync queue: client-side queue for offline changes, flushed on reconnect
- Partitioning: `sync_log` partitioned by `created_at` (monthly)

## Don'ts

- Don't use auto-increment integer IDs for syncable entities (UUID only)
- Don't query sync_log without a version or time range filter (it grows fast)
- Don't skip the sync_log entry when modifying syncable entities
- Don't store file contents in the database — store content_hash and use object storage
- Don't use `NOW()` on the client for sync timestamps — use server time
