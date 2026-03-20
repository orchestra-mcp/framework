---
estimate: M
id: FEAT-BQR
kind: bug
priority: P0
project_slug: orchestra-agents
status: done
title: Fix workflow deduplication on mobile
type: feature
---

# Fix workflow deduplication on mobile

Add dedup logic in Flutter sync providers. Unique constraint by name+project_id, keep latest updated_at on conflict. One-time migration to clean existing duplicates.


---
**in-progress -> in-testing** (2026-03-19T22:51:35Z):
## Changes
- apps/flutter/lib/core/powersync/sync_providers.dart (added dedup query to syncedWorkflowsProvider — INNER JOIN with GROUP BY name+project_slug keeping MAX updated_at)
- apps/flutter/lib/core/api/library_provider.dart (fixed workflowsProvider dedup to use name+project_slug instead of name-only)
- apps/flutter/lib/core/powersync/powersync_provider.dart (added _deduplicateWorkflows cleanup function that runs on DB init, uses ROW_NUMBER window function to delete duplicate rows)
- orch-ref/database/migrations/20260320001000_add_workflow_dedup_index.sql (new migration: cleans existing duplicates + adds unique index on user_id+project_slug+name)


---
**in-testing -> in-review** (2026-03-19T22:51:54Z): Gate skipped for kind=bug


---
**Review (approved)** (2026-03-19T22:52:09Z): Workflow dedup fix approved — client-side read dedup, startup cleanup, and server-side unique index.
