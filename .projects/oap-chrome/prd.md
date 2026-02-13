# PRD 4: Chrome Sidebar & UI Architecture

**Parent:** orchestra-app (Master PRD)
**Depends on:** PRD 2 (oap-services)

---

## Goal

Restructure the Chrome extension's sidebar from hardcoded views into a dynamic, extensible shell that extensions register into. Extract the sidebar framework as a core service (`src/app/Chrome/`) and move all view-specific code into their respective extension packages (`src/packages/*/resources/chrome/`).

---

## Current State

`packages/chrome-extension/src/sidepanel/App.tsx` hardcodes all sidebar views:
- 28 Zustand stores directly imported
- All sidebar icons, panels, and views wired inline
- No way for extensions to add new sidebar entries or tabs

---

## Scope

### 1. Dynamic Sidebar Shell (`src/app/Chrome/`)

Extract the sidebar framework into 6 registerable component areas:

#### 1.1 Sidebar Icon Rail (`src/app/Chrome/Sidebar/`)

**What it is:** The vertical icon bar on the left side

**Registration API:**
```typescript
interface SidebarEntry {
  id: string;
  icon: string;           // Icon component or name
  label: string;          // Tooltip text
  order: number;          // Position in rail
  badge?: number | string; // Badge count/text
}
```

- Extensions register entries via `IChromeSidebarService.registerSidebarEntry()`
- Clicking an entry shows its registered content panel
- Active entry highlighted
- Badge support (e.g., unread count, git changes count)

#### 1.2 Sidebar Content (`src/app/Chrome/Sidebar/`)

**What it is:** The main content area when a sidebar icon is selected

**Registration API:**
```typescript
interface ContentRegistration {
  sidebarId: string;        // Which sidebar entry this belongs to
  component: React.ComponentType;
  order?: number;
}
```

- Each sidebar entry has one or more content panels
- Extensions register their content component
- Content lazy-loaded on first view

#### 1.3 Sidebar Header (`src/app/Chrome/Header/`)

**What it is:** The header bar above content — label + action buttons

**Registration API:**
```typescript
interface HeaderAction {
  id: string;
  icon: string;
  label: string;          // Tooltip
  onClick: () => void;
  order: number;
}
```

- Header label comes from active sidebar entry
- Extensions register action buttons per sidebar
- Actions appear as icon buttons in header

#### 1.4 Toggleable Content Sections

**What it is:** Collapsible accordion sections within a sidebar panel

- Extensions register toggleable sections within their content
- Expand/collapse state persisted
- Reorderable by user (drag-and-drop)

#### 1.5 Top Bar (`src/app/Chrome/Header/`)

**What it is:** Global bar above everything — breadcrumb, global actions

**Registration API:**
```typescript
interface TopBarItem {
  id: string;
  component: React.ComponentType;
  position: 'left' | 'center' | 'right';
  order: number;
}
```

- Extensions register items with position
- Breadcrumb navigation
- Global action buttons

#### 1.6 Status Bar (`src/app/Chrome/Status/`)

**What it is:** Bottom bar with real-time status indicators

**Registration API:**
```typescript
interface StatusBarItem {
  id: string;
  text: string;
  icon?: string;
  tooltip?: string;
  alignment: 'left' | 'right';
  order: number;
  onClick?: () => void;
}
```

- Extensions register status items (git branch, LSP status, connection state, timer)
- Real-time updates via `update()` method
- Click actions

### 2. Dynamic Tabs System (`src/app/Chrome/Tabs/`)

**What it is:** A tab bar within the content area for multi-content views

**Registration API:**
```typescript
interface TabRegistration {
  id: string;
  label: string;
  icon?: string;
  component: React.ComponentType;
  closable?: boolean;
  order?: number;
  parentSidebar?: string;
}
```

**Requirements:**
- Extensions open tabs via `IChromeSidebarService.openTab()`
- Tab types: terminal, diff view, editor, query result, log viewer, custom
- Drag-and-drop tab reordering
- Close button on closable tabs
- Tab overflow: scroll or dropdown menu
- Active tab state persisted across sidebar switches
- Split view support (horizontal/vertical drag to split)
- Tab context menu (close, close others, close all, split right/down)

### 3. Store Architecture Migration

**Current:** 28 Zustand stores in `chrome-extension/src/stores/`

**Migration:**
- Each store moves to its extension package: `src/packages/{name}/resources/chrome/stores/`
- Core sidebar state (active sidebar, open tabs, layout) stays in a shared store at `src/resources/chrome/stores/sidebarStore.ts`
- Extensions import only the core sidebar API, not each other's stores

| Store | Moves To |
|-------|----------|
| `sidebarStore.ts` | `src/resources/chrome/stores/` (shared core) |
| `settingsStore.ts`, `settingsSync.ts` | `src/app/Settings/` (core) |
| `connectionStore.ts` | `src/app/Socket/` (core) |
| `notificationStore.ts` | `src/app/Notifications/` (core) |
| `gitStore.ts`, `remoteStore.ts`, `multiRepoStore.ts` | `src/packages/version-control/resources/chrome/stores/` |
| `tasksStore.ts` | `src/packages/tasks-manager/resources/chrome/stores/` |
| `databaseStore.ts` | `src/packages/database-manager/resources/chrome/stores/` |
| `terminalStore.ts` | `src/packages/terminal-manager/resources/chrome/stores/` |
| `devLogsStore.ts` | `src/packages/log-viewer/resources/chrome/stores/` |
| `fileExplorerStore.ts` | `src/packages/explorer/resources/chrome/stores/` |
| `editorStore.ts`, `lspStatusStore.ts` | `src/packages/editor/resources/chrome/stores/` |
| `timerStore.ts`, `timeReportStore.ts` | `src/packages/time-tracker/resources/chrome/stores/` |
| `pomodoroStore.ts` | `src/packages/pomodoro/resources/chrome/stores/` |
| `alarmStore.ts` | `src/packages/alarm/resources/chrome/stores/` |
| `calendarStore.ts` | `src/packages/event-tracker/resources/chrome/stores/` |
| `widgetStore.ts` | `src/app/Widgets/` (core) |
| `marketplaceStore.ts` | `src/app/Marketplace/` (core) |
| `servicesStore.ts` | `src/packages/os-services-manager/resources/chrome/stores/` |
| `workspaceSync.ts` | `src/app/Providers/` (core) |
| `sshStore.ts`, `notesStore.ts` | Respective packages |

### 4. Chrome Extension Entry Point

**Current:** `chrome-extension/src/sidepanel/App.tsx` imports everything

**New:** `App.tsx` becomes a thin shell that:
1. Renders the sidebar icon rail (populated by registered entries)
2. Renders the active content area (populated by registered content)
3. Renders the tab bar (populated by open tabs)
4. Renders top bar + status bar (populated by registered items)
5. All actual feature views come from extension packages via registration

### 5. Transport Layer

**Current:** `chrome-extension/src/transport/` handles WebSocket communication

**Migration:** Stays as shared infrastructure in `src/resources/chrome/transport/` — used by all extension packages to communicate with desktop app via WebSocket.

---

## Documentation

- `docs/core-services/chrome-sidebar.md` — Full sidebar API reference
- Each extension package's `docs/guides/` covers its sidebar/tab registrations

---

## Success Criteria

- Chrome sidebar renders entirely from registered entries (no hardcoded views)
- All 13 extension packages register their sidebar/tab/status bar contributions
- Tabs system works: terminal as tab, diff as tab, editor as tab, custom tabs
- Drag-and-drop tab reordering works
- Split view works
- Status bar shows real-time updates from extensions
- All 28 stores migrated to their respective packages
- `App.tsx` is a thin shell (~100 lines, no feature imports)
- `pnpm build:extension` produces working Chrome extension
