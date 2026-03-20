---
id: FEAT-MSP
kind: feature
priority: P1
project_slug: orchestra-win
status: backlog
title: ConnectionIndicator + StatusBadge — shared controls
type: feature
---

# ConnectionIndicator + StatusBadge — shared controls

Implement reusable UI controls in `Orchestra.Desktop/Controls/`:

**`ConnectionIndicator.xaml`** — small status row in the NavigationView pane footer:
- Green dot (Ellipse, 8px) + "Connected" text when `ConnectionState.Connected`
- Orange dot + "Reconnecting..." with `ProgressRing` (16px) when reconnecting
- Gray dot + "Disconnected" when disconnected
- Binds to `QUICConnection.StateChanged` via `ObservableProperty`

**`StatusBadge.xaml`** — pill-shaped badge for workflow states:
- `Background` from `WorkflowStateExtensions.GetColor()`, white text
- Used in feature lists, backlog trees, and chat event cards

**`EmptyStateControl.xaml`** — centered empty state with icon glyph, title, subtitle, optional CTA button. Used in all list views when no items exist.

**`ConnectionDot.xaml`** — 8px colored `Ellipse` with optional pulse animation for live indicators (green when live)