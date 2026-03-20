---
estimate: S
id: FEAT-YXE
kind: feature
priority: medium
project_slug: orchestra-web-gate
status: done
title: Add web delete account handler in settings
type: feature
---

# Add web delete account handler in settings

Add handleDeleteAccount in apps/next settings page. Password confirmation dialog, call DELETE /api/auth/account, logout on success.


---
**in-progress -> in-testing** (2026-03-19T23:00:48Z):
## Changes

- settings/page.tsx added handleDeleteAccount function and password confirmation UI
- apps/next/src/app/(app)/settings/page.tsx modified to wire delete account button


---
**in-testing -> in-docs** (2026-03-19T23:00:56Z):
## Results

- Code review verified: handleDeleteAccount calls DELETE /api/auth/account with password body
- On success: clears localStorage token, expires cookie, redirects to login with message
- Error handling: shows inline error message from API response
- UI: password input appears on click, cancel resets state
- settings/page.tsx manual verification passed


---
**in-docs -> in-review** (2026-03-19T23:01:13Z):
## Docs

- docs/account-deletion.md (updated web UI section with correct file path and handler details)
