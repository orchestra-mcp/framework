# Health Sidebar — Desktop Navigation

The Health section is accessible from the desktop icon rail via the heart icon (10th position).

## Sidebar Sections

The health sidebar organizes 11 items into 3 groups:

### Overview
| Item | Icon | Route |
|------|------|-------|
| Overview | dashboard | `/health` |
| Health Score | favorite | `/health/score` |
| Vitals | monitor_heart | `/health/vitals` |
| Daily Flow | auto_graph | `/health/flow` |

### Tracking
| Item | Icon | Route |
|------|------|-------|
| Hydration | water_drop | `/health/hydration` |
| Caffeine | coffee | `/health/caffeine` |
| Nutrition | restaurant | `/health/nutrition` |
| Weight | monitor_weight | `/health/weight` |

### Wellness
| Item | Icon | Route |
|------|------|-------|
| Pomodoro | timer | `/health/pomodoro` |
| Shutdown | nightlight | `/health/shutdown` |
| Sleep | bedtime | `/health/sleep` |

## Active State

Each sidebar item highlights when the current route matches its target path using `GoRouterState.matchedLocation`.

## Implementation

- **File**: `apps/flutter/lib/screens/shell/desktop_shell.dart`
- **Class**: `_HealthSidebar`
- **Rail entry**: Added to `_railDestinations` array
