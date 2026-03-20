---
estimate: S
id: FEAT-UII
kind: feature
priority: P2
project_slug: orchestra-agents
status: done
title: Claude Desktop Config IDE Support
type: feature
---

# Claude Desktop Config IDE Support

Add claude-desktop to IDE config generator for orchestra init --ide claude-desktop. Config paths: macOS ~/Library/Application Support/Claude/claude_desktop_config.json, Windows %APPDATA%/Claude/claude_desktop_config.json, Linux ~/.config/Claude/claude_desktop_config.json. Uses mergeJSONMcpConfig to preserve existing servers.

Files: libs/cli/internal/ide.go


---
**in-progress -> in-testing** (2026-03-20T18:32:55Z):
## Changes
- libs/cli/internal/ide.go (added claudeDesktopConfigPath helper with macOS/Windows/Linux paths, claudeDesktopConfig IDE config, registered "claude-desktop" in ideRegistry and allIDENames)


---
**in-testing -> in-docs** (2026-03-20T18:33:39Z):
## Results
- libs/cli/internal/ide_test.go (5 new tests: TestClaudeDesktopConfigRegistered, TestClaudeDesktopInAllIDENames, TestClaudeDesktopConfigPath, TestClaudeDesktopConfigGenerate, TestClaudeDesktopConfigPreservesExisting)
- All 5 tests pass: `go test ./internal/ -v -count=1 -run "TestClaudeDesktop"` → PASS ok github.com/orchestra-mcp/cli/internal 0.633s


---
**in-docs -> in-review** (2026-03-20T18:33:57Z):
## Docs
- docs/claude-desktop-config.md (new — covers usage, config paths, generated format, difference from Claude Code)


---
**Review (approved)** (2026-03-20T18:34:09Z): Claude Desktop config support approved. 5 tests pass, docs complete.
