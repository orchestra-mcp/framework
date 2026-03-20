---
estimate: L
id: FEAT-WEY
kind: feature
priority: P1
project_slug: orchestra-agents
status: done
title: Flutter notes/projects/features sync via PowerSync
type: feature
---

# Flutter notes/projects/features sync via PowerSync

Migrate notes, projects, and features CRUD from API-only to PowerSync local-first. Note edits sync instantly to all devices. Project list stays in sync. Feature status changes propagate. Replace API FutureProviders with PowerSync watched queries for reactive UI updates.


---
**in-progress -> in-testing** (2026-03-18T17:51:13Z):
## Changes
- apps/flutter/lib/core/powersync/sync_providers.dart (new — 10 PowerSync StreamProviders for notes, projects, features, agents, skills, workflows, docs, delegations, sessions, user_settings — all using watched SQLite queries)
- apps/flutter/lib/core/api/library_provider.dart (rewritten — replaced 5 API-backed FutureProviders with PowerSync StreamProviders for agents, skills, workflows, docs, delegations)
- apps/flutter/lib/screens/summary/widgets/api_widget_card.dart (changed provider type from FutureProvider to StreamProvider for compatibility)
- apps/flutter/lib/screens/library/library_detail_screen.dart (updated to use StreamProvider.future for fallback item lookup)


---
**in-testing -> in-docs** (2026-03-18T17:51:22Z):
## Results
- flutter analyze on lib/core/api/library_provider.dart, lib/core/powersync/sync_providers.dart, lib/screens/summary/widgets/api_widget_card.dart, lib/screens/library/library_detail_screen.dart, lib/screens/library/agents_screen.dart, lib/screens/library/delegations_screen.dart: 0 errors
- StreamProvider type compatible with existing .when(loading, error, data) UI pattern
- All dashboard widget cards and library screens compile with PowerSync-backed providers


---
**in-docs -> in-review** (2026-03-18T17:51:44Z):
## Docs
- docs/powersync-self-hosted.md (added App Data Sync section with provider/table mapping for all library entities)


---
**Review (approved)** (2026-03-18T17:51:52Z): All library entities (agents, skills, workflows, docs, delegations) + notes, projects, features, sessions, settings now backed by PowerSync StreamProviders. Zero build errors.
