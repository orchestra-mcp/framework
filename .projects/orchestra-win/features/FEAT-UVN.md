---
id: FEAT-UVN
kind: feature
priority: P2
project_slug: orchestra-win
status: backlog
title: Test Runner sub-plugin — go test / cargo test / vitest / Playwright
type: feature
---

# Test Runner sub-plugin — go test / cargo test / vitest / Playwright

Implement `Orchestra.Desktop/Plugins/DevToolsPlugin/TestRunner/` — multi-framework test runner with live output.

**`TestRunnerPage.xaml`:**
- Top: `ComboBox` framework selector (Go, Rust, Node/Vitest, Playwright, dotnet), path `TextBox`, filter `TextBox`, Run button
- Left: `TestTree` (`TreeView` — test suites > test cases, pass ✓ green / fail ✗ red / skip ◌ gray icons)
- Right: `TestDetailPanel` — selected test output, failure message, stack trace, screenshot (Playwright)
- Bottom status bar: `X passed`, `Y failed`, `Z skipped`, duration, `ProgressBar`

**Live streaming:** test output streams via `StreamChunk` events, `TestTree` updates in real-time as results arrive

**Framework commands:**
- Go: `go test ./... -v -json`
- Rust: `cargo test -- --format json`
- Node: `vitest run --reporter json`
- Playwright: `playwright test --reporter json`
- .NET: `dotnet test --logger trx`

**MCP tools called:** `test_run`, `test_list`, `test_run_single`, `test_run_suite`, `test_get_results`, `test_coverage`

**Platform:** Desktop, HoloLens