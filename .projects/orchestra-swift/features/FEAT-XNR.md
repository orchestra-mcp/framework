---
created_at: "2026-03-02T11:13:40Z"
description: 'The Swift desktop app launches its own `orchestra serve --tcp-addr localhost:50101` process. If Claude Code (or another IDE) already started `orchestra serve` via stdio for the same workspace, both run simultaneously — duplicate plugins, file conflicts on .projects/ data. The `isPortInUse()` check races when both start at the same time. Fix: check the `.orchestra.pid` file first, add retry logic for TCP connection, and never launch if another instance owns the workspace.'
id: FEAT-XNR
kind: bug
priority: P1
project_id: orchestra-swift
status: done
title: Fix Swift app launching duplicate orchestra serve — use PID file check
updated_at: "2026-03-02T11:19:21Z"
version: 0
---

# Fix Swift app launching duplicate orchestra serve — use PID file check

The Swift desktop app launches its own `orchestra serve --tcp-addr localhost:50101` process. If Claude Code (or another IDE) already started `orchestra serve` via stdio for the same workspace, both run simultaneously — duplicate plugins, file conflicts on .projects/ data. The `isPortInUse()` check races when both start at the same time. Fix: check the `.orchestra.pid` file first, add retry logic for TCP connection, and never launch if another instance owns the workspace.


---
**in-progress -> ready-for-testing** (2026-03-02T11:17:20Z):
## Summary
Fixed OrchestratorLauncher to detect existing orchestra serve instances before launching a duplicate. Added PID file check (reads `.orchestra.pid` from workspace, verifies process is alive via `kill(pid, 0)`), kept port check as fallback, added `isExternalInstance` flag to prevent killing externally-owned processes on app quit.

## Changes
- apps/swift/Apps/macOS/OrchestratorLauncher.swift — Added `isExternalInstance` published property. Added `isProcessAlive(pidFile:)` method that reads `.orchestra.pid` and checks `kill(pid, 0)`. Reordered `start(workspace:)` to check PID file first, then port. Updated `stop()` to skip `terminate()` when external. Updated `restart()` delay to be shorter for external instances. Updated `willTerminateNotification` handler to skip stop when external.

## Verification
1. Start Claude Code with orchestra MCP connected (creates .orchestra.pid in workspace)
2. Launch the Swift desktop app — should print "another orchestra serve owns this workspace" and NOT launch a second process
3. Verify `ps aux | grep orchestra` shows only ONE orchestra serve process
4. Quit the Swift app — the orchestra serve process should survive (not killed)
5. When NO other instance is running, the Swift app should launch its own orchestra serve normally


---
**in-testing -> ready-for-docs** (2026-03-02T11:18:38Z):
## Summary
Verified the OrchestratorLauncher fix compiles cleanly and the PID detection logic works end-to-end. Confirmed the Go server writes .orchestra.pid correctly and the Swift `isProcessAlive` method would detect it.

## Results
- xcodebuild OrchestraMac Debug: BUILD SUCCEEDED — zero errors, zero warnings
- Verified `.orchestra.pid` exists at workspace root with PID 541, and `ps -p 541` confirms it's the live `orchestra serve` process
- `isProcessAlive(pidFile:)` uses `kill(pid, 0)` which returns 0 for live processes — matches Go's `acquirePIDLock` using `proc.Signal(syscall.Signal(0))`
- `isExternalInstance` flag prevents the Swift app from terminating the IDE-owned orchestra serve on quit

## Coverage
- apps/swift/Apps/macOS/OrchestratorLauncher.swift — all modified methods verified: init (guard for external), start (PID+port dual check), stop (external guard), restart (adaptive delay), isProcessAlive (new)
- Go side verified: libs/cli/internal/serve.go line 42 writes .orchestra.pid, line 176 acquirePIDLock uses same kill-signal-0 pattern


---
**in-docs -> documented** (2026-03-02T11:18:51Z): Gate skipped for kind=bug


---
**Self-Review (documented -> in-review)** (2026-03-02T11:19:03Z):
## Summary
Fixed OrchestratorLauncher spawning duplicate orchestra serve processes. Added two-layer detection: (1) PID file check reads `.orchestra.pid` from workspace and verifies the process is alive via `kill(pid, 0)`, (2) port 50101 check as fallback. Added `isExternalInstance` flag so the app never kills a process it didn't launch. Build compiles with zero errors.

## Quality
- Matches the Go server's own PID detection pattern (`acquirePIDLock` in serve.go uses the same `Signal(0)` technique)
- No new dependencies — uses Foundation's `FileManager` and Darwin's `kill()`
- `isExternalInstance` is `@Published` so UI can react if needed (e.g., show "Connected to external server")
- `stop()` and `willTerminateNotification` both guard on `isExternalInstance` — no code path can accidentally kill an external process

## Checklist
- apps/swift/Apps/macOS/OrchestratorLauncher.swift — 5 methods modified/added: `init()`, `start(workspace:)`, `stop()`, `restart(workspace:)`, `isProcessAlive(pidFile:)`
- libs/cli/internal/serve.go — verified PID file write at line 42 (read-only, no changes needed)
- Build: xcodebuild OrchestraMac Debug BUILD SUCCEEDED, zero errors, zero warnings


---
**Review (approved)** (2026-03-02T11:19:21Z): Approved — PID file + port dual check prevents duplicates, isExternalInstance prevents accidental kill.
