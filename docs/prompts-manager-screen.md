# Prompts Manager — Flutter Screen

CRUD interface for startup prompts and quick actions with trigger filtering, enable/disable toggle, and priority sorting.

## Layout

### Desktop
```
┌─────────────────────────────────────────────────────────────────┐
│  [🔍 Search prompts...]  [Trigger ▾]  [+ New Prompt]           │
├─────────────────────────────────────────────────────────────────┤
│  ┌───────────────────────────────────────────────────────────┐  │
│  │ ◉ Database Setup        [startup]  P:2   ✏️ 🗑            │  │
│  │   Initialize database connection on startup               │  │
│  │   tags: db, setup                                         │  │
│  ├───────────────────────────────────────────────────────────┤  │
│  │ ○ Quick Deploy          [manual]   P:1   ✏️ 🗑            │  │
│  │   Deploy current branch to staging                        │  │
│  ├───────────────────────────────────────────────────────────┤  │
│  │ ◉ Health Check          [scheduled] P:0  ✏️ 🗑            │  │
│  │   Run health checks every hour                            │  │
│  └───────────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────────┘
```

### Mobile
- Same list, full-width cards, FAB for new prompt

## Features

- **Prompt cards**: Title, trigger badge, priority badge, enabled toggle, content preview (monospace), tags
- **Trigger badges**: startup (green), manual (blue), scheduled (orange)
- **Enabled toggle**: Switch to enable/disable, calls `togglePrompt`
- **Create/Edit dialog**: Title, multiline monospace prompt editor (8 lines), trigger dropdown, priority, tags (comma-separated), enabled switch
- **Delete confirmation**: Dialog before deleting
- **Search**: Filter by title/content substring
- **Trigger filter**: Dropdown to filter by trigger type

## MCP Tools Used

| Action | MCP Tool |
|--------|----------|
| List prompts | `list_prompts` |
| Get prompt | `get_prompt` |
| Create | `create_prompt` |
| Update | `update_prompt` |
| Delete | `delete_prompt` |

## Files
- `apps/flutter/lib/screens/devtools/prompts_screen.dart`
- `apps/flutter/test/screens/devtools/prompts_screen_test.dart` (14 tests)
