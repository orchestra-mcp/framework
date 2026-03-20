---
id: FEAT-XWU
kind: feature
priority: P1
project_slug: orchestra-win
status: backlog
title: Local SQLite cache — Microsoft.Data.Sqlite
type: feature
---

# Local SQLite cache — Microsoft.Data.Sqlite

Implement `Orchestra.Core/Services/LocalCache.cs` — offline-first SQLite cache at `%LOCALAPPDATA%\Orchestra\cache.db`.

**Schema:**
```sql
CREATE TABLE projects (id TEXT PRIMARY KEY, data TEXT NOT NULL, updated_at TEXT NOT NULL);
CREATE TABLE features (id TEXT PRIMARY KEY, project_id TEXT, data TEXT NOT NULL, updated_at TEXT NOT NULL);
CREATE TABLE notes (id TEXT PRIMARY KEY, data TEXT NOT NULL, updated_at TEXT NOT NULL);
CREATE TABLE chat_sessions (id TEXT PRIMARY KEY, data TEXT NOT NULL, updated_at TEXT NOT NULL);
CREATE TABLE settings_cache (key TEXT PRIMARY KEY, value TEXT NOT NULL);
```

**`LocalCache` API:**
- `CacheProjectsAsync(IEnumerable<Project>)` / `GetCachedProjectsAsync()`
- `CacheFeaturesAsync(string projectId, IEnumerable<Feature>)` / `GetCachedFeaturesAsync(projectId)`
- `CacheNotesAsync(...)` / `GetCachedNotesAsync()`
- `CacheSessionsAsync(...)` / `GetCachedSessionsAsync()`
- `InvalidateCacheAsync(string entity)` — clears all rows for entity
- `GetLastSyncedAtAsync(string entity)` / `SetLastSyncedAtAsync(string entity, DateTimeOffset)`

**Strategy:** on connect → refresh from orchestrator → write to cache; on disconnect → serve from cache with stale banner

**NuGet:** `Microsoft.Data.Sqlite 8.0+`