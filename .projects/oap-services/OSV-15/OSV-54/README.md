# OSV-54: ILspServerService Interface & Lifecycle Manager

**Type**: Story | **Status**: backlog | **Points**: 8

As a developer, I want a typed ILspServerService so that extensions can register language servers with automatic binary download, lifecycle management, and multi-root workspace support.

## Acceptance Criteria

- [ ] ILspServerService interface in src/app/LSP/ILspServerService.ts
- [ ] LspServerService implements registerLanguageServer/getActiveServers/restartServer
- [ ] registerLanguageServer returns Disposable
- [ ] Auto-download language server binaries on first use
- [ ] Lifecycle management: start, stop, restart servers
- [ ] Multi-root workspace support: servers aware of all workspace folders
- [ ] Unit tests for registration, lifecycle, and restart
