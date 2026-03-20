---
title: Feature Workflow Tools
description: 34 tools for gated feature lifecycle management
order: 1
---

# Feature Workflow Tools

The `tools.features` plugin provides **70 tools** for managing the complete feature lifecycle — from creation through testing, documentation, and review.

## Feature Lifecycle

Every piece of work in Orchestra follows a gated lifecycle:

```
todo → in-progress → in-testing → in-docs → in-review → done
                                    ↗ (bugs/hotfixes skip docs)
```

Each transition requires **evidence** — proof that the previous phase is complete. This prevents shortcuts and ensures quality.

## Core Feature Tools

| Tool | Description |
|------|-------------|
| `create_feature` | Create a new feature with kind (feature/bug/hotfix/chore) |
| `list_features` | List features filtered by status, project, assignee |
| `search_features` | Full-text search across feature titles and descriptions |
| `get_feature` | Get full feature details including audit trail |
| `set_current_feature` | Start working on a feature (acquires session lock) |
| `advance_feature` | Pass a gate with evidence to move to the next phase |
| `submit_review` | Complete the review cycle (approved or needs-edits) |
| `unlock_feature` | Admin tool to release stale session locks |

## Feature Kinds

| Kind | Description | Docs Gate |
|------|-------------|-----------|
| `feature` | New functionality or enhancement | Required |
| `bug` | Defect report | Skipped |
| `hotfix` | Urgent fix | Skipped |
| `chore` | Maintenance, refactoring, CI | Required |
| `testcase` | QA test case linked to a parent feature | Skipped |

## Gate Evidence

Each gate transition requires structured evidence with a section header and file references:

### Gate 1: Code Complete (in-progress → in-testing)

```
evidence: "## Changes\n- src/auth/login.go (added JWT validation)\n- src/auth/middleware.go (new file)"
```

### Gate 2: Test Complete (in-testing → in-docs)

```
evidence: "## Results\n- src/auth/login_test.go (12 tests, all pass)\n- src/auth/middleware_test.go (8 tests, all pass)"
```

Test file patterns are validated: `*_test.go`, `*.test.ts`, `*.test.tsx`, `*.spec.js`, etc.

### Gate 3: Docs Complete (in-docs → in-review)

```
evidence: "## Docs\n- docs/auth-middleware.md (new — JWT validation flow)"
```

Docs must be `.md` files in the `docs/` directory. This gate is auto-skipped for bugs, hotfixes, and testcases.

## Plan Tools

For tasks that span 3+ features, use plans:

| Tool | Description |
|------|-------------|
| `create_plan` | Create a plan in draft status |
| `approve_plan` | Move plan from draft to approved |
| `breakdown_plan` | Break plan into features with dependencies |
| `complete_plan` | Mark plan as completed after all features are done |
| `get_plan` | Get plan details and linked features |
| `list_plans` | List plans by status |

## Request Queue Tools

| Tool | Description |
|------|-------------|
| `create_request` | Queue a user request while busy |
| `list_requests` | View the request queue |
| `get_next_request` | Pick up the next queued request |
| `convert_request` | Convert a request into a feature |
| `dismiss_request` | Discard an irrelevant request |

## Git Tools

| Tool | Description |
|------|-------------|
| `git_quick_commit` | Stage all + commit with person profile |
| `git_push` | Push to remote |
| `git_pull` | Pull from remote (optional rebase) |
| `git_create_branch` | Create and switch to a new branch |
| `git_merge_branch` | Merge a branch |
| `git_status_summary` | Get working tree status |

## Bug Reporting

```
create_bug_report({
  title: "Login fails with expired JWT",
  related_feature: "FEAT-042",
  description: "After JWT expiry..."
})
```

Creates a feature with `kind: bug` linked to the original feature. Follows the same lifecycle but docs gate is auto-skipped.

## Session Locking

Features are locked to the calling MCP session when work begins. This prevents concurrent sessions from modifying the same feature.

- Locks are acquired by `set_current_feature`
- Locks auto-expire after 30 minutes of inactivity
- `unlock_feature` is the admin recovery tool
