# OC-42: Scaffold src/app/ directories with index.ts stubs

**Type**: Story | **Status**: backlog | **Points**: 3

As a developer, I want all PascalCase directories under src/app/ created with index.ts stub files, so that the application structure is established and ready for feature implementation.

## Acceptance Criteria

- [ ] All directories from PRD exist under src/app/ with PascalCase naming
- [ ] Each directory has an index.ts file that exports an empty object or type
- [ ] Directories include: AI, Actions, Chrome (with Header, Sidebar, Status, Tabs subdirs), Components, Http, IPC, Jobs, LSP, MCP, Marketplace, Models, Notifications, Panels, Providers, Search, Services, Settings, Socket, Tray, VS, Widgets, Themes, AccountCenter, BrowserInjection
- [ ] pnpm typecheck passes with all stub files
