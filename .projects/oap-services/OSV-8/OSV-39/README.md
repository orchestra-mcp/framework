# OSV-39: IWebServerService Interface & Route Registration

**Type**: Story | **Status**: done | **Points**: 5

As a developer, I want a typed IWebServerService so that extensions can dynamically register HTTP routes and static file paths at runtime.

## Acceptance Criteria

- [ ] IWebServerService interface in src/app/Http/IWebServerService.ts
- [ ] WebServerService implements registerRoute/registerStaticPath/getBaseUrl
- [ ] registerRoute and registerStaticPath return Disposable
- [ ] Route matching supports path parameters (:id) and wildcards
- [ ] CORS configuration via settings
- [ ] Static file serving with proper MIME types
- [ ] Unit tests for route registration and matching

## Tasks

| ID | Title | Status | Type |
|----|-------|--------|------|
| OSV-114 | Define IWebServerService interface and route types | backlog | task |
| OSV-115 | Implement WebServerService with dynamic route registration | backlog | task |
| OSV-116 | Write unit tests for WebServerService | backlog | task |
