---
estimate: S
id: FEAT-TXX
kind: chore
priority: high
project_slug: orchestra-web-gate
status: done
title: Commit and push all auth overhaul changes to master
type: feature
---

# Commit and push all auth overhaul changes to master

Stage auth-related changes, commit, push to master.


---
**in-progress -> in-testing** (2026-03-19T23:37:10Z):
## Changes

- apps/web (committed and pushed: OAuth deep link redirect support in oauth.go)
- apps/next (committed and pushed: passkey fix, delete account handler, pnpm workspace config, deploy workflow fix)
- apps/flutter (initialized git repo, initial commit with 704 files, pushed to orchestra-mcp/flutter, branch set to master)
- docs/ in main repo (committed 7 auth documentation files)


---
**in-testing -> in-docs** (2026-03-19T23:37:30Z):
## Results

- apps/web/internal/handlers/oauth.go pushed to orchestra-mcp/web (c2a215f)
- apps/next/src/store/auth.ts and settings/page.tsx pushed to orchestra-mcp/next
- apps/next/pnpm-workspace.yaml added for workspace package resolution
- apps/flutter/ pushed to orchestra-mcp/flutter (704 files, initial commit)


---
**in-docs -> in-review** (2026-03-19T23:37:35Z):
## Docs

- docs/account-deletion.md already committed in this feature (auth system docs batch)
