---
id: FEAT-NDX
kind: feature
priority: P2
project_slug: orchestra-pro
status: done
title: Add Rate Limiting to Tool Dispatch
type: feature
---

# Add Rate Limiting to Tool Dispatch

Add per-session token bucket rate limiter to the in-process router. Default: 100 calls/minute, configurable via environment variable ORCHESTRA_RATE_LIMIT. Return structured error with retry-after hint when exceeded. Files: libs/cli/internal/inprocess/router.go, new ratelimit.go.


---
**in-progress -> in-testing** (2026-03-14T19:38:26Z):
## Changes
- libs/cli/internal/inprocess/ratelimit.go (new — sliding-window rate limiter with per-caller buckets, configurable via ORCHESTRA_RATE_LIMIT env var, default 100 calls/min)
- libs/cli/internal/inprocess/router.go (modified — added limiter field to Router, integrated rate limit check in routeToolCall before dispatch)


---
**in-testing -> in-docs** (2026-03-14T19:39:38Z):
## Results
- libs/cli/internal/inprocess/ratelimit_test.go (new — 8 tests)
- TestRateLimiter_AllowsWithinLimit: PASS — 5 calls within limit of 5
- TestRateLimiter_BlocksOverLimit: PASS — 4th call blocked, returns rateLimitError with RetryAfter
- TestRateLimiter_PerCallerIsolation: PASS — separate caller buckets
- TestRateLimiter_WindowExpiry: PASS — calls allowed after 50ms window expires
- TestRateLimitError_Message: PASS — error message includes "rate limit exceeded" and "retry after"
- TestNewRateLimiter_DefaultLimit: PASS — defaults to 100/min
- TestNewRateLimiter_EnvOverride: PASS — ORCHESTRA_RATE_LIMIT=50 works
- TestNewRateLimiter_InvalidEnv: PASS — invalid env falls back to default


---
**in-docs -> in-review** (2026-03-14T19:39:56Z):
## Docs
- docs/rate-limiting.md (new — configuration, sliding window algorithm, error response format)


---
**Review (approved)** (2026-03-14T20:16:12Z): Per-caller sliding-window rate limiter with env-configurable limit and structured error responses.