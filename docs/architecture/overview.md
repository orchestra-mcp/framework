---
title: System Overview
description: High-level architecture of Orchestra MCP — plugins, routing, storage, and platforms
order: 1
---

# System Overview

Orchestra MCP is built from three layers: the **orchestrator** (routing + lifecycle), **plugins** (tools + capabilities), and **transports** (IDE + desktop connections).

## Architecture Diagram

```
┌─────────────────────────────────────────────────┐
│  IDE Layer                                       │
│  Claude Code · Cursor · VS Code · 6 more         │
└──────────────────────┬──────────────────────────┘
                       │ MCP / stdio
┌──────────────────────┴──────────────────────────┐
│  transport.stdio                                 │
└──────────────────────┬──────────────────────────┘
                       │ in-process router
┌──────────────────────┴──────────────────────────┐
│  Orchestrator                                    │
│  Plugin loader · Message router · Lifecycle mgr  │
└───┬────────┬────────┬────────┬──────────────────┘
    │        │        │        │
┌───┴──┐ ┌──┴───┐ ┌──┴───┐ ┌──┴───────┐
│tools │ │bridge│ │engine│ │storage   │
│.feat │ │.claude│ │.rag │ │.markdown │
│70 t  │ │5+str │ │22 t │ │          │
└──────┘ └──────┘ └──────┘ └──────────┘
    In-process Go     QUIC     In-process
```

## Key Numbers

| Metric | Count |
|--------|-------|
| MCP Tools | 300+ |
| Plugins | 38 (4 core + 34 optional) |
| Content Packs | 24 |
| IDE Support | 9 |
| Platforms | 6 |
| AI Bridges | 6 providers |
| Proto services | QUIC + TCP + stdio |

## Plugin Categories

### Core (Always Bundled)

| Plugin | Role |
|--------|------|
| `storage.markdown` | Markdown + YAML frontmatter persistence |
| `transport.stdio` | MCP stdio transport for IDEs |
| `tools.features` | Feature lifecycle, plans, git (70 tools) |
| `tools.marketplace` | Pack management, stack detection (15 tools + 5 prompts) |

### AI & Bridges

| Plugin | Provider | Tools |
|--------|----------|-------|
| `bridge.claude` | Anthropic | 5 + streaming |
| `bridge.openai` | OpenAI + aliases | 5 |
| `bridge.gemini` | Google | 5 |
| `bridge.ollama` | Local models | 5 |
| `bridge.firecrawl` | Web scraping | 5 |
| `agent.orchestrator` | Multi-agent workflows | 20 |

### DevTools

| Plugin | Tools | Capabilities |
|--------|-------|-------------|
| `devtools.database` | 18 | PostgreSQL, SQLite, query, schema |
| `devtools.docker` | 10 | Containers, compose, images |
| `devtools.terminal` | 6 | Background scripts, log tailing |
| `devtools.git` | 20 | Branches, commits, diffs |
| `devtools.ssh` | 7 | Remote server management |
| `devtools.test-runner` | 8 | Test execution, assertions |
| `devtools.file-explorer` | 17 | File operations, search |
| `devtools.services` | 6 | Service management |
| `devtools.debugger` | 9 | Debug sessions |
| `devtools.log-viewer` | 5 | Log aggregation |
| `devtools.components` | 6 | UI component management |
| `devtools.devops` | 8 | CI/CD, deployment |

### AI Awareness

| Plugin | Tools | Capabilities |
|--------|-------|-------------|
| `ai.browser-context` | 7 | Page content, DOM analysis |
| `ai.screenshot` | 6 | Screen capture, OCR |
| `ai.screen-reader` | 6 | Accessibility tree reading |
| `ai.vision` | 6 | Image analysis |

### Engine

| Plugin | Language | Tools |
|--------|----------|-------|
| `engine.rag` | Rust | 22 — parsing, search, memory |

## Data Storage

All project data is stored as Markdown with YAML frontmatter in `.projects/`:

```
.projects/
├── <project-slug>/
│   ├── project.json
│   ├── features/     FEAT-XXX.md
│   ├── plans/        PLAN-XXX.md
│   ├── requests/     REQ-XXX.md
│   └── persons/      PERS-XXX.md
└── .packs/
    └── registry.json
```

Benefits:
- **Git-native** — all data is version-controlled
- **Human-readable** — inspect and edit with any text editor
- **Portable** — copy between machines, no database setup

## Platform Support

| Platform | Technology | Connection |
|----------|-----------|------------|
| macOS | Swift + WidgetKit | TCP :50101 |
| Windows | C# + WinUI 3 | TCP :50101 |
| Linux | Vala + GTK4 | TCP :50101 |
| iOS & Android | Flutter | TCP :50101 |
| Web | Next.js | REST API |
| Chrome Extension | Manifest V3 | MCP bridge |

Desktop apps connect to the orchestrator via TCP with length-delimited Protobuf. The web dashboard uses the Go backend's REST API. The Chrome extension bridges to MCP via a background service worker.
