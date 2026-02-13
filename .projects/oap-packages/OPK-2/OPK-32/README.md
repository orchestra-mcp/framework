# OPK-32: Build Editor ServiceProvider

**Type**: Story | **Status**: backlog | **Points**: 5

As a developer, I want the EditorServiceProvider to register all Editor contributions with core services so that the package is fully integrated.

## Acceptance Criteria

- [ ] EditorServiceProvider registers tab type for editor tabs
- [ ] Registers search provider for file content search
- [ ] Registers settings: fontSize, fontFamily, tabSize, theme, minimap, wordWrap
- [ ] Registers commands: editor.open, editor.save, editor.formatDocument
- [ ] boot() and shutdown() lifecycle methods implemented
