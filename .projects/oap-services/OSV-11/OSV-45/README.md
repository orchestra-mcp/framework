# OSV-45: IMarketplaceService Interface & Extension Management

**Type**: Story | **Status**: done | **Points**: 8

As a developer, I want a typed IMarketplaceService so that extensions can be installed, uninstalled, enabled, and disabled at runtime with dependency resolution.

## Acceptance Criteria

- [ ] IMarketplaceService interface in src/app/Marketplace/IMarketplaceService.ts
- [ ] MarketplaceService implements registerExtensionType/publishExtension/installExtension/uninstallExtension/enableExtension/disableExtension/searchExtensions/getInstalledExtensions
- [ ] Extension types: Orchestra, VSCode, AI Tools, Services, Integrations
- [ ] Install downloads and extracts to extensions directory
- [ ] Dependency resolution: install missing deps before extension
- [ ] Enable/disable toggles extension without uninstalling
- [ ] Unit tests for install, uninstall, enable, disable flows

## Tasks

| ID | Title | Status | Type |
|----|-------|--------|------|
| OSV-129 | Define IMarketplaceService interface and extension types | backlog | task |
| OSV-130 | Implement MarketplaceService with install/uninstall and dependency resolution | backlog | task |
| OSV-131 | Write unit tests for MarketplaceService | backlog | task |
