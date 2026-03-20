---
title: Storage Layer
description: Markdown + YAML frontmatter storage system for features, plans, and project data
order: 3
---

# Storage Layer

Orchestra stores all project data as **Markdown files with YAML frontmatter**. No database required — everything is human-readable, git-native, and portable.

## Directory Structure

```
.projects/
├── <project-slug>/
│   ├── project.json          # Project metadata
│   ├── features/
│   │   ├── FEAT-001.md       # Feature with lifecycle
│   │   ├── FEAT-002.md
│   │   └── ...
│   ├── plans/
│   │   ├── PLAN-001.md       # Implementation plans
│   │   └── ...
│   ├── requests/
│   │   ├── REQ-001.md        # User request queue
│   │   └── ...
│   └── persons/
│       ├── PERS-001.md       # Team member profiles
│       └── ...
└── .packs/
    └── registry.json          # Installed packs registry
```

## File Format

### Feature Example

```markdown
---
id: FEAT-042
title: Add JWT authentication middleware
status: in-testing
kind: feature
priority: high
assignee: fadymondy
labels:
  - auth
  - security
created_at: 2026-03-15T10:30:00Z
updated_at: 2026-03-15T14:22:00Z
---

# Add JWT authentication middleware

## Description
Implement JWT validation middleware for all protected API routes.

## Acceptance Criteria
- [ ] JWT tokens validated on every protected route
- [ ] Token refresh flow working
- [ ] Expired tokens return 401

## Audit Trail
- 2026-03-15T10:30:00Z — Created (todo)
- 2026-03-15T10:32:00Z — Started (in-progress)
- 2026-03-15T14:22:00Z — Code complete (in-testing)
```

### Plan Example

```markdown
---
id: PLAN-015
title: Authentication system overhaul
status: in-progress
feature_count: 5
---

# Authentication system overhaul

## Features
1. FEAT-042 — JWT middleware (in-testing)
2. FEAT-043 — OAuth providers (todo)
3. FEAT-044 — Session management (todo)
4. FEAT-045 — Rate limiting (todo)
5. FEAT-046 — Audit logging (todo)
```

## Storage Plugin

The `storage.markdown` plugin handles all file I/O:

| Operation | Implementation |
|-----------|---------------|
| Create | Write new `.md` file with frontmatter |
| Read | Parse YAML frontmatter + markdown body |
| Update | Modify frontmatter fields, append to body |
| Delete | Remove the `.md` file |
| List | Glob `*.md` in directory, parse frontmatter |
| Search | Iterate files, match frontmatter fields |

## ID Generation

IDs use a prefix + random alphanumeric pattern:

| Entity | Pattern | Example |
|--------|---------|---------|
| Feature | `FEAT-XXX` | FEAT-042 |
| Plan | `PLAN-XXX` | PLAN-015 |
| Request | `REQ-XXX` | REQ-007 |
| Person | `PERS-XXX` | PERS-001 |
| Agent | `AGT-XXXX` | AGT-0042 |
| Workflow | `WFL-XXXX` | WFL-0015 |
| Run | `RUN-{uuid}` | RUN-a1b2c3d4 |

## Benefits

### Git-Native
All data lives in your repo. Feature transitions, plan breakdowns, and audit trails show up in `git log` and `git blame`.

### Human-Readable
Open any `.md` file in your editor and see exactly what's happening. No database client needed.

### Portable
Copy `.projects/` to another machine and all your project state comes with it.

### Conflict-Friendly
Markdown frontmatter merges cleanly in most git merge scenarios. Status fields are the only conflict-prone area, and the audit trail helps resolve them.

## Global Storage

Some data lives outside the project:

| Path | Content |
|------|---------|
| `~/.orchestra/me.json` | Current user profile |
| `~/.orchestra/workspaces.json` | Workspace registry |
| `~/.orchestra/agentops/accounts.json` | AI provider accounts |
| `~/.orchestra/certs/` | mTLS certificates |
| `~/.orchestra/config.json` | Global configuration |
