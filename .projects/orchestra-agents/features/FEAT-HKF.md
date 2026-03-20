---
estimate: M
id: FEAT-HKF
kind: feature
priority: P2
project_slug: orchestra-agents
status: done
title: MCPB Bundle Packaging
type: feature
---

# MCPB Bundle Packaging

Create MCPB v0.3 manifest.json and build tooling to produce .mcpb bundles for one-click install in Claude Desktop chat app. Binary server type (Go compiled). Cross-platform: darwin amd64/arm64, linux amd64/arm64, win32 amd64. Add make mcpb target. Include tools_generated:true since 290 dynamic tools.

New files: scripts/mcpb/manifest.json, scripts/mcpb/build-mcpb.sh, scripts/mcpb/icon.png. Modified: Makefile


---
**in-progress -> in-testing** (2026-03-20T18:36:45Z):
## Changes
- scripts/mcpb/manifest.json (new — MCPB v0.3 manifest with 5 platform entry points, user_config.workspace, tools_generated/prompts_generated)
- scripts/mcpb/build-mcpb.sh (new — cross-compile 5 targets, stage manifest+icon+binaries, zip into .mcpb)
- scripts/mcpb/icon.png (new — placeholder icon)
- Makefile (added mcpb target and .PHONY entry)


---
**in-testing -> in-docs** (2026-03-20T18:37:29Z):
## Results
- scripts/mcpb/test-mcpb.sh (26 validation tests: manifest JSON validity, required fields, manifest_version 0.3, server.type binary, 5 platform entry points, tools_generated, user_config.workspace required, build script executable, strict mode, 5 cross-compile targets, output file, icon, Makefile target)
- All 26 tests pass: `bash scripts/mcpb/test-mcpb.sh` → Results: 26 passed, 0 failed


---
**in-docs -> in-review** (2026-03-20T18:37:48Z):
## Docs
- docs/mcpb-bundle-packaging.md (new — covers build process, contents, manifest fields, platform targets, installation flow)


---
**Review (approved)** (2026-03-20T18:38:03Z): MCPB bundle packaging approved. 26 validation tests pass, docs complete.
