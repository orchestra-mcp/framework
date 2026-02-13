# OSV-15: Dynamic LSP Server

**Type**: Epic | **Status**: backlog | **Priority**: medium

Extract LSP management from platform/lspClient.ts + platform/lspServers/ + lspManagerService.ts into src/app/LSP/. Provides ILspServerService with registerLanguageServer/getActiveServers/restartServer API. Extension-based language server registration, auto binary download, lifecycle management, VSCode language extension compatibility, and multi-root workspace support.
