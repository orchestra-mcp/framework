# OCR-5: Chrome Extension Entry Point Refactor

**Type**: Epic | **Status**: backlog | **Priority**: high

Refactor packages/chrome-extension/src/sidepanel/App.tsx from its current ~430-line monolith with hardcoded feature imports into a thin ~100-line shell that renders only from registered extensions. Move transport layer to src/resources/chrome/transport/. App.tsx will render: sidebar icon rail (from registrations), active content area (from registrations), tab bar (from registrations), top bar + status bar (from registrations). Zero hardcoded feature imports.
