# OPK-30: Migrate Editor main services

**Type**: Story | **Status**: backlog | **Points**: 5

As a developer, I want the editor and Monaco configuration logic migrated into the Editor package so that code editing functionality is self-contained.

## Acceptance Criteria

- [ ] EditorService.ts exists in src/Services/ with open/save/format methods
- [ ] Monaco configuration is encapsulated in the package
- [ ] All imports updated to use new package paths
- [ ] TypeScript compiles without errors
