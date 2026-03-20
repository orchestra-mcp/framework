---
id: FEAT-HBM
kind: feature
priority: P1
project_slug: orchestra-sync
status: done
title: Pull Updates Banner on App Start
type: feature
---

# Pull Updates Banner on App Start

Update banner shown on app launch when team has new data:
- **Startup check**: On app init, call GET /api/sync/status to check for pending updates
- **Material Banner**: Show at top of screen: "Your team has X updates available" with entity type breakdown
- **Pull action**: Download all pending updates, merge into local data, update sync metadata
- **Dismiss action**: Hide banner (but badge remains on sync icon)
- **Background refresh**: Periodically check for updates (configurable interval)
- **Entity type icons**: Show which types have updates (projects, notes, skills, etc.)

Depends on: FEAT-ZQU (Sync Service), FEAT-QVB (API Client)


---
**in-progress -> in-testing** (2026-03-17T16:05:06Z):
## Changes
- apps/flutter/lib/widgets/team_updates_banner.dart (new — TeamUpdatesBanner widget, BannerDismissedNotifier, PullInProgressNotifier, auto-refresh timer, entity type icon/color helpers, pull updates with snackbar feedback)
- apps/flutter/lib/screens/summary/summary_screen.dart (added TeamUpdatesBanner to sliver list, pull-to-refresh resets banner and re-checks for updates)


---
**in-testing -> in-docs** (2026-03-17T16:08:17Z):
## Results
- apps/flutter/test/widgets/team_updates_banner_test.dart (17 tests — all passed)
  - BannerDismissedNotifier: starts false, dismiss, reset (3 tests)
  - PullInProgressNotifier: starts false, set changes value (2 tests)
  - TeamUpdateStatus model: fields, entries, zero updates, fromJson (4 tests)
  - TeamUpdateEntry model: fields, fromJson (2 tests)
  - TeamUpdatesBanner widget: shows banner, entity type chips, hides when no updates, dismiss hides, close icon dismisses, singular text (6 tests)


---
**in-docs -> in-review** (2026-03-17T16:08:43Z):
## Docs
- docs/pull-updates-banner.md (new — architecture, components, state providers, entity type icons, behavior)


---
**Review (approved)** (2026-03-17T16:09:40Z): Pull updates banner complete with auto-refresh, entity breakdown, pull action, and dismiss support.
