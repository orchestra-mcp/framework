# OC-41: Build Event Bus and Disposable utilities

**Type**: Story | **Status**: backlog | **Points**: 5

As a developer, I want a typed Event Bus with Event&lt;T&gt;, EventEmitter, and Disposable utilities (Disposable interface, DisposableStore, toDisposable, combineDisposables), so that all services can communicate via events and clean up resources reliably.

## Acceptance Criteria

- [ ] Event<T> type provides typed event subscription
- [ ] EventEmitter implementation fires events with correct typed payloads
- [ ] Disposable interface defines dispose() method
- [ ] DisposableStore collects disposables and disposes all at once
- [ ] toDisposable() wraps a function into a Disposable
- [ ] combineDisposables() merges multiple Disposables into one
- [ ] Every register() call returns a Disposable for unregistration
- [ ] Unit tests cover all utilities and edge cases
