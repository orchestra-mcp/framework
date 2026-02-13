# OCR-23: Refactor App.tsx to thin registration-driven shell

**Type**: Story | **Status**: backlog | **Points**: 8

As the system architect, I want App.tsx reduced to a thin ~100-line shell that renders only from registered extensions, so that adding new sidebar panels, tabs, or status bar items never requires editing App.tsx.

## Acceptance Criteria

- [ ] App.tsx at packages/chrome-extension/src/sidepanel/App.tsx is under 120 lines
- [ ] App.tsx imports ONLY: SidebarIconRail, SidebarContent, SidebarHeader, TopBar, StatusBar, TabBar from src/app/Chrome/
- [ ] Zero imports of feature components (FileExplorer, EditorPanel, TasksPanel, GitPanel, etc.)
- [ ] Zero imports of feature stores (gitStore, terminalStore, databaseStore, etc.)
- [ ] App.tsx renders layout: TopBar + (SidebarIconRail + (SidebarHeader + SidebarContent/TabBar)) + StatusBar
- [ ] All existing functionality works identically after refactor
- [ ] Chrome extension builds successfully with pnpm build:extension
