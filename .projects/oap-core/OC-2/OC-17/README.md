# OC-17: Build LifecycleService

**Type**: Story | **Status**: backlog | **Points**: 3

As a developer, I want a LifecycleService that manages application phases (Starting, Ready, Stopping, Stopped) and emits lifecycle events, so that extensions and core services can hook into startup and shutdown sequences reliably.

## Acceptance Criteria

- [ ] LifecycleService tracks phases: Starting -> Ready -> Stopping -> Stopped
- [ ] Lifecycle events (onWillStartup, onDidStartup, onWillShutdown, onDidShutdown) fire in correct order
- [ ] when(phase) returns a Promise that resolves when the phase is reached
- [ ] Phase transitions are one-directional (cannot go backwards)
- [ ] Handler errors are caught and logged without blocking other handlers
- [ ] ILifecycleService service identifier is created for DI
- [ ] Unit tests cover all phase transitions and event emissions
