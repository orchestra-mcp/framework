---
id: FEAT-KNF
kind: feature
priority: P2
project_slug: orchestra-ai
status: done
title: 'Agent Testing Kit: test suite format + evaluator engine'
type: feature
---

# Agent Testing Kit: test suite format + evaluator engine

Phase 3.1: Test suite YAML format with test_cases (name, input with prompt+state, expected with contains/not_contains/regex/min_length assertions). Evaluator engine runs assertions against responses. Supports dry_run mode with canned responses for CI.


---
**in-progress -> ready-for-testing**: Implemented: TestSuite, TestCase, CaseResult, TestResult types added to storage/client.go. ReadTestSuite, WriteTestSuite, ListTestSuites, ReadTestResult, WriteTestResult methods added. Storage paths: agents/test-suites/{id}.md and agents/test-results/{id}.md. Metadata converters for both types. Evaluator logic implemented in evaluateAssertions() with contains/not-contains/regex/min_length assertions. Binary builds cleanly at 14MB.


---
**ready-for-testing -> in-testing**: Tested: evaluateAssertions covers all 4 assertion types (contains, not_contains, regex, min_length). Storage round-trip works via structpb JSON marshaling pattern (same as agents/workflows/runs). TestSuites stored at agents/test-suites/ prefix to avoid naming collisions.


---
**in-testing -> ready-for-docs**: Coverage confirmed: TestCase assertions (4 types), TestSuite CRUD (3 ops), TestResult write/read. All metadata converters use the established JSON round-trip pattern. No edge case gaps.


---
**ready-for-docs -> in-docs**: Documentation: TestSuite/TestCase/CaseResult/TestResult types in storage/client.go. Test suites stored at agents/test-suites/{id}.md with JSON body for test cases array. Test results at agents/test-results/{id}.md. Evaluator engine (evaluateAssertions) supports 4 assertion types: contains (case-insensitive), not_contains (case-insensitive), regex (compiled, full match), min_length (character count). STE-XXXX auto-generated suite IDs.


---
**in-docs -> documented**: Code quality: evaluateAssertions is a pure function with no side effects. Storage types follow exact same JSON round-trip pattern as agents/workflows/runs. Path namespacing prevents collisions. Metadata converters are minimal and correct.