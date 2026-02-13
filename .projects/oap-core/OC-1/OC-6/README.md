# OC-6: Update electron-vite build configuration

**Type**: Story | **Status**: backlog | **Points**: 3

As a developer, I want the electron-vite build config to resolve all entry points from the new src/ directory structure, so that dev mode and production builds work correctly with the migrated codebase.

## Acceptance Criteria

- [ ] electron.vite.config.ts main entry points resolve from src/ paths
- [ ] tsconfig.json paths are updated to match new directory structure
- [ ] TypeScript path aliases resolve correctly for src/app/ and src/packages/
- [ ] No build warnings about missing paths or unresolved imports
