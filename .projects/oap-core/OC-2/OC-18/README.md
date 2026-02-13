# OC-18: Build ActivationService

**Type**: Story | **Status**: backlog | **Points**: 3

As a developer, I want an ActivationService that respects activationEvents from extension manifests (onStartup, onCommand, onView, etc.), so that extensions are only loaded when they are actually needed, improving startup performance.

## Acceptance Criteria

- [ ] ActivationService registers extension manifests and their activationEvents
- [ ] fireEvent() activates all extensions matching a given event string
- [ ] fireStartupFinished() activates all eager (*) and onStartup extensions
- [ ] onCommand:, onLanguage:, onView:, onFileSystem:, onWebviewPanel: events are supported
- [ ] Extensions are only activated once (duplicate fire is a no-op)
- [ ] markActivated/markDeactivated correctly track state
- [ ] Unit tests cover all activation event types and edge cases
