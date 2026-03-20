---
id: FEAT-PNX
kind: feature
priority: P2
project_slug: orchestra-linux
status: backlog
title: Test runner sub-tool
type: feature
---

# Test runner sub-tool

Test Runner sub-tool. Sidebar: list of discovered test suites (framework icon, name, file count). Run All button and per-suite Run button. Results panel: GtkTreeListModel showing test suites → test files → individual tests with pass/fail/skip icons and duration. Failing test row: expandable with error message and stack trace in GtkSourceView. Coverage summary: AdwPreferencesGroup with coverage % per file as GtkLevelBar. Watch mode toggle. Calls devtools.test-runner tools: test_discover, test_run, test_run_suite, test_results, test_coverage, test_watch. Frameworks: go test, cargo test, vitest, pytest.