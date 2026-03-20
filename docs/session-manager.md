# Enhanced Session Manager

## Backend Changes

### Session List (`GET /api/settings/sessions`)

The session list now includes:
- **User-agent parsing**: Device name, OS, browser extracted from user-agent string
- **Device type classification**: mobile, tablet, or desktop
- **Registered devices**: Device tokens appear as additional sessions
- **Tunnel status**: Active tunnels cross-referenced with sessions (`tunnel_active: true`)

### Session Revocation (`DELETE /api/settings/sessions/:id`)

- Now actually works (was a no-op)
- Deletes device tokens for `device:*` session IDs
- Blocks revocation of the current session

### User-Agent Parsing

Supports: macOS, iOS, iPadOS, Windows, Linux, Android.
Browsers: Chrome, Safari, Firefox, Edge, Orchestra App.

## Flutter Changes

Session rows now display:
- OS and browser info (e.g., "macOS · Chrome · 192.168.1.1")
- Green "Tunnel connected" indicator when a tunnel is active for the session
- Last seen timestamp in the info line
