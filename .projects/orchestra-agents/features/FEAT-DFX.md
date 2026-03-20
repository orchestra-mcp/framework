---
estimate: S
id: FEAT-DFX
kind: bug
priority: P1
project_slug: orchestra-agents
status: done
title: Fix Go CLI build — add plugin-tools-hooks to go.work
type: feature
---

# Fix Go CLI build — add plugin-tools-hooks to go.work

The CLI imports plugin-tools-hooks in serve.go but the module is missing from go.work. Add it so the CLI compiles. Verify with make build-cli or go build.


---
**in-progress -> in-testing** (2026-03-20T17:04:09Z):
## Changes
- go.work (added 5 missing plugin modules: plugin-devtools-api, plugin-health, plugin-tools-hooks, plugin-tools-prompts, plugin-tools-secrets)
- libs/cli/go.mod (added 3 missing require entries: plugin-services-notifications, plugin-services-voice, plugin-devtools-ssh; removed unresolable plugin-tools-hooks v0.1.0 since go.work handles local resolution)

## Verification
`go build -o /dev/null github.com/orchestra-mcp/cli` succeeds with clean output. Binary produces correct version output.


---
**in-testing -> in-review** (2026-03-20T17:04:26Z): Gate skipped for kind=bug


---
**Review (approved)** (2026-03-20T17:05:30Z): CLI build fixed.
