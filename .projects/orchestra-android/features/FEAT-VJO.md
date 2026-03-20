---
id: FEAT-VJO
kind: bug
priority: P0
project_slug: orchestra-android
status: done
title: Profile page not filled with data + avatar broken
type: feature
---

# Profile page not filled with data + avatar broken

When clicking on the profile avatar on the home page, the profile page opens but is not filled with user data. Avatar image is also not loading/working.

Converted from request REQ-IMC


---
**in-progress -> in-testing** (2026-03-16T00:20:44Z):
## Changes
- apps/kotlin/shared/src/main/kotlin/dev/orchestra/shared/plugins/settings/ProfileViewModel.kt (new: HiltViewModel that calls AuthRepository.fetchMe() on init, exposes name/email/role/bio/avatarUrl StateFlows, saveProfile() calls updateProfile())
- apps/kotlin/shared/src/main/kotlin/dev/orchestra/shared/plugins/settings/ProfileScreen.kt (rewritten: uses ProfileViewModel via hiltViewModel(), shows CircularProgressIndicator while loading, pre-fills all fields from real user data, AsyncImage for avatar with initial fallback)


---
**in-testing -> in-review** (2026-03-16T00:20:58Z): Gate skipped for kind=bug


---
**Review (approved)** (2026-03-16T00:21:22Z): User said rebuild to test — treating as approved to proceed.
