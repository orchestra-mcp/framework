# OCR-21: Migrate terminal, database, services, devLogs, ssh, and notes stores to extension packages

**Type**: Story | **Status**: backlog | **Points**: 5

As the system architect, I want infrastructure and tool stores (terminal, database, services, devLogs, ssh, notes) moved to their respective extension packages, so that each tool feature owns its own state.

## Acceptance Criteria

- [ ] terminalStore.ts moved to src/packages/terminal-manager/resources/chrome/stores/terminalStore.ts
- [ ] databaseStore.ts moved to src/packages/database-manager/resources/chrome/stores/databaseStore.ts
- [ ] servicesStore.ts moved to src/packages/os-services-manager/resources/chrome/stores/servicesStore.ts
- [ ] devLogsStore.ts moved to src/packages/log-viewer/resources/chrome/stores/devLogsStore.ts
- [ ] sshStore.ts moved to src/packages/ssh-manager/resources/chrome/stores/sshStore.ts
- [ ] notesStore.ts moved to src/packages/notes/resources/chrome/stores/notesStore.ts
- [ ] All imports in consuming components updated
- [ ] Each target directory has an index.ts barrel export
- [ ] TypeScript strict mode passes
