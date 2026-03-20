---
id: FEAT-XHL
kind: feature
priority: P0
project_slug: orchestra-flutter
status: done
title: PTY streaming and terminal_stream tool
type: feature
---

# PTY streaming and terminal_stream tool

Add subscriber fan-out to PTY manager and create terminal_stream streaming tool in devtools-terminal plugin. Part of PLAN-ZJM.


---
**in-progress -> in-testing** (2026-03-16T20:40:48Z):
## Changes
- libs/plugin-devtools-terminal/internal/pty/manager.go (added subscriber fan-out: subscribers map, Subscribe method, goroutine fan-out with non-blocking send, channel cleanup on PTY close)
- libs/plugin-devtools-terminal/internal/tools/terminal_stream.go (new streaming tool handler using plugin.StreamingToolHandler signature, subscribes to PTY output and pipes to chunks channel)
- libs/plugin-devtools-terminal/internal/plugin.go (registered terminal_stream as streaming tool via RegisterStreamingTool)


---
**in-testing -> in-docs** (2026-03-16T20:41:31Z):
## Results
- libs/plugin-devtools-terminal/internal/pty/manager_test.go (5 new tests: TestManager_Subscribe_NotFound, TestManager_Subscribe_ReceivesOutput, TestManager_Subscribe_MultipleSubscribers, TestManager_Subscribe_Unsubscribe, TestManager_Subscribe_ClosedSession — all passing)
- All 23 tests pass across 2 test packages (pty: 14 tests, tools: 14 tests)


---
**in-docs -> in-review** (2026-03-16T20:41:56Z):
## Docs
- docs/terminal-streaming.md (terminal streaming architecture, subscriber fan-out pattern, WebGate streaming protocol, Flutter usage example)
