# Health Detail Pages — UX Redesign

All 10 health detail tabs have been redesigned with consistent patterns for loading, error handling, empty states, and enhanced data visualization.

## Common Patterns Applied

### Loading States
- **Shimmer skeletons** (hydration, caffeine, nutrition, pomodoro, shutdown) — animated placeholder blocks that mirror the final layout shape
- **Spinner** (vitals) — centered `CircularProgressIndicator` during permission check

### Error Handling
- **Error banner** — red-tinted container with error message (max 2 lines, ellipsis) and "Retry" button calling `notifier.refresh()`
- Present on: hydration, caffeine, nutrition, pomodoro, shutdown

### Pull-to-Refresh
- `RefreshIndicator` wrapping `ListView` with `AlwaysScrollableScrollPhysics`
- Present on all 10 tabs for consistency

### Empty States
- Descriptive card with relevant icon, heading, and instructional subtitle
- Present on: hydration, caffeine, nutrition, weight, sleep

## Tab-Specific Enhancements

### Hydration (`hydration_tab.dart`)
- Gout flush recommendation card (amber warning when `totalMl < 1500`)
- Status message display from `state.statusMessage`
- Time-since-last-drink indicator with color-coded urgency
- Accessibility `Semantics` on quick-add buttons

### Caffeine (`caffeine_tab.dart`)
- Daily limit progress bar toward 400mg recommended max
- Contextual insight card (no Red Bull celebration, matcha switch suggestion, over-limit warning)
- Animated cortisol window banner with subtle breathing pulse
- Drink count badge in log header

### Nutrition (`nutrition_tab.dart`)
- Arc gauge safety score visualization (270-degree arc with fill)
- Category breakdown card with stacked color bar per `FoodCategory`
- Trigger condition warnings with per-condition icons (IBS, GERD, gout, fatty liver)

### Pomodoro (`pomodoro_tab.dart`)
- Phase-colored custom ring painter (color matches work/break/standAlert)
- Stand-up alert card — prominent full-width gradient card during standAlert phase
- Motivational insight card based on progress
- Focus time + cycle streak row
- **Float button** (desktop only) — toggles `PomodoroFloatingController` overlay

### Pomodoro Floating Widget (`pomodoro_floating_widget.dart`)
- Desktop-only draggable overlay via `OverlayEntry` + `GestureDetector.onPanUpdate`
- **Expanded mode**: 200px card with timer (36px monospace), progress bar, start/pause/skip/reset controls, session counter
- **Minimized mode**: compact pill showing time + phase indicator dot
- Toggle: minimize/expand buttons in card header, tap pill to expand
- Glass effect: `BackdropFilter` blur + semi-transparent dark background
- Phase-colored: work=red, shortBreak=green, longBreak=blue, standAlert=amber, idle=gray
- Controller: `PomodoroFloatingController.show(context)` / `.hide()` / `.toggle(context)` / `.isVisible`
- Integrates with existing `pomodoroProvider` (Riverpod) — shares state with pomodoro tab

### Shutdown (`shutdown_tab.dart`)
- "Start Shutdown" CTA button when phase is inactive
- Prominent countdown display (hours/minutes, amber when <30 min remain)
- Violated insight banner with guidance text

### Weight (`weight_tab.dart`)
- Weight change delta chip (green/orange arrow between entries)
- Weekly summary insight card (min, max, avg, trend)
- Trend chart with Y-axis labels and highlighted min/max data points

### Sleep (`sleep_tab.dart`)
- Sleep debt indicator with 3 severity levels (mild/moderate/severe)
- Consistency score based on bedtime/wake time standard deviation
- Visual arc gauge for average sleep quality

### Vitals (`vitals_tab.dart`)
- "Connect Health" CTA when no health permissions
- TODO annotations for wiring real health service data

### Daily Flow (`daily_flow_tab.dart`)
- Live scores from pomodoro/hydration/nutrition/shutdown providers (was hardcoded)
- Insight text card identifying lowest-scoring component with actionable guidance

### Health Score (`health_score_tab.dart`)
- Already had loading shimmer and error state — no changes needed

## Dependencies
- `shimmer: ^3.0.0` (already in pubspec.yaml) — used by nutrition, pomodoro, shutdown tabs
- `fl_chart` — used by vitals and daily flow tabs (existing dependency)
