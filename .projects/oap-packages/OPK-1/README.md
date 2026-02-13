# OPK-1: Explorer Package

**Type**: Epic | **Status**: done | **Priority**: high

Migrate and create the Explorer package at src/packages/explorer/. This is a NEW package extracted from chrome-extension file tree views + desktop fileSystemService.ts. Sources: packages/desktop/src/main/services/fileSystemService.ts, packages/chrome-extension/src/sidepanel/explorer/ (ContextMenu.tsx, FileExplorer.tsx, FileIcon.tsx, FileTree.tsx, FileTreeNode.tsx, InlineInput.tsx, icons.tsx), packages/chrome-extension/src/stores/fileExplorerStore.ts. The ServiceProvider registers: sidebar entry (folder icon), MCP tools (list_files, read_file, write_file), search provider (file search), settings (exclude patterns, show hidden files), tray menu (Open Workspace).

## Stories

| ID | Title | Status | Priority |
|----|-------|--------|----------|
| OPK-14 | Scaffold Explorer package structure | done | high |
| OPK-15 | Migrate Explorer main services | done | high |
| OPK-16 | Migrate Explorer Chrome UI | done | high |
| OPK-17 | Build Explorer ServiceProvider | done | high |
| OPK-18 | Write Explorer documentation | done | medium |
