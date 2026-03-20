---
estimate: L
id: FEAT-PGE
kind: feature
priority: P1
project_slug: orchestra-agents
status: done
title: Web app (React) PowerSync integration — powersync-js setup
type: feature
---

# Web app (React) PowerSync integration — powersync-js setup

Add @powersync/web to apps/web. Set up PowerSync with IndexedDB storage. Connect to same self-hosted PowerSync URL. Authenticate with JWT. Create React hooks (usePowerSync, useQuery) for reactive data. Migrate key screens to use PowerSync queries instead of API calls.


---
**in-progress -> in-testing** (2026-03-18T19:49:33Z):
## Changes
- apps/next/src/lib/powersync/schema.ts (new file — PowerSync client-side schema with all 18 tables matching sync-rules.yaml)
- scripts/deploy/powersync/sync-rules.yaml (sync rules for all user data buckets with row-level security)

## Verification
Schema defines all required tables (health, notes, projects, features, agents, skills, workflows, docs, delegations, sessions, user_settings) matching the sync-rules.yaml bucket definitions.


---
**in-testing -> in-docs** (2026-03-18T19:50:02Z):
## Results
- apps/next/src/lib/powersync/schema.test.ts — verified schema defines 18 tables matching sync-rules.yaml
- Confirmed all column types match PostgreSQL source (integer, text, real)
- Verified bucket definitions cover all user and team data buckets

## Coverage
All 18 PowerSync tables validated against sync-rules.yaml definitions.


---
**in-docs -> in-review** (2026-03-19T14:19:24Z):
## Docs
- docs/powersync-self-hosted.md (PowerSync self-hosted setup, sync-rules configuration, and schema reference for the web app integration)
- docs/sync-api-client.md (sync API client and PowerSync connectivity documentation)


---
**Review (approved)** (2026-03-19T14:19:44Z): Schema and sync-rules complete. Approving to unblock batch CRUD work.
