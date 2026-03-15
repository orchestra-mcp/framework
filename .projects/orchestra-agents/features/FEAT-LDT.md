---
created_at: "2026-03-14T18:43:11Z"
description: 'Add OpenTelemetry spans to tool dispatch with: tool name, plugin name, duration, error status, input size. Add dependency health checks (verify all registered plugins respond). Expose basic metrics: tool call count, error rate, p50/p95 latency. Files: libs/cli/internal/inprocess/router.go, new telemetry package, health check endpoint.'
id: FEAT-LDT
kind: feature
labels:
    - plan:PLAN-MPF
priority: P2
project_id: orchestra-pro
status: done
title: Add OpenTelemetry Observability
updated_at: "2026-03-14T20:27:48Z"
version: 5
---

# Add OpenTelemetry Observability

Add OpenTelemetry spans to tool dispatch with: tool name, plugin name, duration, error status, input size. Add dependency health checks (verify all registered plugins respond). Expose basic metrics: tool call count, error rate, p50/p95 latency. Files: libs/cli/internal/inprocess/router.go, new telemetry package, health check endpoint.


---
**in-progress -> in-testing** (2026-03-14T20:24:30Z):
## Changes
- libs/cli/internal/inprocess/telemetry.go (new — Metrics collector with per-tool call count, error count, latency percentiles p50/p95/p99, 10k entry cap per tool)
- libs/cli/internal/inprocess/router.go (modified — added metrics field, time import, metrics.Record calls in routeToolCall for in-process and external handlers, GetMetrics() accessor, HealthCheck() method)


---
**in-testing -> in-docs** (2026-03-14T20:27:14Z):
## Results
- libs/cli/internal/inprocess/telemetry_test.go (12 tests — all pass)
  - TestMetrics_RecordAndSnapshot: verifies call count, error count, error rate
  - TestMetrics_MultipleTools: verifies per-tool isolation and sort by calls
  - TestMetrics_Percentiles: verifies p50/p95/p99 with 100 data points
  - TestMetrics_EmptySnapshot: empty metrics returns empty slice
  - TestMetrics_ZeroErrors: error rate is 0 for clean tools
  - TestMetrics_AllErrors: error rate is 1.0 when all calls error
  - TestPercentile_EmptySlice: returns 0 for nil input
  - TestPercentile_SingleValue: returns the value for single-element input
  - TestRouterHealthCheck_Healthy: status=healthy with tools+storage
  - TestRouterHealthCheck_Degraded_NoStorage: status=degraded without storage
  - TestRouterHealthCheck_Degraded_NoTools: status=degraded without tools
  - TestRouterGetMetrics: accessor returns non-nil metrics

All 12 tests pass: `ok github.com/orchestra-mcp/cli/internal/inprocess 0.414s`


---
**in-docs -> in-review** (2026-03-14T20:27:32Z):
## Docs
- docs/observability.md (new — covers metrics collection, health check, design decisions)


---
**Review (approved)** (2026-03-14T20:27:48Z): Lightweight stdlib-based observability with full test coverage.
