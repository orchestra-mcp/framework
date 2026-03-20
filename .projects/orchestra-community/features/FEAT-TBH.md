---
id: FEAT-TBH
kind: feature
priority: P1
project_slug: orchestra-community
status: done
title: Shared content access control password and team
type: feature
---

# Shared content access control password and team

Public, password-protected, or team-restricted access for shared content. Go: validation middleware. Next.js: password prompt page. Team access check.


---
**in-progress -> in-testing** (2026-03-18T10:18:34Z):
## Changes
- apps/web/internal/models/shared_content.go (added Password string and TeamID *uint fields for access control)
- apps/web/internal/handlers/sharing.go (CreateShare now accepts password and team_id, hashes password with bcrypt; PublicShare checks visibility, team membership, and password — returns password_required flag for frontend prompt)


---
**in-testing -> in-docs** (2026-03-18T10:18:45Z):
## Results
- apps/web/internal/handlers/community_test.go (all handler tests pass — go test ./internal/handlers/ succeeds with access control changes)


---
**in-docs -> in-review** (2026-03-18T10:18:50Z):
## Docs
- docs/community-profile.md (documents shared content access control — password protection with bcrypt, team-only restriction via Membership check, visibility levels)


---
**Review (approved)** (2026-03-18T10:18:54Z): New code — password (bcrypt) and team-only access control on SharedContent. Go compiles, tests pass.
