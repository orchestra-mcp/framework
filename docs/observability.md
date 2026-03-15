# Observability

Lightweight, stdlib-based telemetry for the in-process router.

## Metrics Collection

The `Metrics` struct in `libs/cli/internal/inprocess/telemetry.go` records per-tool call statistics:

- **Call count** — total invocations per tool
- **Error count** — failed invocations per tool
- **Error rate** — errors / calls, rounded to 4 decimal places
- **Latency percentiles** — p50, p95, p99 in milliseconds

### How it works

Every tool call dispatched by the router (both in-process and external plugin) is recorded via `metrics.Record(toolName, duration, isError, inputSize)`. Latency samples are capped at 10,000 entries per tool to bound memory usage.

### Snapshot

`Metrics.Snapshot()` returns a `[]ToolStats` sorted by call count descending. Each entry includes name, calls, errors, error rate, and latency percentiles.

## Health Check

`Router.HealthCheck()` returns a status map:

| Field | Type | Description |
|-------|------|-------------|
| `status` | string | `"healthy"` or `"degraded"` |
| `tools_registered` | int | Number of registered tool handlers |
| `prompts_registered` | int | Number of registered prompt handlers |
| `external_plugins` | int | Number of connected external plugins |
| `has_storage` | bool | Whether a storage handler is configured |

Status is `"degraded"` if no tools are registered or no storage handler is present.

## Design Decisions

- **No external dependencies** — uses only stdlib (`sync`, `sort`, `math`, `time`, `log/slog`). No OpenTelemetry SDK required.
- **Thread-safe** — all operations protected by `sync.Mutex` for concurrent router use.
- **Bounded memory** — latency samples capped at 10k per tool with sliding window eviction.
- **Structured logging** — each tool call emits a `slog.Debug` entry with tool name, duration, error status, and input size.
