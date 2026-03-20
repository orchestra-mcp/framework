---
name: project-manager
description: Project management with Orchestra MCP tools. Activates when planning features, tracking workflow, managing dependencies, or coordinating work.
---

# Project Manager

All project management is driven through **Orchestra MCP tools**. Never manage tasks outside the MCP workflow.

## MANDATORY: Auto-Session Workflow

When the user asks you to do ANY task — build, fix, test, refactor, document, investigate, or change ANYTHING — you MUST follow this flow:

1. **Check for existing feature**: Use `search_features` or `list_features` to see if a feature already exists for this work.
2. **Create feature if needed**: Use `create_feature` to track the work. Set appropriate priority and labels.
3. **Start work**: Use `set_current_feature` to move the feature to in-progress.
4. **Do the work**: Write code, delegate to sub-agents if needed.
5. **Pass gates**: Use `advance_feature` with required evidence at each gate.
6. **Review**: Use `request_review` and ask the user for approval via `AskUserQuestion`.
7. **Complete**: Use `submit_review` with the user's decision.

**NEVER do any work without an active feature in MCP.** This includes running tests, writing docs, investigating bugs, and refactoring. The MCP tracks all work.

## User Interaction Rule

**ALWAYS use the AskUserQuestion tool when you need user input.** Never print questions as plain text. This includes:
- Feature planning decisions (scope, priority, approach)
- Architecture and design choices
- Review approval (Gate 4 requires human approval)
- Any clarification or confirmation needed from the user

## Feature Lifecycle (10 states)

```
backlog -> todo -> in-progress -> ready-for-testing -> in-testing ->
  ready-for-docs -> in-docs -> documented -> in-review -> done
                                                |
                        needs-edits <-----------+
```

### Gated Transitions (evidence required)

The MCP enforces gates. You CANNOT advance without providing evidence in the correct format.

| Gate | Transition | Required Sections | How |
|------|-----------|-------------------|-----|
| 1 | in-progress -> ready-for-testing | ## Summary, ## Changes, ## Verification | advance_feature with evidence |
| 2 | in-testing -> ready-for-docs | ## Summary, ## Results, ## Coverage | advance_feature with evidence |
| 3 | in-docs -> documented | ## Summary, ## Location | advance_feature with evidence |
| 4 | documented -> in-review | ## Summary, ## Quality, ## Checklist | request_review with evidence |
| 5 | in-review -> done | User approval | submit_review after AskUserQuestion |

**Gate evidence format** — provide markdown with `## Section` headers:
```
evidence: "## Summary\n<what was done>\n\n## Changes\n<files changed>\n\n## Verification\n<how to test>"
```

If you forget what's needed, call `get_gate_requirements` to see the checklist.

**NEVER batch-advance through gates.** Each gate requires real work done first.

### Free Transitions (no gate)

These transitions can be done without evidence:
- backlog -> todo (prioritization)
- todo -> in-progress (claiming work)
- ready-for-testing -> in-testing (starting tests)
- ready-for-docs -> in-docs (starting docs)
- needs-edits -> in-progress (restarting after rejection)

## Starting a Session

```
get_project_status    -> See overall state (counts, completion %)
get_workflow_status   -> What's blocked, in-progress, completion %
get_next_feature      -> Pick highest-priority actionable work
```

## During Work

```
set_current_feature   -> Mark feature in-progress
advance_feature       -> Move through lifecycle (gated transitions need evidence)
get_gate_requirements -> See what evidence is needed for the next gate
update_feature        -> Change priority, description, labels
assign_feature        -> Assign to a team member
add_dependency        -> Create blocker relationships between features
```

## Feature Tools (35 total)

### Project (4)
create_project, list_projects, delete_project, get_project_status

### Feature (6)
create_feature, get_feature, update_feature, list_features, delete_feature, search_features

### Workflow (6)
advance_feature, reject_feature, get_next_feature, set_current_feature, get_workflow_status, get_gate_requirements

### Review (3)
request_review, submit_review, get_pending_reviews

### Dependencies (4)
add_dependency, remove_dependency, get_dependency_graph, get_blocked_features

### WIP Limits (3)
set_wip_limits, get_wip_limits, check_wip_limit

### Reporting (3)
get_progress, get_review_queue, get_blocked_features

### Metadata (6)
add_labels, remove_labels, assign_feature, unassign_feature, set_estimate, save_feature_note, list_feature_notes

## Marketplace Tools (15 total)

### Pack Management (6)
install_pack, remove_pack, update_pack, list_packs, get_pack, search_packs

### Recommendations (2)
detect_stacks, recommend_packs

### Content Queries (5)
list_skills, list_agents, list_hooks, get_skill, get_agent

### Configuration (2)
set_project_stacks, get_project_stacks

## Sub-Agent Rules

Sub-agents (Task tool) do **NOT** have MCP access. They cannot call advance_feature or any workflow tool.

| Rule | Detail |
|------|--------|
| Sub-agents = code only | Only use during in-progress for writing code |
| Main agent owns lifecycle | YOU handle all gates: test, document, review |
| One feature at a time | Complete full lifecycle before picking next |
| Summarize to user | Tell user what sub-agent built before advancing |

## Conventions

- One feature = one branch = one PR
- Every PR must have tests
- Use add_labels for categorization
- Use set_estimate for sizing
- Use save_note to record decisions
