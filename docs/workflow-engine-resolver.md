# Per-Project Workflow Engine Resolution

The workflow engine now resolves per-project from the database, replacing the single global engine. Each project can have its own custom workflow while falling back to the default when no DB record exists.

## Architecture

```
EngineResolver
  ├── Resolve(projectID) → *Engine
  │     ├── Check cache (30s TTL)
  │     ├── Query globaldb.GetProjectWorkflow()
  │     ├── Convert WorkflowRecord → WorkflowDefinition → Engine
  │     └── Cache result
  ├── Invalidate(projectID) — clear single project cache
  └── InvalidateAll() — clear entire cache
```

## How It Works

1. **EngineResolver** wraps a fallback `*Engine` (the default workflow)
2. When a tool handler needs the engine (e.g. `advance_feature`), it calls `resolver.Resolve(projectID)`
3. The resolver checks its in-memory cache first (30-second TTL)
4. On cache miss, it queries `globaldb.GetProjectWorkflow(projectID)` for a DB-backed workflow
5. If found, it converts the `WorkflowRecord` → `WorkflowDefinition` → `*Engine` and caches it
6. If not found, it returns and caches the fallback engine

## Cache Invalidation

CRUD operations on workflows automatically invalidate the resolver cache:

- `create_workflow` → `resolver.Invalidate(projectID)`
- `update_workflow` → `resolver.Invalidate(projectID)`
- `delete_workflow` → `resolver.Invalidate(projectID)`

This ensures the next `advance_feature` / `set_current_feature` / etc. picks up the latest workflow definition.

## Affected Tool Handlers

These handlers now resolve the engine per-project instead of using a global engine:

| Tool | Change |
|------|--------|
| `advance_feature` | `resolver.Resolve(projectID)` before checking transitions |
| `reject_feature` | `resolver.Resolve(projectID)` before checking transitions |
| `set_current_feature` | `resolver.Resolve(projectID)` before checking transitions |
| `get_gate_requirements` | `resolver.Resolve(projectID)` before looking up gates |

## Key File

- `libs/sdk-go/workflow/resolver.go` — EngineResolver implementation
- `libs/sdk-go/workflow/resolver_test.go` — 8 tests covering all paths

## Backwards Compatibility

- Projects without a DB workflow record use the default engine (same as before)
- The `*Engine` type is unchanged — resolver is an additive wrapper
- Existing tests updated to use `testResolver` wrapping `testEng` (same behavior)
