# OSV-17: VSCode Compatibility Layer

**Type**: Epic | **Status**: backlog | **Priority**: medium

Extract VSCode compatibility from vscodeExtensionService.ts + vsixInstaller.ts + textmateService.ts + grammarLoader.ts + semanticTokenRegistry.ts into src/app/VS/. Provides VSIX install/extraction, theme parsing (.tmTheme, VS Code JSON), grammar parsing (.tmLanguage), snippet extraction, and unification with Marketplace, Theme, and LSP services.
