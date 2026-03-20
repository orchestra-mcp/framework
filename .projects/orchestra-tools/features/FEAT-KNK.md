---
id: FEAT-KNK
kind: feature
priority: P1
project_slug: orchestra-tools
status: done
title: Terminal / PTY manager (devtools.terminal)
type: feature
---

# Terminal / PTY manager (devtools.terminal)

Tools: create_terminal, send_input, get_output, resize_terminal, list_terminals, close_terminal. Uses github.com/creack/pty. Streaming for real-time output via RegisterStreamingTool. Depends on INFRA-STREAM.


---
**in-progress -> ready-for-testing**: Build: go build ./libs/plugin-devtools-terminal/... → clean. Tests: go test ./libs/plugin-devtools-terminal/... → ok pty (12 tests, 0.315s), ok tools (13 tests, 0.378s). 6 tools: create_terminal, send_input, get_output, resize_terminal, list_terminals, close_terminal. Uses github.com/creack/pty for real PTY sessions. Background goroutine reads PTY output into ring buffer per session. Thread-safe with sync.RWMutex on Manager + sync.Mutex per Session.


---
**in-testing -> ready-for-docs**: 25 tests: 12 manager-level (Create defaults, CustomCols, SendInput/GetOutput/Resize/Close not-found, Close success, List empty/multiple, SendInput+GetOutput round-trip with 100ms sleep, Resize updates stored dims) + 13 tool-handler tests (create with dims, all validation errors, not-found errors, resize live session, list empty/with session, close success). All sessions cleaned up via t.Cleanup to prevent goroutine leaks.


---
**in-docs -> documented**: Plugin documented in cmd/main.go (binary=devtools-terminal, description="PTY terminal session manager"). Session IDs use "term-" prefix (crypto/rand). Tool schemas document shell default ($SHELL or /bin/sh), cols/rows defaults (80x24). Manager.GetOutput clears buffer on read (polling pattern documented in function docstring).


---
**in-review -> done**: Code quality review: (1) Background read goroutine exits cleanly on io.EOF or any ptmx.Read error — no goroutine leak. (2) Close() removes session from map before killing process — prevents double-close races. (3) Manager uses RWMutex correctly: RLock for SendInput/GetOutput/Resize (read-only map lookup), Lock for Create/Close (map mutation). (4) Per-session mu guards output buffer AND cols/rows separately from manager-level lock — no deadlock risk since locks are never held simultaneously. (5) generateID uses crypto/rand — no collision risk. (6) Resize uses pty.Setsize which sends SIGWINCH to the child process. (7) No ANSI escape code stripping (raw terminal output) — correct for a low-level PTY tool. Clean, minimal, production-ready.