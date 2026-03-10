# Team Avatar Upload

Upload and persist a team avatar image via the dashboard.

## API

### `POST /api/team/avatar`

Uploads a team avatar. Requires `owner` or `admin` role on the team.

**Request:** `multipart/form-data` with `avatar` field.

**Constraints:**
- File types: `.jpg`, `.jpeg`, `.png`, `.gif`, `.webp`
- Max size: 2MB

**Response:**
```json
{ "ok": true, "avatar_url": "/uploads/avatars/team-xxx-1709971200.png" }
```

The old avatar file is automatically deleted when a new one is uploaded.

## Model

`Team.AvatarURL` (`avatar_url` column) stores the path. Returned by `GET /api/team` and `GET /api/teams`.

## Frontend

The team page (`/team`) shows the avatar on both the Overview and Settings tabs. Clicking the camera icon opens a file picker. The image previews immediately via `FileReader`, then uploads via `POST /api/team/avatar`. On success, `fetchTeam()` refreshes the store so the persisted URL is used on subsequent page loads.

The **WorkspaceSwitcher** dropdown (sidebar header) also displays the team avatar in both the trigger button and the team list items, falling back to the initial letter when no avatar is set.

**Team members** display user avatars (`avatar_url` from User model) in both the recent members overview and the full members table, falling back to initial letters.

## Files

| File | Purpose |
|------|---------|
| `apps/web/internal/models/team.go` | AvatarURL field |
| `apps/web/internal/handlers/teams.go` | UploadTeamAvatar handler + member avatar_url in response |
| `apps/web/internal/routes/routes.go` | Route registration |
| `apps/next/src/store/roles.ts` | Team interface with avatar_url |
| `apps/next/src/app/(app)/team/page.tsx` | Upload UI + member avatar display |
| `apps/next/src/app/(app)/layout.tsx` | WorkspaceSwitcher team avatar |
| `apps/web/internal/handlers/teams_test.go` | 6 test cases |
