# OPK-3: Tasks Manager Package

**Type**: Epic | **Status**: backlog | **Priority**: high

Migrate the Tasks Manager package at src/packages/tasks-manager/. Sources: packages/extensions/tasks/src/ (index.ts, tasksRpcHandlers.ts, timeTrackingReader.ts), packages/chrome-extension/src/sidepanel/tasks/ (BacklogTree.tsx, TasksPanel.tsx, TaskDetailView.tsx, Dashboard.tsx, FilterBar.tsx, TreeNode.tsx, WorkflowStatus.tsx, CreateForms.tsx, ProjectSelector.tsx, PrdWizard.tsx, ContextMenu.tsx, SyncConflictDialog.tsx, TimeReportPanel.tsx, AlarmSettings.tsx, PomodoroCycleSetup.tsx, PomodoroPanel.tsx), packages/chrome-extension/src/stores/tasksStore.ts. The ServiceProvider registers: sidebar entry (tasks icon), MCP tools (task/project/epic/story tools), search provider (task search), settings (task sync, providers), tray menu (My Tasks), widgets (task summary widget).
