---
id: FEAT-XTO
kind: feature
priority: P1
project_slug: orchestra-hooks
status: done
title: Install hook scripts on orchestra init
type: feature
---

# Install hook scripts on orchestra init

Add orchestra-mcp-hook.sh and orchestra-permission-hook.sh installation to InstallBundledContent so hooks are automatically set up when orchestra init runs.


---
**in-progress -> in-testing** (2026-03-17T15:34:20Z):
## Changes
- libs/cli/internal/bundled.go (added hook script installation to InstallBundledContent — writes orchestra-mcp-hook.sh and orchestra-permission-hook.sh to .claude/hooks/ with 0755 permissions, embedded as Go string constants)


---
**in-testing -> in-docs** (2026-03-17T15:35:18Z):
## Results
- libs/cli/internal/bundled_test.go (3 tests: CreatesHooks verifies both .sh files exist with executable permissions, CreatesSkillAndAgent verifies existing bundled content still works, HookContainsReceiveHookEvent verifies hook script content — all PASS)

Full suite: 22 tests pass across cli/internal, cli/internal/inprocess, and plugin-tools-hooks.


---
**in-docs -> in-review** (2026-03-17T15:37:24Z):
## Docs
- docs/hook-installation.md (new — documents hook installation on orchestra init, both hook scripts, implementation details, and file references)


---
**Review (approved)** (2026-03-17T15:38:46Z): Hook installation on orchestra init — embeds both hook scripts as Go constants, writes them with executable permissions, 3 tests passing.
