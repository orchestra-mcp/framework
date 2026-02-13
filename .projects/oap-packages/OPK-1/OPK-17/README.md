# OPK-17: Build Explorer ServiceProvider

**Type**: Story | **Status**: done | **Points**: 5

As a developer, I want the ExplorerServiceProvider to register all Explorer contributions with core services so that the package is fully integrated into the application.

## Acceptance Criteria

- [ ] ExplorerServiceProvider registers sidebar entry with folder icon
- [ ] Registers MCP tools: list_files, read_file, write_file
- [ ] Registers search provider for file search
- [ ] Registers settings: exclude patterns, show hidden files
- [ ] Registers tray menu item: Open Workspace
- [ ] boot() and shutdown() lifecycle methods implemented

## Tasks

| ID | Title | Status | Type |
|----|-------|--------|------|
| OPK-27 | Implement ExplorerServiceProvider with all registrations | backlog | task |
