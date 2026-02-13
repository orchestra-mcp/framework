# OCR-1: Dynamic Sidebar Icon Rail & Content Registration

**Type**: Epic | **Status**: backlog | **Priority**: high

Extract the hardcoded sidebar shell from packages/chrome-extension/src/sidepanel/App.tsx into a dynamic, registration-based system at src/app/Chrome/Sidebar/. Create IChromeSidebarService with registerSidebarEntry() and registerContent() APIs. Extensions will register their sidebar icons and content panels rather than being imported directly. Target directory: src/app/Chrome/Sidebar/
