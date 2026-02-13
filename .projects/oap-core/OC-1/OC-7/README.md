# OC-7: Verify build pipeline works end-to-end

**Type**: Story | **Status**: backlog | **Points**: 2

As a developer, I want to confirm that all build commands (dev, build, typecheck) work correctly from the new src/ structure, so that I can confidently develop and ship from the migrated codebase.

## Acceptance Criteria

- [ ] pnpm dev:desktop starts the Electron tray app without errors
- [ ] pnpm build:desktop produces a working production build in dist/
- [ ] pnpm typecheck passes with zero errors
- [ ] pnpm lint runs without path resolution errors
