# Pack Workflow Bridge

Packs can now ship a complete workflow — both the **state machine** (YAML) and **phase behavior** (skills) — as a single installable unit.

## Architecture

```
pack install
    │
    ├── skills/       → .claude/skills/     (Claude behavior per phase)
    ├── agents/       → .claude/agents/     (specialized sub-agents)
    ├── hooks/        → .claude/hooks/      (automation hooks)
    └── workflow/     → .claude/workflows/  (YAML) → globaldb (applied to project)
```

The YAML controls **structure** (what states exist, which transitions are valid, what evidence gates require). Skills control **behavior** (what Claude does within each phase, what's forbidden, what evidence looks like). Go enforces both — session locking, evidence validation, audit trail — and is never overridden by pack content.

## Pack Format

Add a `workflows` array to `pack.json` `contents`:

```json
{
  "name": "github.com/my-org/pack-my-workflow",
  "version": "0.1.0",
  "contents": {
    "skills": ["my-workflow-coding", "my-workflow-testing"],
    "agents": [],
    "hooks": [],
    "workflows": ["my-workflow.yaml"]
  }
}
```

Workflow YAML files live in a `workflow/` directory at the pack root:

```
pack-my-workflow/
├── pack.json
├── workflow/
│   └── my-workflow.yaml     ← state machine
└── skills/
    ├── my-workflow-coding/
    │   └── SKILL.md          ← Claude behavior in coding phase
    └── my-workflow-testing/
        └── SKILL.md          ← Claude behavior in testing phase
```

## Workflow YAML Format

```yaml
name: my-workflow
description: Custom 4-state delivery workflow
initial_state: todo

states:
  todo:
    label: To Do
    terminal: false
    active_work: false
  coding:
    label: Coding
    terminal: false
    active_work: true
  review:
    label: In Review
    terminal: false
    active_work: true
  done:
    label: Done
    terminal: true
    active_work: false

transitions:
  - from: todo
    to: coding
  - from: coding
    to: review
    gate: code_complete
  - from: review
    to: done

gates:
  code_complete:
    label: Code Complete
    required_section: Changes
    file_patterns: []
    skippable_for: []
```

### YAML Fields

| Field | Description |
|-------|-------------|
| `name` | Unique workflow name (used for upsert — reinstalling updates in place) |
| `description` | Human-readable description |
| `initial_state` | Must match a state ID |
| `states.*` | Map of state ID → `{label, terminal, active_work}` |
| `transitions` | Array of `{from, to, gate?}` |
| `gates.*` | Map of gate ID → `{label, required_section, file_patterns, docs_folder?, skippable_for}` |

**Rules:**
- Exactly one state with `terminal: true` (the done state)
- `active_work: true` states count against WIP limits
- Gates referenced in transitions must exist in the `gates` map
- `required_section` becomes the `## Heading` Claude must include in evidence
- `skippable_for` lists work kinds (bug, hotfix, testcase, chore) that bypass this gate

## Install Behavior

```
orchestra pack install my-org/pack-my-workflow
```

1. Clones the repo
2. Copies skills → `.claude/skills/`
3. Copies agents → `.claude/agents/`
4. Copies hooks → `.claude/hooks/`
5. Copies workflow YAML → `.claude/workflows/`
6. Loads the YAML and upserts it into globaldb for the active project
7. If a workflow with the same name already exists, updates it in place (upsert)
8. Registers everything in `.projects/.packs/registry.json`

To target a specific project:

```
install_pack repo:my-org/pack-my-workflow project_id:my-project
```

## Update Behavior

```
orchestra pack update my-org/pack-my-workflow
```

Re-downloads the pack and re-applies the workflow YAML to the active project. Existing workflow records with the same name are updated in place — features in flight keep their current state.

## Remove Behavior

```
orchestra pack remove my-org/pack-my-workflow
```

Removes skills, agents, hooks, and the workflow YAML file from `.claude/`. Does **not** delete the globaldb workflow record — features already created under that workflow are preserved.

## Designing a Workflow Pack

Use the `/workflow-builder` skill (from `pack-flow`) to design a workflow conversationally:

```
/workflow-builder
```

The skill walks you through:
1. Describing your process phases
2. Defining gates and evidence requirements
3. Generating the YAML state machine
4. Generating a skill per active phase
5. Writing all files to `pack-[name]/`

Then push to GitHub and install:

```bash
git init pack-my-workflow && cd pack-my-workflow
# add generated files
git remote add origin https://github.com/my-org/pack-my-workflow
git push -u origin main

# install anywhere
install_pack repo:github.com/my-org/pack-my-workflow
```

## Reference Pack

`orchestra-mcp/pack-workflow-default` ships the standard 7-state Orchestra workflow as a reference. Install it to explicitly pin the built-in workflow or fork it as a starting point:

```
orchestra pack install orchestra-mcp/pack-workflow-default
```

States: `todo → in-progress → in-testing → in-docs → in-review → done` (with `needs-edits` loop).

## Relationship to Dynamic Workflow CRUD

The pack bridge is a layer on top of the existing `create_workflow` / `update_workflow` MCP tools (see [dynamic-workflow-crud.md](dynamic-workflow-crud.md)). On install, it calls the same underlying globaldb operations — packs are just a distribution mechanism for workflow definitions that would otherwise require manual tool calls.

You can also modify a pack-installed workflow live via MCP tools without reinstalling the pack:

```
update_workflow workflow_id:WFL-ABC states:{...} transitions:[...]
```
