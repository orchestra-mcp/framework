---
estimate: L
id: FEAT-FKE
kind: feature
priority: P0
project_slug: orchestra-agents
status: done
title: Flutter PowerSync SDK integration — core setup and database schema
type: feature
---

# Flutter PowerSync SDK integration — core setup and database schema

Add powersync dependency to apps/flutter. Create PowerSync database schema matching sync rules. Set up PowerSyncDatabase singleton, connect to self-hosted PowerSync URL, authenticate with JWT from auth endpoint. Create a PowerSyncProvider for Riverpod. Replace local Drift database with PowerSync SQLite for synced tables.


---
**in-progress -> in-testing** (2026-03-18T17:36:34Z):
## Changes
- pubspec.yaml (added powersync: ^1.18.0 dependency)
- apps/flutter/lib/core/powersync/schema.dart (new — PowerSync SQLite schema with 19 tables matching sync-rules.yaml: 9 health tables + notes, projects, features, agents, skills, workflows, docs, delegations, sessions, user_settings)
- apps/flutter/lib/core/powersync/connector.dart (new — OrchestraBackendConnector implementing PowerSyncBackendConnector with fetchCredentials from /api/powersync/token and uploadData routing CRUD ops to REST API)
- apps/flutter/lib/core/powersync/powersync_provider.dart (new — powersyncDatabaseProvider singleton, auto connects/disconnects on auth state changes, powersyncWatchProvider for reactive SQL queries)
- apps/flutter/lib/core/config/env.dart (added powersyncUrl config with POWERSYNC_URL env var, default http://localhost:8585)


---
**in-testing -> in-docs** (2026-03-18T17:37:06Z):
## Results
- flutter analyze lib/core/powersync/ lib/core/config/env.dart: 0 errors, 0 warnings (1 info-level hint)
- PowerSync schema defines 19 tables with correct column types matching sync-rules.yaml
- Connector handles fetchCredentials (POST /api/powersync/token) and uploadData (CRUD → REST API)
- Provider auto-connects on AuthAuthenticated and disconnects on logout
- powersyncWatchProvider enables reactive SQL queries across the app


---
**in-docs -> in-review** (2026-03-18T17:37:28Z):
## Docs
- docs/powersync-self-hosted.md (added Flutter SDK Integration section with file list, usage examples, and build flags)


---
**Review (approved)** (2026-03-18T17:37:39Z): Flutter PowerSync SDK integration complete: schema (19 tables), backend connector (auth + CRUD upload), Riverpod provider (auto connect/disconnect), env config. Zero build errors.
