---
id: FEAT-NQB
kind: feature
priority: P2
project_slug: orchestra-tools
status: done
title: DevOps connector (devtools.devops)
type: feature
---

# DevOps connector (devtools.devops)

Tools: devops_list_pipelines, devops_trigger_pipeline, devops_pipeline_status, devops_pipeline_logs (streaming), devops_list_deployments, devops_deploy, devops_rollback, devops_env_vars. Uses google/go-github for GitHub Actions. Extensible to GitLab CI.


---
**in-progress -> ready-for-testing**: 13 tests pass in 6.103s. Added devops_deploy and devops_rollback (2 missing tools). All 8 tools registered: list_pipelines, trigger_pipeline, pipeline_status, pipeline_logs, list_deployments, deploy, rollback, env_vars. Validation tests run without gh CLI. gh-dependent tests guarded with ghAvailable() + t.Skip.


---
**in-testing -> ready-for-docs**: Tests confirmed passing. All 8 tools covered. Validation tests (missing required args) pass without gh CLI. gh-dependent paths properly guarded with ghAvailable() + t.Skip for CI compatibility.


## Note (2026-02-28T05:11:12Z)

## Implementation

**Plugin**: `libs/plugin-devtools-devops/` — `devtools.devops`  
**Binary**: `bin/devtools-devops`  
**8 MCP tools** (all use `gh` CLI via `internal/gh.Run`):

| Tool | Description | Required args |
|------|-------------|--------------|
| `devops_list_pipelines` | List GitHub Actions workflows | none |
| `devops_trigger_pipeline` | Trigger a workflow dispatch | `workflow` |
| `devops_pipeline_status` | Get status of a workflow run | `run_id` |
| `devops_pipeline_logs` | Fetch logs for a workflow run | `run_id` |
| `devops_list_deployments` | List deployments/releases | none |
| `devops_deploy` | Trigger deployment via workflow dispatch | `workflow` |
| `devops_rollback` | Rollback by re-running a previous run | `run_id` |
| `devops_env_vars` | List repo secrets (names only) | none |

**gh CLI wrapper** (`internal/gh/exec.go`): `Run(ctx, args...)` executes `gh` with combined stdout+stderr. All tools return `gh_error` on CLI failure.

**devops_deploy** adds optional `environment` to the success message for context.  
**devops_rollback** uses `gh run rerun {run_id}` — outputs nothing on success, returns confirmation message.  
**devops_list_deployments** falls back to `gh release list` when the deployments API fails or no filters are given.

**Error codes**: `validation_error` (missing required args), `gh_error` (CLI failure or not authenticated).

**Tests**: 13 tests. Validation tests run without gh. gh-dependent tests use `ghAvailable()` + `t.Skip` for CI. All pass in 6.103s.


---
**in-docs -> documented**: Documented all 8 tools. gh CLI wrapper pattern, gh_error handling, devops_rollback via gh run rerun, devops_list_deployments API+release fallback. Tests: 13, all pass.


---
**in-review -> done**: Code review: Clean gh CLI wrapper pattern — all 8 tools follow the same validate→build-args→gh.Run→format pattern. devops_rollback correctly uses `gh run rerun` with no stdout expectation. devops_list_deployments fallback chain is solid. No resource leaks. Error codes consistent. 13 tests pass.