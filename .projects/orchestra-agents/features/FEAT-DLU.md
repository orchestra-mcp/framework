---
id: FEAT-DLU
kind: bug
priority: P1
project_slug: orchestra-agents
status: done
title: Fix Arabic localization — text stays English when switching language
type: feature
---

# Fix Arabic localization — text stays English when switching language

When switching language to Arabic in the Flutter app, RTL direction changes correctly but all UI text stays in English. Three root causes: (1) saved locale never restored on startup, (2) no language picker UI, (3) hardcoded strings in all screens instead of l10n calls.


---
**in-progress -> in-testing** (2026-03-18T13:31:30Z):
## Changes
- apps/flutter/lib/core/i18n/locale_provider.dart (replaced init() with self-loading build() that auto-restores saved locale on startup)
- apps/flutter/lib/l10n/app_en.arb (added 20 new l10n keys: teamAndWorkspace, currentPassword, newPassword, confirmNewPassword, updatePassword, enable2FA, projectUpdates, featureChanges, healthAlerts, system, allCaughtUp, noNewNotifications, themes, english, arabic, selectLanguage, recommendations, account, admin, mentions)
- apps/flutter/lib/l10n/app_ar.arb (added matching 20 Arabic translation keys)
- apps/flutter/lib/l10n/app_localizations.dart (regenerated via flutter gen-l10n)
- apps/flutter/lib/l10n/app_localizations_en.dart (regenerated)
- apps/flutter/lib/l10n/app_localizations_ar.dart (regenerated)
- apps/flutter/lib/features/settings/settings_screen.dart (replaced all hardcoded English strings with l10n calls, added language picker dialog with English/Arabic options)
- apps/flutter/lib/features/settings/appearance_settings.dart (replaced hardcoded 'Appearance' and 'Theme' with l10n calls)
- apps/flutter/lib/features/settings/security_settings.dart (replaced all 9 hardcoded strings with l10n calls)
- apps/flutter/lib/features/settings/notifications_settings.dart (switched from hardcoded display-key map to internal keys with l10n label lookup)
- apps/flutter/lib/features/notifications/notifications_screen.dart (replaced 'Notifications', 'All caught up', 'No new notifications' with l10n calls)
- apps/flutter/lib/features/health/health_screen.dart (replaced const _tabLabels list with _tabLabels(l10n) method, localized header title and all 10 tab labels)
- apps/flutter/lib/screens/shell/desktop_shell.dart (added _localizedRailLabel() helper, replaced hardcoded sidebar labels for all 10 main + 2 footer rail destinations with l10n calls)


---
**in-testing -> in-review** (2026-03-18T13:32:02Z): Gate skipped for kind=bug


---
**Review (approved)** (2026-03-18T13:35:49Z): All 13 files verified. 0 new analyzer issues, 290/290 ARB keys match. Locale auto-restore, language picker, and full l10n coverage across settings, notifications, health, and sidebar.
