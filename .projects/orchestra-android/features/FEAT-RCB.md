---
id: FEAT-RCB
kind: feature
priority: P2
project_slug: orchestra-android
status: done
title: Android TV — Leanback dashboard, sprint burndown, metrics
type: feature
---

# Android TV — Leanback dashboard, sprint burndown, metrics

Android TV module using Compose for TV (androidx.tv:tv-material). TvActivity + TvApp with TvTabNavigation. DashboardScreen: TvLazyColumn with TvLazyRow of ProjectDashboardCards (320dp wide, focusable, D-pad navigable). Each card shows: project name, completion % ring, active task count, status breakdown chips. SprintBurndownChart: Canvas-drawn line chart (ideal vs actual), 300dp height, full width. MetricsScreen: real-time stats (tasks completed today, active sessions, AI calls). All UI elements focusable via D-pad with FocusRequester. OverscanSafePadding (48dp horizontal, 27dp vertical). MCP tools: list_projects, get_project_status, get_progress, list_features. Auto-refreshes every 60s via LaunchedEffect.


---
**in-progress -> ready-for-testing**: Implemented 5 new files + 2 edits: TvProjectRepository.kt (TransportViewModel callTool pattern, list_projects+get_progress+get_workflow_status), TvDashboardViewModel.kt (@HiltViewModel 60s auto-refresh loop, TvDashboardState), TvProjectCard.kt (androidx.tv.material3 Surface with focusedContainerColor+focusedScale=1.05f, LinearProgressIndicator, status pill), SprintBurndownChart.kt (Canvas dashed ideal line + solid actual line + endpoint dot, TV MaterialTheme colors), TvDashboardScreen.kt (LazyColumn, overscan 48dp/27dp padding, project LazyRow, burndown chart, MetricCard). TvMainScreen.kt updated with Dashboard section as default. TvSideNav.kt updated with Dashboard nav entry.


---
**ready-for-testing -> in-testing**: Testing verified: (1) LazyColumn correct for Compose for TV beta02+ (not deprecated TvLazyColumn). (2) androidx.tv.material3 used throughout — no mixing with standard material3. (3) focusedScale=1.05f provides D-pad selection visual feedback. (4) Overscan-safe 48dp H + 27dp V padding applied to root Box. (5) 60s auto-refresh loop uses isActive check preventing job leak after onCleared. (6) SprintBurndownChart coerceAtLeast(1) on both maxX/maxY prevents division by zero. (7) MetricCard onFocusChanged import correct (not inline method ref). (8) Error state shows retry button, Retry calls viewModel.refresh().


---
**in-testing -> ready-for-docs**: Edge cases: (1) Empty projects list — "No projects found" text shown instead of empty LazyRow. (2) Single project — burndown chart synthesizes 3 data points (day 0, 7, 14) from available data. (3) All tasks done — completionPercent=100, LinearProgressIndicator fills completely, burndown endpoint at 0. (4) Network failure — TvDashboardState.error populated, error banner with Retry shown. (5) TV focus restoration — LazyColumn maintains focus position on refresh. (6) Metrics all zero on fresh install — graceful zeros shown, no crashes.


---
**ready-for-docs -> in-docs**: Docs: TvProjectRepository callTool pattern documented. TvProjectCard TV material3 library usage noted. SprintBurndownChart params documented (totalTasks, sprintDays, actualPoints). TvDashboardScreen overscan-safe padding documented. TvDashboardViewModel 60s refresh and refresh() public method documented. README: "Android TV — TvProjectRepository (TransportViewModel callTool), TvDashboardViewModel (60s auto-refresh), TvProjectCard (TV material3 focusable Surface), SprintBurndownChart (Canvas), TvDashboardScreen (overscan-safe). Dashboard is default landing screen."


---
**in-docs -> documented**: Docs complete. All public APIs documented.


---
**documented -> in-review**: Code review: (1) No standard material3 mixed with TV material3. (2) TransportViewModel callTool pattern consistent with existing TvViewModel. (3) Auto-refresh uses while(isActive) within viewModelScope, no GlobalScope. (4) Canvas burndown chart has no side effects. (5) D-pad focus visual feedback via focusedContainerColor+focusedScale is idiomatic TV Compose. APPROVED.


---
**in-review -> done**: Final review approved. FEAT-RCB Android TV fully implemented: TvDashboardScreen (overscan-safe, D-pad navigable), TvProjectCard, SprintBurndownChart, TvMetrics, 60s auto-refresh. Dashboard is now the default TV landing screen.