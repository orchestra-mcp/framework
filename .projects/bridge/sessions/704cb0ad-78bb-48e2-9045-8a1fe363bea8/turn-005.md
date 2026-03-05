---
cost_usd: 0
duration_ms: 33143
model: claude-sonnet-4-6
number: 5
timestamp: "2026-03-04T08:55:14Z"
tokens_in: 0
tokens_out: 0
user_prompt: understand the codebase and let me know what is do
---

## User

understand the codebase and let me know what is do

## Response

⚙ Skill: docs
✓ Skill
Here's what the **Orchestra MCP** codebase is and does:

---

## What It Is

**Orchestra MCP** is an AI-powered IDE and project management platform targeting **5 platforms**:
- macOS/iOS/watchOS (Swift)
- Windows (C# / WinUI 3)
- Linux (Vala + GTK4)
- Chrome Extension
- Web Dashboard

---

## Core Architecture

It's a **monorepo** with three main layers:

| Layer | Tech | Role |
|-------|------|------|
| **Backend** | Go (Fiber v3 + GORM) | REST API, WebSocket sync, auth (JWT), job queue |
| **Engine** | Rust (Tonic gRPC) | CPU-heavy work — Tree-sitter parsing, Tantivy search, SQLite, encryption |
| **Frontend** | React/TypeScript (pnpm + Turborepo) | 5 apps sharing `@orchestra/shared` + `@orchestra/ui` |

---

## What It Actually Does

### 1. Plugin System
Everything is a plugin. The Go runtime at `app/plugins/` provides dependency injection, feature flags, and a VS Code-style contribution system. Each plugin is a standalone Go module.

### 2. MCP Plugin (290 tools)
The primary plugin provides **290 MCP tools** for AI agents via the Model Context Protocol — project management, feature workflows, sprint planning, PRD generation, agent orchestration, and more.

### 3. Feature Workflow Engine
A **13-state lifecycle** for software development work:
```
backlog → todo → in-progress → ready-for-testing → in-testing 
→ ready-for-docs → in-docs → documented → in-review → done
```
With enforced gates that require real evidence at each transition.

### 4. Multi-Agent Orchestration
Bridges to **Claude, OpenAI, Gemini, Ollama, Firecrawl** — routes AI calls across providers, manages sessions, tracks budgets, and runs parallel agents.

### 5. Three-Layer Database
- **PostgreSQL** (cloud) — source of truth with pgvector + full-text search
- **SQLite** (local) — offline support via Rust engine
- **Redis** — real-time pub/sub sync + caching

### 6. Packs Marketplace
**17 installable packs** that add skills, agents, and hooks to Claude Code and other IDEs. Stack-aware (Go, Rust, React, Python, etc.).

### 7. Native Desktop Apps
Tray-only macOS app with global `Cmd+K` hotkey, floating bubble/card UI, workspace switching, and voice input.

---

## In Short

Orchestra MCP turns AI agents (Claude, GPT-4, Gemini, etc.) into a **structured software delivery system** — with enforced workflows, multi-agent coordination, cross-platform IDE support, and a full plugin ecosystem. It's both the framework and the first major plugin built on top of it.

---
- **Session:** 704cb0ad-78bb-48e2-9045-8a1fe363bea8
- **Model:** claude-sonnet-4-6
- **Tokens:** 5 in / 1041 out
- **Duration:** 33142ms

