---
title: orchestra serve
description: Start the MCP server and load all plugins
order: 1
---

# orchestra serve

Start the Orchestra MCP server. This is the main command that makes all tools available to your AI client.

## Usage

```bash
orchestra serve [flags]
```

## What It Does

1. Loads the orchestrator with all registered plugins
2. Starts the in-process router (direct Go function calls for bundled plugins)
3. Connects external plugins over QUIC (e.g., engine.rag)
4. Exposes all tools via MCP's stdio transport
5. Your IDE reads `.mcp.json` and connects automatically

## Output

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

## Flags

| Flag | Default | Description |
|------|---------|-------------|
| `--workspace` | Current directory | Path to the workspace root |
| `--port` | 9100 | TCP port for desktop app connections |
| `--verbose` | false | Enable debug logging |
| `--plugins` | all | Comma-separated list of plugins to load |

## Environment Variables

| Variable | Description |
|----------|-------------|
| `ORCHESTRA_HOME` | Global config directory (default: `~/.orchestra`) |
| `ORCHESTRA_LOG_LEVEL` | Log level: debug, info, warn, error |

## Plugin Loading Order

1. **Core plugins** (always loaded): storage.markdown, transport.stdio, tools.features, tools.marketplace
2. **Optional plugins** (loaded if installed): bridge.claude, engine.rag, agent.orchestrator, devtools.*, etc.
3. **External plugins** (connected via QUIC): third-party plugins, remote engine.rag instances

## TCP Server

When desktop apps (macOS Swift, Windows C#, Linux GTK4) connect, Orchestra also starts a TCP server on port 50101 with length-delimited Protobuf framing.

## Examples

```bash
# Start with default settings
orchestra serve

# Start with specific workspace
orchestra serve --workspace /path/to/project

# Start with verbose logging
orchestra serve --verbose

# Start with only core plugins
orchestra serve --plugins storage.markdown,tools.features,transport.stdio
```
