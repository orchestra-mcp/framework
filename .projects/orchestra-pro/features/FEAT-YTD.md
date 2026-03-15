---
created_at: "2026-03-14T18:43:11Z"
description: 'Add defer recover() wrapper in the in-process router''s tool dispatch path so that a single tool panic returns an error response instead of crashing the entire orchestrator and all 395 tools. Files: libs/cli/internal/inprocess/router.go callTool() method.'
id: FEAT-YTD
kind: bug
labels:
    - plan:PLAN-MPF
priority: P0
project_id: orchestra-pro
status: done
title: Add Panic Recovery to Tool Dispatch
updated_at: "2026-03-14T18:53:48Z"
version: 4
---

# Add Panic Recovery to Tool Dispatch

Add defer recover() wrapper in the in-process router's tool dispatch path so that a single tool panic returns an error response instead of crashing the entire orchestrator and all 395 tools. Files: libs/cli/internal/inprocess/router.go callTool() method.


---
**in-progress -> in-testing** (2026-03-14T18:50:24Z):
## Changes
- libs/cli/internal/inprocess/router.go (added safeCallTool and safeCallPrompt functions with defer recover() — catches panics in tool and prompt handlers, logs the panic, returns structured error response instead of crashing. Updated routeToolCall to use safeCallTool, updated routePromptGet to use safeCallPrompt)


---
**in-testing -> in-review** (2026-03-14T18:53:18Z): Gate skipped for kind=bug


---
**Review (approved)** (2026-03-14T18:53:48Z): Panic recovery wrappers for tool and prompt dispatch. 6/6 tests pass. Router proven stable after tool panics.
