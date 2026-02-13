# OSV-46: Marketplace VSIX Support & License Validation

**Type**: Story | **Status**: done | **Points**: 5

As a developer, I want VSIX compatibility and license key validation so that VSCode extensions can be installed and paid extensions are properly gated.

## Acceptance Criteria

- [ ] VSIX file extraction and manifest parsing
- [ ] VSCode extension compatibility check on install
- [ ] License key validation for paid extensions
- [ ] Deep link support: marketplace://install?id=extension-id
- [ ] IPC handlers: marketplace:install, marketplace:uninstall, marketplace:search, marketplace:list

## Tasks

| ID | Title | Status | Type |
|----|-------|--------|------|
| OSV-132 | Implement VSIX compatibility and license key validation | backlog | task |
| OSV-133 | Write VSIX handler and license validator tests | backlog | task |
