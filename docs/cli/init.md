---
title: orchestra init
description: Initialize a new Orchestra project in the current directory
order: 2
---

# orchestra init

Initialize Orchestra in an existing project directory. Creates configuration files and detects your tech stack.

## Usage

```bash
orchestra init [flags]
```

## What It Creates

| File/Directory | Purpose |
|----------------|---------|
| `.mcp.json` | MCP client configuration — auto-detected by Claude Code, Cursor, VS Code |
| `.projects/` | Feature storage directory (markdown-based) |
| `CLAUDE.md` | AI assistant instructions with workflow rules |
| `AGENTS.md` | Agent definitions for specialized sub-agents |

## Stack Detection

Orchestra auto-detects 12 tech stacks and recommends packs:

| Stack | Detection | Recommended Pack |
|-------|-----------|-----------------|
| Go | `go.mod` | `pack-go` |
| Rust | `Cargo.toml` | `pack-rust` |
| React | `package.json` with react dep | `pack-react` |
| TypeScript | `tsconfig.json` | `pack-typescript` |
| Python | `pyproject.toml`, `requirements.txt` | `pack-python` |
| Ruby | `Gemfile` | `pack-ruby` |
| Java | `pom.xml`, `build.gradle` | `pack-java` |
| Kotlin | `build.gradle.kts` with kotlin | `pack-kotlin` |
| Swift | `Package.swift` | `pack-swift` |
| C# | `*.csproj`, `*.sln` | `pack-csharp` |
| PHP | `composer.json` | `pack-php` |
| Docker | `Dockerfile`, `docker-compose.yml` | `pack-docker` |

## Example

```bash
cd my-go-api
orchestra init

# Detecting project stack...
#   Go 1.22    ✓  detected
#   Docker     ✓  detected
#
# Created .mcp.json
# Created .projects/
# Created CLAUDE.md
# Created AGENTS.md
#
# Recommended packs:
#   orchestra pack install go
#   orchestra pack install docker
```

## Flags

| Flag | Default | Description |
|------|---------|-------------|
| `--force` | false | Overwrite existing config files |
| `--no-packs` | false | Skip pack recommendations |
| `--workspace` | `.` | Target directory |

## Re-initialization

Running `orchestra init` in an already-initialized project is safe — it only creates files that don't exist yet. Use `--force` to regenerate all files.
