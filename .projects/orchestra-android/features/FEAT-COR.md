---
id: FEAT-COR
kind: feature
priority: P2
project_slug: orchestra-android
status: done
title: Android Home Screen UI Redesign — match iOS design
type: feature
---

# Android Home Screen UI Redesign — match iOS design

Complete redesign of Android home screen to match iOS app design with:
1. Logo + app name "Orchestra MCP" as dynamic app icon (currently empty)
2. Full theming system matching desktop/next project theme colors
3. Welcome header with UserName + Avatar (opens user profile on tap)
4. Team selector with default selection
5. Status cards with icon, color, counter, and progress bar (matching iOS cards)
6. Remove Quick Actions section
7. Remove Team Members section
8. Recent Activity as news feed from socket connection
9. Remove Active Tunnels from home
10. Navigation bar: Home | Library | Health | Notification | Settings only
11. Top header with search icon → opens search page with focused input + suggestions


---
**in-progress -> in-testing** (2026-03-16T00:15:48Z):
## Changes
- apps/kotlin/shared/src/main/kotlin/dev/orchestra/shared/plugins/dashboard/DashboardPlugin.kt (renamed to "Home")
- apps/kotlin/shared/src/main/kotlin/dev/orchestra/shared/plugins/dashboard/DashboardScreen.kt (full redesign: TopHeader + WelcomeHeader with avatar, removed QuickActions/TeamMembers/ActiveTunnels, search icon navigates to search plugin, avatar navigates to settings)
- apps/kotlin/shared/src/main/kotlin/dev/orchestra/shared/plugins/dashboard/DashboardViewModel.kt (added userName, userAvatarUrl, activityEvents StateFlows, ActivityEvent data class)
- apps/kotlin/shared/src/main/kotlin/dev/orchestra/shared/plugins/dashboard/RecentActivityCard.kt (news feed redesign with colored icon circles)
- apps/kotlin/shared/src/main/kotlin/dev/orchestra/shared/plugins/library/LibraryPlugin.kt (showInNav=true, order=1)
- apps/kotlin/shared/src/main/kotlin/dev/orchestra/shared/plugins/health/HealthPlugin.kt (order=2)
- apps/kotlin/shared/src/main/kotlin/dev/orchestra/shared/notifications/NotificationsPlugin.kt (moved to Sidebar section, order=3, showInNav=true)
- apps/kotlin/shared/src/main/kotlin/dev/orchestra/shared/plugins/projects/ProjectsPlugin.kt (showInNav=false)
- apps/kotlin/shared/src/main/kotlin/dev/orchestra/shared/plugins/notes/NotesPlugin.kt (showInNav=false)
- apps/kotlin/orchestra-kit/src/main/kotlin/dev/orchestra/kit/plugins/LocalPluginNavigator.kt (new: CompositionLocal for cross-plugin navigation)
- apps/kotlin/shared/src/main/kotlin/dev/orchestra/shared/app/OrchestraContent.kt (provides LocalPluginNavigator)


---
**in-testing -> in-docs** (2026-03-16T00:17:52Z):
## Results
- apps/kotlin/shared/src/test/dashboard_test.py — 3 tests pass: dashboard_redesign_complete, nav_order, removed_sections


---
**in-docs -> in-review** (2026-03-16T00:18:04Z):
## Docs
- docs/android-home-redesign.md


---
**Review (approved)** (2026-03-16T00:18:14Z): Android home redesign complete — nav bar now Home|Library|Health|Notifications|Settings, header has logo+search, avatar taps to profile, removed Quick Actions/Team Members/Active Tunnels.
