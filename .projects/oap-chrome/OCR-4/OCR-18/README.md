# OCR-18: Migrate core infrastructure stores to src/app/ and src/resources/

**Type**: Story | **Status**: backlog | **Points**: 8

As the system architect, I want core stores (sidebar, connection, settings, notifications, widgets, marketplace, workspace) moved to their proper locations in src/app/ or src/resources/chrome/stores/, so that they are independent of extension code and importable by any package.

## Acceptance Criteria

- [ ] sidebarStore.ts moved to src/resources/chrome/stores/sidebarStore.ts
- [ ] connectionStore.ts moved to src/app/Socket/stores/connectionStore.ts
- [ ] settingsStore.ts moved to src/app/Settings/stores/settingsStore.ts
- [ ] settingsSync.ts moved to src/app/Settings/stores/settingsSync.ts
- [ ] notificationStore.ts moved to src/app/Notifications/stores/notificationStore.ts
- [ ] widgetStore.ts moved to src/app/Widgets/stores/widgetStore.ts
- [ ] marketplaceStore.ts moved to src/app/Marketplace/stores/marketplaceStore.ts
- [ ] workspaceSync.ts moved to src/app/Providers/stores/workspaceSync.ts
- [ ] All imports in consuming files updated to new paths
- [ ] Each target directory has an index.ts barrel export
- [ ] TypeScript strict mode passes with no errors
