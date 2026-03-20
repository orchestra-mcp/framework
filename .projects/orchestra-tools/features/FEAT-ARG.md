---
id: FEAT-ARG
kind: feature
priority: P1
project_slug: orchestra-tools
status: done
title: Interactive SSH session manager + 4 tools (devtools.ssh)
type: feature
---

# Interactive SSH session manager + 4 tools (devtools.ssh)

Add interactive SSH sessions with PTY allocation to the devtools-ssh plugin. Includes InteractiveManager with Open/Send/Subscribe/Resize/Close methods and 4 new tools: ssh_interactive_open, ssh_interactive_send, ssh_interactive_stream (streaming), ssh_interactive_close.


---
**in-progress -> in-testing** (2026-03-16T20:47:25Z):
## Changes
- libs/plugin-devtools-ssh/internal/ssh/interactive.go (new — InteractiveSession, InteractiveManager with Open/Send/Subscribe/Resize/List/Close, subscriber fan-out)
- libs/plugin-devtools-ssh/internal/tools/ssh_interactive_open.go (new — ssh_interactive_open tool handler)
- libs/plugin-devtools-ssh/internal/tools/ssh_interactive_send.go (new — ssh_interactive_send tool handler)
- libs/plugin-devtools-ssh/internal/tools/ssh_interactive_stream.go (new — ssh_interactive_stream streaming tool handler)
- libs/plugin-devtools-ssh/internal/tools/ssh_interactive_close.go (new — ssh_interactive_close tool handler)
- libs/plugin-devtools-ssh/internal/plugin.go (modified — register 4 new interactive tools)


---
**in-testing -> in-docs** (2026-03-16T20:48:13Z):
## Results
- libs/plugin-devtools-ssh/internal/tools/interactive_test.go (14 new tests — all pass)
  - TestSSHInteractiveOpen_MissingSessionID, TestSSHInteractiveOpen_UnknownSession
  - TestSSHInteractiveSend_MissingArgs, TestSSHInteractiveSend_MissingInput, TestSSHInteractiveSend_UnknownSession
  - TestSSHInteractiveClose_MissingID, TestSSHInteractiveClose_UnknownSession
  - TestSSHInteractiveStream_MissingID, TestSSHInteractiveStream_UnknownSession
  - TestInteractiveManager_ListEmpty, TestInteractiveManager_SubscribeNotFound, TestInteractiveManager_ResizeNotFound, TestInteractiveManager_SendNotFound, TestInteractiveManager_CloseNotFound
- 28/28 tests pass (14 existing + 14 new)


---
**in-docs -> in-review** (2026-03-16T20:49:00Z):
## Docs
- docs/interactive-ssh.md (new — architecture, 4 tool descriptions, subscriber fan-out, PTY config, usage flow)


---
**Review (approved)** (2026-03-16T20:49:32Z): User approved. 14 new tests passing, clean build, docs complete.
