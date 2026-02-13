---
name: project-manager
description: Project management and scrum master patterns. Activates when planning sprints, breaking down features, prioritizing tasks, creating architecture decision records, or coordinating across teams.
---

# Project Manager — MCP-Driven Workflow

All project management is driven through **Orchestra MCP tools**. Never manage tasks outside the MCP workflow.

## 13-State Task Lifecycle

```
backlog → todo → in-progress → ready-for-testing → in-testing
→ ready-for-docs → in-docs → documented → in-review → done
```

Special: `blocked` (from in-progress), `rejected` (from in-review, auto-creates bug), `cancelled` (terminal).

Use `advance_task` for happy-path progression. Use `reject_task` to reject from review.

## MCP Session Flow

### Starting a Session
```
get_project_status  → See overall state (counts, completion %, blocked)
list_sessions       → What happened in previous sessions
get_context         → Retrieve relevant memory
get_next_task       → Pick highest-priority actionable work
```

### During Work
```
set_current_task    → Mark task in-progress (cascades parents)
advance_task        → Move through lifecycle stages
update_task         → Set blocked, change priority, update description
complete_task       → Finish task (cascades parents to done if all siblings done)
```

### Ending a Session
```
save_session        → Persist session summary and events
save_memory         → Store important decisions for future context
```

## MCP Tools by Category (56 total)

### Project (5): `create_project`, `list_projects`, `get_project_status`, `read_prd`, `write_prd`
### Epic (5): `create_epic`, `list_epics`, `get_epic`, `update_epic`, `delete_epic`
### Story (5): `create_story`, `list_stories`, `get_story`, `update_story`, `delete_story`
### Task (5): `create_task`, `list_tasks`, `get_task`, `update_task`, `delete_task`
### Workflow (5): `get_next_task`, `set_current_task`, `complete_task`, `search`, `get_workflow_status`
### Lifecycle (2): `advance_task`, `reject_task`
### PRD (9): `start_prd_session`, `answer_prd_question`, `skip_prd_question`, `back_prd_question`, `get_prd_session`, `abandon_prd_session`, `preview_prd`, `split_prd`, `list_prd_phases`
### Quality (2): `report_bug`, `log_request`
### Memory (6): `save_memory`, `search_memory`, `get_context`, `save_session`, `list_sessions`, `get_session`
### Artifacts (2): `save_plan`, `list_plans`
### Usage (3): `record_usage`, `get_usage`, `reset_session_usage`
### Claude (6): `list_skills`, `list_agents`, `install_skills`, `install_agents`, `receive_hook_event`, `get_hook_events`
### Docs (1): `regenerate_readme`

## Team Structure (Agents)

```
Scrum Master (coordinator)
├── go-architect       → Go backend (Fiber v3, GORM, services)
├── rust-engineer      → Rust engine (gRPC, Tree-sitter, Tantivy)
├── frontend-dev       → React/TypeScript (all 5 frontends)
├── ui-ux-designer     → Design system, components, styling
├── dba                → PostgreSQL, SQLite, sync protocol
├── mobile-dev         → React Native, WatermelonDB
├── devops             → Docker, CI/CD, deployment
├── widget-engineer    → Native OS widgets (macOS/Windows/Linux)
├── platform-engineer  → macOS CGo, Spotlight, Keychain, iCloud
├── extension-architect → Extension system + marketplace
└── ai-engineer        → AI/LLM, RAG, vectors, embeddings
```

## Sprint Planning via MCP

```
1. get_project_status         → Current state and bottlenecks
2. get_workflow_status         → Blocked items, completion %
3. search (type: "task")       → Find backlog items to prioritize
4. create_epic                 → Sprint epic with title and description
5. create_story                → User stories under the sprint epic
6. create_task                 → Tasks for each story, one per agent
7. save_plan                   → Document sprint plan as artifact
8. save_memory                 → Store sprint context for future sessions
```

## Feature Decomposition via MCP

For any new feature:
```
1. create_epic                 → Feature epic
2. create_story (per layer)    → Stories for each team/layer
3. create_task (per story)     → Concrete tasks, typed as task/bug/hotfix
```

Layer breakdown:
1. Proto contracts (if cross-language) → `rust-engineer` + `go-architect`
2. Database schema → `dba`
3. Backend API → `go-architect`
4. Engine logic (if CPU-intensive) → `rust-engineer`
5. Sync integration → `dba` + `go-architect`
6. Frontend → `frontend-dev` + `ui-ux-designer`
7. Tests at each layer → respective agent

## PRD-Driven Development

For large features, use the guided PRD flow:
```
start_prd_session    → Guided questions (project name, goals, users, features, tech)
answer_prd_question  → Answer each (or skip_prd_question for optional)
back_prd_question    → Go back if needed
preview_prd          → Review generated markdown
split_prd            → Break into numbered phase sub-projects
list_prd_phases      → View all phases with status
```

Each phase becomes a standalone project with its own epics, stories, and tasks.

## Architecture Decision Records

Save ADRs using `save_plan`:
```
save_plan(project, title: "ADR-NNN: Decision Title", content: "...")
```

ADR format:
```markdown
# ADR-NNN: [Title]
## Status: [Proposed | Accepted | Deprecated | Superseded]
## Context: [What motivated this decision?]
## Decision: [What we decided]
## Consequences: [What changes because of this?]
## Alternatives: [What else was considered?]
```

## Priority Matrix

```
                URGENT              NOT URGENT
          ┌───────────────────┬───────────────────┐
IMPORTANT │ DO FIRST          │ SCHEDULE          │
          │ Blocked items     │ Feature backlog   │
          │ Bugs (critical)   │ Improvements      │
          │ Security issues   │ Refactoring       │
          ├───────────────────┼───────────────────┤
NOT       │ DELEGATE          │ BACKLOG           │
IMPORTANT │ UI polish         │ Nice-to-haves     │
          │ Minor bugs        │ Research          │
          │ Logging gaps      │ Experiments       │
          └───────────────────┴───────────────────┘
```

## Cross-Team Coordination

1. **Proto changes** → `go-architect` + `rust-engineer` (regenerate code)
2. **Schema changes** → `dba` review + migration before any code
3. **Shared types** → `frontend-dev` updates `@orchestra/shared` for all 5 platforms
4. **Design system** → `ui-ux-designer` reviews `@orchestra/ui` changes
5. **Sync protocol** → coordinated Go + Rust + all clients
6. **API changes** → `go-architect` + `frontend-dev` + version bump if breaking
7. **Breaking changes** → save ADR via `save_plan`, notify all affected agents

## Conventions

- One feature = one epic = one branch = one PR
- PR titles: `feat:`, `fix:`, `refactor:`, `docs:`, `test:`, `chore:`
- Every PR must have tests
- Breaking changes require ADR
- Use `report_bug` for bugs, `log_request` for feature ideas
- Mobile releases plan 1-2 weeks ahead for app store review
