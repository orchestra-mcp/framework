# PRD 3: Extension Package Migration

**Parent:** orchestra-app (Master PRD)
**Depends on:** PRD 2 (oap-services)

---

## Goal

Migrate all 13 extension packages from `packages/extensions/` + `packages/chrome-extension/` into self-contained packages in `src/packages/` following the established ServiceProvider pattern. Each package combines its main process code + UI code into one standalone package.

---

## Package Structure (every package follows this)

```
src/packages/{name}/
├── src/
│   ├── {Name}ServiceProvider.ts       # Entry point — registers with core services
│   ├── Http/                          # HTTP controllers (if needed)
│   ├── Models/                        # Data models
│   ├── Services/                      # Business logic (migrated from extensions/{name}/)
│   ├── Jobs/                          # Background jobs
│   ├── Notifications/                 # Notification handlers
│   ├── Panels/                        # Panel definitions
│   └── Widgets/                       # Widget components
├── database/                          # Migrations (if needed)
├── routes/
│   ├── web.ts                         # HTTP routes
│   └── socket.ts                      # WebSocket routes
├── resources/
│   ├── chrome/                        # Chrome sidebar UI (migrated from chrome-extension/sidepanel/{name}/)
│   ├── desktop/                       # Desktop panel UI
│   └── web/                           # Web platform UI (future)
├── docs/
│   ├── README.md                      # Extension overview
│   ├── api/
│   │   └── README.md
│   ├── guides/
│   │   └── README.md
│   └── changelog/
│       └── README.md
├── tests/
├── package.json                       # Manifest with contributes
├── tsconfig.json
└── vitest.config.ts
```

---

## Migration Map — All 13 Packages

### 1. Explorer (`src/packages/explorer/`)

**Source:** NEW — extracted from `chrome-extension/` file tree views + `fileSystemService.ts`

| From | To |
|------|-----|
| `desktop/services/fileSystemService.ts` | `src/Services/ExplorerService.ts` |
| `chrome-extension/sidepanel/` file tree components | `resources/chrome/` |
| `chrome-extension/stores/fileExplorerStore.ts` | `resources/chrome/stores/` |

**ServiceProvider registers:**
- Sidebar entry (folder icon)
- MCP tools: `list_files`, `read_file`, `write_file`
- Search provider: file search
- Settings: exclude patterns, show hidden files
- Tray menu: "Open Workspace"

---

### 2. Editor (`src/packages/editor/`)

**Source:** `chrome-extension/src/editor/` + Monaco setup

| From | To |
|------|-----|
| `chrome-extension/src/editor/` | `src/Services/` + `resources/chrome/` |
| `chrome-extension/stores/editorStore.ts` | `resources/chrome/stores/` |
| Monaco config from `chrome-extension/` | `src/Services/EditorService.ts` |

**ServiceProvider registers:**
- Tab type: editor tabs
- Search provider: file content search
- Settings: fontSize, fontFamily, tabSize, theme, minimap, wordWrap
- Commands: `editor.open`, `editor.save`, `editor.formatDocument`

---

### 3. Tasks Manager (`src/packages/tasks-manager/`)

**Source:** `extensions/tasks/` + `chrome-extension/sidepanel/tasks/` (19 files)

| From | To |
|------|-----|
| `extensions/tasks/src/main/` | `src/Services/` |
| `chrome-extension/sidepanel/tasks/BacklogTree.tsx` + all | `resources/chrome/` |
| `chrome-extension/stores/tasksStore.ts` | `resources/chrome/stores/` |

**ServiceProvider registers:**
- Sidebar entry (tasks icon)
- MCP tools: existing task/project/epic/story tools
- Search provider: task search
- Settings: task sync, providers
- Tray menu: "My Tasks"
- Widgets: task summary widget

---

### 4. Version Control (`src/packages/version-control/`)

**Source:** `extensions/git/` + `extensions/github/` + `extensions/gitlab/` + `extensions/bitbucket/` + `chrome-extension/sidepanel/git/` (20 files)

| From | To |
|------|-----|
| `extensions/git/src/main/` (GitService, DiffProvider, BranchStrategyEngine, ConflictResolver, RemoteService, BlameEnricher, etc.) | `src/Services/` |
| `extensions/github/`, `gitlab/`, `bitbucket/` | `src/Services/Providers/` |
| `chrome-extension/sidepanel/git/` (SourceControlPanel, BranchesPanel, CommitLog, PRPanel, IssuesPanel) | `resources/chrome/` |
| `chrome-extension/stores/gitStore.ts`, `remoteStore.ts`, `multiRepoStore.ts` | `resources/chrome/stores/` |

**ServiceProvider registers:**
- Sidebar entry (git icon)
- Tab types: diff view, merge conflict view
- MCP tools: git operations
- Search provider: commit search, branch search
- Settings: default provider, branch strategy
- Status bar: current branch
- Integrations: GitHub, GitLab, Bitbucket (via AccountCenter)

---

### 5. Terminal Manager (`src/packages/terminal-manager/`)

**Source:** `extensions/terminal/` + `chrome-extension/src/terminal/`

| From | To |
|------|-----|
| `extensions/terminal/src/main/` | `src/Services/` |
| `chrome-extension/src/terminal/` | `resources/chrome/` |
| `chrome-extension/stores/terminalStore.ts` | `resources/chrome/stores/` |

**ServiceProvider registers:**
- Tab type: terminal tabs (closable, multiple)
- Sidebar entry (terminal icon)
- Settings: shell selection, font, cursor style
- Tray menu: "New Terminal"
- Commands: `terminal.new`, `terminal.split`

---

### 6. Database Manager (`src/packages/database-manager/`)

**Source:** `extensions/dev-database/` + `chrome-extension/sidepanel/database/` (11 files)

| From | To |
|------|-----|
| `extensions/dev-database/src/` (PostgresDriver, etc.) | `src/Services/` |
| `chrome-extension/sidepanel/database/` (ConnectionsList, DatabasePanel, QueryEditor, QueryHistory, SchemaTree, TableBrowser) | `resources/chrome/` |
| `chrome-extension/stores/databaseStore.ts` | `resources/chrome/stores/` |

**ServiceProvider registers:**
- Sidebar entry (database icon)
- Tab types: query editor, table browser
- Search provider: schema search
- Settings: connections, default driver
- MCP tools: query, schema browse

---

### 7. OS Services Manager (`src/packages/os-services-manager/`)

**Source:** `extensions/dev-services/` (12 adapters: Postgres, MySQL, Redis, Docker, Node, Python, PHP, Apache, Nginx, Meilisearch, Mailpit, Ruby)

| From | To |
|------|-----|
| `extensions/dev-services/src/main/ServiceManager.ts` | `src/Services/` |
| `extensions/dev-services/src/main/adapters/` (12 adapters) | `src/Services/Adapters/` |
| `extensions/dev-services/src/main/ServiceAdapterRegistry.ts` | `src/Services/` |
| `chrome-extension/stores/servicesStore.ts` | `resources/chrome/stores/` |

**ServiceProvider registers:**
- Sidebar entry (services icon)
- Tray menu: dynamic items per service with green/yellow/red iconColor
- Settings: service paths, auto-start
- MCP tools: start/stop/restart services
- Notifications: service status change alerts

---

### 8. Log Viewer (`src/packages/log-viewer/`)

**Source:** `extensions/dev-logs/` + `chrome-extension/sidepanel/dev-logs/`

| From | To |
|------|-----|
| `extensions/dev-logs/src/main/` | `src/Services/` |
| `chrome-extension/sidepanel/dev-logs/DevLogsPanel.tsx` | `resources/chrome/` |
| `chrome-extension/stores/devLogsStore.ts` | `resources/chrome/stores/` |

**ServiceProvider registers:**
- Sidebar entry (log icon)
- Tab type: log viewer tab
- Search provider: log search
- Settings: log paths, watch patterns, filter levels

---

### 9. Time Tracker (`src/packages/time-tracker/`)

**Source:** `extensions/time-tracker/` + `extensions/time-reports/`

| From | To |
|------|-----|
| `extensions/time-tracker/src/` | `src/Services/` |
| `extensions/time-reports/src/` | `src/Services/Reports/` |
| Timer panel views | `resources/chrome/` + `resources/desktop/` |
| `chrome-extension/stores/timerStore.ts`, `timeReportStore.ts` | `resources/chrome/stores/` |

**ServiceProvider registers:**
- Widget: timer panel
- Tray menu: "Start/Stop Timer"
- Panel: time reports
- Settings: tracking mode, report format
- MCP tools: start/stop timer, get reports

---

### 10. Alarm (`src/packages/alarm/`)

**Source:** `extensions/alarms/` + `desktop/services/alarmPanelService.ts`

| From | To |
|------|-----|
| `extensions/alarms/src/` | `src/Services/` |
| Alarm panel views | `resources/desktop/` |

**ServiceProvider registers:**
- Widget: alarm panel
- Tray menu: "Alarms"
- Notifications: alarm triggers
- Settings: sound, snooze duration

---

### 11. Event Tracker (`src/packages/event-tracker/`)

**Source:** `extensions/calendar/` (MultiAccountCalendarService, OAuthService, providers/)

| From | To |
|------|-----|
| `extensions/calendar/src/` (MultiAccountCalendarService, providers/) | `src/Services/` |
| `extensions/calendar/src/OAuthService.ts` | Uses AccountCenter service instead |
| Calendar panel views | `resources/chrome/` + `resources/desktop/` |
| `chrome-extension/stores/calendarStore.ts` | `resources/chrome/stores/` |

**ServiceProvider registers:**
- Widget: calendar panel
- Sidebar entry (calendar icon)
- Tray menu: "Upcoming Events"
- Integrations: Google Calendar, Outlook (via AccountCenter)
- Settings: refresh interval, default calendar
- Notifications: meeting reminders

---

### 12. Pomodoro (`src/packages/pomodoro/`)

**Source:** `extensions/pomodoro/` + `desktop/services/pomodoroPanelService.ts`

| From | To |
|------|-----|
| `extensions/pomodoro/src/` | `src/Services/` |
| Pomodoro panel views | `resources/desktop/` |
| `chrome-extension/stores/pomodoroStore.ts` | `resources/chrome/stores/` |

**ServiceProvider registers:**
- Widget: pomodoro panel
- Tray menu: "Pomodoro" with timer display
- Notifications: phase change (work → break → long break)
- Settings: intervals, sounds

---

### 13. Break Tracker (`src/packages/break-tracker/`)

**Source:** `desktop/services/breakPanelService.ts` + break panel views

| From | To |
|------|-----|
| `desktop/services/breakPanelService.ts` | `src/Services/` |
| Break panel views | `resources/desktop/` |

**ServiceProvider registers:**
- Widget: break panel
- Tray menu: "Break Tracker"
- Notifications: break reminders
- Settings: break interval, reminder frequency

---

## Success Criteria

- All 13 packages migrated to `src/packages/` with ServiceProvider pattern
- Each package has `main/` (services) + `resources/chrome/` (UI) + `resources/desktop/` (panels)
- Each package has `docs/` with README.md indexes
- Each package's ServiceProvider successfully registers with all relevant core services
- Each package has `package.json` with `contributes` manifest
- All existing functionality preserved
- `pnpm typecheck` passes
- `pnpm test` passes
