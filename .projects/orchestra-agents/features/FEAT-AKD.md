---
estimate: S
id: FEAT-AKD
kind: bug
priority: P0
project_slug: orchestra-agents
status: done
title: Add missing tables to sync-rules.yaml
type: feature
---

# Add missing tables to sync-rules.yaml

Add user_plans, user_requests, user_persons buckets. Add body to features SELECT. Cast JSONB columns for workflows.


---
**in-progress -> in-testing** (2026-03-19T14:24:02Z):
## Changes
- scripts/deploy/powersync/sync-rules.yaml (added user_plans, user_requests, user_persons buckets; added body to features SELECT; added states::text, transitions::text, gates::text, initial_state, is_default, version to workflows SELECT)


---
**in-testing -> in-review** (2026-03-19T22:46:07Z): Gate skipped for kind=bug


---
**Review (approved)** (2026-03-19T22:46:31Z): Sync rules verified: all 3 new buckets (plans, requests, persons) present, body added to features, JSONB casts on workflows correct.
