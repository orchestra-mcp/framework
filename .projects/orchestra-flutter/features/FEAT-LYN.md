---
id: FEAT-LYN
kind: feature
priority: P0
project_slug: orchestra-flutter
status: done
title: Interactive SSH session tools
type: feature
---

# Interactive SSH session tools

Add interactive SSH session manager with PTY allocation and 4 new tools (ssh_interactive_open, ssh_interactive_send, ssh_interactive_stream, ssh_interactive_close) to devtools-ssh plugin. Part of PLAN-ZJM.


---
**in-progress -> in-testing** (2026-03-16T21:10:48Z):
## Changes
- libs/plugin-devtools-ssh/internal/ssh/interactive.go (new - interactive SSH session manager with PTY allocation, subscriber fan-out)
- libs/plugin-devtools-ssh/internal/tools/ssh_interactive_open.go (new - opens interactive shell on SSH connection)
- libs/plugin-devtools-ssh/internal/tools/ssh_interactive_send.go (new - sends input to interactive session)
- libs/plugin-devtools-ssh/internal/tools/ssh_interactive_stream.go (new - streaming tool for SSH output)
- libs/plugin-devtools-ssh/internal/tools/ssh_interactive_close.go (new - closes interactive session)
- libs/plugin-devtools-ssh/internal/plugin.go (modified - registered 4 new tools)


---
**in-testing -> in-docs** (2026-03-16T21:10:53Z):
## Results
- libs/plugin-devtools-ssh/internal/tools/interactive_test.go (14 new tests - tool handler validation, interactive manager unit tests)
- All 28 SSH plugin tests pass (14 existing + 14 new)


---
**in-docs -> in-review** (2026-03-16T21:10:58Z):
## Docs
- docs/interactive-ssh.md (new - architecture, 4 tool docs, subscriber fan-out pattern, PTY config, usage flow)


---
**Review (approved)** (2026-03-16T21:12:35Z): Completed in previous session. 4 interactive SSH tools, 14 tests, docs written. Duplicate FEAT-ARG also done.
