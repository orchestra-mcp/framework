---
id: FEAT-MVT
kind: feature
priority: P1
project_slug: orchestra-community
status: done
title: Inline name username bio editing
type: feature
---

# Inline name username bio editing

Click name opens edit modal for display name, username, and bio. Go: PUT /api/users/profile. Username uniqueness validation.


---
**in-progress -> in-testing** (2026-03-17T16:42:04Z):
## Changes
- orch-ref/app/models/sync.go (added Bio field to User model)
- orch-ref/app/handlers/auth_handler.go (added bio to userResource)
- orch-ref/app/handlers/community_handler.go (added slugifyUsername helper, updateProfile handler with name/username/bio update, username uniqueness validation)
- orch-ref/app/handlers/community_routes.go (added PUT /api/users/profile route)
- apps/next/src/store/auth.ts (added bio to User interface)
- apps/next/src/components/profile/profile-edit-form.tsx (new: edit form with cover/avatar modals, name/username/bio fields, slug validation, character counts, save to API)
- apps/next/src/app/[locale]/(marketing)/member/[handle]/edit/page.tsx (replaced stub with functional edit page rendering ProfileEditForm)


---
**in-testing -> in-docs** (2026-03-17T16:58:33Z):
## Results
- apps/next/src/components/profile/__tests__/profile-edit-form.test.ts (21 assertions: form exports, name/username/bio fields, avatar/cover modal imports, API endpoint, slug validation, char count, auth store, edit page integration, Go handler, slugifyUsername, uniqueness check, model/resource/route/store — all PASS)
- orch-ref Go tests pass (existing handler tests still green)


---
**in-docs -> in-review** (2026-03-17T16:59:11Z):
## Docs
- docs/community-profile.md (added Profile Editing section with PUT endpoint docs, request body, validation rules, frontend component reference, and added PUT /api/users/profile to API table)


---
**Review (approved)** (2026-03-17T18:06:50Z): User approved. Inline profile editing with slug validation complete.
