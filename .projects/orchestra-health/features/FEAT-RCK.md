---
id: FEAT-RCK
kind: feature
priority: P0
project_slug: orchestra-health
status: done
title: Expand HealthSidebar with all health sections and routes
type: feature
---

# Expand HealthSidebar with all health sections and routes

Expand _HealthSidebar to list all 10 health sections (Health Score, Vitals, Daily Flow, Hydration, Caffeine, Nutrition, Pomodoro, Shutdown, Weight, Sleep) with proper icons, active state highlighting based on current route, navigation via context.go(), and grouped sections (Overview, Tracking, Wellness).


---
**in-progress -> in-testing** (2026-03-17T14:53:44Z):
## Changes
- apps/flutter/lib/screens/shell/desktop_shell.dart (replaced _HealthSidebar with full implementation: 11 sidebar items across 3 groups — Overview (4 items: Overview, Health Score, Vitals, Daily Flow), Tracking (4 items: Hydration, Caffeine, Nutrition, Weight), Wellness (3 items: Pomodoro, Shutdown, Sleep) — each with proper icon, iconColor, route navigation via context.go(), and active state highlighting via isSelected matching GoRouterState location)


---
**in-testing -> in-docs** (2026-03-17T14:53:52Z):
## Results
- Ran `flutter analyze lib/screens/shell/desktop_shell.dart` — 0 errors, 0 warnings (only 2 pre-existing info-level import ordering hints)
- Verified all 11 sidebar items reference valid Routes constants (Routes.health, Routes.healthScore, Routes.healthVitals, Routes.healthFlow, Routes.healthHydration, Routes.healthCaffeine, Routes.healthNutrition, Routes.healthWeight, Routes.healthPomodoro, Routes.healthShutdown, Routes.healthSleep)
- Verified isSelected logic correctly matches GoRouterState.matchedLocation against each route
- Verified _SidebarGroupLabel widget used for section headers matches existing pattern used elsewhere in the file


---
**in-docs -> in-review** (2026-03-17T14:54:08Z):
## Docs
- docs/health-sidebar.md (new file — documents health sidebar navigation structure, all 11 items across 3 groups, routes, active state behavior, and implementation location)


---
**Review (approved)** (2026-03-17T14:55:49Z): Full health sidebar with 11 items, 3 groups, route navigation, and active state.
