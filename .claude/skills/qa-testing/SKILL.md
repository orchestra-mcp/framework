---
name: qa-testing
description: >-
  Orchestrates multi-agent testing across Go, Rust, Node.js, and Playwright.
  Activates when running tests, writing tests, debugging test failures, checking
  coverage, or setting up CI test pipelines; or when the user mentions test,
  testing, QA, spec, coverage, e2e, integration test, or unit test.
---

# QA Testing — Multi-Agent Test Orchestration

## When to Apply

Activate this skill when:
- Running or writing tests for any part of the stack
- Debugging test failures across Go, Rust, Node, or E2E
- Setting up test infrastructure or CI pipelines
- Checking test coverage or improving test quality
- The user says "run tests", "fix tests", "add tests", "coverage"

## Agent Delegation

This skill delegates to specialized testing agents based on what's being tested:

| What's Being Tested | Agent | Tools |
|---------------------|-------|-------|
| Go backend (`app/`, `cmd/`, `config/`) | `qa-go` | `go test`, testify, httptest, Fiber test app |
| Go plugins (`plugins/*/`) | `qa-go` | `go test`, standalone module testing |
| Rust engine (`engine/`) | `qa-rust` | `cargo test`, tempfile, tokio::test, tonic mock |
| React frontends (`resources/`) | `qa-node` | vitest, @testing-library/react, pnpm test |
| Shared packages (`resources/shared/`, `resources/ui/`) | `qa-node` | vitest, component snapshots |
| End-to-end browser flows | `qa-playwright` | Playwright, page objects, screenshots |
| Cross-stack integration | All agents in parallel | Each tests their layer |

## Running Tests

```bash
# All tests
make test

# By stack
go test ./...                                    # Go backend
cd plugins/mcp && go test ./...                  # MCP plugin
cd engine && cargo test                          # Rust engine
pnpm --filter './resources/*' test               # All frontends
pnpm --filter @orchestra/shared test             # Shared package
pnpm --filter @orchestra/ui test                 # UI components

# With coverage
go test -cover ./...
cd engine && cargo tarpaulin
pnpm --filter './resources/*' test -- --coverage
```

## Test File Conventions

| Stack | Pattern | Location |
|-------|---------|----------|
| Go | `*_test.go` in same package | Next to source files |
| Rust | `#[cfg(test)] mod tests` or `tests/` | Inline or `engine/tests/` |
| Node/React | `*.test.ts(x)` or `__tests__/` | Next to source or `__tests__/` |
| Playwright | `*.spec.ts` | `tests/e2e/` |

## Multi-Agent Workflow

When testing across the full stack:

1. **Parallel dispatch** — spawn `qa-go`, `qa-rust`, `qa-node` simultaneously
2. **Collect results** — wait for all agents to report pass/fail
3. **Fix failures** — delegate fixes to the appropriate agent
4. **Re-run** — verify fixes pass before reporting done
5. **E2E last** — run `qa-playwright` after unit/integration tests pass

## Connection to MCP Workflow Gates

Testing is required at two workflow gates. `advance_task` will **block** without evidence:

### Gate 1: `in-progress` → `ready-for-testing`
Before advancing, you MUST:
1. Run tests for the task's code (`go test`, `cargo test`, `pnpm test`)
2. Confirm all tests pass
3. Provide evidence: `advance_task(evidence="go test ./plugins/foo/... — 12/12 passed")`

### Gate 2: `in-testing` → `ready-for-docs`
Before advancing, you MUST:
1. Verify test coverage is acceptable
2. Check edge cases are covered (nil, empty, error paths)
3. Provide evidence: `advance_task(evidence="Coverage 85%, edge cases for nil/empty/error covered")`

### Example: Testing a Go Plugin Task

```
1. Agent builds plugin code (in-progress)
2. Delegate to qa-go: "Run tests for plugins/foo/"
3. qa-go runs: cd plugins/foo && go test ./... -v -cover
4. qa-go reports: "12/12 passed, 87% coverage"
5. advance_task(evidence="go test ./plugins/foo/... — 12/12 passed, 87% coverage")
   → ready-for-testing [GATE 1 passed]
6. advance_task → in-testing
7. Review: edge cases covered? error paths tested?
8. advance_task(evidence="Verified: nil input, empty config, invalid ID all tested")
   → ready-for-docs [GATE 2 passed]
```
