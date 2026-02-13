# OSV-56: IBrowserInjectionService Interface & Script Registry

**Type**: Story | **Status**: done | **Points**: 5

As a developer, I want a typed IBrowserInjectionService so that extensions can register content scripts for injection into web pages with URL pattern matching and bidirectional messaging.

## Acceptance Criteria

- [ ] IBrowserInjectionService interface in src/app/BrowserInjection/IBrowserInjectionService.ts
- [ ] BrowserInjectionService implements registerScript/injectOnUrl/sendToPage/onPageMessage
- [ ] registerScript and injectOnUrl return Disposable
- [ ] URL pattern matching: glob and RegExp support
- [ ] Script isolation: each extension's scripts run in separate world
- [ ] Unit tests for URL matching and script registration

## Tasks

| ID | Title | Status | Type |
|----|-------|--------|------|
| OSV-156 | Define IBrowserInjectionService interface and injection types | backlog | task |
| OSV-157 | Implement BrowserInjectionService with URL matching and script registry | backlog | task |
| OSV-158 | Write unit tests for BrowserInjectionService | backlog | task |
