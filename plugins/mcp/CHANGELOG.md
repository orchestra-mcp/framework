# Changelog

All notable changes to Orchestra MCP are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.1.0] - 2026-02-13

### Added

- 40 built-in MCP tools across 10 categories (project, epic, story, task, workflow, PRD, bugfix, usage, readme, artifacts)
- Dual-mode operation: standalone stdio CLI + integrated Go plugin
- TOON (Text Object-Oriented Notation) file format for data persistence
- Workflow state machine with validated transitions
- Workspace init command (`orchestra-mcp init`)
- Plugin extensibility via `RegisterExternalTools()` — other Go plugins can push tools
- REST API endpoints (`/api/mcp/tools`, `/api/mcp/tools/call`)
- Version injection via ldflags (`--version`, `--help` flags)
- go:embed bundled resources (skills, agents)
- Distribution: Homebrew tap, npm wrapper, curl installer, GoReleaser multi-platform builds
- GitHub Actions CI/CD (lint, format, test, build, release)
- Comprehensive test suite (transport, tools, helpers, toon, workflow, providers)
- golangci-lint (26 linters) + gofumpt formatting

[0.1.0]: https://github.com/orchestra-mcp/mcp/releases/tag/v0.1.0
