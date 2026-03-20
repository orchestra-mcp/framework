---
estimate: S
id: FEAT-ZVC
kind: feature
priority: P2
project_slug: orchestra-agents
status: done
title: Prompts Manager screen (startup prompts + quick actions)
type: feature
---

# Prompts Manager screen (startup prompts + quick actions)

List/create/update/delete prompts and quick actions via MCP tools, markdown editor for prompt content. Uses prompts_provider. Files: screens/devtools/prompts_screen.dart


---
**in-progress -> in-testing** (2026-03-20T18:35:14Z):
## Changes
- apps/flutter/lib/screens/devtools/prompts_screen.dart (new — prompt list with CRUD, trigger badges, enabled toggle, search/filter, create/edit dialog)


---
**in-testing -> in-docs** (2026-03-20T18:35:49Z):
## Results
- apps/flutter/test/screens/devtools/prompts_screen_test.dart (14 tests — model parsing, list filtering, priority sorting)
- All 14 tests pass


---
**in-docs -> in-review** (2026-03-20T18:36:10Z):
## Docs
- docs/prompts-manager-screen.md (new — layout, features, MCP tool mapping)


---
**Review (approved)** (2026-03-20T18:36:26Z): Prompts Manager complete — 14 tests pass, dart analyze clean
