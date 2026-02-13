# OSV-58: VSIX Installer & Theme/Grammar Parsing

**Type**: Story | **Status**: backlog | **Points**: 8

As a developer, I want VSIX extraction and parsing of themes and grammars so that VSCode extensions can be installed and their themes/grammars used by the IDE.

## Acceptance Criteria

- [ ] VSIX file extraction (ZIP format) to extensions directory
- [ ] package.json manifest parsing for contributes field
- [ ] Theme parsing: .tmTheme XML and VS Code JSON format
- [ ] Grammar parsing: .tmLanguage and .tmLanguage.json TextMate grammars
- [ ] Snippet extraction from VSCode snippet files
- [ ] Parsed artifacts registered with ThemeService, LspService respectively
- [ ] Unit tests for VSIX extraction and all parsing formats
