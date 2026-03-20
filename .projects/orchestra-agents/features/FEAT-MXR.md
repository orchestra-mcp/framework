---
estimate: S
id: FEAT-MXR
kind: bug
priority: medium
project_slug: orchestra-agents
status: done
title: Sleep logs API endpoints for health sync
type: feature
---

# Sleep logs API endpoints for health sync

Add missing sleep log endpoints. POST /api/health/sleep (log sleep session: start_time, end_time, quality, notes). GET /api/health/sleep (list sleep logs, filter by date range). GET /api/health/sleep/stats (average duration, quality trends). Add sleep_logs handler to existing health handler group. Wire to PowerSync sleep_logs bucket sync.


---
**in-progress -> in-testing** (2026-03-20T18:10:18Z):
## Changes
- apps/web/internal/models/sleep_log.go (pre-existing SleepLog model)
- apps/web/internal/repositories/health_repository.go (added CreateSleepLog, ListSleepLogs)
- apps/web/internal/services/health_service.go (added LogSleepRequest DTO, LogSleep, ListSleepLogs with duration calc + quality validation)
- apps/web/internal/handlers/health.go (added LogSleep POST, ListSleepLogs GET handlers)
- apps/web/internal/handlers/health_routes.go (registered POST/GET /api/health/sleep routes)


---
**in-testing -> in-review** (2026-03-20T18:11:01Z): Gate skipped for kind=bug


---
**Review (approved)** (2026-03-20T18:11:18Z): Sleep logs API endpoints added: POST/GET /api/health/sleep with validation tests. User approved.
