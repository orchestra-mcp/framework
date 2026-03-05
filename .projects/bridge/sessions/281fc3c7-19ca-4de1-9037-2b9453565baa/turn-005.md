---
cost_usd: 0
duration_ms: 96192
model: claude-sonnet-4-6
number: 5
timestamp: "2026-03-02T18:02:24Z"
tokens_in: 0
tokens_out: 0
user_prompt: that's good check the current code base and let me know what is doing
---

## User

that's good check the current code base and let me know what is doing

## Response

Here's a thorough breakdown of what this codebase is doing:

---

## Orchestra Framework — What It Does

**Orchestra** is an AI-agentic IDE framework — a plugin-based system that gives AI agents (Claude, GPT, Gemini, etc.) access to 290 real-world tools via the **Model Context Protocol (MCP)**.

---

### Core Architecture

```
IDE Agent (Claude Code, Cursor, VS Code, etc.)
  │ JSON-RPC (stdin/stdout)
  ▼
orchestra serve  (single Go process)
  ├─ In-process core plugins (4)
  │   ├── storage.markdown       — disk storage (YAML frontmatter + Markdown)
  │   ├── tools.features (34)    — feature-driven workflow (11-state lifecycle)
  │   ├── tools.marketplace (15) — pack/plugin install
  │   └── transport.stdio        — JSON-RPC bridge
  │
  ├─ QUIC-connected plugins (32)
  │   ├── bridge.claude/openai/gemini/ollama/firecrawl
  │   ├── devtools.git/docker/terminal/ssh/debugger/...
  │   ├── agent.orchestrator (multi-agent)
  │   ├── engine.rag (Rust: Tree-sitter + Tantivy + SQLite)
  │   └── 27 more...
  │
  └─ TCP (port 50101) for desktop apps (Swift/Windows/Linux)
```

---

### What It's Made Of

| Layer | Tech |
|-------|------|
| Core | Go 1.25, quic-go, mTLS, Protobuf |
| Search/Parse Engine | Rust (Tree-sitter, Tantivy, rusqlite) |
| Frontend | React 19, TypeScript, Next.js, React Native |
| Desktop | Swift (macOS/iOS), Kotlin (Android), C#/WinUI3 (Windows), Vala/GTK4 (Linux) |
| Database | PostgreSQL, SQLite, Redis |

---

### Key Features

1. **290 MCP Tools** across 36 plugins — git, docker, terminal, AI chat, code parsing, memory, multi-agent orchestration, and more
2. **Feature-driven workflow** — 11-state lifecycle (backlog → done) with evidence-gated transitions, WIP limits, and review gates
3. **Multi-agent orchestration** — Define agents/workflows, run them, test against multiple AI providers
4. **RAG Engine (Rust)** — Code indexing (Tree-sitter), full-text search (Tantivy), vector memory (SQLite cosine similarity)
5. **17 content packs** — Skills, agents, and hooks for Go, Rust, React, Python, Docker, and more
6. **5 desktop/mobile apps** — Swift (universal Apple), Kotlin (Android), Next.js (web), Windows (WinUI3), Linux (GTK4)

---

### Current State

- **v1.0.0 GA** (released March 2, 2026)
- Recent work has been on the **server deployment scripts** (`setup-server.sh`) for Ubuntu 24.04 + Caddy + Cloudflare
- Active features in progress: Swift app, Android app, Linux desktop, Windows desktop, RAG engine

---

In short: it's a production-grade AI IDE framework that makes any AI agent dramatically more capable by giving it real tools to work with. What would you like to dive into?

---
- **Session:** 281fc3c7-19ca-4de1-9037-2b9453565baa
- **Model:** claude-sonnet-4-6
- **Tokens:** 4 in / 1097 out
- **Duration:** 96190ms

