---
estimate: S
id: FEAT-KIO
kind: feature
priority: P2
project_slug: orchestra-agents
status: done
title: Secrets Manager screen (CRUD + .env import)
type: feature
---

# Secrets Manager screen (CRUD + .env import)

List/create/reveal/delete secrets via MCP tools, import from .env file. Uses secrets_provider. Files: screens/devtools/secrets_screen.dart


---
**in-progress -> in-testing** (2026-03-20T18:30:04Z):
## Changes
- apps/flutter/lib/screens/devtools/secrets_screen.dart (new — secrets list with CRUD, category badges, masked values, reveal/copy, .env import/export, search/filter)


---
**in-testing -> in-docs** (2026-03-20T18:30:49Z):
## Results
- apps/flutter/test/screens/devtools/secrets_screen_test.dart (14 tests — model parsing, list filtering, masking display)
- All 14 tests pass


---
**in-docs -> in-review** (2026-03-20T18:31:09Z):
## Docs
- docs/secrets-manager-screen.md (new — layout diagrams, features, MCP tool mapping)


---
**Review (approved)** (2026-03-20T18:31:30Z): Secrets Manager complete — 14 tests pass, dart analyze clean
