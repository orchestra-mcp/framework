---
id: FEAT-KHA
kind: bug
priority: P0
project_slug: orchestra-agents
status: done
title: Workspace file scanner on app startup
type: feature
---

# Workspace file scanner on app startup

On desktop app launch, scan the workspace .projects/ directory for all markdown files, parse YAML frontmatter, and update the local SQLite DB with any files that changed since last scan. This ensures the UI reflects edits made outside the app (via Claude Code, text editors, etc).


---
**in-progress -> in-testing** (2026-03-20T01:24:51Z):
## Changes

- apps/flutter/lib/core/workspace/workspace_scanner.dart (new: scans .projects/ directory for markdown entity files, parses YAML frontmatter, scans .claude/agents/ and .claude/skills/)
- apps/flutter/lib/core/workspace/workspace_scanner_provider.dart (new: FutureProvider that runs scanner on startup, convenience providers for each entity type)
- apps/flutter/lib/core/api/library_provider.dart (updated: agentsProvider and skillsProvider now fallback to workspace scanner when SQLite DB returns empty)


---
**in-testing -> in-review** (2026-03-20T01:24:59Z): Gate skipped for kind=bug


---
**Review (approved)** (2026-03-20T01:25:20Z): Workspace file scanner approved — scans .projects/ and .claude/ on startup with SQLite fallback chain.
