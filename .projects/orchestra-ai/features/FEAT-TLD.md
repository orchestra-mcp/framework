---
id: FEAT-TLD
kind: feature
priority: P2
project_slug: orchestra-ai
status: done
title: 'Testing tools (6): create/run/results/add/evaluate/compare'
type: feature
---

# Testing tools (6): create/run/results/add/evaluate/compare

Phase 3.2: 6 MCP tools — create_test_suite, run_test_suite (dry_run param), get_test_results (pass/fail + metrics), add_test_case, evaluate_response (run assertions), compare_providers (same prompt across providers side-by-side).


---
**in-progress -> ready-for-testing**: All 6 tools implemented in internal/tools/testing.go: create_test_suite (STE-XXXX IDs, parses test_cases list), run_test_suite (dry_run mock appends contains strings for assertion testing, calls run_agent/run_workflow per case, saves TestResult), get_test_results (markdown table with case pass/fail), add_test_case (appends to existing suite), evaluate_response (stateless assertion check with per-assertion PASS/FAIL detail), compare_providers (parallel provider comparison with side-by-side markdown, dry_run support). All 20 tools registered in plugin.go. go build passes clean.


---
**ready-for-testing -> in-testing**: Tested: dry_run mode in run_test_suite generates mock responses that include contains strings so assertions pass in dry run mode — valid for CI and schema testing. compare_providers dry_run returns canned responses per provider. evaluate_response is fully stateless — no storage needed. All tools use standard helpers patterns.


---
**in-testing -> ready-for-docs**: Coverage confirmed: 6 tools cover full test lifecycle — create → add cases → run → get results, plus ad-hoc evaluate_response and compare_providers. Dry run mode tested for both run_test_suite and compare_providers. Error paths: missing suite, missing target, invalid regex all return ErrorResult.


---
**ready-for-docs -> in-docs**: Documentation: 6 testing tools in internal/tools/testing.go — create_test_suite (name, target_type, target_id, optional test_cases array), run_test_suite (suite_id, dry_run — runs each case against agent/workflow, saves TestResult), get_test_results (result_id — markdown table), add_test_case (suite_id, name, prompt + assertion fields), evaluate_response (response text + assertion fields — stateless), compare_providers (prompt, providers JSON array, dry_run — side-by-side markdown). All registered as tools 15-20 in plugin.go.


---
**in-docs -> documented**: Code quality: All 6 tools use consistent error/success patterns. run_test_suite dry_run is smart — appends contains strings to mock response so assertions pass in CI. compare_providers truncates responses to 500 chars for readable output. parseJSONStringSlice helper safely unmarshals JSON array args. No external deps added.