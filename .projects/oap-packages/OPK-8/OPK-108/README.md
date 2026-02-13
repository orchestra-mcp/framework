# OPK-108: Migrate Log Viewer main services

**Type**: Story | **Status**: done | **Points**: 5

As a developer, I want the log scanning, tailing, parsing services migrated from extensions/dev-logs/ into the Log Viewer package.

## Acceptance Criteria

- [ ] LogScannerService.ts, LogTailService.ts, GenericLogParser.ts, LogParserRegistry.ts migrated
- [ ] All 4 framework parsers migrated to Parsers/
- [ ] tools.ts and types.ts migrated
- [ ] All imports updated
- [ ] TypeScript compiles

## Tasks

| ID | Title | Status | Type |
|----|-------|--------|------|
| OPK-113 | Migrate log service and parser files | backlog | task |
| OPK-114 | Migrate and update Log Viewer unit tests | backlog | task |
