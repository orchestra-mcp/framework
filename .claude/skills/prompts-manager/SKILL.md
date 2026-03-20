---
name: prompts-manager
description: Manage startup prompts and quick actions via MCP tools. Activates when creating, listing, updating, or deleting startup prompts or quick actions; or when the user mentions prompts, quick actions, startup configuration, or session initialization.
---

# Prompts Manager — Startup Prompts & Quick Actions

Manage reusable AI prompts and quick actions that can be triggered on session startup, manually, or on a schedule. Stored via MCP storage (synced to web dashboard).

## Available Tools (11)

### Startup Prompts (5 tools)

| Tool | Description |
|------|-------------|
| `create_prompt` | Create a startup prompt with title, prompt text, trigger type, priority, and tags |
| `get_prompt` | Get a prompt by ID with full content |
| `update_prompt` | Update title, prompt text, trigger, priority, enabled status, or tags |
| `delete_prompt` | Delete a startup prompt |
| `list_prompts` | List prompts with optional filtering by trigger, enabled status, or tag |

### Quick Actions (5 tools)

| Tool | Description |
|------|-------------|
| `create_action` | Create a quick action with title, prompt, icon, shortcut, category, and tags |
| `get_action` | Get an action by ID with full content |
| `update_action` | Update title, prompt, icon, shortcut, category, enabled, confirm, or tags |
| `delete_action` | Delete a quick action |
| `list_actions` | List actions with optional filtering by category, enabled status, or tag |

### Composite (1 tool)

| Tool | Description |
|------|-------------|
| `get_startup` | Get all enabled startup prompts in priority order, ready for session injection |

## Concepts

### Startup Prompts

Prompts that run automatically when an AI session starts. They set context, load preferences, or establish working patterns.

**Trigger types:**
- `startup` — Runs every new session (default)
- `manual` — Only when explicitly invoked
- `scheduled` — Time-based execution

**Priority:** Lower number = runs first. Use priority to control the order prompts are injected.

### Quick Actions

Reusable prompt shortcuts with UI metadata (icon, keyboard shortcut, category). Think of them as bookmarkable AI commands.

**Features:**
- **Icon** — Visual identifier in the UI (e.g., `play`, `rocket`, `bug`)
- **Shortcut** — Keyboard shortcut hint (e.g., `Cmd+Shift+T`)
- **Category** — Grouping for organized menus (e.g., `development`, `deployment`)
- **Confirm** — Require user confirmation before executing

## Storage

- **Prompts:** `.projects/{project}/prompts/{id}.md` (YAML frontmatter + markdown body)
- **Actions:** `.projects/{project}/actions/{id}.md` (YAML frontmatter + markdown body)
- **Sync:** Both are synced to the web dashboard via sync.cloud plugin

## Examples

### Create a startup prompt
```
create_prompt(title="Project Context", prompt="You are working on Orchestra MCP...", trigger="startup", priority=0)
```

### Create a quick action
```
create_action(title="Run Tests", prompt="Run all tests and report results", icon="play", shortcut="Cmd+Shift+T", category="development")
```

### Get all startup prompts for session injection
```
get_startup(project_id="my-project")
```

## Plugin Location

`libs/plugin-tools-prompts/` — Core plugin, always bundled in-process.
