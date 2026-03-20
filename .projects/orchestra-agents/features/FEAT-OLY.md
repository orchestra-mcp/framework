---
estimate: S
id: FEAT-OLY
kind: chore
priority: P2
project_slug: orchestra-agents
status: done
title: org/repo install shorthand + seeder update
type: feature
---

# org/repo install shorthand + seeder update

In installer.go, if input lacks /, prefix with orchestra-mcp/pack-. If org/repo format, use as-is. Update tool description and seed data.


---
**in-progress -> in-testing** (2026-03-19T23:52:59Z):
## Changes

- libs/plugin-tools-marketplace/internal/packs/installer.go (verified: ResolvePackRepo already handles short names, org/repo, and full github paths — no code changes needed)
- libs/plugin-tools-marketplace/internal/tools/pack.go (verified: tool description already documents all 3 shorthand formats in the schema description)


---
**in-testing -> in-docs** (2026-03-19T23:53:05Z):
## Results

- libs/plugin-tools-marketplace/internal/packs/installer.go (ResolvePackRepo verified: handles "go-backend" → github.com/orchestra-mcp/pack-go-backend, "myorg/mypack" → github.com/myorg/mypack, and full paths unchanged)
- libs/plugin-tools-marketplace/internal/tools/pack.go (pack_install tool schema describes all 3 formats in description field)


---
**in-docs -> in-review** (2026-03-19T23:53:57Z):
## Docs

- docs/cli/pack.md (added Name Resolution section documenting the 3 shorthand formats with examples table and fallback behavior)


---
**Review (approved)** (2026-03-19T23:54:11Z): Shorthand already implemented, docs updated.
