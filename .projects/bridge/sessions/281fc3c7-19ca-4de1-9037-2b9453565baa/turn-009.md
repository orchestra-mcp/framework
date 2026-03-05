---
cost_usd: 0
duration_ms: 26421
model: claude-sonnet-4-6
number: 9
timestamp: "2026-03-02T18:25:12Z"
tokens_in: 0
tokens_out: 0
user_prompt: can you let me understand the current code base?
---

## User

can you let me understand the current code base?

## Response

Based on the exploration I already did earlier in this session, here's a clear breakdown:

---

## What Is Orchestra?

Orchestra is an **AI-powered IDE framework** — it supercharges AI agents (like me) by giving them access to **290 real tools** (git, docker, terminal, code search, memory, multi-agent orchestration, etc.) via the **Model Context Protocol (MCP)**.

Think of it as a plugin platform that sits between your AI agent and your development environment.

---

## How It's Structured

```
orchestra-agents/
├── libs/              # 48 Go packages — the entire framework
│   ├── proto/         # Protobuf definitions (wire protocol)
│   ├── gen-go/        # Auto-generated Go code from proto
│   ├── sdk-go/        # Plugin development SDK
│   ├── cli/           # `orchestra` CLI binary
│   ├── orchestrator/  # Central hub/router
│   └── plugin-*/      # 36 plugins (4 core + 32 optional)
│
├── packs/             # 17 content packs (skills, agents, hooks per stack)
├── apps/              # 5 desktop/mobile apps
│   ├── swift/         # macOS/iOS universal app
│   ├── kotlin/        # Android app
│   ├── next/          # Web dashboard (Next.js 15)
│   ├── web/           # Go web backend
│   └── (windows/linux in progress)
│
├── scripts/           # Build, release, deploy automation
├── docs/              # Architecture decisions + implementation guides
└── bin/               # ~40 compiled binaries
```

---

## The 36 Plugins

### 4 Core (always bundled in the binary)
| Plugin | What it does |
|--------|-------------|
| `storage.markdown` | Disk storage using YAML frontmatter + Markdown |
| `tools.features` | Feature workflow — 34 tools, 11-state lifecycle |
| `tools.marketplace` | Install/search packs and plugins |
| `transport.stdio` | JSON-RPC bridge to AI agents |

### 32 Optional (install via `orchestra plugin install`)
| Category | Examples |
|----------|---------|
| AI Bridges | `bridge.claude`, `bridge.openai`, `bridge.gemini`, `bridge.ollama` |
| Dev Tools | `devtools.git`, `devtools.docker`, `devtools.terminal`, `devtools.ssh` |
| Agent Ops | `agent.orchestrator` — define agents, workflows, run/test them |
| RAG Engine | `engine.rag` — Rust-powered code indexing + vector memory |
| Workspace | `tools.sessions`, `tools.workspace`, `tools.notes`, `tools.docs` |
| Services | `services.voice`, `services.notifications` |

---

## Communication Flow

```
AI Agent (Claude, GPT, Gemini...)
    │  JSON-RPC via stdin/stdout
    ▼
orchestra serve  (single Go process)
    ├── Core plugins → direct Go function calls
    └── Optional plugins → QUIC + mTLS + Protobuf
         └── Desktop apps → TCP on port 50101
```

---

## Tech Stack

| Layer | Technology |
|-------|-----------|
| Core | Go 1.25, quic-go, mTLS, Protobuf |
| RAG Engine | Rust (Tree-sitter, Tantivy, rusqlite) |
| Web | React 19, TypeScript, Next.js 15, Zustand |
| Mobile | React Native, WatermelonDB |
| Desktop | Swift, Kotlin, C#/WinUI3, Vala/GTK4 |
| Database | PostgreSQL, SQLite, Redis |

---

## Current Status

- **v1.0.0 GA** — released March 2, 2026
- Most recent commits have been fixing the **server deployment scripts** for Ubuntu 24.04
- Active development on: Swift app, Android app, Linux/Windows desktop apps, RAG engine

---

Want me to dive deeper into any specific part — a particular plugin, the workflow system, the Swift app, the Rust engine, etc.?

---
- **Session:** 281fc3c7-19ca-4de1-9037-2b9453565baa
- **Model:** claude-sonnet-4-6
- **Tokens:** 3 in / 1092 out
- **Duration:** 26420ms

