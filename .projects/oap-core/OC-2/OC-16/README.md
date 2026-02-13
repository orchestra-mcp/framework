# OC-16: Build ExtensionHost (package discovery and loading)

**Type**: Story | **Status**: backlog | **Points**: 8

As a developer, I want an ExtensionHost that discovers packages from src/packages/*/package.json, loads their manifests, and activates them in dependency order with error isolation, so that extensions are loaded reliably and one failure does not crash others.

## Acceptance Criteria

- [ ] ExtensionHost scans src/packages/ for package.json files
- [ ] Manifests are validated using the extension scanner
- [ ] Extensions are activated in dependency order (respecting extensionDependencies)
- [ ] One extension failing activation does not prevent others from activating
- [ ] Activation has a configurable timeout (default 10s)
- [ ] Deactivation disposes all subscriptions cleanly
- [ ] Global uncaught errors are traced back to source extension
- [ ] Unit tests cover discovery, loading, activation, deactivation, and error isolation
