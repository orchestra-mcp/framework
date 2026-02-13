# OPK-15: Migrate Explorer main services

**Type**: Story | **Status**: done | **Points**: 5

As a developer, I want the file system service logic migrated from the desktop package into the Explorer package so that file browsing functionality is self-contained in its own package.

## Acceptance Criteria

- [x] ExplorerService.ts exists in src/Services/ with all file operations
- [x] MCP tools for list_files, read_file, write_file are defined
- [x] All imports updated to use new package paths
- [x] TypeScript compiles without errors

## Tasks

| ID | Title | Status | Type |
|----|-------|--------|------|
| OPK-22 | Migrate fileSystemService.ts to ExplorerService.ts | done | task |
| OPK-23 | Create Explorer MCP tool definitions | done | task |
| OPK-24 | Write ExplorerService unit tests | done | task |
