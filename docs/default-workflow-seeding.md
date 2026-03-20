# Default Workflow Seeding

## Overview

When a project is created or first resolved by the workflow engine, Orchestra automatically seeds the default 7-state workflow into the global database. This ensures every project has a workflow record without requiring manual setup.

## How It Works

### On Project Creation

`CreateProject` in `tools/project.go` calls `workflow.SeedDefaultWorkflow(slug)` after writing the project to storage. This creates the default workflow record in `~/.orchestra/db/global.db`.

### On First Resolve (Migration)

For projects that existed before the workflow DB was introduced, `EngineResolver.Resolve()` auto-seeds the default workflow when no DB record is found. This provides seamless migration — existing projects get a workflow record on first access.

### Idempotency

`SeedDefaultWorkflow` is safe to call multiple times:
- If a workflow already exists for the project, it returns `nil, nil` (no-op)
- If a concurrent call creates a duplicate, the UNIQUE constraint is caught and returns `nil, nil`

## Default Workflow States

| State | Label | Terminal | Active Work |
|-------|-------|----------|-------------|
| todo | To Do | No | No |
| in-progress | In Progress | No | Yes |
| in-testing | Testing | No | Yes |
| in-docs | Documentation | No | Yes |
| in-review | Review | No | No |
| needs-edits | Needs Edits | No | No |
| done | Done | Yes | No |

## API

```go
// SeedDefaultWorkflow creates the default workflow for a project if none exists.
// Returns the created record, or nil if a workflow already exists.
func SeedDefaultWorkflow(projectID string) (*globaldb.WorkflowRecord, error)
```

## Files

- `libs/sdk-go/workflow/resolver.go` — `SeedDefaultWorkflow()` and auto-seeding in `Resolve()`
- `libs/plugin-tools-features/internal/tools/project.go` — seeding on project create
