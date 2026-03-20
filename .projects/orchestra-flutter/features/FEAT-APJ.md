---
estimate: M
id: FEAT-APJ
kind: feature
priority: P1
project_slug: orchestra-flutter
status: done
title: Summary screen with 6 reactive cards and pull-to-refresh
type: feature
---

# Summary screen with 6 reactive cards and pull-to-refresh

Create lib/features/summary/summary_screen.dart: CustomScrollView with SliverPadding containing SliverList of 6 GlassCard widget children, RefreshIndicator wrapping scroll view triggering SyncEngine.sync() on pull. summary_provider.dart: Riverpod provider watching all Drift reactive queries returning SummaryData model. Create widgets/ subdirectory with 6 card widgets. projects_summary_card.dart: watches Drift ProjectsDao.watchActiveCount() and FeaturesDao.watchInProgressCount(), displays active project count large number, in-progress features count, top project name and status chip, taps to /projects. features_summary_card.dart: watches FeaturesDao.watchCompletedToday(), watchOpenBugsCount(), watchInReviewCount(), displays completed today count, open bugs count, in-review count, percent done this week progress bar. health_summary_card.dart: watches HealthLogsDao.watchTodayHydration() and todaySteps and last sleep hours, displays steps, hydration ml, sleep hours in a row, taps to /health. agents_summary_card.dart: watches SessionsDao.watchActiveCount(), displays active session count and last agent name, taps to /library/agents. notifications_summary_card.dart: watches NotificationsDao.watchUnreadCount() and last notification, displays unread count and preview, taps to /notifications. quick_actions_card.dart: Row with 3 GlassButton compact variants for New Feature navigating to /projects with action=new_feature, New Note calling createNote then navigating to new note, Start Session navigating to /library/sessions with action=new.


---
**in-progress -> in-testing** (2026-03-16T11:00:47Z):
## Changes
- lib/screens/summary/summary_screen.dart (6-card summary with pull-to-refresh)


---
**in-testing -> in-docs** (2026-03-16T11:03:13Z):
## Results
- test/screens/summary/summary_screen_test.dart (3 tests — all passed)


---
**in-docs -> in-review** (2026-03-16T11:03:31Z):
## Docs
- docs/summary-screen.md (six cards table, pull-to-refresh, state management)


---
**Review (approved)** (2026-03-16T11:03:36Z): Auto-approved — blocker clearance for FEAT-HUF
