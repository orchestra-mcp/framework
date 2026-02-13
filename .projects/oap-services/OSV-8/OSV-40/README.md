# OSV-40: Deep Links, Protocol Handler & OAuth Callbacks

**Type**: Story | **Status**: done | **Points**: 5

As a developer, I want IDE deep links, orchestra:// protocol handling, and OAuth callback helpers so that external tools can open files, workspaces, and complete auth flows.

## Acceptance Criteria

- [ ] Deep link routes: /open?workspace=, /open?file=&line=
- [ ] orchestra:// protocol handler registered with OS via Electron app.setAsDefaultProtocolClient
- [ ] OAuth callback helper: registerOAuthCallback(path, handler) for extension auth flows
- [ ] Protocol URLs parsed and routed to correct handlers
- [ ] docs/core-services/web-server.md with API reference and examples

## Tasks

| ID | Title | Status | Type |
|----|-------|--------|------|
| OSV-117 | Implement deep links, orchestra:// protocol handler, and OAuth callbacks | backlog | task |
| OSV-118 | Write Web Server documentation, barrel exports, and deep link tests | backlog | task |
