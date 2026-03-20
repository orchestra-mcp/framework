---
title: Agent Orchestration
description: 20 tools for defining and running multi-model AI agent workflows
order: 3
---

# Agent Orchestration

The `agent.orchestrator` plugin provides **20 MCP tools** for defining AI agents, composing workflows, and testing across multiple AI providers.

## Overview

Agent orchestration lets you:
- **Define reusable agents** with specific instructions and model preferences
- **Compose workflows** that chain agents in sequence or parallel
- **Compare providers** (Claude, GPT-4o, Gemini, Ollama) on the same prompt
- **Test agent quality** with assertion-based evaluation suites

## AI Bridges

Orchestra supports 6 AI bridges, each exposing 5 tools:

| Bridge | Provider | Models |
|--------|----------|--------|
| `bridge.claude` | Anthropic | Claude Opus, Sonnet, Haiku |
| `bridge.openai` | OpenAI | GPT-4o, GPT-4o-mini |
| `bridge.gemini` | Google | Gemini Pro, Flash |
| `bridge.ollama` | Local | Llama, Mistral, CodeLlama, etc. |
| `bridge.firecrawl` | Firecrawl | Web scraping + extraction |

OpenAI-compatible providers (DeepSeek, Qwen, Kimi, Grok, Perplexity) route through `bridge.openai` with provider-specific base URLs.

## Agent Tools

| Tool | Description |
|------|-------------|
| `define_agent` | Create a reusable agent definition |
| `get_agent` | Get agent details |
| `list_agents` | List all defined agents |
| `delete_agent` | Remove an agent |

### Defining an Agent

```
define_agent({
  name: "code-reviewer",
  provider: "claude",
  model: "claude-sonnet-4-6",
  instruction: "Review code for bugs, security issues, and style. Return structured feedback.",
  tools: ["search", "get_symbols", "parse_file"]
})

→ Agent AGT-0042 created
```

## Workflow Tools

| Tool | Description |
|------|-------------|
| `define_workflow` | Create a multi-step agent pipeline |
| `get_workflow` | Get workflow details |
| `list_workflows` | List all workflows |
| `delete_workflow` | Remove a workflow |

### Defining a Workflow

```
define_workflow({
  name: "review-pipeline",
  steps: [
    { agent: "code-reviewer", input: "Review the PR diff" },
    { agent: "security-scanner", input: "Check for OWASP top 10" },
    { agent: "doc-generator", input: "Generate changelog entry" }
  ]
})

→ Workflow WFL-0015 created (3 steps)
```

## Execution Tools

| Tool | Description |
|------|-------------|
| `run_agent` | Execute a single agent |
| `run_workflow` | Execute a multi-step workflow |
| `get_run_status` | Check execution progress |
| `list_runs` | List recent executions |
| `cancel_run` | Cancel a running execution |

### Running a Workflow

```
run_workflow({ id: "WFL-0015" })

→ Step 1/3: code-reviewer    ✓ 1.2s
→ Step 2/3: security-scanner ✓ 0.8s
→ Step 3/3: doc-generator    ✓ 2.1s
  Workflow completed in 4.1s
```

## Discovery

| Tool | Description |
|------|-------------|
| `list_available_models` | List all configured AI models across providers |

## Testing Tools

| Tool | Description |
|------|-------------|
| `create_test_suite` | Create a test suite for agent evaluation |
| `run_test_suite` | Execute a test suite |
| `get_test_results` | View test results |
| `add_test_case` | Add a test case to a suite |
| `evaluate_response` | Evaluate a response against assertions |
| `compare_providers` | Benchmark a prompt across multiple providers |

### Comparing Providers

```
compare_providers({
  prompt: "Explain the QUIC transport protocol",
  providers: ["claude", "openai", "gemini"]
})

→ claude   1.2s  quality: 0.94  tokens: 847
  openai   0.8s  quality: 0.91  tokens: 623
  gemini   0.6s  quality: 0.88  tokens: 712
```

### Assertion Types

Test suites support 4 assertion types:

| Type | Description |
|------|-------------|
| `contains` | Response contains text (case-insensitive) |
| `not_contains` | Response does not contain text |
| `regex` | Response matches a regular expression |
| `min_length` | Response meets minimum character count |

## Dry Run

All execution tools support `dry_run: true` for CI/schema testing without actually calling AI providers.
