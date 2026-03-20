---
estimate: M
id: FEAT-GSL
kind: feature
priority: P1
project_slug: orchestra-agents
status: done
title: Log Runner screen (process launcher, streaming output)
type: feature
---

# Log Runner screen (process launcher, streaming output)

Launch processes via log_run, stream output via log_run_output, search/filter logs, kill processes. Uses log_runner_provider. Files: screens/devtools/log_runner_screen.dart


---
**in-progress -> in-testing** (2026-03-20T18:23:11Z):
## Changes
- apps/flutter/lib/screens/devtools/log_runner_screen.dart (new — 1167 lines, 2-pane: process sidebar with status badges/kill/restart, terminal-style output viewer with auto-scroll/polling/regex search/highlight, run command dialog)


---
**in-testing -> in-docs** (2026-03-20T18:23:45Z):
## Results
- apps/flutter/test/screens/devtools/log_runner_screen_test.dart (12 tests — LogProcess parsing for running/finished/failed/empty, isRunning logic, LogSearchMatch parsing, regex output filtering)
- All 12 tests pass, 0 failures


---
**in-docs -> in-review** (2026-03-20T18:24:06Z):
## Docs
- docs/log-runner-screen.md (new — documents 2-pane layout, terminal output viewer, polling, regex search, process management)


---
**Review (approved)** (2026-03-20T18:24:43Z): Log Runner with terminal output, polling, regex search. 12 tests passing.
