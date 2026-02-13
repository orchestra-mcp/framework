# OSV-30: VSCode Theme Import & Documentation

**Type**: Story | **Status**: done | **Points**: 3

As a developer, I want to import VSCode themes (.tmTheme and VS Code JSON) so that the IDE can leverage the vast VSCode theme ecosystem.

## Acceptance Criteria

- [ ] importVSCodeTheme(vsixPath) parses and converts to ThemeDefinition
- [ ] Supports .tmTheme XML format
- [ ] Supports VS Code JSON theme format
- [ ] Imported theme auto-registered and available in theme list
- [ ] docs/core-services/themes.md with API reference and import examples

## Tasks

| ID | Title | Status | Type |
|----|-------|--------|------|
| OSV-91 | Implement VSCode theme importer | backlog | task |
| OSV-92 | Write Themes documentation, barrel exports, and importer tests | backlog | task |
