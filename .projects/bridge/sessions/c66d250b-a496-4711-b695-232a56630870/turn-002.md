---
cost_usd: 0
duration_ms: 21488
model: claude-sonnet-4-6
number: 2
timestamp: "2026-03-04T14:50:25Z"
tokens_in: 0
tokens_out: 0
user_prompt: check the current codebase and let me know what is do
---

## User

check the current codebase and let me know what is do

## Response

Based on the CLAUDE.md and my memory, here's what this codebase is:

## Orchestra MCP — AI-Agentic IDE Platform

**What it is:** A project management + AI orchestration platform delivered as an MCP (Model Context Protocol) server. It gives AI coding assistants (Claude Code, Cursor, VS Code, etc.) structured project management tools.

**Core components:**

| Layer | Tech | Purpose |
|-------|------|---------|
| CLI binary | Go | `orchestra serve/init/pack` — the main entry point |
| Plugin system | Go | 36 in-process plugins, 290 MCP tools |
| Storage | Markdown + YAML frontmatter | Feature/sprint/session files in `.projects/` |
| RAG Engine | Rust (quinn, Tantivy, SQLite) | Vector search, code parsing, memory |
| AI Bridges | Go | Claude, OpenAI, Gemini, Ollama, Firecrawl |
| Packs | JSON manifests | 17 installable skill/agent/hook bundles |

**What it does for users:**
- Enforces a gated feature workflow (backlog → todo → in-progress → testing → docs → review → done)
- Provides 290 MCP tools for sprint planning, PRDs, agent orchestration, session management, workspace management, etc.
- Lets AI agents write code with traceability — every feature has structured evidence at each gate
- Supports multi-AI orchestration (spawn Claude/GPT/Gemini sub-agents, compare providers, run test suites)

**Current state (from git status):**
- `Makefile` and `scripts/dev-swift.sh` have uncommitted changes
- Several new bridge session files and a few new feature files (`FEAT-IUO.md`, `FEAT-XNR.md`, `FEAT-GVN.md` updated)
- `.claude/settings.json` modified

Want me to dig into any specific area?

---
- **Session:** c66d250b-a496-4711-b695-232a56630870
- **Model:** claude-sonnet-4-6
- **Tokens:** 3 in / 562 out
- **Cost:** $0.1450
- **Duration:** 21487ms

