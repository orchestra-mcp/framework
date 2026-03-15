---
created_at: "2026-03-14T18:43:11Z"
description: 'Add OpenTelemetry spans to tool dispatch with: tool name, plugin name, duration, error status, input size. Add dependency health checks (verify all registered plugins respond). Expose basic metrics: tool call count, error rate, p50/p95 latency. Files: libs/cli/internal/inprocess/router.go, new telemetry package, health check endpoint.'
id: FEAT-LDT
kind: feature
labels:
    - plan:PLAN-MPF
priority: P2
project_id: orchestra-pro
status: todo
title: Add OpenTelemetry Observability
updated_at: "2026-03-14T18:43:11Z"
version: 0
---

# Add OpenTelemetry Observability

Add OpenTelemetry spans to tool dispatch with: tool name, plugin name, duration, error status, input size. Add dependency health checks (verify all registered plugins respond). Expose basic metrics: tool call count, error rate, p50/p95 latency. Files: libs/cli/internal/inprocess/router.go, new telemetry package, health check endpoint.
