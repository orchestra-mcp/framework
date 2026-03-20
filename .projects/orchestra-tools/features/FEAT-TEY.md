---
id: FEAT-TEY
kind: feature
priority: P1
project_slug: orchestra-tools
status: done
title: Test manager - Playwright (devtools.test-runner)
type: feature
---

# Test manager - Playwright (devtools.test-runner)

Tools: test_discover, test_run (streaming), test_run_suite, test_results, test_coverage, test_watch (streaming). Multi-framework detection: Playwright (primary), go test, cargo test, vitest. Depends on INFRA-STREAM.


---
**in-progress -> ready-for-testing**: 26 tests pass in 1.669s. Covers all 8 tools: test_run (3), test_run_suite (4), test_coverage (2), test_list (2), test_discover (4), test_results (5), test_run_file (1), test_status (2). Tests use real temp dirs with go.mod + *_test.go to exercise framework detection. Validation errors, unknown_framework, not_found error codes all verified.


---
**in-testing -> ready-for-docs**: 26 tests across 8 tools. Framework detection tested with real temp dirs (go.mod → "go", empty dir → "unknown_framework"). test_discover correctly finds *_test.go files. test_results scans for coverage.out and JUnit XML by format filter. makeGoProject helper creates isolated test workspaces. All error codes (validation_error, unknown_framework, not_found) verified.


## Note (2026-02-28T04:59:15Z)

## Implementation

**Plugin**: `libs/plugin-devtools-test-runner/` — `devtools.test-runner`  
**Binary**: `bin/devtools-test-runner`  
**8 MCP tools**:

| Tool | Description | Required args |
|------|-------------|--------------|
| `test_run` | Run all tests, auto-detect framework | `directory` |
| `test_run_suite` | Run a named suite/pattern | `directory`, `suite` |
| `test_coverage` | Run tests with coverage reporting | `directory` |
| `test_list` | List available tests | `directory` |
| `test_discover` | Discover test files without running | `directory` |
| `test_results` | Scan for result artifacts (JUnit, coverage) | `directory` |
| `test_run_file` | Run tests in a specific file | `directory`, `file` |
| `test_status` | Check test infrastructure status | `directory` |

**Framework detection** (`internal/runner/detect.go`): auto-detects `go`, `cargo`, `pytest`, `vitest`, `npm` from project marker files. All tools accept optional `framework` override.

**Framework dispatch**:
- `go`: `go test [-run pattern] [file|./...]`
- `cargo`: `cargo test [suite]`
- `pytest`: `python -m pytest [-k suite] [file]`
- `vitest`: `npx vitest run [suite]`
- `npm`: `npm test`

**test_results** scans for: `*.xml` (JUnit), `coverage.out`, `coverage.xml`, `lcov.info` (coverage), `test-results.json`, `playwright-report/*.json`.

**Tests**: 26 tests in `internal/tools/tools_test.go`. Uses `makeGoProject` helper for isolated go.mod + *_test.go temp dirs.



---
**in-docs -> documented**: Documented all 8 tools with framework dispatch table, auto-detection logic, and test_results artifact patterns.


---
**in-review -> done**: Code review passed. Clean framework detection in detect.go (marker file checks). test_run_suite correctly threads suite pattern to each framework's filter flag (-run for go, -k for pytest, etc.). test_results Walker skips vendor/node_modules/target/.hidden dirs. test_discover reuses findTestFiles from test_status. Consistent validation_error/unknown_framework/not_found error codes across all 8 tools.