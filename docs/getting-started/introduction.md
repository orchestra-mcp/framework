---
title: Introduction
description: What is Orchestra MCP and why it exists
order: 1
---

# Introduction to Orchestra MCP

Orchestra MCP is an AI-agentic IDE framework that gives your AI coding assistant superpowers. It exposes **300+ MCP tools** across 38 plugins, works with **9 IDEs** (Claude Code, Cursor, VS Code, Cline, Windsurf, Codex, Gemini, Zed, Continue.dev), and runs on **6 platforms** (macOS, Windows, Linux, iOS, Android, Web).

## What is Orchestra?

Orchestra is the middleware between your AI client and your development workflow. When you type a request in Claude Code or Cursor, Orchestra provides the tools your AI needs to:

- **Manage features** through a gated lifecycle (todo → in-progress → in-testing → in-docs → in-review → done)
- **Query databases** without raw SQL in your terminal
- **Run background scripts** with live log tailing
- **Test APIs** with saved collections and history
- **Manage secrets** without exposing `.env` files
- **Orchestrate multiple AI models** (Claude, GPT-4o, Gemini, Ollama, and more)
- **Search codebases** with RAG memory (Tree-sitter + Tantivy + cosine similarity)
- **Install content packs** with pre-built skills, agents, and hooks for your stack

## Core Concepts

### Plugin
A standalone module that connects to the orchestrator. Plugins are written in Go, Rust, Swift, Kotlin, or C#. Each plugin exposes MCP tools that your AI client can call.

### MCP Tool
A callable function exposed by a plugin via the Model Context Protocol. Your AI client (Claude, Cursor, etc.) calls these automatically when it needs to perform an action.

### Pack
A curated collection of skills (slash commands), agents, and hooks. Installed with `orchestra pack install <name>`. There are 24 official packs covering Go, Rust, React, Python, Kubernetes, Docker, and more.

### Orchestrator
The central process that manages plugin routing and lifecycle. It runs in-process for local IDE use (no separate server needed) and exposes all tools over MCP's stdio transport.

### Feature
The unit of work in Orchestra. Every task — building, fixing, testing, refactoring — goes through a gated lifecycle with evidence requirements at each transition.

## Architecture at a Glance

```
Your IDE (Claude Code, Cursor, VS Code, ...)
         ↓  MCP / stdio
    transport.stdio
         ↓  in-process router
    orchestrator
    ↙    ↓    ↓    ↘
tools  bridge  engine  storage
.features .claude  .rag  .markdown
```

Orchestra uses a single-process in-process architecture for local IDE use. All 38 plugins run in the same process, communicating via direct Go function calls. External plugins (like the Rust-based engine.rag) connect over QUIC with mTLS.

## What's Included

| Category | Count | Examples |
|----------|-------|---------|
| MCP Tools | 300+ | `create_feature`, `db_query`, `ai_prompt`, `search_memory` |
| Plugins | 38 | tools.features, bridge.claude, engine.rag, devtools.docker |
| Content Packs | 24 | Go, Rust, React, Python, Kubernetes, Docker |
| IDE Support | 9 | Claude Code, Cursor, VS Code, Cline, Windsurf, Codex, Gemini, Zed, Continue.dev |
| Platforms | 6 | macOS (Swift), Windows (C#), Linux (GTK4), iOS & Android (Flutter), Web (Next.js) |
| AI Bridges | 6 | Claude, OpenAI, Gemini, Ollama, Firecrawl, + OpenAI-compatible aliases |

## Next Steps

- [Installation](/docs/getting-started/installation) — Install Orchestra in 30 seconds
- [Quick Start](/docs/getting-started/quick-start) — Get your first project running
- [CLI Reference](/docs/cli/serve) — Learn the CLI commands
