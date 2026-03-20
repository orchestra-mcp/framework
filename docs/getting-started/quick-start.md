---
title: Quick Start
description: Get your first Orchestra project running in 5 minutes
order: 3
---

# Quick Start

Get Orchestra running and create your first feature in under 5 minutes.

## Step 1: Install Orchestra

```bash
curl -fsSL https://orchestra-mcp.dev/install.sh | sh
```

## Step 2: Initialize Your Project

```bash
cd your-project
orchestra init
```

Orchestra detects your stack and creates the necessary config files:

```
Detecting project stack...
  Go 1.22   ✓  detected
  React 18  ✓  detected
  Docker    ✓  detected

Created .mcp.json
Created .projects/
Created CLAUDE.md
```

## Step 3: Start the MCP Server

```bash
orchestra serve
```

```
✓ orchestrator        in-process router
✓ storage.markdown    .projects/
✓ tools.features      70 tools
✓ tools.marketplace   15 tools + 5 prompts
✓ engine.rag          22 tools (Rust)
✓ bridge.claude       5 tools + streaming
✓ agent.orchestrator  20 tools
✓ transport.stdio     MCP server

⚡ 300+ tools ready · MCP server on stdio
```

## Step 4: Connect Your IDE

Open your project in Claude Code, Cursor, or VS Code. The MCP tools are available immediately — your AI assistant can now:

- Create and manage features
- Run database queries
- Execute tests
- Search your codebase with RAG
- Orchestrate multi-model AI workflows

## Step 5: Install a Pack (Optional)

```bash
orchestra pack install go
# Installing orchestra-mcp/pack-go v0.2.0...
#   + 4 skills, 2 agents, 1 hook
#   Stack: go (detected)

orchestra pack install react
# Installing orchestra-mcp/pack-react v0.2.0...
#   + 3 skills, 2 agents, 1 hook
```

Packs add stack-specific skills (slash commands), agents, and hooks to your project.

## Step 6: Create Your First Feature

In your AI client, say:

> "Create a feature to add user authentication"

Orchestra creates a tracked feature with a gated lifecycle:

```
Feature FEAT-001 created: "Add user authentication"
Status: todo → in-progress
Session lock acquired
```

Your AI writes code during `in-progress`, tests during `in-testing`, docs during `in-docs`, and presents for review during `in-review`. Each transition requires evidence.

## You're Ready

Your Orchestra project is set up. Here's what to explore next:

- [Feature Workflow](/docs/tools/features) — Learn the gated feature lifecycle
- [MCP Tools](/docs/tools/rag) — Explore RAG memory and search
- [Agent Orchestration](/docs/tools/agents) — Set up multi-model AI workflows
- [Content Packs](/docs/tools/marketplace) — Browse available packs
