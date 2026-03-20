# Dynamic Workflow CRUD

The workflow engine now supports per-project, database-backed workflow definitions with full CRUD operations via MCP tools.

## Architecture

- **Storage**: SQLite (`~/.orchestra/db/global.db`, table `workflows`)
- **ID format**: `WFL-XXX` (3 random uppercase letters)
- **Uniqueness**: One workflow name per project (enforced via unique index)
- **Default workflow**: Each project can have one default workflow; when no custom states are provided, the standard Orchestra workflow is used

## Database Schema

```sql
CREATE TABLE workflows (
    id TEXT PRIMARY KEY,
    project_id TEXT NOT NULL,
    name TEXT NOT NULL,
    description TEXT DEFAULT '',
    initial_state TEXT NOT NULL DEFAULT 'todo',
    states TEXT NOT NULL DEFAULT '{}',       -- JSON map
    transitions TEXT NOT NULL DEFAULT '[]',  -- JSON array
    gates TEXT NOT NULL DEFAULT '{}',        -- JSON map
    is_default INTEGER DEFAULT 0,
    created_at TEXT NOT NULL,
    updated_at TEXT NOT NULL
);
```

## MCP Tools

### create_workflow

Creates a new workflow definition for a project.

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| project_id | string | yes | Project slug |
| name | string | yes | Unique name per project |
| description | string | no | Description |
| initial_state | string | no | Starting state (default: `todo`) |
| states | object | no | Map of state definitions |
| transitions | array | no | Transition definitions |
| gates | object | no | Gate definitions |
| is_default | boolean | no | Set as project default (default: true) |

If `states` is omitted, the standard Orchestra workflow (todo -> in-progress -> in-testing -> in-docs -> in-review -> done) is used.

### get_workflow

Retrieves a workflow by ID or project default.

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| workflow_id | string | no | Workflow ID (e.g. WFL-ABC) |
| project_id | string | no | Get default workflow for project |

At least one of `workflow_id` or `project_id` is required.

### update_workflow

Updates an existing workflow. Only provided fields are changed.

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| workflow_id | string | yes | Workflow ID |
| name | string | no | New name |
| description | string | no | New description |
| initial_state | string | no | New initial state |
| states | object | no | Replace all states |
| transitions | array | no | Replace all transitions |
| gates | object | no | Replace all gates |
| is_default | boolean | no | Set as default |

### delete_workflow

Deletes a workflow by ID.

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| workflow_id | string | yes | Workflow ID |

### list_workflows

Lists all workflows, optionally filtered by project.

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| project_id | string | no | Filter by project |

## Validation Rules

All create/update operations validate the workflow structure:

1. At least one state must be defined
2. `initial_state` must reference an existing state
3. All transition `from`/`to` must reference existing states
4. All transition `gate` must reference existing gates
5. At least one terminal state must exist

## State Definition

```json
{
  "todo": {
    "label": "To Do",
    "terminal": false,
    "active_work": false
  },
  "done": {
    "label": "Done",
    "terminal": true,
    "active_work": false
  }
}
```

## Transition Definition

```json
[
  {"from": "todo", "to": "in-progress"},
  {"from": "in-progress", "to": "in-testing", "gate": "code_complete"}
]
```

## Gate Definition

```json
{
  "code_complete": {
    "label": "Code Complete",
    "required_section": "Changes",
    "file_patterns": ["*.go", "*.ts"],
    "skippable_for": ["bug", "hotfix"]
  }
}
```
