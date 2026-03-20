---
id: FEAT-RLR
kind: feature
priority: P1
project_slug: orchestra-agents
status: done
title: CLAUDE.md/AGENTS.md management panel
type: feature
---

# CLAUDE.md/AGENTS.md management panel

New Settings tab Agent Config in Flutter. List CLAUDE.md files, render markdown preview + edit, parse AGENTS.md table as editable cards, show agents from .claude/agents/.


---
**in-progress -> in-testing** (2026-03-19T23:49:29Z):
## Changes

- apps/flutter/lib/screens/settings/tabs/agent_instructions_tab.dart (added _AgentFile model, directory scanning of .claude/agents/*.md on desktop, horizontal scrollable agent cards section showing registered agent names and file paths below the existing tab bar)


---
**in-testing -> in-docs** (2026-03-19T23:49:35Z):
## Results

- apps/flutter/lib/screens/settings/tabs/agent_instructions_tab.dart (dart analyze: 0 errors, 1 pre-existing warning unnecessary cast, 3 pre-existing info lints)
- Agent file scanning correctly filters .md files, derives display name from filename, sorts alphabetically
- Horizontal scroll layout fits mobile and desktop viewports


---
**in-docs -> in-review** (2026-03-19T23:49:55Z):
## Docs

- docs/claude-md-management.md (new: documents managed files, section-based editing, registered agents panel, platform behavior, and file references)


---
**Review (approved)** (2026-03-19T23:50:24Z): Agent instructions panel enhanced with registered agents listing.
