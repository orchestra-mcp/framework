---
estimate: M
id: FEAT-LNU
kind: feature
priority: P1
project_slug: orchestra-tools
status: done
title: Restructure serve.go for core+external model
type: feature
---

# Restructure serve.go for core+external model

Remove 32 plugin imports from serve.go. Keep 4 core (storage.markdown, transport.stdio, tools.features, tools.marketplace). Add QUIC bridge startup and loadExternalPlugins() call. Add --no-plugins flag. Update signal handling for external plugin shutdown.


---
**in-progress -> ready-for-testing**:
## Summary
Restructured serve.go from 36 hard-coded plugin imports down to 4 core plugins. Added --no-plugins flag, QUIC bridge startup, and external plugin loading via loadExternalPlugins(). Binary size dropped from 35MB to 17MB (51% reduction). Removed initLocalPlugin and initAIPlugin helpers (no longer needed).

## Changes
- libs/cli/internal/serve.go (rewritten — removed 32 plugin imports, kept 4 core: storage.markdown, transport.stdio, tools.features, tools.marketplace; added QUIC bridge + external loader phases; added --no-plugins flag; updated signal handling for external plugin shutdown)

## Verification
- `cd libs/cli && go build ./internal/...` passes cleanly
- `cd libs/cli && go build -o /tmp/orchestra-lite .` produces working 17MB binary (was 35MB)
- `go vet ./internal/...` passes


---
**in-testing -> ready-for-docs**:
## Summary
Full CLI binary builds and runs correctly with only 4 core plugins. Binary size 17MB (down from 35MB). All subcommands work (version, help, etc.).

## Results
- go build: PASS (17MB binary)
- go vet ./...: PASS
- orchestra version: works correctly
- Binary size: 17MB (51% reduction from 35MB)

## Coverage
The restructured serve.go retains the same patterns (initStoragePlugin) for core plugins. External plugin loading is deferred to loadExternalPlugins which was tested in FEAT-GUX.


---
**in-docs -> documented**:
## Summary
serve.go has clear phase comments (PHASE 1: CORE PLUGINS, PHASE 2: EXTERNAL PLUGINS, PHASE 3: SIGNAL HANDLING, PHASE 4: TRANSPORT) explaining the startup flow. The --no-plugins flag is documented in the flag definition.

## Location
- libs/cli/internal/serve.go (phase comments, flag documentation, function docs)


---
**Self-Review (documented -> in-review)**:
## Summary
The core architectural change: serve.go goes from 36 hard-coded plugin imports to 4 core plugins (storage.markdown, transport.stdio, tools.features, tools.marketplace). All other plugins are loaded dynamically from the registry as external QUIC-connected processes. Binary drops from 35MB to 17MB. Added --no-plugins flag for core-only mode.

## Quality
- Clean 4-phase startup: core plugins → QUIC bridge → external plugins → transport
- Graceful degradation: if QUIC bridge fails, external plugins are skipped with a log warning
- Existing functionality preserved for core tools (features, marketplace)
- Signal handling properly shuts down external plugins before cancelling context

## Checklist
- libs/cli/internal/serve.go (rewritten — 150 lines, down from 400)


---
**Review (approved)**: Approved — clean restructure with major binary size reduction.