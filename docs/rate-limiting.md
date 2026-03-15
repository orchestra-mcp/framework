# Rate Limiting

## Overview

The in-process router enforces per-caller rate limits on tool dispatch to prevent runaway loops or misbehaving plugins from overwhelming the system.

## Configuration

| Setting | Default | Source |
|---------|---------|--------|
| Calls per minute | 100 | `ORCHESTRA_RATE_LIMIT` env var |
| Window duration | 1 minute | Hardcoded |

Set `ORCHESTRA_RATE_LIMIT=50` to lower the limit, or `ORCHESTRA_RATE_LIMIT=500` to raise it.

## How It Works

- **Sliding window**: Each caller maintains a list of call timestamps within the current 1-minute window
- **Per-caller isolation**: Rate limits are tracked per `CallerPlugin` field from the ToolRequest. Callers without an identifier share a "default" bucket
- **Expired eviction**: Old timestamps are evicted on each `allow()` call
- **Structured error**: When exceeded, returns a `rate_limited` error code with a `retry after` hint indicating when the earliest call in the window expires

## Error Response

When rate limited, tool calls return:
```json
{
  "success": false,
  "error_code": "rate_limited",
  "error_message": "rate limit exceeded, retry after 45.2s"
}
```

## Files

| File | Purpose |
|------|---------|
| `libs/cli/internal/inprocess/ratelimit.go` | `rateLimiter` implementation |
| `libs/cli/internal/inprocess/router.go` | Integration point in `routeToolCall` |
| `libs/cli/internal/inprocess/ratelimit_test.go` | 8 tests |
