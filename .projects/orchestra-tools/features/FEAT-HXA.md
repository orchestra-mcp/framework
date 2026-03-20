---
id: FEAT-HXA
kind: feature
priority: P1
project_slug: orchestra-tools
status: done
title: Bundle terminal + SSH plugins in-process in serve.go
type: feature
---

# Bundle terminal + SSH plugins in-process in serve.go

Register devtools-terminal and devtools-ssh plugins as in-process plugins in the CLI serve command, same pattern as existing bridge.claude and devtools.database.


---
**in-progress -> in-testing** (2026-03-16T20:50:58Z):
## Changes
- libs/cli/internal/serve.go (modified — added devtoolsterminal and devtoolsssh imports, registered both as in-process plugins with plugin.New/Register/Export/RegisterPlugin pattern)


---
**in-testing -> in-docs** (2026-03-16T20:51:23Z):
## Results
- libs/cli/internal/inprocess/router_test.go (existing tests pass — verifies plugin registration works)
- libs/plugin-devtools-terminal/internal/pty/manager_test.go (23 tests pass)
- libs/plugin-devtools-ssh/internal/tools/interactive_test.go (14 tests pass)
- libs/plugin-devtools-ssh/internal/tools/tools_test.go (14 tests pass)
- go build ./libs/cli/... succeeds — clean compilation with both new plugin imports


---
**in-docs -> in-review** (2026-03-16T20:51:46Z):
## Docs
- docs/terminal-plugin-bundle.md (new — documents both plugins bundled in serve.go, lists all 18 tools, access methods)


---
**Review (approved)** (2026-03-16T20:52:20Z): User approved. Both plugins registered in-process, clean build.
