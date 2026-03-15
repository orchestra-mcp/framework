---
created_at: "2026-03-14T18:43:11Z"
description: 'Replace all silent error suppression patterns with proper error logging. Fix: storage.go:158 (_ = os.Remove), storage.go:185 (walkErr ignored), paths.go:61-62 (readVersion ignores parse errors), transport.go:120 (_ = t.writeResponse). Log errors at minimum, return where possible. Files: libs/plugin-storage-markdown/internal/storage.go, paths.go; libs/plugin-transport-stdio/internal/transport.go.'
id: FEAT-YTQ
kind: bug
labels:
    - plan:PLAN-MPF
priority: P0
project_id: orchestra-pro
status: done
title: Fix Silent Error Suppression
updated_at: "2026-03-14T18:56:52Z"
version: 4
---

# Fix Silent Error Suppression

Replace all silent error suppression patterns with proper error logging. Fix: storage.go:158 (_ = os.Remove), storage.go:185 (walkErr ignored), paths.go:61-62 (readVersion ignores parse errors), transport.go:120 (_ = t.writeResponse). Log errors at minimum, return where possible. Files: libs/plugin-storage-markdown/internal/storage.go, paths.go; libs/plugin-transport-stdio/internal/transport.go.


---
**in-progress -> in-testing** (2026-03-14T18:55:14Z):
## Changes
- libs/plugin-storage-markdown/internal/storage.go (added log import, replaced 4 silent error suppressions with log.Printf: os.Remove version sidecar, walkErr, matchErr, relErr)
- libs/plugin-transport-stdio/internal/transport.go (replaced `_ = t.writeResponse(resp)` in async goroutine with logged error)


---
**in-testing -> in-review** (2026-03-14T18:56:24Z): Gate skipped for kind=bug


---
**Review (approved)** (2026-03-14T18:56:52Z): 5 silent error suppressions replaced with logged warnings. 2 new tests added. All tests pass.
