---
id: FEAT-WDO
kind: feature
priority: P1
project_slug: orchestra-tools
status: done
title: Broaden mandatory workflow rule to cover ALL user requests
type: feature
---

# Broaden mandatory workflow rule to cover ALL user requests

The CLAUDE.md mandatory workflow rule says "when the user asks you to build, fix, or change anything" — but this is too narrow. Agents bypass it for non-code tasks like "test the workflow" or "run the tests". The rule must cover ANY task the user requests, not just code changes. Update all 3 sources: root CLAUDE.md, workspace.go generated CLAUDE.md, and bundled.go SKILL.md.


---
**in-progress -> ready-for-testing**: ## Summary
Broadened the mandatory workflow rule across all 3 sources so agents cannot bypass MCP for ANY task — not just code changes. The old wording "build, fix, or change anything" let agents skip MCP for tasks like "test the workflow" or "investigate a bug". Now it explicitly covers: build, fix, test, refactor, document, investigate, or change.

## Changes
- `CLAUDE.md` (root): Changed trigger from "build, fix, or change anything" to "do ANY task — build, fix, test, refactor, document, investigate, or change anything". Changed reinforcement from "Never write code without an active feature" to "Never do any work without an active feature. This includes running tests, writing docs, investigating bugs, and refactoring."
- `libs/cli/internal/workspace.go`: Same wording changes in buildClaudeMD() — the generated CLAUDE.md that `orchestra init` writes to user projects.
- `libs/cli/internal/bundled.go`: Same wording changes in projectManagerSkill constant — the SKILL.md installed to `.claude/skills/project-manager/`.

## Verification
- `go build ./internal/...` passes in libs/cli (workspace.go + bundled.go compile)
- All 9 gate validation tests pass in libs/sdk-go/types
- All 29 workflow tests pass in libs/plugin-tools-features/internal


---
**in-testing -> ready-for-docs**: ## Summary
Verified all 3 modified files compile and all existing tests pass. This is a wording-only change to instruction text — no logic changes, so existing gate validation and workflow tests cover correctness.

## Results
- `libs/cli`: `go build ./internal/...` — compiles cleanly, no errors
- `libs/sdk-go/types`: 9/9 gate validation tests pass
- `libs/plugin-tools-features/internal`: 29/29 workflow tests pass (including 10 gate enforcement tests)

## Coverage
No new test code needed — this change modifies only string constants in CLAUDE.md, workspace.go, and bundled.go. The gate enforcement logic and validation tests are unchanged and already comprehensive (16 unit tests for gate validation + 10 integration tests for gate enforcement in workflow tools).


---
**in-docs -> documented**: ## Summary
The mandatory workflow rule is self-documenting — it lives in CLAUDE.md (the project's primary instruction file), the generated CLAUDE.md template (workspace.go), and the bundled SKILL.md (bundled.go). All three are the documentation.

## Location
- Root CLAUDE.md lines 222-234: "Mandatory Workflow Rule" section — read by agents for every session
- `libs/cli/internal/workspace.go` lines 126-135: Generated CLAUDE.md template — written to user projects on `orchestra init`
- `libs/cli/internal/bundled.go` lines 47-57: SKILL.md template — installed to `.claude/skills/project-manager/` on init


---
**Review (approved)**: User approved. Wording broadened across all 3 sources to prevent agents from bypassing MCP for non-code tasks.