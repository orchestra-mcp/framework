---
id: FEAT-VIK
kind: feature
priority: P2
project_slug: orchestra-web
status: backlog
title: Install + Release Scripts
type: feature
---

# Install + Release Scripts

Add transport-webtransport to all distribution and release automation.

Changes:
- `scripts/install.sh` — add `transport-webtransport` to the binary install loop alongside other binaries (orchestrator, transport-stdio, tools-features, etc.)
- `scripts/ship.sh` — add `plugin-transport-webtransport` to tier3 sync block alongside other tier3 plugins (plugin-engine-rag, plugin-bridge-claude, etc.)
- `scripts/sync-repos.sh` — add `plugin-transport-webtransport` as rsync target pointing to libs/plugin-transport-webtransport/

Pattern reference: follow the exact same pattern used for plugin-transport-quic-bridge in each script — same tier placement, same rsync target format, same binary install format.

Acceptance: `make install` copies transport-webtransport binary to /usr/local/bin/ alongside other binaries, ship.sh syncs the plugin dir to its separate GitHub repo in the correct tier order