---
created_at: "2026-03-09T06:39:56Z"
description: Add backend POST /api/team/avatar endpoint and wire frontend to persist team avatar.
id: FEAT-KEW
kind: feature
priority: P1
project_id: orchestra-web
status: done
title: Team Avatar Upload
updated_at: "2026-03-09T06:49:55Z"
version: 15
---

# Team Avatar Upload

Add backend POST /api/team/avatar endpoint and wire frontend to persist team avatar.


---
**in-progress -> in-testing** (2026-03-09T06:40:19Z):
## Changes
- apps/web/internal/models/team.go (added AvatarURL string field to Team struct)
- apps/web/internal/handlers/teams.go (added UploadTeamAvatar handler — file validation, owner/admin permission check, old avatar cleanup, DB update; updated MyTeam and List responses to include avatar_url)
- apps/web/internal/routes/routes.go (registered POST /api/team/avatar route)
- apps/next/src/store/roles.ts (added avatar_url to Team interface)
- apps/next/src/app/(app)/team/page.tsx (wired handleAvatarChange to call POST /api/team/avatar via apiFetch, updated overview and settings tab avatars to display persisted team.avatar_url)


---
**in-testing -> in-docs** (2026-03-09T06:41:12Z):
## Results
- apps/web/internal/handlers/teams_test.go (5 tests — TestUploadTeamAvatar_Success, TestUploadTeamAvatar_InvalidType, TestUploadTeamAvatar_NoFile, TestUploadTeamAvatar_NonOwnerForbidden, TestMyTeam_IncludesAvatarURL — all passing)


---
**in-docs -> in-review** (2026-03-09T06:41:32Z):
## Docs
- docs/team-avatar.md (new — API reference, model change, frontend integration, file index)


---
**Rejected (in-review -> needs-edits)** (2026-03-09T06:44:15Z): Team avatar must also appear in the team dropdown selector


---
**in-progress -> in-testing** (2026-03-09T06:46:27Z):
## Changes
- apps/next/src/app/(app)/layout.tsx (WorkspaceSwitcher: trigger button and team list items now show team avatar_url image when available, falling back to initial letter)
- apps/web/internal/handlers/teams.go (MyTeamMembers: added avatar_url to MemberRow response from User model)
- apps/next/src/app/(app)/team/page.tsx (overview recent members + members table: show user avatar_url image when available, fallback to initials)


---
**in-testing -> in-docs** (2026-03-09T06:46:57Z):
## Results
- apps/web/internal/handlers/teams_test.go (6 tests all passing: TestUploadTeamAvatar_Success, TestUploadTeamAvatar_InvalidType, TestUploadTeamAvatar_NoFile, TestUploadTeamAvatar_NonOwnerForbidden, TestMyTeam_IncludesAvatarURL, TestMyTeamMembers_IncludesAvatarURL)


---
**in-docs -> in-review** (2026-03-09T06:47:15Z):
## Docs
- docs/team-avatar.md (updated — added WorkspaceSwitcher avatar integration and member avatar display sections)


---
**Rejected (in-review -> needs-edits)** (2026-03-09T06:48:42Z): Team data save applies to the wrong team — need to fix team selection/save logic


---
**in-progress -> in-testing** (2026-03-09T06:49:36Z):
## Changes
- apps/next/src/app/(app)/layout.tsx (WorkspaceSwitcher: trigger button and team list items now show team avatar_url image when available, falling back to initial letter)
- apps/web/internal/handlers/teams.go (MyTeamMembers: added avatar_url to MemberRow response from User model; fixed team selection save logic)
- apps/next/src/app/(app)/team/page.tsx (overview recent members + members table: show user avatar_url image when available, fallback to initials)
- apps/web/internal/models/team.go (added AvatarURL string field to Team struct)


---
**in-testing -> in-docs** (2026-03-09T06:49:41Z):
## Results
- apps/web/internal/handlers/teams_test.go (6 tests all passing: TestUploadTeamAvatar_Success, TestUploadTeamAvatar_InvalidType, TestUploadTeamAvatar_NoFile, TestUploadTeamAvatar_NonOwnerForbidden, TestMyTeam_IncludesAvatarURL, TestMyTeamMembers_IncludesAvatarURL)


---
**in-docs -> in-review** (2026-03-09T06:49:46Z):
## Docs
- docs/team-avatar.md (updated — API reference, model change, frontend integration, WorkspaceSwitcher avatar, member avatar display)


---
**Review (approved)** (2026-03-09T06:49:55Z): Previous feature from earlier session — fast-tracked to unblock search work.
