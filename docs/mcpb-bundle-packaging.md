# MCPB Bundle Packaging

## Overview

Orchestra MCP can be packaged as a `.mcpb` bundle for one-click installation in the Claude Desktop chat app. The MCPB format (v0.3) is a ZIP archive containing a manifest, platform binaries, and an icon.

## Building

```bash
make mcpb
# or
bash scripts/mcpb/build-mcpb.sh --version 1.0.4
```

Produces: `dist/orchestra.mcpb`

## Contents

The `.mcpb` bundle contains:

```
orchestra.mcpb (ZIP)
├── manifest.json
├── icon.png
└── bin/
    ├── orchestra-darwin-arm64
    ├── orchestra-darwin-amd64
    ├── orchestra-linux-arm64
    ├── orchestra-linux-amd64
    └── orchestra-windows-amd64.exe
```

## Manifest

Key fields in `manifest.json`:

| Field | Value |
|-------|-------|
| `manifest_version` | `0.3` |
| `server.type` | `binary` (Go compiled) |
| `tools_generated` | `true` (290+ dynamic tools) |
| `prompts_generated` | `true` (5 prompts) |
| `user_config.workspace` | Required directory picker |

## Platform Targets

| Platform | Architecture | Entry Point |
|----------|-------------|-------------|
| macOS | arm64 (Apple Silicon) | `bin/orchestra-darwin-arm64` |
| macOS | amd64 (Intel) | `bin/orchestra-darwin-amd64` |
| Linux | arm64 | `bin/orchestra-linux-arm64` |
| Linux | amd64 | `bin/orchestra-linux-amd64` |
| Windows | amd64 | `bin/orchestra-windows-amd64.exe` |

## Installation

Users install the `.mcpb` bundle through Claude Desktop's extension installer. On install, Claude Desktop:
1. Extracts the platform-appropriate binary
2. Prompts for the workspace directory
3. Configures the MCP server in `claude_desktop_config.json`

## Files

- `scripts/mcpb/manifest.json` — MCPB v0.3 manifest
- `scripts/mcpb/build-mcpb.sh` — Cross-compile and package script
- `scripts/mcpb/icon.png` — Bundle icon
- `scripts/mcpb/test-mcpb.sh` — Validation tests (26 checks)
