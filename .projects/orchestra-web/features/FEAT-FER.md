---
id: FEAT-FER
kind: feature
priority: P2
project_slug: orchestra-web
status: backlog
title: Plugin README
type: feature
---

# Plugin README

Documentation for the web gateway plugin.

File: `libs/plugin-transport-webtransport/README.md`

Sections:
- **Overview**: HTTP/2 JSON-RPC 2.0 gateway that bridges browser clients to the Orchestra plugin backbone. Serves an embedded React dashboard at https://localhost:4433. Single binary deployment — React app is embedded via go:embed.
- **Architecture diagram**: `Browser → HTTPS POST /rpc → Gateway (transport.webtransport) → QUIC+Protobuf mTLS → Orchestrator → plugins`
- **CLI flags table**: --orchestrator-addr (default localhost:9100), --listen-addr (default :4433), --certs-dir (default ~/.orchestra/certs), --api-key (optional, enables Bearer token auth)
- **Supported MCP methods**: initialize, ping, tools/list, tools/call, prompts/list, prompts/get
- **Dashboard pages**: Projects, Features (Kanban), Tools Explorer, Prompts, Packs, Activity Log, Storage Browser
- **Development workflow**:
  - Production: run `orchestra serve` — gateway starts automatically if bin/transport-webtransport exists, visit https://localhost:4433
  - Frontend dev: `cd apps/web && pnpm dev` — Vite dev server on :5173 with HMR, proxies /rpc to the running gateway at :4433
  - Build: `make build-transport-webtransport` — builds React app, copies dist/ into Go package, compiles single binary
- **Build**: `make build-transport-webtransport` builds React, embeds it, produces bin/transport-webtransport

Acceptance: README is accurate, covers all CLI flags, both dev workflows, and the architecture diagram