# OCR-4: Zustand Store Migration

**Type**: Epic | **Status**: backlog | **Priority**: high

Migrate all 26 stores from packages/chrome-extension/src/stores/ to their respective extension packages or core service locations. Core stores (sidebarStore, connectionStore, settingsStore, settingsSync, notificationStore, widgetStore, marketplaceStore, workspaceSync) stay in src/resources/chrome/stores/ or src/app/{Service}/. Extension stores move to src/packages/{name}/resources/chrome/stores/. Every store file must be moved, imports updated, and re-exported correctly.
