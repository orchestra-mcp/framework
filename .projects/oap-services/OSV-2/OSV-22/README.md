# OSV-22: Panel Theme Injection & IPC Bridge Auto-Setup

**Type**: Story | **Status**: backlog | **Points**: 5

As a developer, I want panels to automatically receive IDE theme CSS variables and have IPC bridges set up so that panels look consistent and can communicate with their extension services.

## Acceptance Criteria

- [ ] CSS custom properties injected into every panel BrowserWindow on open
- [ ] Theme updates propagated to open panels in real-time
- [ ] IPC bridge auto-setup: panel preload exposes typed API matching extension handlers
- [ ] Auto tray menu entry creation when trayMenuEntry specified in PanelRegistration
- [ ] Panel resizable/alwaysOnTop options respected from registration
