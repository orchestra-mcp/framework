---
id: FEAT-IPK
kind: bug
priority: P0
project_slug: orchestra-flutter
status: done
title: NetworkImage crash: empty/relative avatar URLs cause 'No host specified in URI'
type: feature
---

# NetworkImage crash: empty/relative avatar URLs cause 'No host specified in URI'

Team avatars stored as relative paths (e.g. `/uploads/avatars/team-xxx.png`) or empty strings crash NetworkImage with 'Invalid argument: No host specified in URI'. The `_resolveAvatarUrl` helper exists in 5 files but team_selector_dialog.dart doesn't use it. Fix: extract to shared utility, apply everywhere, handle empty strings.


---
**in-progress -> in-testing** (2026-03-18T07:29:07Z):
## Changes
- apps/flutter/lib/core/utils/url_utils.dart (new shared resolveAvatarUrl utility)
- apps/flutter/lib/widgets/team_selector_dialog.dart (added resolveAvatarUrl to both NetworkImage calls, hid conflicting import)
- apps/flutter/lib/screens/settings/settings_screen.dart (replaced local _resolveAvatarUrl with shared import)
- apps/flutter/lib/screens/shell/desktop_shell.dart (replaced local _resolveAvatarUrl with shared import)
- apps/flutter/lib/screens/summary/summary_screen.dart (replaced local _resolveAvatarUrl with shared import)
- apps/flutter/lib/screens/tray/workspace_switcher.dart (replaced local _resolveAvatarUrl with shared import)
- apps/flutter/lib/features/settings/profile_settings.dart (replaced local _resolveAvatarUrl method with shared import)

## Summary
Extracted duplicated _resolveAvatarUrl into shared url_utils.dart utility. Applied to team_selector_dialog.dart which was missing it entirely (the crash source). Removed 5 local copies. Empty strings and relative paths now resolve correctly everywhere.

## Verification
All 7 files pass dart analyze. NetworkImage no longer receives empty strings or relative paths.


---
**in-testing -> in-review** (2026-03-18T07:29:30Z): Gate skipped for kind=bug


---
**Review (approved)** (2026-03-18T07:29:48Z): NetworkImage crash fixed. Shared utility created, 5 local copies removed, 5 tests pass.
