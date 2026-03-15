# Architecture Unification — Team-First, SQLite Sync, Web as Source of Truth

## Context

The current architecture is user-scoped and file-based. The user wants a **team-first, database-driven architecture** where:

- **Web (PostgreSQL) is the source of truth** — all projects, features, plans, skills, agents live in the cloud DB
- **Local SQLite syncs bidirectionally** — MCP tools work offline against SQLite, sync pushes/pulls to cloud
- **RAG rebuilds from SQLite** — engine-rag reads from the same local DB, no separate data silo
- **All content stored as markdown** — body/content fields in DB are always markdown text. Docs also remain as `.md` files on disk for agent readability
- **Teams scope everything** — User → Teams → Workspaces → Projects
- **Skills/Agents/Hooks are global entities** — sharable across teams via public URLs, includable in any project
- **Tunnel carries bridge + terminal** — web smart actions fire Claude Code on desktop via tunnel, results sync back
- **Workflow drives CLAUDE.md/AGENTS.md** — selecting skills/agents in a project regenerates the instruction files

### Current State

```
User (web) ──owns──→ Project (web DB)
                         ↑ sync (one-way: local→cloud)
User (desktop) ──owns──→ .projects/ (markdown files)
                         ↑ MCP tools read/write
                    StorageHandler (file-based)
```

### Target State

```
User ──(Membership)──→ Team
                        ├──→ Skills (global, sharable, public URL = read-only + clone)
                        ├──→ Agents (global, sharable, public URL = read-only + clone)
                        └──→ Hooks  (global, sharable)

Workspace ──(WorkspaceTeam pivot)──→ Team (many-to-many)
    └──→ Project (many)
          ├── Features, Plans, Persons, Requests, Docs, Notes
          ├── ProjectSkill (included skills from any team)
          ├── ProjectAgent (included agents from any team)
          └── ProjectHook  (included hooks from any team)

Web (PostgreSQL) ←──sync (LWW)──→ Local (SQLite) ←── MCP tools
                                                  ←── RAG engine
                                                  ←── Smart actions
```

---

## Phase 0: Data Model — Team-First Hierarchy

### 0.1 Web DB Schema Changes (PostgreSQL)

**Current issues found:**
- `Project.team_id` exists but queries use `WHERE user_id = ?` only — team scoping not enforced
- No Workspace model in web DB (only in local globaldb)
- Skills/Agents/Hooks have no DB representation — purely file-based
- Features query by `project_slug + user_id`, not team-scoped

**New/Modified models in `apps/web/internal/models/`:**

```
Workspace (NEW)
├── id (UUID)
├── owner_id (uint, FK → User) — creator
├── name
├── folders (JSON array of paths)
├── primary_folder
├── status (active/archived)
├── metadata (JSON)
└── timestamps

WorkspaceTeam (NEW — pivot, many-to-many)
├── workspace_id (UUID, FK → Workspace)
├── team_id (UUID, FK → Team)
├── role (owner/editor/viewer) — team's access level to workspace
└── PRIMARY KEY(workspace_id, team_id)

Skill (NEW)
├── id (UUID)
├── team_id (UUID, FK → Team, nullable) — null = personal
├── name, slug
├── description
├── content (text — the SKILL.md body)
├── scope (personal/team/public)
├── public_url (generated when scope=public)
├── icon, color
├── stacks (JSON — which tech stacks it applies to)
└── timestamps

Agent (NEW)
├── id (UUID)
├── team_id (UUID, FK → Team, nullable)
├── name, slug
├── description
├── content (text — the agent .md body)
├── scope (personal/team/public)
├── public_url
├── icon, color
└── timestamps

Hook (NEW)
├── id (UUID)
├── team_id (UUID, FK → Team, nullable)
├── name, slug
├── description
├── script (text — the .sh content)
├── scope (personal/team/public)
├── event_type (pre-tool/post-tool/on-error/etc.)
└── timestamps

ProjectSkill (NEW — pivot)
├── project_id (UUID, FK → Project)
├── skill_id (UUID, FK → Skill)
└── enabled (bool)

ProjectAgent (NEW — pivot)
├── project_id (UUID, FK → Project)
├── agent_id (UUID, FK → Agent)
└── enabled (bool)

ProjectHook (NEW — pivot)
├── project_id (UUID, FK → Project)
├── hook_id (UUID, FK → Hook)
└── enabled (bool)
```

**Modified models:**

```
Project — add workspace_id (UUID, FK → Workspace)
        — keep team_id (denormalized for fast queries, set from workspace's primary team)
        — all queries change: WHERE team_id IN (user's team IDs) (not user_id)

Workspace ↔ Team: many-to-many via WorkspaceTeam pivot.
A workspace can belong to multiple teams with different access levels.
A workspace has many projects (folders on a machine).
```

**Relationship chain:**
```
User ──(Membership)──→ Team ──(WorkspaceTeam)──→ Workspace (many-to-many)
                        │                          └──→ Project (many)
                        │                                ├──→ Features, Plans, Persons, Requests, Docs, Notes
                        │                                ├──→ ProjectSkill (included skills)
                        │                                ├──→ ProjectAgent (included agents)
                        │                                └──→ ProjectHook (included hooks)
                        ├──→ Skill (team-scoped, or personal/public)
                        ├──→ Agent (team-scoped, or personal/public)
                        └──→ Hook (team-scoped, or personal/public)

Workspace can be shared across multiple teams (many-to-many via WorkspaceTeam pivot).
Skills/Agents with scope=public get a read-only public URL. Other teams can clone/import them.
Sync uses LWW (last-write-wins) everywhere — no manual merge UI needed.
```

---

## Phase 1: Local SQLite — MCP Storage Backend

### 1.1 SQLite Schema (mirrors web PostgreSQL)

**Location:** `~/.orchestra/db/{workspace-hash}.db` (existing pattern in globaldb)

```sql
-- Core entities (synced from/to cloud)
CREATE TABLE workspaces (
    id TEXT PRIMARY KEY,
    owner_id TEXT,
    name TEXT NOT NULL,
    folders TEXT,          -- JSON array
    primary_folder TEXT,
    status TEXT DEFAULT 'active',
    metadata TEXT,         -- JSON
    version INTEGER DEFAULT 1,
    synced_at TEXT,
    created_at TEXT, updated_at TEXT, deleted_at TEXT
);

CREATE TABLE workspace_teams (
    workspace_id TEXT NOT NULL,
    team_id TEXT NOT NULL,
    role TEXT DEFAULT 'editor',   -- owner/editor/viewer
    PRIMARY KEY(workspace_id, team_id)
);

CREATE TABLE projects (
    id TEXT PRIMARY KEY,
    workspace_id TEXT,
    team_id TEXT,
    slug TEXT NOT NULL,
    name TEXT NOT NULL,
    description TEXT,
    version INTEGER DEFAULT 1,
    synced_at TEXT,
    created_at TEXT, updated_at TEXT, deleted_at TEXT,
    UNIQUE(slug, team_id)
);

CREATE TABLE features (
    id TEXT PRIMARY KEY,          -- FEAT-XXXX
    project_id TEXT NOT NULL,
    project_slug TEXT NOT NULL,
    title TEXT, description TEXT, body TEXT,
    status TEXT, priority TEXT, kind TEXT,
    assignee TEXT, estimate TEXT,
    labels TEXT,                  -- JSON
    depends_on TEXT,              -- JSON
    version INTEGER DEFAULT 1,
    synced_at TEXT,
    created_at TEXT, updated_at TEXT, deleted_at TEXT
);

-- Same pattern for: plans, persons, requests, docs, notes,
-- assignment_rules, hypotheses, experiments, discovery_cycles

CREATE TABLE skills (
    id TEXT PRIMARY KEY,
    team_id TEXT,
    name TEXT, slug TEXT, description TEXT,
    content TEXT,                 -- SKILL.md body
    scope TEXT DEFAULT 'personal', -- personal/team/public
    stacks TEXT,                  -- JSON
    version INTEGER DEFAULT 1,
    synced_at TEXT,
    created_at TEXT, updated_at TEXT, deleted_at TEXT
);

CREATE TABLE agents (
    id TEXT PRIMARY KEY,
    team_id TEXT,
    name TEXT, slug TEXT, description TEXT,
    content TEXT,                 -- agent .md body
    scope TEXT DEFAULT 'personal',
    version INTEGER DEFAULT 1,
    synced_at TEXT,
    created_at TEXT, updated_at TEXT, deleted_at TEXT
);

CREATE TABLE hooks (
    id TEXT PRIMARY KEY,
    team_id TEXT,
    name TEXT, slug TEXT, description TEXT,
    script TEXT,                  -- .sh content
    scope TEXT DEFAULT 'personal',
    event_type TEXT,
    version INTEGER DEFAULT 1,
    synced_at TEXT,
    created_at TEXT, updated_at TEXT, deleted_at TEXT
);

-- Pivot: which skills/agents/hooks are included in a project
CREATE TABLE project_skills (project_id TEXT, skill_id TEXT, PRIMARY KEY(project_id, skill_id));
CREATE TABLE project_agents (project_id TEXT, agent_id TEXT, PRIMARY KEY(project_id, agent_id));
CREATE TABLE project_hooks (project_id TEXT, hook_id TEXT, PRIMARY KEY(project_id, hook_id));

-- Sync tracking
CREATE TABLE change_log (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    entity_type TEXT NOT NULL,
    entity_id TEXT NOT NULL,
    action TEXT NOT NULL,         -- upsert/delete
    version INTEGER NOT NULL,
    timestamp TEXT NOT NULL,
    synced INTEGER DEFAULT 0
);

CREATE TABLE sync_state (
    key TEXT PRIMARY KEY,
    value TEXT
);
-- Keys: last_pull_at, device_id, team_id
```

### 1.2 SQLite StorageHandler

**Modify:** `libs/plugin-storage-sqlite/`

The existing `StorageHandler` interface stays (Read/Write/Delete/List). But internally, the SQLite handler now:
- Maps paths to table+column queries: `"my-project/features/FEAT-ABC"` → `SELECT * FROM features WHERE id = 'FEAT-ABC' AND project_slug = 'my-project'`
- On Write: inserts/updates row + appends to `change_log`
- On Delete: soft-delete (`deleted_at = now()`) + appends to `change_log`
- On List: `SELECT ... WHERE entity_type = ? AND project_slug = ?`

### 1.3 Docs: DB → Markdown Files → Public Web

**DB is the source of truth for docs.** The `body` column stores raw markdown. The flow:

```
DB (SQLite/PostgreSQL) ──generates──→ docs/{slug}.md (on disk)
                       ──syncs──→ Web DB (PostgreSQL)
                                    ──publishes──→ /docs/{team}/{project}/{slug} (public URL)
```

**DB → `.md` file sync (local):**
- On doc create/update in SQLite: regenerate `docs/{slug}.md` from DB body
- On sync pull (new doc from cloud): write to SQLite + generate `.md` file
- Agents read docs from either SQLite (via MCP tools) or filesystem (`docs/` folder) — both always in sync
- `.md` files are git-trackable artifacts generated from DB, not the other way around

**All content is markdown in DB** — features, plans, notes, docs all store `body`/`content` as markdown text. This is the natural format for agent consumption.

**Public docs viewer on web:**

The Doc model gets `published` (bool) and `published_url` (slug) fields. When published:
- Accessible at `GET /docs/{team-slug}/{project-slug}/{doc-slug}` — no auth required
- Web reads markdown from PostgreSQL `docs.body` column, renders as HTML
- Rendered with `react-markdown` or server-side MDX
- Styled with project branding (logo, colors from project metadata)
- SEO-friendly: title, description, og:image meta tags
- Table of contents auto-generated from headings
- Nested docs (parent_id) render as sidebar navigation tree
- User can publish/unpublish from web dashboard or via MCP tool

### 1.4 Migration from Markdown

- On first boot: scan `.projects/` for existing markdown files
- Parse YAML frontmatter → insert into corresponding SQLite tables
- Idempotent: skip if entity already exists with same version
- After migration: `.projects/` files remain for docs only; SQLite is primary for everything else

---

## Phase 2: Bidirectional Sync Engine

### 2.1 Local → Cloud Push

- Runs every 30s in background goroutine
- Immediate push on write (debounced 2s)
- Reads `change_log` for unsynced entries, batches into SyncRecords
- POST /api/sync/push with team_id + device_id
- On success: marks change_log rows as synced=1

### 2.2 Cloud → Local Pull

- GET /api/sync/pull?since={last_pull_at}&device_id={id}&team_id={team_id}
- Returns SyncRecords for all team activity
- Apply to local SQLite with LWW (version comparison)
- Runs every 30s + triggered by WebSocket push notification
- Includes ALL team member changes (not just current user)

### 2.3 Real-Time Sync via WebSocket

When cloud receives a push, broadcast to all connected team tunnels:
```json
{ "type": "sync_update", "entity_type": "feature", "entity_id": "FEAT-ABC", "action": "upsert" }
```

Desktop receives notification → triggers immediate pull for that entity.

### 2.4 RAG Rebuilds from SQLite

Engine-rag reads from the same local SQLite instead of maintaining a separate data silo:
- On sync pull (new/changed entities) → re-index in Tantivy
- Memory/embeddings tables remain in engine-rag's own DB (different concern)
- Entity content for RAG comes from the shared SQLite

---

## Phase 3: Workflow — Skills/Agents Drive CLAUDE.md

### 3.1 Project Configuration

When skills/agents are included in a project (via `project_skills`/`project_agents` pivots), the system regenerates:

- **CLAUDE.md** — Lists included skills as slash commands, references included agents
- **AGENTS.md** — Full agent definitions from included agents' `content` field
- **CONTEXT.md** — Project-specific context from project metadata

Query SQLite instead of scanning `.claude/skills/` directories:
```sql
SELECT s.* FROM skills s JOIN project_skills ps ON s.id = ps.skill_id WHERE ps.project_id = ?
```

### 3.2 Workflow as Shared Configuration

- A "workflow" = a curated set of skills + agents + hooks for a project
- Teams create workflows that can be applied to any project
- Changing the workflow on web → syncs to local → regenerates CLAUDE.md → MCP behavior changes
- This is how product/project managers control AI agent behavior remotely

---

## Phase 4: Smart Action via Tunnel + Bridge

### 4.1 Flow: Web → Desktop → Claude → Sync Back

```
Web UI: User types "create a login feature with OAuth2"
    ↓
Tunnel: RelayEnvelope → Desktop
    ↓
Desktop: ai_prompt(prompt, wait=true) → Claude Code CLI
    ↓
Claude: Determines tool=create_feature, args={title, kind, ...}
    ↓
Desktop: MCP callTool("create_feature", args) → writes to SQLite
    ↓
Sync: Push to cloud (immediate, <2s) → Broadcasts to all clients
    ↓
Web UI: Receives update → refreshes → shows created item
```

### 4.2 Tunnel Carries Both Terminal + Bridge

1. **Smart action requests** — `ai_prompt` calls from web → desktop Claude bridge
2. **Terminal I/O** — PTY sessions for remote terminal access
3. **Sync notifications** — Real-time change broadcasts
4. **Permission flow** — Claude asks permission → web user approves → response relayed back

No changes to tunnel relay protocol needed — it already multiplexes arbitrary JSON-RPC messages.

---

## Phase 5: Web UX — Workspace-First + Matched Tabs

### 5.1 Remove Chat Bubble + DevTools
### 5.2 Workspace Selector (After Login)
### 5.3 Match Desktop Tabs: Notes, Skills, Agents, Docs, Projects, Terminal, Settings

---

## Phase 6: Teams, Subscription & Feature Flags

### 6.1 Teams on Desktop
### 6.2 Subscription on Desktop
### 6.3 Feature Flags (Admin Controls All Clients)

| Key | Default | Controls |
|-----|---------|----------|
| notes | true | Notes tab |
| skills | true | Skills tab |
| agents | true | Agents tab |
| docs | true | Docs tab |
| projects | true | Projects tab |
| terminal | true | Terminal tab |
| teams | true | Teams section |
| smart_action | true | Smart action |

---

## Implementation Order

| # | Phase | Task | Effort |
|---|-------|------|--------|
| 1 | 0 | Web DB: New models + migrations | Medium |
| 2 | 0 | Web API: CRUD routes for workspaces, skills, agents, hooks | Medium |
| 3 | 0 | Web API: Team-scoped project queries | Small |
| 4 | 1 | Local SQLite: Relational schema | Medium |
| 5 | 1 | Local SQLite: StorageHandler | Medium |
| 6 | 1 | Markdown → SQLite migration | Small |
| 7 | 2 | Sync engine: Bidirectional push/pull | Large |
| 8 | 2 | Sync: Real-time WebSocket broadcast | Medium |
| 9 | 2 | RAG: Read from shared SQLite | Medium |
| 10 | 3 | Workflow: CLAUDE.md/AGENTS.md from SQLite | Medium |
| 11 | 3 | MCP tools: Skill/Agent/Hook CRUD | Medium |
| 12 | 4 | Desktop: CMD+K global smart action | Small |
| 13 | 4 | Web: Smart action bar + tunnel bridge | Medium |
| 14 | 5 | Web: Remove chat bubble + devtools | Small |
| 15 | 5 | Web: Workspace selector + matched tabs | Medium |
| 16 | 6 | Desktop: Teams + subscription + feature flags | Medium |
| 17 | 5 | Public docs viewer | Medium |
