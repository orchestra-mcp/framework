# OSV-55: LSP VSCode Compatibility & Documentation

**Type**: Story | **Status**: backlog | **Points**: 5

As a developer, I want VSCode language extension compatibility and documentation so that existing VSCode language extensions work and developers know how to register new servers.

## Acceptance Criteria

- [ ] VSCode language extension contributes.languages parsed from VSIX manifest
- [ ] Language server config extracted from VSCode extension package.json
- [ ] IPC handlers: lsp:register, lsp:getActive, lsp:restart
- [ ] docs/core-services/lsp-server.md with API reference and language server authoring guide
