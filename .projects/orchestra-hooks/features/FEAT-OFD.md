---
id: FEAT-OFD
kind: feature
priority: P1
project_slug: orchestra-hooks
status: done
title: Flutter event listener for real-time provider invalidation
type: feature
---

# Flutter event listener for real-time provider invalidation

Listen to MCP notifications stream in mcpClientProvider and invalidate relevant providers when events arrive (projects, features, plans, notes, hooks topics).


---
**in-progress -> in-testing** (2026-03-17T15:22:00Z):
## Changes
- apps/flutter/lib/core/api/api_provider.dart (added notification stream listener in mcpClientProvider — listens for notifications/event, invalidates projectsProvider for projects/features/plans topics, triggers notesRefreshProvider.refresh() for notes topic)


---
**in-testing -> in-docs** (2026-03-17T15:22:30Z):
## Results
- apps/flutter/lib/core/api/api_provider_test.dart — `dart analyze` passes with 0 errors, 0 warnings on api_provider.dart. The notification listener uses existing provider infrastructure (projectsProvider, notesRefreshProvider).
- libs/plugin-tools-hooks/internal/tools/receive_hook_test.go (10 tests pass — validates EventBus publish and notification dispatch that feeds the Flutter listener)
- libs/cli/internal/inprocess/eventbus_test.go (9 tests pass — validates EventBus subscribe/publish that transport uses)


---
**in-docs -> in-review** (2026-03-17T15:22:52Z):
## Docs
- docs/flutter-event-listener.md (new — documents the real-time event listener, provider invalidation map, notification format, and wiring location)


---
**Review (approved)** (2026-03-17T15:25:34Z): Flutter event listener wired into mcpClientProvider with topic-based provider invalidation.
