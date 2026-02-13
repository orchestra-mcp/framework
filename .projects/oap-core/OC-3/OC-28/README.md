# OC-28: Define ServiceProvider base class

**Type**: Story | **Status**: backlog | **Points**: 3

As an extension developer, I want an abstract ServiceProvider base class with register/boot/shutdown methods and access to the DI container, so that every extension follows a consistent lifecycle pattern and can register services in a standard way.

## Acceptance Criteria

- [ ] Abstract ServiceProvider class exists with register(), boot(), shutdown() methods
- [ ] ServiceProvider has access to the ServiceRegistry (DI container) via constructor injection
- [ ] register() is called first to register services into the container
- [ ] boot() is called after all providers have registered
- [ ] shutdown() is called during extension deactivation for cleanup
- [ ] TypeScript generics allow typed service resolution
- [ ] Unit tests verify the lifecycle call order
