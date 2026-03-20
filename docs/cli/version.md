---
title: orchestra version
description: Display the current Orchestra version and build info
order: 4
---

# orchestra version

Display the current Orchestra CLI version and build information.

## Usage

```bash
orchestra version
```

## Output

```
Orchestra v1.0.4 (darwin/arm64)
Built: 2026-03-12
Commit: 5aebe1b
Plugins: 4 core + 34 optional
```

## Version Format

Orchestra follows semantic versioning (`MAJOR.MINOR.PATCH`):
- **Major** — Breaking changes to the CLI or MCP tool interface
- **Minor** — New features, tools, or plugins
- **Patch** — Bug fixes and performance improvements

## Checking for Updates

```bash
# The install script always fetches the latest version
curl -fsSL https://orchestra-mcp.dev/install | sh

# Or check the current version against the latest release
orchestra version
```
