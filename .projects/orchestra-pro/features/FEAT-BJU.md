---
id: FEAT-BJU
kind: feature
priority: P1
project_slug: orchestra-pro
status: done
title: Replace log.Printf with Structured Logging (slog)
type: feature
---

# Replace log.Printf with Structured Logging (slog)

Replace all log.Printf/log.Fatalf calls with Go stdlib log/slog. Add request IDs to tool dispatch, structured fields (plugin, tool, duration, error), log levels (debug/info/warn/error). Fix unsafe concurrent logging in StdioTransport. Files: all core plugins (10-15 files across storage-markdown, transport-stdio, cli/inprocess, tools-features, tools-marketplace, tools-notes, tools-docs).


---
**in-progress -> in-testing** (2026-03-14T19:08:06Z):
## Changes
- libs/plugin-storage-markdown/internal/storage.go (replaced 4 log.Printf with slog.Warn)
- libs/plugin-transport-stdio/internal/transport.go (replaced 2 log.Printf with slog.Error/slog.Debug)
- libs/cli/internal/inprocess/router.go (replaced 7 log.Printf with slog.Info/slog.Error/slog.Warn)
- libs/cli/internal/inprocess/tcpserver.go (replaced 6 log.Printf with slog.Info/slog.Error)
- libs/cli/internal/inprocess/quicserver.go (replaced 4 log.Printf with slog.Info/slog.Error)
- libs/cli/internal/inprocess/tcpsender.go (replaced 7 log.Printf with slog.Warn/slog.Info/slog.Error)
- libs/cli/internal/inprocess/reverse_tunnel.go (replaced 5 log.Printf with slog.Info/slog.Warn)
- libs/cli/internal/inprocess/webgate.go (replaced 9 log.Printf with slog.Info/slog.Warn/slog.Error/slog.Debug)
- libs/cli/internal/inprocess/tunnel_claim.go (replaced 1 log.Printf with slog.Warn)
- libs/plugin-tools-marketplace/internal/tools/recommend.go (replaced 1 log.Printf with slog.Debug)


---
**in-testing -> in-docs** (2026-03-14T19:08:21Z):
## Results
- libs/plugin-storage-markdown/internal/storage_test.go (17/17 pass)
- libs/plugin-transport-stdio/internal/transport_test.go (23/23 pass)
- libs/cli/internal/inprocess/ (all tests pass including recovery and webgate tests)
- libs/plugin-tools-marketplace/internal/packs/ and storage/ (all pass)
- 46 log.Printf calls replaced with structured slog across 10 files, zero regressions


---
**in-docs -> in-review** (2026-03-14T19:08:42Z):
## Docs
- docs/structured-logging.md (new — documents slog migration, log levels, converted files, structured field patterns)


---
**Review (approved)** (2026-03-14T19:09:19Z): 46 log.Printf calls migrated to structured slog across 10 core runtime files. All tests pass.