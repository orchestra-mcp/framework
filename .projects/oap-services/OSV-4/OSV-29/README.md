# OSV-29: Theme CSS Injection & Real-Time Propagation

**Type**: Story | **Status**: done | **Points**: 5

As a developer, I want theme CSS variables injected into all panels and Chrome extension so that switching themes updates the entire IDE in real-time.

## Acceptance Criteria

- [ ] CSS custom properties injected into all open BrowserWindows on theme change
- [ ] WebSocket message broadcasts theme change to Chrome extension
- [ ] Editor syntax highlighting colors derived from active theme
- [ ] Real-time preview: no page reload required on switch
- [ ] IPC handlers: theme:setActive, theme:getActive, theme:getAll, theme:getCssVariables

## Tasks

| ID | Title | Status | Type |
|----|-------|--------|------|
| OSV-89 | Implement theme CSS injection into BrowserWindows and WebSocket broadcast | backlog | task |
| OSV-90 | Write tests for ThemePropagator and theme IPC handlers | backlog | task |
