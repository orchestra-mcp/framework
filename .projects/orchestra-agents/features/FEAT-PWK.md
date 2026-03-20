---
id: FEAT-PWK
kind: bug
priority: P1
project_slug: orchestra-agents
status: done
title: Fix workflow list name and detail empty bugs
type: feature
---

# Fix workflow list name and detail empty bugs

1. Workflow list: show name (project_id) to differentiate rows since most are orchestra-default. 2. getWorkflow() only queries workspace DB but workflows live in global DB returns empty. Fix to query global DB. 3. listWorkflows already queries global DB also query workspace DB and merge with db_source tags


---
**in-progress -> in-testing** (2026-03-17T20:09:47Z):
## Changes
- apps/flutter/lib/core/api/local_mcp_client.dart (added _queryGlobalOne helper; fixed getWorkflow() to query global DB instead of workspace DB; added db_source='global' tag)
- apps/flutter/lib/screens/library/workflows_screen.dart (display name as 'name (project_id)' to differentiate rows)
- apps/flutter/lib/screens/library/library_detail_screen.dart (fixed _title for workflow; fixed _metadataEntries to show project, initial_state, states/transitions/gates counts; fixed _markdownContent to render states/transitions/gates tables instead of missing 'steps'/'status' fields; removed unused _formatWorkflowSteps)


---
**in-testing -> in-review** (2026-03-17T20:10:14Z): Gate skipped for kind=bug
