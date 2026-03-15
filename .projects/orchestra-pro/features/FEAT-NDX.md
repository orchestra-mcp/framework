---
created_at: "2026-03-14T18:43:11Z"
description: 'Add per-session token bucket rate limiter to the in-process router. Default: 100 calls/minute, configurable via environment variable ORCHESTRA_RATE_LIMIT. Return structured error with retry-after hint when exceeded. Files: libs/cli/internal/inprocess/router.go, new ratelimit.go.'
id: FEAT-NDX
kind: feature
labels:
    - plan:PLAN-MPF
priority: P2
project_id: orchestra-pro
status: todo
title: Add Rate Limiting to Tool Dispatch
updated_at: "2026-03-14T18:43:11Z"
version: 0
---

# Add Rate Limiting to Tool Dispatch

Add per-session token bucket rate limiter to the in-process router. Default: 100 calls/minute, configurable via environment variable ORCHESTRA_RATE_LIMIT. Return structured error with retry-after hint when exceeded. Files: libs/cli/internal/inprocess/router.go, new ratelimit.go.
