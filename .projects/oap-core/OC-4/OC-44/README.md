# OC-44: Scaffold src/packages/example/ complete template directories

**Type**: Story | **Status**: backlog | **Points**: 2

As an extension developer, I want the example extension at src/packages/example/ to have the complete reference structure including docs/, database/, routes/, resources/, and tests/ directories, so that I can copy it as a template when creating new extensions.

## Acceptance Criteria

- [ ] This story is a verification/supplement to OC-31 story tasks
- [ ] src/packages/example/ matches PRD directory spec exactly
- [ ] All subdirectories exist with appropriate placeholder files
- [ ] docs/ has README.md, api/, guides/, changelog/ with README.md each
- [ ] database/ exists with .gitkeep
- [ ] resources/ has chrome/, desktop/, web/ subdirectories
- [ ] tests/ has at least one passing test file
- [ ] The example extension can be loaded by ExtensionHost successfully
