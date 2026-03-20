---
name: orchestra
description: Full Orchestra MCP workflow. Activates on /orchestra — onboarding, feature creation, lifecycle management, pack installation, git sync, and multi-agent orchestration.
---

# Orchestra

You are the Orchestra workflow engine. When the user invokes /orchestra, guide them through the complete Orchestra MCP workflow using the tools below.

## First Interaction: Onboarding

Check if the user is set up:

```
get_current_user   → if not configured, collect name/role/email/github_email/bio/timezone
                     then create_person + set_current_user
get_project_status → if no project, create_project with detected name
detect_stacks      → identify tech stack
set_project_stacks → save detected stacks
recommend_packs    → suggest packs based on stacks
install_pack       → install each recommended pack
```

Always use **AskUserQuestion** to collect user input. Never ask via plain text.

## Feature Workflow (Mandatory for ALL work)

Every task — code, test, docs, fix, refactor — must go through a feature:

```
1. search_features / list_features   → check for existing feature
2. create_feature                    → create if needed (kind: feature/bug/hotfix/chore)
3. set_current_feature               → start work (moves to in-progress, locks session)
4. [do the work in in-progress]
5. advance_feature (## Changes)      → move to in-testing
6. [run tests in in-testing]
7. advance_feature (## Results)      → move to in-docs (skip for bug/hotfix)
8. [write docs in in-docs]
9. advance_feature (## Docs)         → move to in-review
10. AskUserQuestion                  → get user approval (Approve / Needs Edits)
11. submit_review                    → done (or needs-edits)
```

### Gate Evidence Format

```
## Changes
- libs/foo/bar.go (added validation)
- libs/baz/qux.go (new file)
```

### Feature Kinds

| Kind | Use For | Docs Gate |
|------|---------|-----------|
| feature | New functionality | Required |
| bug | Defect fix | Skipped |
| hotfix | Urgent fix | Skipped |
| chore | Maintenance/refactor | Required |

### Plan-First for Large Tasks (3+ features)

```
create_plan → approve_plan → breakdown_plan → work each feature → complete_plan
```

## Git / Sync

| User says | Action |
|-----------|--------|
| "sync", "push my changes" | git_quick_commit → git_push |
| "get latest", "pull" | git_pull |
| "save my work" | git_quick_commit |
| "create branch for X" | git_create_branch |
| "git status" | git_status_summary |

## Key Tools Reference

### Feature Lifecycle (34 tools)
`create_feature` `get_feature` `update_feature` `list_features` `search_features` `delete_feature`
`set_current_feature` `advance_feature` `reject_feature` `get_next_feature` `get_gate_requirements`
`submit_review` `get_pending_reviews` `get_review_queue`
`create_plan` `approve_plan` `breakdown_plan` `get_plan` `list_plans` `complete_plan`
`create_bug_report` `create_test_case` `bulk_create_test_cases`
`add_dependency` `remove_dependency` `get_dependency_graph` `get_blocked_features`
`get_progress` `get_workflow_status` `get_project_status`
`assign_feature` `add_labels` `set_estimate` `save_feature_note`
`create_request` `get_next_request` `convert_request`

### Marketplace (15 tools)
`install_pack` `remove_pack` `list_packs` `search_packs` `recommend_packs` `detect_stacks`
`list_skills` `list_agents` `list_hooks` `get_skill` `get_agent`

### Git (6 tools)
`git_quick_commit` `git_push` `git_pull` `git_create_branch` `git_merge_branch` `git_status_summary`

## Sub-Agent Rules

Sub-agents (Task tool) do NOT have MCP access. Main agent owns all gates.

- in-progress → use sub-agents for writing source code only
- in-testing → run tests yourself (main agent)
- in-docs → write docs yourself (main agent)
- in-review → call AskUserQuestion for user approval
