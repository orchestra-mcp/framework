# Structured Logging with log/slog

## Overview

All core runtime files now use Go's stdlib `log/slog` instead of `log.Printf`.
This provides structured key-value logging with proper log levels.

## Log Levels

| Level | Usage |
|-------|-------|
| `slog.Debug` | Verbose operational info (notifications, event polling, dispatch completion) |
| `slog.Info` | Startup, connections, plugin registration, reconnection success |
| `slog.Warn` | Recoverable issues (inaccessible paths, poll errors, reconnect attempts) |
| `slog.Error` | Panics, write failures, dispatch errors, upgrade failures |

## Files Converted

- `libs/plugin-storage-markdown/internal/storage.go` — 4 calls
- `libs/plugin-transport-stdio/internal/transport.go` — 2 calls
- `libs/cli/internal/inprocess/router.go` — 7 calls
- `libs/cli/internal/inprocess/tcpserver.go` — 6 calls
- `libs/cli/internal/inprocess/quicserver.go` — 4 calls
- `libs/cli/internal/inprocess/tcpsender.go` — 7 calls
- `libs/cli/internal/inprocess/reverse_tunnel.go` — 5 calls
- `libs/cli/internal/inprocess/webgate.go` — 9 calls
- `libs/cli/internal/inprocess/tunnel_claim.go` — 1 call
- `libs/plugin-tools-marketplace/internal/tools/recommend.go` — 1 call

## Structured Fields

All log calls include contextual key-value pairs:

```go
// Before
log.Printf("[inprocess] PANIC in tool %q: %v", toolName, r)

// After
slog.Error("panic in tool handler", "tool", toolName, "panic", r)
```

Common fields: `tool`, `plugin`, `error`, `addr`, `session_id`, `path`, `method`.
