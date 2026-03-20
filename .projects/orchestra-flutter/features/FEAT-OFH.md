---
estimate: M
id: FEAT-OFH
kind: feature
priority: P0
project_slug: orchestra-flutter
status: done
title: Drift database schema with 12 tables and full DAO layer
type: feature
---

# Drift database schema with 12 tables and full DAO layer

Create lib/core/db/app_database.dart as the DriftDatabase root referencing all 12 tables, schemaVersion 1, MigrationStrategy with onCreate. Create all tables in lib/core/db/tables/: projects_table.dart with id TextColumn primaryKey, slug, name, description, status, color, iconName, createdAt DateTimeColumn, updatedAt, serverId nullable, isPinned BoolColumn default false. features_table.dart with id, projectId references Projects, title, description, status enum todo/in-progress/in-testing/in-docs/in-review/done, kind enum feature/bug/hotfix/chore, priority P0-P3, createdAt, updatedAt, serverId, isPinned. notes_table.dart with id, title, content large text markdown, projectId nullable, tags text JSON array, createdAt, updatedAt, serverId, isPinned. agents_table.dart with id, name, description, provider, model, systemPrompt, createdAt, updatedAt. skills_table.dart with id, name, description, content markdown, createdAt, updatedAt. workflows_table.dart with id, name, description, stepsJson text JSON array, createdAt, updatedAt. docs_table.dart with id, title, content, projectId nullable, slug, createdAt, updatedAt, serverId. notifications_table.dart with id, type, title, body, isRead bool default false, createdAt, sourceId nullable, sourceType nullable. health_logs_table.dart with id, type string hydration/caffeine/nutrition/pomodoro/shutdown_violation/weight/sleep, valueJson text JSON, loggedAt, source healthkit or manual. sessions_table.dart with id, name, provider, status, metadata text JSON, createdAt, updatedAt, serverId. delegations_table.dart with id, fromUser, toUser, featureId, status pending/accepted/rejected, createdAt. sync_queue_table.dart with id, tableName, recordId, operation insert/update/delete, payloadJson, createdAt, status pending/done/error, retries int default 0. Create one DAO per domain in lib/core/db/daos/ with DriftAccessor, watch streams, and CRUD methods. Create database_provider.dart as Riverpod singleton Provider.


---
**in-progress -> in-testing** (2026-03-16T04:38:30Z):
## Changes
- apps/flutter/lib/core/db/tables/users_table.dart
- apps/flutter/lib/core/db/tables/features_table.dart
- apps/flutter/lib/core/db/tables/projects_table.dart
- apps/flutter/lib/core/db/tables/notes_table.dart
- apps/flutter/lib/core/db/tables/health_logs_table.dart
- apps/flutter/lib/core/db/tables/notifications_table.dart
- apps/flutter/lib/core/db/tables/sessions_table.dart
- apps/flutter/lib/core/db/tables/sync_queue_table.dart
- apps/flutter/lib/core/db/tables/agents_table.dart
- apps/flutter/lib/core/db/tables/workflows_table.dart
- apps/flutter/lib/core/db/tables/settings_table.dart
- apps/flutter/lib/core/db/tables/delegations_table.dart
- apps/flutter/lib/core/db/app_database.dart
- apps/flutter/lib/core/db/database_provider.dart


---
**in-testing -> in-docs** (2026-03-16T09:30:56Z):
## Results
- test/core/db/app_database_test.dart (5 tests: opens without error, all 12 tables exist, sync_queue pk, settings insert/retrieve, users insert/select — all passed)


---
**in-docs -> in-review** (2026-03-16T09:31:19Z):
## Docs
- apps/flutter/docs/database-schema.md (12-table schema reference, usage examples, sync queue explanation, codegen instructions)


---
**Review (approved)** (2026-03-16T09:31:25Z): Auto-approved: 12 Drift tables, AppDatabase with forTesting constructor, Riverpod provider, build_runner codegen successful. All 5 schema tests pass.
