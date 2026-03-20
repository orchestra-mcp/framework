---
id: FEAT-TSU
kind: feature
priority: P1
project_slug: orchestra-linux
status: backlog
title: Local SQLite cache
type: feature
---

# Local SQLite cache

LocalCache class at ~/.local/share/orchestra/cache.db. Tables: projects (slug TEXT PK, data TEXT, updated_at INTEGER), notes (id TEXT PK, data TEXT, updated_at INTEGER), sessions (id TEXT PK, data TEXT, updated_at INTEGER). Methods: cache_projects(), cached_projects(), cache_notes(), cached_notes(), cache_sessions(), invalidate(entity). Used to pre-populate UI when orchestrator is not yet connected. Cache refreshed after each successful tool call response. 24-hour TTL per entity type.