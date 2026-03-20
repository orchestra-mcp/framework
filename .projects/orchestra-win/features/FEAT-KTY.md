---
id: FEAT-KTY
kind: feature
priority: P2
project_slug: orchestra-win
status: backlog
title: Windows 11 Widgets — Adaptive Cards (project status + sprint)
type: feature
---

# Windows 11 Widgets — Adaptive Cards (project status + sprint)

Implement `Orchestra.Widgets/` project — Windows 11 widget provider using the Widgets Board API and Adaptive Cards.

**`Orchestra.Widgets.csproj`:** separate MSIX component, references `Microsoft.Windows.Widgets.Providers` from Windows App SDK.

**Widgets (2 initial):**

**`ProjectWidget.cs`** — shows active project status:
```
┌────────────────────────────┐
│ 🟣 orchestra-win            │
│ ████████░░ 73% complete     │
│ 12 in-progress · 4 blocked  │
│ [Open] [New Feature]        │
└────────────────────────────┘
```
Adaptive Card JSON with `ProgressBar`, `FactSet` (status breakdown), action buttons

**`SprintWidget.cs`** — current sprint burndown:
```
┌────────────────────────────┐
│ Sprint 3 · 8 days left      │
│ ▓▓▓▓▓░░░░░ 52% done         │
│ 18/35 tasks complete        │
│ [View Sprint] [Standup]     │
└────────────────────────────┘
```

**`WidgetProvider` lifecycle:** `CreateWidget`, `DeleteWidget`, `OnWidgetContextChanged`, `OnActionInvoked` → dispatches to `ToolService` via named pipe IPC to main app

**Refresh:** `PeriodicTimer` every 5 minutes calls `WidgetManager.GetDefault().UpdateWidget(...)`

**Registration:** `Package.appxmanifest` `windows.widget` extension entry

**Platform:** Windows 11 22H2+ (Widgets Board). Gracefully absent on Windows 10.