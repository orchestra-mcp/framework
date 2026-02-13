# OCR-19: Migrate version-control and editor stores to extension packages

**Type**: Story | **Status**: backlog | **Points**: 5

As the system architect, I want git, remote, multiRepo, editor, lspStatus, and fileExplorer stores moved to their respective extension packages, so that each extension owns its own state and can be loaded/unloaded independently.

## Acceptance Criteria

- [ ] gitStore.ts moved to src/packages/version-control/resources/chrome/stores/gitStore.ts
- [ ] remoteStore.ts moved to src/packages/version-control/resources/chrome/stores/remoteStore.ts
- [ ] multiRepoStore.ts moved to src/packages/version-control/resources/chrome/stores/multiRepoStore.ts
- [ ] editorStore.ts moved to src/packages/editor/resources/chrome/stores/editorStore.ts
- [ ] lspStatusStore.ts moved to src/packages/editor/resources/chrome/stores/lspStatusStore.ts
- [ ] fileExplorerStore.ts moved to src/packages/explorer/resources/chrome/stores/fileExplorerStore.ts
- [ ] All imports in consuming components updated to new paths
- [ ] Each target directory has an index.ts barrel export
- [ ] TypeScript strict mode passes
