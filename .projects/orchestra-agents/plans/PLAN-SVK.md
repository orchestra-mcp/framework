---
id: PLAN-SVK
project_slug: orchestra-agents
status: approved
title: Fix Flutter workflow bugs + global DB for all entities + sync team
type: plan
---

# Fix Flutter workflow bugs + global DB for all entities + sync team

## Problems

1. **Workflow list shows template name not useful label** — All workflows display `orchestra-default` as name. Should show `name (project_id)` or project_id subtitle to differentiate.
2. **Workflow detail comes empty** — `getWorkflow()` queries workspace DB only, but workflows live in global DB → returns `{}`. Must check global DB too.
3. **Global DB only loaded for workflows** — `listWorkflows` uses `_queryGlobal`, but other entities (features, projects, notes, persons, etc.) only query workspace DB. Global DB should be merged for all entities.
4. **Sync with team shows loading forever** — Team list never loads in sync dialog.
5. **Sync to team missing from sidebar context menus** — Need "Sync to Team" option in entity context menus.

## Approach

- Bug 1+2: Fix `local_mcp_client.dart` workflow methods (list + detail)
- Bug 3: Add global DB queries for features, projects, notes, persons, etc. and merge with workspace results, tagging each with `db_source`
- Bug 4: Fix sync dialog team loading
- Bug 5: Add sync-to-team action to entity context menus
