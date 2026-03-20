---
title: Installation
description: Install Orchestra MCP on macOS, Linux, or Windows
order: 2
---

# Installation

Orchestra installs as a single binary. No Node.js, no Python, no Docker required.

## Install Script

```bash
curl -fsSL https://orchestra-mcp.dev/install.sh | sh
```

This downloads the latest release for your platform and installs it to `/usr/local/bin/orchestra`. Prompts for sudo if needed.

## Verify Installation

```bash
orchestra version
# Orchestra v1.0.4 (darwin/arm64)
```

## Initialize a Project

```bash
cd your-project
orchestra init
```

This creates:
- `.mcp.json` — MCP client configuration (auto-detected by your IDE)
- `.projects/` — Feature storage directory
- `CLAUDE.md` — AI assistant instructions
- `AGENTS.md` — Agent definitions

Orchestra auto-detects your project's tech stack (Go, Rust, React, Python, etc.) and recommends packs to install.

## System Requirements

| Platform | Requirement |
|----------|-------------|
| macOS | 13.0+ (Ventura), Apple Silicon or Intel |
| Linux | kernel 5.4+, glibc 2.31+ |
| Windows | Windows 10 19041+ (WSL2 for CLI, native app coming) |

## IDE Configuration

After `orchestra init`, your IDE picks up `.mcp.json` automatically:

- **Claude Code** — Works immediately, no extra config
- **Cursor** — Works immediately via MCP settings
- **VS Code** — Install the MCP extension, restart
- **Cline / Windsurf / Continue.dev** — Point MCP config to the `.mcp.json` file

## Updating

```bash
curl -fsSL https://orchestra-mcp.dev/install.sh | sh
```

The install script always fetches the latest version. Your projects and settings are preserved.

## Uninstalling

```bash
rm /usr/local/bin/orchestra
rm -rf ~/.orchestra  # Optional: remove global config
```

## Next Steps

- [Quick Start](/docs/getting-started/quick-start) — Build your first feature
- [CLI Reference](/docs/cli/serve) — Explore all CLI commands
