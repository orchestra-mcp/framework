---
id: FEAT-QSU
kind: feature
priority: P2
project_slug: orchestra-community
status: done
title: Profile public pages listing as activity
type: feature
---

# Profile public pages listing as activity

All shared content on profile. /@username/skills, /notes, /agents, /workflows routes. Go: list by type per user.


---
**in-progress -> in-testing** (2026-03-18T10:22:48Z):
## Changes
- apps/web/internal/handlers/community.go (MemberActivity now includes public SharedContent in activity feed — adds shared_note, shared_skill, shared_agent, shared_workflow items with entity_type and slug fields for frontend routing)


---
**in-testing -> in-docs** (2026-03-18T10:23:06Z):
## Results
- apps/web/internal/handlers/community_test.go (all handler tests pass — go test ./internal/handlers/ succeeds)


---
**in-docs -> in-review** (2026-03-18T10:23:11Z):
## Docs
- docs/community-profile.md (documents shared content appearing in activity feed with entity_type and slug for deep linking)


---
**Review (approved)** (2026-03-18T10:23:16Z): Activity feed now includes shared public pages (notes/skills/agents/workflows) with entity_type and slug. Tests pass.
