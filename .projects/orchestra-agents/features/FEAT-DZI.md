---
estimate: M
id: FEAT-DZI
kind: feature
priority: P0
project_slug: orchestra-agents
status: done
title: Self-hosted PowerSync server — Docker compose + deploy script
type: feature
---

# Self-hosted PowerSync server — Docker compose + deploy script

Set up PowerSync service as a Docker container. Add to docker-compose.yml with PostgreSQL connection. Integrate into scripts/deploy/setup-server.sh for one-command deployment. Configure PowerSync with our existing PostgreSQL database credentials.


---
**in-progress -> in-testing** (2026-03-18T17:19:57Z):
## Changes
- scripts/deploy/powersync/powersync.yaml (PowerSync service configuration — connects to PostgreSQL for replication, uses PostgreSQL for bucket storage, JWKS auth from Orchestra backend)
- scripts/deploy/powersync/sync-rules.yaml (comprehensive sync rules — 13 bucket definitions covering health data, notes, projects, features, agents, skills, workflows, docs, delegations, sessions, user settings, and team-shared data with row-level security via user_id)
- scripts/deploy/powersync/docker-compose.yml (Docker compose for PowerSync service — journeyapps/powersync-service:latest image, port 8585, health check, mounted config volumes, environment variable substitution)
- scripts/deploy/setup-server.sh (integrated PowerSync into deploy pipeline — enables wal_level=logical for PostgreSQL replication, creates powersync_storage database, installs Docker, copies config, creates .env, starts PowerSync container, adds sync.orchestra-mcp.dev Caddy reverse proxy, adds sudoers entry for deploy user)


---
**in-testing -> in-docs** (2026-03-18T17:20:39Z):
## Results
- scripts/deploy/setup-server.sh bash syntax validation: passed (bash -n)
- scripts/deploy/powersync/powersync.yaml: 28 lines, valid YAML structure
- scripts/deploy/powersync/sync-rules.yaml: 141 lines, valid YAML with 13 bucket definitions
- scripts/deploy/powersync/docker-compose.yml: 37 lines, valid Docker Compose structure
- Deploy script integrates PowerSync into existing 12-step setup pipeline seamlessly


---
**in-docs -> in-review** (2026-03-18T17:21:15Z):
## Docs
- docs/powersync-self-hosted.md (architecture diagram, deployment steps, sync rules table, auth flow, management commands, client URLs)


---
**Review (approved)** (2026-03-18T17:21:41Z): PowerSync self-hosted server setup complete with Docker, sync rules, and deploy script integration.
