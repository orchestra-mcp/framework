---
id: PLAN-BQZ
project_slug: orchestra-flutter
status: in-progress
title: Plan 3: Glass Design System & Core Screens
type: plan
---

# Plan 3: Glass Design System & Core Screens

## Overview
Build the full Liquid Glass component library and all core authenticated screens: Summary, Notifications, Search, Projects tree, and all Library sub-screens. This is the main user-facing content layer. Depends on Plans 1+2.

## Scope

### 1. Liquid Glass Component Library (`lib/design/glass/`)
All components use BackdropFilter + gradient + border for frosted glass effect. Token-driven: colors from active OrchestraTheme.

- `glass_card.dart`:
  ```dart
  BackdropFilter(filter: ImageFilter.blur(sigmaX:20, sigmaY:20),
    child: Container(decoration: BoxDecoration(
      color: theme.bg.withOpacity(theme.isLight ? 0.15 : 0.12),
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: Colors.white.withOpacity(0.2)),
      gradient: LinearGradient(colors: [Colors.white.withOpacity(0.1), Colors.transparent],
        begin: Alignment.topLeft, end: Alignment.bottomRight))))
  ```
  Props: child, padding, margin, borderRadius (override), onTap

- `glass_nav_bar.dart` — wraps `liquid_glass_nav` package. 3 items with icons + optional badge. Height 80px + SafeArea bottom. Active item: accent color tint.

- `glass_header.dart` — Frosted fixed header, 60px. Left slot + Right slot. BackdropFilter blur. Automatically shows back button when pushed route detected.

- `glass_sheet.dart` — Frosted bottom sheet modal (showModalBottomSheet wrapper). Full height variant and half-height variant. Drag handle at top. Used for: Search, Smart Action results, FCM notification banners.

- `glass_button.dart` — Gradient CTA button (accent colors, linear gradient). Full-width variant + icon variant. Loading state (CircularProgressIndicator). Disabled state (opacity 0.5).

- `glass_list_tile.dart` — Universal list item. Props:
  - leadingColor (Color), leadingIcon (IconData), label (String), description (String)
  - onTap, onLongPress (enters multi-select)
  - contextMenuActions: [{label, icon, onTap, isDestructive}]
  - Swipe right (DismissDirection.startToEnd): Pin (gold star + accent bg)
  - Swipe left (DismissDirection.endToStart): Delete (red trash, requires confirm dialog)
  - `...` button → DropdownMenu with: Rename, Select, Change Icon, Change Color, Team Scope, Member Scope, Edit, Delete
  - Multi-select mode: checkbox appears left, bulk action bar slides up at bottom

- `glass_background.dart` — Full-screen gradient mesh background. ShaderMask with theme accent colors at 8% opacity. Blurred blobs (low-opacity circles at random positions). Static (does not animate during scroll).

- `icon_color_picker.dart` — Reusable icon + color picker used in context menu "Change Icon/Color": 36-color palette + lucide icon grid search.

### 2. Summary Screen (`lib/features/summary/`)
- `summary_screen.dart` — CustomScrollView with SliverList of GlassCard widgets, pull-to-refresh triggers SyncEngine.sync()
- `summary_provider.dart` — Riverpod: watches Drift reactive queries for all card data
- Card widgets in `widgets/`:
  - `projects_summary_card.dart` — active project count, in-progress features count, top project name + status chip
  - `features_summary_card.dart` — completed today, open bugs count, in-review count, % done this week
  - `health_summary_card.dart` — today's steps / hydration ml / sleep hours from Drift health_logs; taps → /health
  - `agents_summary_card.dart` — active session count, last agent used name; taps → /library/agents
  - `notifications_summary_card.dart` — unread count, latest notification preview; taps → /notifications
  - `quick_actions_card.dart` — 3 buttons: [+ New Feature], [+ Note], [Start Session]; each triggers modal sheet

### 3. Notifications Screen (`lib/features/notifications/`)
- `notifications_screen.dart`:
  - Real-time feed via `ws_provider` StreamProvider
  - Two sections: Updates (project/feature activity) | Health (health alerts)
  - Each row: icon (colored per type) + title + body (1 line) + relative timestamp + unread dot
  - Swipe left → mark as read (updates Drift notifications_table)
  - Tap → navigate to source (deep link: feature_id → /projects/:id/features/:fid, etc.)
  - Pull-to-refresh → SyncEngine.sync() + mark visible as read
  - Empty state: glass card with bell icon + "All caught up"
- `notifications_provider.dart` — Riverpod: StreamProvider from Drift + WS events merged

### 4. Search Screen (`lib/features/search/`)
- Opens as `GlassSheet` (full-height modal) from nav bar search icon
- `search_screen.dart`:
  - Auto-focused search field at top (custom glass text input)
  - Default state: 9 category rows using `GlassListTile` style:
    1. Projects — FolderKanban icon, purple (#8B5CF6)
    2. Notes — FileText icon, orange (#F97316)
    3. Skills — Zap icon, yellow (#EAB308)
    4. Agents — Bot icon, cyan (#06B6D4)
    5. Workflows — GitBranch icon, blue (#3B82F6)
    6. Docs — BookOpen icon, pink (#EC4899)
    7. Terminal Sessions — Terminal icon, indigo (#6366F1)
    8. Delegations — Share2 icon, green (#22C55E)
    9. Health — Heart icon, red (#EF4444)
  - Each row shows count badge from Drift reactive query
  - Typing state: live results grouped by category (Drift FTS search across all tables)
  - Tap result → navigate to correct detail screen
- `search_provider.dart` — Riverpod: debounced (300ms) Drift FTS + REST /api/search?q=

### 5. Projects Screen + Detail + Tree (`lib/features/projects/`)
- `projects_screen.dart` — GlassListTile list, pull-to-refresh, FAB [+ New Project]
  - Each tile: project color/icon, name, description, active features count badge
  - Swipe left → delete (confirm), Swipe right → pin
  - Long press → multi-select → bulk delete/export

- `project_detail_screen.dart` — Project header (name + description + status chip) + tab bar:
  - Overview: stats (features by status, plans count, open requests)
  - Features: filterable list (status chips: all/todo/in-progress/in-review/done)
  - Plans: plan cards with phase indicator + progress %
  - Requests: request list with priority badges

- `project_tree_screen.dart` — Expandable tree view:
  - Root: project name
  - ├ Features (grouped by status)
  - ├ Plans (with phase bar)
  - ├ Requests (with priority icon)
  - ├ Persons (member avatars)
  - Each node tappable → opens detail or markdown editor
  - Animated expand/collapse with IndentGuide lines

### 6. Library Sub-Screens (`lib/features/library/`)
All screens follow the same pattern: GlassListTile list + FAB + pull-to-refresh + swipe actions.

- `notes_screen.dart` + note detail → `MarkdownEditor` (Plan 5)
  - Each tile shows: title, first line of content, last updated relative time
  - FAB → creates new note (blank markdown) → opens MarkdownEditor immediately

- `agents_screen.dart` — Agent tiles: name, provider badge (claude/openai/etc.), model badge
  - Detail: system prompt (markdown view), recent runs, model config
  - FAB → create agent modal (name, provider, model, system_prompt)

- `skills_screen.dart` — Skills tiles: name, description preview
  - Detail: full skill markdown content (read-only)

- `workflows_screen.dart` — Workflow tiles: name, steps count badge
  - Detail: step-by-step card list

- `docs_screen.dart` — Docs tiles: title, project badge
  - Detail → `MarkdownEditor`

- `delegations_screen.dart` — Delegation tiles: from→to, feature title, status chip
  - Status chips: pending/accepted/rejected (colored)

- `sessions_screen.dart` — Session tiles: name, provider, status (active/inactive)
  - Tap → opens terminal session (Plan 5)

## Multi-Select Bulk Actions
When GlassListTile enters multi-select mode (long press):
- Checkboxes appear on all tiles
- Bottom bulk action bar slides up: Delete (red), Pin/Unpin (gold), Export (blue)
- "X selected" count shown in header
- Tap outside bulk bar or press back → exits multi-select

## Verification Criteria
1. All glass components render on iOS, Android, macOS, Windows, Linux without errors
2. BackdropFilter blur effect visible on all platforms (degrades gracefully on Linux if Impeller not available)
3. Summary cards populate from Drift reactive queries (live update on sync)
4. Notifications real-time update via WS without screen refresh
5. Search returns results within 300ms debounce for Drift FTS
6. Project tree expands/collapses all nodes smoothly
7. GlassListTile swipe actions work: swipe right pin ✓, swipe left delete with confirm ✓
8. Long press → multi-select → bulk delete removes from Drift + triggers sync queue
9. All 9 search categories show correct Drift counts
10. FCM notification deep-link navigates to correct detail screen
