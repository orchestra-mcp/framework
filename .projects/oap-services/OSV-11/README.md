# OSV-11: Dynamic Marketplace Service

**Type**: Epic | **Status**: done | **Priority**: high

Extract marketplace from marketplaceClient.ts + marketplaceWindowService.ts + marketplace-renderer.ts + vsixInstaller.ts into src/app/Marketplace/. Provides IMarketplaceService with publishExtension/installExtension/uninstallExtension/enableExtension/disableExtension/searchExtensions API. Supports Orchestra, VSCode, AI Tools, Services, Integrations types, runtime install/uninstall, license key validation, and dependency resolution.

## Stories

| ID | Title | Status | Priority |
|----|-------|--------|----------|
| OSV-45 | IMarketplaceService Interface & Extension Management | done | high |
| OSV-46 | Marketplace VSIX Support & License Validation | done | high |
| OSV-47 | Marketplace Search, Discovery & Documentation | done | medium |
