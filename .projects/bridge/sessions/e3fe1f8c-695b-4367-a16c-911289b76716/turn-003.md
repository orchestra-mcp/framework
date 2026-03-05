---
cost_usd: 0
duration_ms: 87512
model: claude-sonnet-4-6
number: 3
timestamp: "2026-03-04T14:30:04Z"
tokens_in: 0
tokens_out: 0
user_prompt: understand the codebase and let me know what is do?
---

## User

understand the codebase and let me know what is do?

## Response

⚙ Skill: docs
✓ Skill
⚙ Agent: Overview of Orchestra Agents codebase
⚙ Read: /Users/fadymondy/Sites/orchestra-agents/README.md
✓ Read
⚙ Bash: ls -la /Users/fadymondy/Sites/orchestra-agents/ | head -40
✓ Bash
⚙ Bash: find /Users/fadymondy/Sites/orchestra-agents/libs -maxdepth 2 -type d | head -60
✓ Bash
⚙ Bash: ls -la /Users/fadymondy/Sites/orchestra-agents/packs | head -30
✓ Bash
⚙ Bash: ls -la /Users/fadymondy/Sites/orchestra-agents/apps
✓ Bash
⚙ Bash: ls -la /Users/fadymondy/Sites/orchestra-agents/bin | head -20
✓ Bash
⚙ Read: /Users/fadymondy/Sites/orchestra-agents/libs/cli/cmd/serve/main.go
✗ Read
⚙ Read: /Users/fadymondy/Sites/orchestra-agents/libs/sdk-go/plugin/plugin.go
✗ Read
⚙ Bash: head -50 /Users/fadymondy/Sites/orchestra-agents/libs/orchestrator/config/con...
✗ Bash
⚙ Bash: find /Users/fadymondy/Sites/orchestra-agents/libs -name "main.go" -path "*/cm...
⚙ Bash: find /Users/fadymondy/Sites/orchestra-agents/libs -name "go.mod" | head -20
✓ Bash
✓ Bash
⚙ Bash: ls -la /Users/fadymondy/Sites/orchestra-agents/libs | grep -E "^d" | awk '{pr...
✗ Bash
⚙ Read: /Users/fadymondy/Sites/orchestra-agents/libs/proto/orchestra/plugin.proto
✗ Read
⚙ Read: /Users/fadymondy/Sites/orchestra-agents/go.work
✗ Read
⚙ Bash: find /Users/fadymondy/Sites/orchestra-agents/libs -maxdepth 1 -type d | tail -20
✓ Bash
⚙ Glob: /Users/fadymondy/Sites/orchestra-agents/go.work
✓ Glob
⚙ Read: /Users/fadymondy/Sites/orchestra-agents/go.work
✓ Read
⚙ Read: /Users/fadymondy/Sites/orchestra-agents/orchestra.json
✓ Read
⚙ Bash: head -100 /Users/fadymondy/Sites/orchestra-agents/libs/proto/orchestra/plugin...
✗ Bash
⚙ Bash: find /Users/fadymondy/Sites/orchestra-agents/libs/proto -name "*.proto" | hea...
✓ Bash
⚙ Bash: ls -la /Users/fadymondy/Sites/orchestra-agents/libs/cli/internal
✓ Bash
⚙ Bash: head -100 /Users/fadymondy/Sites/orchestra-agents/libs/orchestrator/main.go
✗ Bash
⚙ Bash: head -80 /Users/fadymondy/Sites/orchestra-agents/libs/orchestrator/server.go
✗ Bash
⚙ Bash: head -60 /Users/fadymondy/Sites/orchestra-agents/libs/sdk-go/plugin/plugin.go
✗ Bash
⚙ Bash: wc -l /Users/fadymondy/Sites/orchestra-agents/libs/plugin-tools-features/inte...
✗ Bash
⚙ Bash: find /Users/fadymondy/Sites/orchestra-agents/libs/orchestrator -name "*.go" -...
✓ Bash
⚙ Bash: find /Users/fadymondy/Sites/orchestra-agents/libs/sdk-go -name "*.go" -type f...
✓ Bash
⚙ Read: /Users/fadymondy/Sites/orchestra-agents/libs/orchestrator/cmd/main.go
✓ Read
⚙ Read: /Users/fadymondy/Sites/orchestra-agents/libs/sdk-go/plugin/plugin.go
✓ Read
⚙ Read: /Users/fadymondy/Sites/orchestra-agents/libs/orchestrator/internal/router.go
✓ Read
⚙ Read: /Users/fadymondy/Sites/orchestra-agents/Makefile
✓ Read
⚙ Bash: ls -la /Users/fadymondy/Sites/orchestra-agents/apps
✓ Bash
⚙ Bash: head -50 /Users/fadymondy/Sites/orchestra-agents/packs/pack-essentials/pack.json
✓ Bash
⚙ Bash: head -80 /Users/fadymondy/Sites/orchestra-agents/libs/cli/cmd/serve/main.go
✗ Bash
⚙ Bash: head -60 /Users/fadymondy/Sites/orchestra-agents/libs/plugin-tools-features/c...
✗ Bash
⚙ Bash: find /Users/fadymondy/Sites/orchestra-agents -name "*.md" -path "*/docs/*" | ...
✗ Bash
⚙ Bash: find /Users/fadymondy/Sites/orchestra-agents/libs/cli -name "*.go" | head -10
✓ Bash
⚙ Bash: head -50 /Users/fadymondy/Sites/orchestra-agents/libs/cli/main.go 2>/dev/null...
✓ Bash
✓ Agent
Here's what this codebase does:

---

## Orchestra — AI-Agentic IDE Framework

**Orchestra** is a plugin-driven framework that connects AI assistants (Claude, GPT, Gemini, Ollama, etc.) to **290 MCP tools** across 36 plugins. It acts as a local "IDE brain" for AI-powered development.

---

### Core Function

Runs as a single local process that:
1. Exposes tools to AI assistants via the **MCP protocol** (stdio/TCP)
2. Manages **feature-driven project workflows** (backlog → done, 11 states)
3. Hosts **content packs** — installable skills, agents, and hooks for different tech stacks

---

### Main Components

| Layer | What it is |
|-------|-----------|
| `libs/orchestrator/` | Central hub — routes messages, manages plugin lifecycle |
| `libs/cli/` | The `orchestra` binary — `serve`, `init`, `plugin`, `pack` commands |
| `libs/sdk-go/` | Plugin SDK — fluent builder API for writing Go plugins |
| `libs/plugin-tools-features/` | 34 workflow tools (the feature lifecycle system) |
| `libs/plugin-storage-markdown/` | File storage backend (YAML frontmatter + Markdown body) |
| `libs/plugin-engine-rag/` | Rust plugin — Tree-sitter parsing, Tantivy search, SQLite memory |
| `libs/plugin-bridge-*/` | AI bridges — Claude, OpenAI, Gemini, Ollama, Firecrawl |
| `packs/` | 24 official content packs (skills, agents, hooks per stack) |
| `apps/` | Native desktop apps — Swift (macOS), C# (Windows), Vala (Linux), Kotlin (Android) |

---

### Architecture

```
AI Provider (Claude/GPT/Gemini)
        ↓  MCP stdio
  transport.stdio (in-process)
        ↓
  InProcessRouter  ←→  core plugins (storage, features, marketplace)
        ↓  QUIC + mTLS
  Optional plugins (bridges, devtools, agents, AI awareness...)
        ↓  TCP port 50101
  Desktop apps (Swift / C# / GTK4)
```

---

### Key Capabilities

- **Feature workflow** — Gated transitions with evidence validation, WIP limits, dependency graphs
- **Multi-AI routing** — One interface, any provider
- **Content packs** — Install skills (slash commands) + agents + hooks per tech stack
- **Cross-platform** — macOS, Windows, Linux, Android, Web
- **Plugin system** — Drop in a new Go binary to add tools

Want me to dive deeper into any specific part?

---
- **Session:** e3fe1f8c-695b-4367-a16c-911289b76716
- **Model:** claude-sonnet-4-6
- **Tokens:** 6 in / 996 out
- **Cost:** $0.2794
- **Duration:** 87510ms

