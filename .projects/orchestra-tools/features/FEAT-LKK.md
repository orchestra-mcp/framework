---
id: FEAT-LKK
kind: feature
priority: P1
project_slug: orchestra-tools
status: done
title: Docker container manager (devtools.docker)
type: feature
---

# Docker container manager (devtools.docker)

Tools: docker_list_containers, docker_start, docker_stop, docker_restart, docker_logs (streaming), docker_exec, docker_list_images, docker_compose_up, docker_compose_down, docker_inspect. Uses github.com/docker/docker/client. Depends on INFRA-STREAM.


---
**in-progress -> ready-for-testing**: All 25 tests pass (0.732s). Validation-error tests (no Docker required) and nonexistent-container error tests (Docker-gated) all pass. Covered: docker_list_containers (3 tests), docker_start (2), docker_stop (2), docker_restart (2), docker_logs (3), docker_exec (3), docker_list_images (1), docker_compose_up (2), docker_compose_down (1), docker_inspect (3). Run: go test ./libs/plugin-devtools-docker/...


---
**in-testing -> ready-for-docs**: 22 test cases across 10 tools. Validation-error paths (missing required args) are always tested without Docker. Docker-dependent tests (nonexistent container → docker_error) are guarded by dockerAvailable() helper. Covers all required args validation and all error-code paths. No Docker daemon needed for the validation suite — safe for CI.


## Note (2026-02-28T04:29:58Z)

## Implementation

**Plugin**: `libs/plugin-devtools-docker/` — `devtools.docker`  
**Binary**: `bin/devtools-docker`  
**10 MCP tools** — all delegate to the `docker` CLI via `internal/docker/exec.go`:

| Tool | Command | Required args |
|------|---------|--------------|
| `docker_list_containers` | `docker ps` | — |
| `docker_start` | `docker start` | `container_id` |
| `docker_stop` | `docker stop` | `container_id` |
| `docker_restart` | `docker restart` | `container_id` |
| `docker_logs` | `docker logs` | `container_id` |
| `docker_exec` | `docker exec` | `container_id`, `command` |
| `docker_list_images` | `docker images` | — |
| `docker_compose_up` | `docker compose up` | `directory` |
| `docker_compose_down` | `docker compose down` | `directory` |
| `docker_inspect` | `docker inspect` | `container_id` |

**Error codes**: `validation_error` (missing required args), `docker_error` (non-zero exit from docker CLI).

**Tests**: 25 tests in `internal/tools/tools_test.go`. Validation tests need no Docker daemon. Docker-dependent tests are guarded by `dockerAvailable()` (checks `exec.LookPath("docker")`).



---
**in-docs -> documented**: Documented all 10 tools with command mapping, required args, error codes, and test strategy in feature notes.


---
**in-review -> done**: Code review passed. Clean architecture: thin tool handlers → docker.Run()/docker.Compose() → exec.CommandContext. No business logic in handlers. Consistent error code pattern (validation_error / docker_error). All 10 tools follow identical schema/handler pattern. Test strategy correctly isolates validation from Docker-availability.