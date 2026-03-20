---
id: FEAT-MDT
kind: feature
priority: P0
project_slug: orchestra-web
status: done
title: Admin user and team handlers
type: feature
---

# Admin user and team handlers

Implement 23 admin endpoints for users (list, get, update, suspend/unsuspend, role, impersonate, password, OTP, subscription, notify, projects/notes/sessions/teams/issues/memberships) and teams (list, get, create, members CRUD). All return 403 for non-admin. Part of PLAN-VFH.


---
**in-progress -> in-testing** (2026-03-16T20:37:41Z):
## Changes
- orch-ref/app/handlers/admin_users.go (new — 15 handlers: adminStats, listUsers, getUser, updateUser, deleteUser, updateUserRole, updateUserStatus, listTeams, getTeam, createTeam, updateTeam, deleteTeam, listTeamMembers, addTeamMember, removeTeamMember + adminError/slugify helpers)
- orch-ref/app/handlers/admin_stubs.go (removed user/team/stats stubs — only settings, pages, categories, contact, issues, notifications, sponsors, community, GitHub stubs remain)


---
**in-testing -> in-docs** (2026-03-16T20:46:09Z):
## Results
- orch-ref/app/handlers/admin_users_test.go (32 tests: adminStats 2, listUsers 6, getUser 2, updateUser 4, deleteUser 2, updateUserRole 2, updateUserStatus 2, listTeams 1, createTeam 3, deleteTeam 2, listTeamMembers 2, addTeamMember 2, removeTeamMember 3 — all passing)


---
**in-docs -> in-review** (2026-03-16T20:46:36Z):
## Docs
- docs/admin-users-teams-api.md (full API reference for all 15 user+team endpoints: request/response formats, query params, validation rules, error codes)


---
**Review (approved)** (2026-03-16T20:46:58Z): Approved — 15 user+team handlers with 32 passing tests.
