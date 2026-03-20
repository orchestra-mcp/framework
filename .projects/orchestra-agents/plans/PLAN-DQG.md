---
id: PLAN-DQG
project_slug: orchestra-agents
status: in-progress
title: PowerSync self-hosted integration for realtime cross-device data sync
type: plan
---

# PowerSync self-hosted integration for realtime cross-device data sync

## Goal

Integrate self-hosted PowerSync as the sync engine across all platforms (Flutter, Web, Next.js). PowerSync provides offline-first, realtime sync with PostgreSQL — replacing our polling/WS band-aids with a proper sync layer.

## Why PowerSync

- **Offline-first**: Local SQLite on each device, syncs to PostgreSQL when online
- **Realtime**: Changes propagate to all devices instantly via PowerSync's sync protocol
- **Self-hosted**: Full control, no vendor lock-in, deploys on our server
- **PostgreSQL native**: Works directly with our existing Postgres database
- **Multi-platform SDKs**: Flutter (powersync.dart), JavaScript (powersync-js for web/next)
- **Conflict resolution**: Built-in CRDT-based conflict handling

## Architecture

```
PostgreSQL (existing) ←→ PowerSync Service (self-hosted Docker)
                              ↕
              ┌───────────────┼───────────────┐
              ↓               ↓               ↓
        Flutter App      Web App (React)   Next.js App
        (powersync.dart) (powersync-js)    (powersync-js)
        Local SQLite     IndexedDB         IndexedDB
```

## Features to implement

1. **Self-hosted PowerSync server setup** — Docker compose, deploy script integration with setup-server.sh
2. **PostgreSQL sync rules** — Define which tables sync (health, notes, projects, features, etc.)
3. **Flutter PowerSync integration** — Replace API-based data fetching with PowerSync local DB
4. **Web PowerSync integration** — powersync-js for apps/web React app
5. **Next.js PowerSync integration** — powersync-js for apps/next
6. **Health data sync migration** — Replace polling/WS health sync with PowerSync watched queries
7. **Notes/Projects/Features sync** — All entity CRUD through PowerSync
8. **Auth integration** — PowerSync JWT auth with our existing auth system

## Scope

This replaces:
- Manual API polling in health managers
- WebSocket health.updated events
- Pull-to-refresh as the only cross-device sync mechanism
- Separate API calls for each data load

## Deploy integration

Add PowerSync service to `scripts/deploy/setup-server.sh` and Docker compose for easy self-hosted deployment.
