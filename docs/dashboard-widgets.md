# Dynamic Widget Dashboard

## Overview

The dashboard uses a customizable widget system built on a 12-column CSS Grid. Users can show/hide, reorder (drag-and-drop), resize (1-12 columns), and lock widgets. Layout is persisted per-user via the preferences API.

## Types

- **WidgetType** — `'stats' | 'recent_projects' | 'recent_notes' | 'quick_actions' | ... | 'api_collections' | 'presentations' | 'docs'`
- **WidgetLayout** — `{ id, type, colSpan, order, hidden, locked }`
- **WidgetDefinition** — `{ type, label, icon, defaultColSpan, minColSpan, maxColSpan }`

Defined in `apps/next/src/types/dashboard.ts`.

## Store

`useDashboardStore` (Zustand + persist) at `apps/next/src/store/dashboard.ts`:

- **fetchLayout()** — loads from `GET /api/settings/preferences` (`dashboard_layout` key)
- **saveLayout()** — debounced 500ms `PATCH /api/settings/preferences`
- **reorderWidget(from, to)** — drag-and-drop reorder
- **resizeWidget(id, colSpan)** — resize widget columns
- **toggleWidget(id)** — show/hide
- **lockWidget(id)** — lock/unlock
- **resetLayout()** — restore defaults

## Persistence

Layout is stored in the user's `Settings` JSONB column under `preferences.dashboard_layout`. No backend changes were needed — the existing preferences merge handler accepts arbitrary keys.

## WidgetShell

`WidgetShell` at `apps/next/src/components/dashboard/WidgetShell.tsx` wraps every widget with:

- **Header bar** — icon + label from `WidgetDefinition`, drag handle in edit mode
- **Resize dropdown** — grid of allowed colSpan values (filtered by min/max from definition)
- **Lock toggle** — prevents drag when locked, shows lock badge
- **Hide toggle** — hides widget in normal mode, shows at 30% opacity in edit mode
- **Loading state** — animated shimmer skeleton

Props: `{ widget, definition, editMode, onResize, onToggle, onLock, loading, children }`

## Widget Components

All widgets at `apps/next/src/components/dashboard/widgets/`. Mapped via `WIDGET_COMPONENTS` record in `index.ts`.

| Widget | Props | Description |
|--------|-------|-------------|
| `StatsWidget` | `projectCount, noteCount, toolCount, connStatus` | 4 stat cards in responsive auto-fit grid |
| `RecentProjectsWidget` | `projects: Project[]` | Project list (max 5) with links, empty state |
| `RecentNotesWidget` | `notes: Note[]` | Note list with dates, empty state |
| `QuickActionsWidget` | *(none)* | Action buttons: New Project, New Note, Settings |
| `ApiCollectionsWidget` | `collections: ApiCollectionItem[]` | Recent API collections with endpoint count, auth type dot |
| `PresentationsWidget` | `presentations: PresentationItem[]` | Recent presentations with slide count, visibility icon |
| `DocsWidget` | `docs: DocItem[]` | Recent docs with word count, published status dot |

## DashboardGrid

`DashboardGrid` at `apps/next/src/components/dashboard/DashboardGrid.tsx`:

- Uses `DragProvider` from `@orchestra-mcp/ui` with `direction='grid'`
- CSS Grid override: `grid-template-columns: repeat(12, 1fr)` with `gap: 14px`
- Each widget rendered via `DragItem` with `gridColumn: span N` from `widget.colSpan`
- Hidden widgets filtered in normal mode, visible in edit mode
- Locked widgets have drag disabled

## DashboardToolbar

`DashboardToolbar` at `apps/next/src/components/dashboard/DashboardToolbar.tsx`:

- **Customize / Done** toggle button (accent color when active)
- **Widgets** dropdown — checkboxes to show/hide individual widgets
- **Reset** button — restores default layout

## Default Layout

| Widget | ColSpan | Position |
|--------|---------|----------|
| Stats Overview | 12 | 0 |
| Recent Projects | 6 | 1 |
| Recent Notes | 6 | 2 |
| Quick Actions | 12 | 3 |
| API Collections | 6 | 12 |
| Presentations | 6 | 13 |
| Docs | 6 | 14 |

## Go API — Dashboard Data

`GET /api/dashboard` returns:
- `collections` — 5 most recent API collections with endpoint counts (team-scoped)
- `presentations` — 5 most recent presentations with slide counts (team-scoped)
- `docs` — 5 most recent docs with word counts from `strings.Fields(body)` (team-scoped)
- `stats.collection_count`, `stats.presentation_count`, `stats.doc_count`

LAYOUT_VERSION bumped from 3 to 4.
