# OPK-8: Log Viewer Package

**Type**: Epic | **Status**: done | **Priority**: medium

Migrate the Log Viewer package at src/packages/log-viewer/. Sources: packages/extensions/dev-logs/src/main/ (LogScannerService.ts, LogTailService.ts, GenericLogParser.ts, LogParserRegistry.ts, tools.ts, index.ts, parsers/ (LaravelParser.ts, DjangoParser.ts, NodejsParser.ts, RailsParser.ts, index.ts)), packages/extensions/dev-logs/src/types.ts, packages/chrome-extension/src/sidepanel/dev-logs/ (DevLogsPanel.tsx, LogEntryDetailView.tsx, LogEntryList.tsx, LogFilterBar.tsx), packages/chrome-extension/src/stores/devLogsStore.ts. The ServiceProvider registers: sidebar entry (log icon), tab type (log viewer tab), search provider (log search), settings (log paths, watch patterns, filter levels).

## Stories

| ID | Title | Status | Priority |
|----|-------|--------|----------|
| OPK-107 | Scaffold Log Viewer package structure | done | high |
| OPK-108 | Migrate Log Viewer main services | done | high |
| OPK-109 | Migrate Log Viewer Chrome UI | done | high |
| OPK-110 | Build Log Viewer ServiceProvider | done | high |
| OPK-111 | Write Log Viewer documentation | done | medium |
