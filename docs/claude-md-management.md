# CLAUDE.md / AGENTS.md Management Panel

## Overview

The Agent Instructions tab in Flutter Settings manages the three core instruction files used by Claude Code and other AI agents.

## Managed Files

| File | Settings Key | Description |
|------|-------------|-------------|
| `CLAUDE.md` | `claude_md_sections` | Project-level instructions for Claude |
| `.claude/agents.md` | `agents_md_sections` | Agent definitions table |
| `.claude/context.md` | `context_md_sections` | Additional context for agents |

## Section-Based Editing

Each file is parsed into `## Heading` sections. Users can:
- Add new sections
- Edit section headers and body content
- Delete sections
- Reorder by editing headers
- Save changes (writes file on desktop, pushes to `user_settings` for mobile sync)

## Registered Agents Panel

Below the tab bar, a horizontal scrollable row shows all `.md` files found in `.claude/agents/`. Each card displays:
- Agent name (derived from filename, e.g. `devops.md` → `devops`)
- File path (`.claude/agents/devops.md`)

This is read-only on mobile (agents sync via PowerSync). On desktop, files are scanned from the workspace directory.

## Platform Behavior

- **Desktop**: Reads/writes files directly from `$ORCHESTRA_WORKSPACE` or `Directory.current`
- **Mobile/Web**: Reads from `user_settings` PowerSync table (synced from desktop)

## Files

- `apps/flutter/lib/screens/settings/tabs/agent_instructions_tab.dart` — Main tab (479+ lines)
- `apps/flutter/lib/screens/settings/tabs/claude_settings_tab.dart` — settings.json editor (393 lines)
