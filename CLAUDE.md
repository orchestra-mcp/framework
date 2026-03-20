# CLAUDE.md

This project uses [Orchestra MCP](https://github.com/orchestra-mcp/framework) for AI-powered project management.

## Mandatory Workflow Rule

**ALL work MUST go through Orchestra MCP tools.** When the user asks you to do ANY task — build, fix, test, refactor, document, investigate, or change anything:

1. `search_features` / `list_features` — check for existing feature
2. `create_feature` — create one if needed (with `kind`: feature/bug/hotfix/chore)
3. `set_current_feature` — start work (moves to in-progress, acquires session lock)
4. Do the work (each status = ONE activity only, see Strict Phase Rules below)
5. `advance_feature` — pass gates with structured evidence to move to next phase
6. At `in-review`: use `AskUserQuestion` to get user approval
7. `submit_review` — complete

**Never do any work without an active feature.** This includes running tests, writing docs, investigating bugs, and refactoring. The MCP enforces gated transitions — you cannot advance without evidence.

### Feature Kinds

Every feature has a `kind` field: `feature` (default), `bug`, `hotfix`, or `chore`.

- **feature** — New functionality or enhancement
- **bug** — Defect report (Gate 3/docs skipped automatically)
- **hotfix** — Urgent fix (Gate 3/docs skipped automatically)
- **chore** — Maintenance, refactoring, CI work
- **testcase** — QA test case linked to a parent feature (Gate 3/docs skipped automatically)

Use `create_bug_report` as a shortcut for bugs. Use `create_test_case` or `bulk_create_test_cases` for QA test cases linked to a feature.

### Plan-First for Large Tasks (MANDATORY)

When a user request would result in **3 or more features**, you MUST create a plan before implementation:

1. `create_plan` — Create the plan in `draft` status with title and description
2. Present the plan to the user via `AskUserQuestion` for approval
3. `approve_plan` — Move from draft → approved
4. `breakdown_plan` — Break the plan into features with dependencies (pass a JSON array of feature definitions). This auto-creates all features with `plan:{plan_id}` labels and sets up dependency chains. Plan moves to `in-progress`.
5. Work each feature through the full lifecycle (in order of dependencies)
6. `complete_plan` — After all linked features are `done`, mark the plan as completed

**Do NOT skip the plan step for large tasks.** The plan is stored via MCP and provides traceability.

### User Request Queue

When the user sends a new request while you are busy working on a feature:

1. `create_request` — Save it to the queue with kind (feature/hotfix/bug) and priority
2. Continue working on the current feature
3. After the current feature reaches `done`, call `get_next_request` to pick up the next queued request
4. `convert_request` — Convert it into a feature (auto-creates with correct kind/priority)
5. Work the new feature through the full lifecycle

Use `list_requests` to see the queue and `dismiss_request` to discard irrelevant requests.

### Bug Reporting

When a completed feature causes a regression or breakage:

1. `create_bug_report` — Creates a feature with kind=bug, links to the original feature via `related_feature` param
2. The bug follows the same workflow but **docs gate is auto-skipped** for bugs, hotfixes, and testcases (in-testing → in-review directly)
3. Work the bug through: todo → in-progress → in-testing → in-review → done

### Strict Phase Rules (Each Status = ONE Activity)

**Status moves BEFORE the work, not after.** Call `advance_feature` to move to the next phase — the evidence proves the PREVIOUS phase is complete.

| Status | ALLOWED | FORBIDDEN |
|--------|---------|----------|
| `in-progress` | Write/edit source code files ONLY | Running tests, writing docs, asking for review |
| `in-testing` | Write test files and run tests ONLY | Writing source code, writing docs, asking for review |
| `in-docs` | Write/edit `.md` files in `/docs` folder ONLY | Writing source code, writing tests, asking for review |
| `in-review` | Call `AskUserQuestion` for user approval ONLY | Writing code, running tests, writing docs |

### Enforced Gates (3 Gates)

The MCP **rejects** `advance_feature` if evidence is missing or malformed. Evidence must be markdown with a `## Section` header and at least 10 characters of content. **File-type validation** checks that referenced files match expected patterns.

| Gate | Transition | Required Section | File-Type Check | Skippable |
|------|-----------|-----------------|-----------------|----------|
| Code Complete | in-progress → in-testing | `## Changes` **(files)** | Any source files | No |
| Test Complete | in-testing → in-docs | `## Results` **(files)** | Must match test patterns (`*_test.go`, `*.test.ts`, etc.) | No |
| Docs Complete | in-docs → in-review | `## Docs` **(files)** | Must be `.md` files inside `docs/` folder | **Yes** (bug, hotfix, testcase) |

**File-type validation:** If referenced files don't match expected patterns, MCP returns `needs_approval` error. Ask the user via `AskUserQuestion` — if approved, retry with `force: true`.

**Gate evidence format:**
```
evidence: "## Changes\n- libs/foo/bar.go (added validation)\n- libs/baz/qux.go (new file)"
```

Call `get_gate_requirements` to see what's needed for the next transition.

### Free Transitions (no gate)

These transitions can be done without evidence:
- `todo → in-progress` (via `set_current_feature`), `needs-edits → in-progress` (via `set_current_feature`)

### Review Flow

1. Feature reaches `in-review` after passing all gates
2. Use `AskUserQuestion` to present the work to the user with options: "Approve" / "Needs Edits"
3. Call `submit_review` with the user's decision (`status: "approved"` or `status: "needs-edits"`)

**Do NOT call `submit_review` without user approval.** `advance_feature` is blocked from `in-review` — you must use `submit_review`.

### Session-Scoped Feature Locking

Features are locked to the calling MCP session when work begins. This prevents concurrent sessions from interfering.

- `set_current_feature` acquires a session lock (auto-generated UUID per MCP connection)
- `advance_feature` and `submit_review` check the lock belongs to the current session
- Locks auto-expire after 30 minutes of inactivity
- `unlock_feature` is an admin recovery tool to force-release stale locks

### Sub-Agent Rules

Sub-agents (Task tool) do **NOT** have MCP access. They cannot call `advance_feature` or any workflow tool.

- Sub-agents = code only (use during in-progress for writing code)
- Main agent owns lifecycle (YOU handle all gates: test, document, review)
- One feature at a time per assignee (complete full lifecycle before picking next)
- Summarize to user (tell user what sub-agent built before advancing)

### Anti-Patterns (NEVER DO)

- Writing source code during `in-testing` phase (ONLY test code allowed)
- Writing tests during `in-progress` phase (ONLY source code allowed)
- Writing docs outside the `docs/` folder during `in-docs` phase
- Writing fake/boilerplate evidence without doing actual work
- Advancing through gates without providing evidence that references real file paths
- Requesting review for one feature then starting another before review resolves
- Calling `submit_review` without asking the user via `AskUserQuestion` first

### Programmatic Guardrails (MCP-Enforced)

These rules are enforced at the MCP tool level — violation attempts return errors:

1. **Session-scoped locking** — `set_current_feature` acquires a lock tied to the current MCP session. Other sessions cannot advance or modify the locked feature. Returns `session_lock` error. Locks auto-expire after 30 minutes. Use `unlock_feature` for admin recovery.
2. **File-type validation** — Test Complete gate validates test file patterns (`*_test.go`, `*.test.ts`, etc.). Docs Complete gate validates `.md` files in `docs/`. Returns `needs_approval` error — ask user, then retry with `force: true`.
3. **Docs gate auto-skip** — For `bug`, `hotfix`, and `testcase` kinds, in-testing → in-review directly (skip in-docs).
4. **Timestamped audit trail** — Every transition appends an ISO-8601 timestamp to the feature body.
5. **Model capability check** — `set_current_feature` accepts a `model` parameter. Validates the model can handle the feature's size estimate (Haiku→S, Sonnet→S/M, Opus→S/M/L/XL). Returns `model_capability` error.
6. **Review requires user approval** — `advance_feature` is blocked from `in-review`. Only `submit_review` can move to `done`.

## Git & Sync (Natural Language Mapping)

The MCP provides 6 git tools that use the current user's person profile for author identity. **Map natural language requests to these tools automatically:**

| User says | Action |
|-----------|--------|
| "sync my changes", "push my updates", "sync to cloud" | `git_quick_commit` (stage all + commit) → `git_push` |
| "get latest", "pull updates", "sync from cloud" | `git_pull` |
| "save my work", "commit this" | `git_quick_commit` |
| "push", "push to remote" | `git_push` |
| "create a branch for X" | `git_create_branch` |
| "merge X" | `git_merge_branch` |
| "what's the status", "git status" | `git_status_summary` |
| "pull and rebase" | `git_pull` with `rebase: true` |

When the user says "sync" without a specific message, generate a meaningful commit message from the staged changes. All commits use the current user's person profile (name + github_email). No `Co-Authored-By` lines.

## Onboarding (First Interaction)

On the first interaction with a new user, check `get_current_user`. If not configured:

1. Use `AskUserQuestion` to collect: name, role, email, github_email, bio, timezone
2. `create_person` with the collected profile data
3. `set_current_user` to link them to the project
4. Confirm the setup — the profile persists in `~/.orchestra/me.json` across sessions

## Available Tools

Orchestra provides **85 tools** via MCP (70 feature workflow + 15 marketplace) and **5 prompts**.

Run `orchestra serve` to start the MCP server. IDE config is in `.mcp.json`.

## Installed Packs

No packs installed. Run `orchestra pack recommend` to get suggestions.

## Skills (Slash Commands)

| Command | Source |
|---------|--------|
| `/ai-agentic` | .claude/skills/ai-agentic/ |
| `/chrome-extension` | .claude/skills/chrome-extension/ |
| `/database-sync` | .claude/skills/database-sync/ |
| `/docs` | .claude/skills/docs/ |
| `/extension-marketplace` | .claude/skills/extension-marketplace/ |
| `/flow` | .claude/skills/flow/ |
| `/flow-archive` | .claude/skills/flow-archive/ |
| `/flow-brief` | .claude/skills/flow-brief/ |
| `/flow-coach` | .claude/skills/flow-coach/ |
| `/flow-config` | .claude/skills/flow-config/ |
| `/flow-contract` | .claude/skills/flow-contract/ |
| `/flow-docs` | .claude/skills/flow-docs/ |
| `/flow-experiment` | .claude/skills/flow-experiment/ |
| `/flow-expert` | .claude/skills/flow-expert/ |
| `/flow-gate` | .claude/skills/flow-gate/ |
| `/flow-health` | .claude/skills/flow-health/ |
| `/flow-init` | .claude/skills/flow-init/ |
| `/flow-intake` | .claude/skills/flow-intake/ |
| `/flow-kill` | .claude/skills/flow-kill/ |
| `/flow-review` | .claude/skills/flow-review/ |
| `/flow-spec` | .claude/skills/flow-spec/ |
| `/flow-status` | .claude/skills/flow-status/ |
| `/flow-tempo` | .claude/skills/flow-tempo/ |
| `/flow-wip` | .claude/skills/flow-wip/ |
| `/gcp-infrastructure` | .claude/skills/gcp-infrastructure/ |
| `/macos-integration` | .claude/skills/macos-integration/ |
| `/native-extensions` | .claude/skills/native-extensions/ |
| `/native-widgets` | .claude/skills/native-widgets/ |
| `/plugin-generator` | .claude/skills/plugin-generator/ |
| `/project-manager` | .claude/skills/project-manager/ |
| `/prompts-manager` | .claude/skills/prompts-manager/ |
| `/proto-grpc` | .claude/skills/proto-grpc/ |
| `/qa-testing` | .claude/skills/qa-testing/ |
| `/raycast-compat` | .claude/skills/raycast-compat/ |
| `/react-native-mobile` | .claude/skills/react-native-mobile/ |
| `/rust-engine` | .claude/skills/rust-engine/ |
| `/tailwindcss-development` | .claude/skills/tailwindcss-development/ |
| `/typescript-react` | .claude/skills/typescript-react/ |
| `/ui-design` | .claude/skills/ui-design/ |
| `/vscode-compat` | .claude/skills/vscode-compat/ |
| `/wails-desktop` | .claude/skills/wails-desktop/ |

## Agents

Specialized agents in `.claude/agents/` auto-delegate based on task context.

| Agent | File |
|-------|------|
| `ai-engineer` | .claude/agents/ai-engineer.md |
| `clickhouse-engineer` | .claude/agents/clickhouse-engineer.md |
| `csharp-plugin` | .claude/agents/csharp-plugin.md |
| `dba` | .claude/agents/dba.md |
| `devops` | .claude/agents/devops.md |
| `extension-architect` | .claude/agents/extension-architect.md |
| `flutter-android` | .claude/agents/flutter-android.md |
| `flutter-ios` | .claude/agents/flutter-ios.md |
| `flutter-linux` | .claude/agents/flutter-linux.md |
| `flutter-macos` | .claude/agents/flutter-macos.md |
| `flutter-ui-ux` | .claude/agents/flutter-ui-ux.md |
| `flutter-web` | .claude/agents/flutter-web.md |
| `flutter-windows` | .claude/agents/flutter-windows.md |
| `frontend-dev` | .claude/agents/frontend-dev.md |
| `gtk-plugin` | .claude/agents/gtk-plugin.md |
| `kotlin-plugin` | .claude/agents/kotlin-plugin.md |
| `lancedb-engineer` | .claude/agents/lancedb-engineer.md |
| `mobile-dev` | .claude/agents/mobile-dev.md |
| `orchestra` | .claude/agents/orchestra.md |
| `platform-engineer` | .claude/agents/platform-engineer.md |
| `postgres-dba` | .claude/agents/postgres-dba.md |
| `qa-node` | .claude/agents/qa-node.md |
| `qa-playwright` | .claude/agents/qa-playwright.md |
| `qa-rust` | .claude/agents/qa-rust.md |
| `quic-protocol` | .claude/agents/quic-protocol.md |
| `redis-engineer` | .claude/agents/redis-engineer.md |
| `rust-engineer` | .claude/agents/rust-engineer.md |
| `scrum-master` | .claude/agents/scrum-master.md |
| `sqlite-engineer` | .claude/agents/sqlite-engineer.md |
| `swift-plugin` | .claude/agents/swift-plugin.md |
| `ui-ux-designer` | .claude/agents/ui-ux-designer.md |
| `widget-engineer` | .claude/agents/widget-engineer.md |

## Hooks

| Hook | File |
|------|------|
| `orchestra-mcp-hook` | .claude/hooks/orchestra-mcp-hook.sh |
| `orchestra-permission-hook` | .claude/hooks/orchestra-permission-hook.sh |
