# Claude Desktop Config IDE Support

## Overview

`orchestra init --ide claude-desktop` configures the Claude Desktop chat app's global MCP config, separate from Claude Code's per-project `.mcp.json`.

## Usage

```bash
orchestra init --ide claude-desktop --workspace /path/to/project
```

This generates or updates `claude_desktop_config.json` with the Orchestra MCP server entry.

## Config Paths

| Platform | Path |
|----------|------|
| macOS | `~/Library/Application Support/Claude/claude_desktop_config.json` |
| Windows | `%APPDATA%/Claude/claude_desktop_config.json` |
| Linux | `~/.config/Claude/claude_desktop_config.json` |

## Generated Config

```json
{
  "mcpServers": {
    "orchestra": {
      "command": "/usr/local/bin/orchestra",
      "args": ["serve", "--workspace", "/path/to/project"]
    }
  }
}
```

Existing servers in the config file are preserved — only the `orchestra` entry is added or updated.

## Difference from Claude Code

| | Claude Code | Claude Desktop |
|---|---|---|
| Config file | `.mcp.json` (per-project) | `claude_desktop_config.json` (global) |
| IDE flag | `--ide claude` | `--ide claude-desktop` |
| Transport | stdio (same) | stdio (same) |

Both use the same MCP stdio transport — the only difference is where the config file lives.
