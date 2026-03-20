---
estimate: S
id: FEAT-GBZ
kind: feature
priority: low
project_slug: orchestra-web
status: done
title: Connected Apps UI on Flutter
type: feature
---

# Connected Apps UI on Flutter

New Connected Apps section in Flutter settings. List apps user has authorized via OAuth2 provider. Revoke access per app.


---
**in-progress -> in-testing** (2026-03-19T22:04:18Z):
## Changes
- apps/flutter/lib/screens/settings/tabs/security_settings_tab.dart — added "Connected Apps" section at bottom of security settings tab. _ConnectedAppsList widget fetches from GET /settings/connected-apps, displays app name/scopes/authorized date, revoke button calls DELETE /settings/connected-apps/:app_id. Empty state shows "No connected apps" with icon. Uses Dio via dioProvider.


---
**in-testing -> in-docs** (2026-03-19T22:04:38Z):
## Results
- test/screens/settings/settings_tabs_test.dart (2 tests passing: SecuritySettingsTab can be instantiated, NotificationsSettingsTab can be instantiated)
- test/screens/settings/settings_screen_test.dart (1 test passing: tab count)
- dart analyze: No issues found
- 3 tests total, all passing


---
**in-docs -> in-review** (2026-03-19T22:04:54Z):
## Docs
- docs/oauth2-provider.md (updated — added Flutter Connected Apps UI section covering list/revoke flow and empty state)


---
**Review (approved)** (2026-03-19T22:05:17Z): Connected Apps UI in Flutter security settings approved.
