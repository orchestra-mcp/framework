# OC-15: Build ServiceRegistry (DI container)

**Type**: Story | **Status**: backlog | **Points**: 5

As a developer, I want a type-safe Dependency Injection container at src/app/Providers/ServiceRegistry.ts, so that extensions and core services can register and resolve dependencies with proper scoping and lifecycle management.

## Acceptance Criteria

- [ ] ServiceRegistry supports register(), resolve(), has(), dispose() methods
- [ ] createServiceId<T>() produces typed service identifiers
- [ ] Singleton and transient scoping works correctly
- [ ] Circular dependency detection throws a clear error
- [ ] Application/workspace/editor scope fallback chain works
- [ ] All methods are fully typed with generics
- [ ] Unit tests cover all methods and edge cases
