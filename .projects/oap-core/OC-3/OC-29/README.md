# OC-29: Build ContributionRegistry for manifest parsing

**Type**: Story | **Status**: backlog | **Points**: 5

As a core developer, I want a ContributionRegistry that parses the contributes section from each extension's package.json and collects all contributions by type, so that core services can query what commands, settings, sidebar items, tray menus, MCP tools, etc. have been contributed by all extensions.

## Acceptance Criteria

- [ ] ContributionRegistry parses contributes from ExtensionManifest
- [ ] All Orchestra contribution types are supported: sidebar, tabs, trayMenu, settings, commands, mcpTools, searchProviders, widgets, themes, integrations, browserScripts
- [ ] Contributions are tracked with source extensionId for cleanup
- [ ] unregisterExtension removes all contributions from that extension
- [ ] Getter methods return contributions by type
- [ ] getCommandOwner returns the extensionId that contributed a command
- [ ] Validation errors logged with extension name and field path
- [ ] Unit tests cover registration, retrieval, and unregistration
