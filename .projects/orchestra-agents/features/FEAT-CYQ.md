---
estimate: S
id: FEAT-CYQ
kind: bug
priority: P0
project_slug: orchestra-agents
status: done
title: Add missing tables to PowerSync schema
type: feature
---

# Add missing tables to PowerSync schema

Add plans, requests, persons tables to schema.dart. Add body column to features. Add states/transitions/gates/initial_state/is_default/version to workflows. Bump schema version 5→6.


---
**in-progress -> in-testing** (2026-03-19T14:23:04Z):
## Changes
- apps/flutter/lib/core/powersync/schema.dart (added plans/requests/persons tables, body column to features, states/transitions/gates/initial_state/is_default/version to workflows)
- apps/flutter/lib/core/powersync/powersync_provider.dart (bumped schema version 5 to 6)


---
**in-testing -> in-review** (2026-03-19T14:23:21Z): Gate skipped for kind=bug


---
**Review (approved)** (2026-03-19T14:23:26Z): Schema changes verified via static analysis. Auto-approved per user preference.
