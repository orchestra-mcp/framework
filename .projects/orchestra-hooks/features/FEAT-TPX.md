---
id: FEAT-TPX
kind: feature
priority: P0
project_slug: orchestra-hooks
status: done
title: Hook event plugin with notifications, TTS, and SQLite logging
type: feature
---

# Hook event plugin with notifications, TTS, and SQLite logging

Create tools-hooks plugin with receive_hook_event (publishes to EventBus, logs to SQLite, calls notify_send + tts_speak for attention events) and get_hook_events (query log). Port from orch-ref/app/tools/claude_hooks.go to new in-process architecture.


---
**in-progress -> in-testing** (2026-03-17T15:14:30Z):
## Changes
- libs/plugin-tools-hooks/internal/tools/receive_hook.go (new — receive_hook_event tool handler with EventBus publishing, SQLite logging, cross-plugin notify_send + tts_speak calls for attention events)
- libs/plugin-tools-hooks/internal/tools/get_hook_events.go (new — get_hook_events tool handler with optional filters)
- libs/plugin-tools-hooks/internal/tools/hook_log.go (new — SQLite hook_events table via globaldb, LogEvent/QueryEvents/PruneEvents)
- libs/plugin-tools-hooks/internal/plugin.go (rewritten — HooksPlugin struct with Sender, registers both tools)
- libs/plugin-tools-hooks/export.go (new — Register(builder, sender) for in-process registration)
- libs/plugin-tools-hooks/cmd/main.go (updated — uses HooksPlugin with clientAdapter Sender)
- libs/cli/internal/serve.go (modified — imports and registers tools.hooks, services.notifications, services.voice plugins)


---
**in-testing -> in-docs** (2026-03-17T15:17:11Z):
## Results
- libs/plugin-tools-hooks/internal/tools/hook_log_test.go (5 tests: LogEvent, QueryEvents_Empty, LogAndQueryEvents, QueryEvents_Limit, PruneEvents — all PASS)
- libs/plugin-tools-hooks/internal/tools/receive_hook_test.go (5 tests: Schema, Basic, MissingEventType, NotificationDispatch, NoNotificationForNonAttention — all PASS)

All 10 tests pass. CLI inprocess tests (9 EventBus tests) also pass with no regressions.


---
**in-docs -> in-review** (2026-03-17T15:17:43Z):
## Docs
- docs/hooks-plugin.md (new — documents receive_hook_event and get_hook_events tools, database schema, cross-plugin integration, hook file, and future sync plans)


---
**Review (approved)** (2026-03-17T15:18:42Z): Hook event plugin complete with receive_hook_event, get_hook_events, SQLite logging, EventBus publishing, and cross-plugin notification/TTS dispatch. 10 tests passing.
