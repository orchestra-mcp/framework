---
id: FEAT-YST
kind: feature
priority: P2
project_slug: orchestra-tools
status: done
title: OS service control (devtools.services)
type: feature
---

# OS service control (devtools.services)

Tools: list_services, start_service, stop_service, restart_service, service_logs, service_info. macOS: launchctl. Linux: systemctl. Runtime platform detection.


---
**in-progress -> ready-for-testing**: 11 tests pass. All 6 tools covered: list_services (no required args, runs real command), start/stop/restart_service (validation + unknown service → exec_error), service_logs (validation + unknown service returns empty or success), service_info (validation + unknown service → not_found). Tests accept exec_error/not_found/unsupported_os for platform portability.


---
**in-testing -> ready-for-docs**: All 11 tests confirmed passing. Platform dispatch (launchctl/systemctl/unsupported_os) tested with nonexistent service names. service_logs handles empty output gracefully. service_info fallback chain tested.


## Note (2026-02-28T05:44:12Z)

## Implementation

**Plugin**: `libs/plugin-devtools-services/` — `devtools.services`  
**Binary**: `bin/devtools-services`  
**6 MCP tools** (macOS: launchctl, Linux: systemctl, other: unsupported_os error):

| Tool | Description | Required args |
|------|-------------|--------------|
| `list_services` | List OS services | none |
| `start_service` | Start a service by name | `name` |
| `stop_service` | Stop a service by name | `name` |
| `restart_service` | Restart a service by name | `name` |
| `service_logs` | Get logs for a service | `name` |
| `service_info` | Get detailed status for a service | `name` |

**svc package** (`internal/svc/exec.go`):
- `RunLaunchctl(ctx, args...)` — macOS
- `RunSystemctl(ctx, args...)` — Linux
- `RunService(ctx, args...)` — dispatches by `runtime.GOOS`
- `IsDarwin()` / `IsLinux()` — used for tool-level dispatch

**macOS specifics**:
- `list_services`: `launchctl list`
- `start/stop/restart`: `launchctl start/stop/kickstart` 
- `service_logs`: `log show --predicate 'process == "name"'`
- `service_info`: `launchctl print system/{name}` → fallback to `launchctl print gui/501/{name}` → fallback grep `launchctl list`

**Linux specifics**: All tools use `systemctl` equivalents.

**Error codes**: `validation_error`, `exec_error` (command failed), `not_found` (service not found in list), `unsupported_os` (not macOS or Linux).

**Tests**: 11 tests in `internal/tools/tools_test.go`. All pass. Validation tests work on all platforms. OS-specific tests use a nonexistent service name (`orchestra-nonexistent-service-xyz`) to trigger controlled failures.


---
**in-docs -> documented**: Documented all 6 tools. launchctl/systemctl dispatch, macOS log show and service_info fallback chain, unsupported_os guard. Tests: 11, all pass.


---
**in-review -> done**: Code review: Clean OS dispatch pattern using IsDarwin()/IsLinux() booleans. svc package properly separates exec concerns from tool logic. service_info fallback chain (system → gui/501 → list+grep) is realistic for macOS. service_logs uses native log show predicate. All tools handle empty output gracefully. 11 tests pass.