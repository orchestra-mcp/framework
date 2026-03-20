---
estimate: S
id: FEAT-VZH
kind: bug
priority: high
project_slug: orchestra-web
status: done
title: Install script URL consistency fix
type: feature
---

# Install script URL consistency fix

Fix install URL from /install to /install.sh in LandingClient.tsx, installation.md, and quick-start.md.


---
**in-progress -> in-testing** (2026-03-19T22:34:17Z):
## Changes
- apps/next/src/app/[locale]/LandingClient.tsx (fixed install URL from /install to /install.sh)
- docs/getting-started/installation.md (fixed install URL from /install to /install.sh in 2 locations)
- docs/getting-started/quick-start.md (fixed install URL from /install to /install.sh)


---
**in-testing -> in-review** (2026-03-19T22:34:38Z): Gate skipped for kind=bug


---
**Review (approved)** (2026-03-19T22:35:08Z): User approved. Install URL fix complete.
